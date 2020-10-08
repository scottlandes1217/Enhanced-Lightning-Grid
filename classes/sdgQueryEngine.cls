/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
public with sharing class smdgQueryEngine {
    public virtual class smdgQueryEngineException extends smdgException {}
    public  class smdgInvalidFilterException extends smdgException {}
    public  class smdgInvalidSortException extends smdgException {}
    public  class smdgInvalidQueryException extends smdgException {}
    public  class smdgInvalidEngineRequestException extends smdgException {}

    public static smdgRequest InsertDefaults(smdgRequest request)
    {
 
        //If there are no filters - then create a dummy record:
        if (request.filters==null)
            request.filters = new list<smdgFilter>();
        //default pagesize and pageid if not set
        if (request.PageSize ==null)
            request.PageSize = 10;
        if (request.PageID ==null)
            request.PageID = 1;
        return request;
    }

    public static void VerifyRequest(smdgRequest request, Map<String, smdgField> mFields)
    {
        //Check if any of the filters aren't in the original set of ids for fields
        for (smdgFilter filter : request.filters)
        {
            //Note that mfields only has fields that are already checked for FLS so this is in effect an FLS check
            if (!mfields.containsKey(filter.smdgFieldID))
            {
                throw new smdgInvalidFilterException('Invalid smdgRequest.Filters');
            }
        }

        //And the sort order - can't sort by a field that you can't select...
        if (!String.isBlank(request.SortColumn))
        {
            if (!mfields.containsKey(request.SortColumn))
            {
                throw new smdgInvalidSortException('Invalid smdgRequest.SortColumn');
            }
        }
    }

    public static map<String, smdgField> GetSelectFieldsMap(smdg smdgObject)
    {

        Map<String, smdgField> results = new Map<String, smdgField>();
        //Get all the fields for the select clause
        for (smdgField field : smdgObject.smdgFields)
        {
            results.put(field.id,field);
        }
        return results;
    }
 
    public static List<String> GetUniqueSelectFieldsList(smdg smdgObject)
    {
        Set<String> fieldset = new Set<String>();
        //Get all the fields for the select clause
        for (smdgField field : smdgObject.smdgFields)
        {

            //Add the selectable field to the list of select names
            if (String.isNotBlank(field.columnName))
            {
                String colname = field.columnName;
                //Translate any picklist values
                if (field.FieldType ==String.valueof(Schema.DisplayType.PICKLIST))
                {
                    colname = 'tolabel(' + colname + ')';
                }
                if (field.FieldType ==String.valueof(Schema.DisplayType.CURRENCY))
                {
                    //if (field.FieldStyle == 'ShowCurrencyCode')
                    fieldset.add(String.escapeSingleQuotes(colname));
                    colname = 'FORMAT(' + colname + ') ' + colname + 'Formatted';

                }

                fieldset.add(String.escapeSingleQuotes(colname));
            }

        }
        List<String> res = new List<STring>();
        res.addall(fieldset);
        return res;
    }

    public static smdgResult getsmdgResultRaw(smdg newsmdg, smdgRequest request)
    {
        system.debug('QueryEngine:getsmdgResultRaw');
        system.debug(json.serialize(request));
        system.debug(json.serialize(newsmdg));
        //Verify against the database, and escape everything - including the config values

        Boolean bInvalidRequest = false;
        integer internalpageid=0;
        decimal internalPageSize =0;
        String sAllWhereClause = '';
        String sCoreWhereClause = '';
        String pageQuery = '';
        Boolean DisableSharing = true;
        List<String> UserWhereClauses = new List<String>();
        List<String> CoreWhereClauses = new List<String>();
        String sCountLimit = ' limit 10000';
        String AllRows  = '';

        //Lots of steps:
        //0 Test if this is an apex call instead:
        //1 Verify that the data is valid for searching
        //2 Get the core query constructed
        //3 Do parent record id
        //4 Get where clause
        //5 handle pagination

        //load the smdg and fields:

        smdgResult result = new smdgResult();


        Map<String, smdgField> mFields = new Map<String, smdgField>();

        result.isError = true;
        result.ErrorMessage = 'No smdg found';
        //Validate that the request is safe:
        if (newsmdg!=null)
        {
            //The smdg record exists
            try
            {
                mFields = GetSelectFieldsMap(newsmdg);
                //Fix any blank data for paging and null filters
                request = InsertDefaults(request);

                //check there's nothing wrong - will throw an exception
                VerifyRequest(request, mFields);

                //Everything looks oK so far so save the filters
                smdgPreferences.SaveFilters(request, newsmdg.InternalData.sUniqueKey);

                //and generate the query
                List<String> AllSelectFields = GetUniqueSelectFieldsList(newsmdg);

                // Note FLS checks done on AllSelectFields when retrieving smdg (in e.Getsmdg()) above - actually in GetsmdgFields and GetsmdgFieldsFromFieldSet
                // Also - filters can only exist for fields - so this auto filters based on FLS
                pageQuery = 'SELECT ' + String.join(AllSelectFields,',') + ' FROM ' +  String.escapeSingleQuotes(newsmdg.internalData.sObjectName);

                internalpageid =Integer.valueOf(request.PageID);
                internalPageSize = integer.valueOf(request.PageSize);
                internalpageid = internalpageid-1;
                String sSortClause;

                 sSortClause = BuildSortClause(newsmdg, request, mFields);

                //support where it's blank so we can use on non related lists
                if (!String.isBlank(newsmdg.InternalData.ParentFieldName))
                {
                    CoreWhereClauses.add( ' ' + String.escapeSingleQuotes(newsmdg.InternalData.ParentFieldName) + ' = \'' + String.escapeSingleQuotes(request.ParentRecordID) + '\' ');
                }

                //Add the serverside default filter:
                if (!String.isBlank(newsmdg.InternalData.sFilter))
                {
                    CorewhereClauses.add(' ' + newsmdg.InternalData.sFilter + ' ');
                }

                //Loop through each filter clause
                UserWhereClauses = AddFilters(request, mfields);

                //Now merge all parts together
                List<STring> AllWhereClauses = new List<String>();
                AllWhereClauses.AddAll(CoreWhereClauses);
                AllWhereClauses.AddAll(UserWhereClauses);

                if (AllWhereClauses.size()>0)
                    sAllWhereClause = ' WHERE ' + String.join( AllWhereClauses, ' AND ');
                if (CoreWhereClauses.size()>0)
                    sCoreWhereClause = ' WHERE ' + String.join( CoreWhereClauses, ' AND ');

                sAllWhereClause = smdgQueryBuilder.ProcessMergeFields(sAllWhereClause, request.ParentRecordId);
                sCoreWhereClause = smdgQueryBuilder.ProcessMergeFields(sCoreWhereClause, request.ParentRecordId);

                pageQuery = pageQuery + sAllWhereClause;
                integer offset =integer.valueOf( internalPageSize * internalpageid);
                String sPagination = ' limit ' + internalPageSize + ' offset  ' + offset;

                if (newsmdg.InternalData.AllRows)
                {
                    AllRows = ' ALL ROWS';
                }

                pageQuery = pageQuery +  sSortClause + sPagination + AllRows;
                system.debug('getsmdgResultRaw:pageQuery: ' + pageQuery);
            }
            catch (Exception ex)
            {
                throw new smdgInvalidEngineRequestException(ex);
            }

            try
            {
              
                //now evaluate the count
                String countQuery = 'select count() from ' + String.escapeSingleQuotes(newsmdg.InternalData.sObjectName) + ' ' + sAllWhereClause + sCountLimit + AllRows;
                DisableSharing = newsmdg.internalData.DisableSharing;

                Integer countFull = smdgDatabase.CountQuery(countQuery, DisableSharing);

                result.FullQueryCount =countFull;
                result.pagecount = (integer) math.ceil(countFull/internalPageSize);

                result.data = smdgDatabase.Query(pageQuery, DisableSharing);
                system.debug('Query complete - pagesize: ' + result.data.size());
                result.query = pageQuery;
                result.isFiltered = UserWhereClauses.size()>0;
                result.isError = false;
                result.ErrorMessage = '';
            }
            catch (exception ex)
            {
                result.query = pageQuery;
                throw new smdgInvalidQueryException('Unable to query: ' + pageQuery, ex);
            }

        }

        return  result;
    }
    private static String BuildSortClause(smdg smdg, smdgRequest request, Map<String, smdgField> mFields)
    {

        //Default input:
        String sSortColumn = 'Id';
        String sSortOrder = 'A';
        String sSortClause = '';
        try
        {
            if (!String.isBlank(request.SortColumn)) {
                try
                {
                    sSortColumn = String.escapeSingleQuotes(((smdgField)mFields.get(request.SortColumn)).ColumnName);
                    sSortOrder = request.SortOrder;
                }
                catch(Exception ex)
                {
                    //bad sort - remove sort:
                    sSortColumn = '';
                    sSortOrder = '';
                }

            }
            else
            {
                //NO FLS check here for internal sorts
                String defaultSort = smdg.InternalData.sDefaultSort;

                if (String.isNotBlank( defaultSort))
                {
                    String[] sSortClauseParts = defaultSort.trim().toLowerCase().split(' ');
                    sSortColumn = sSortClauseParts[0];
                
                    sSortOrder = 'A';
                    if (sSortClauseParts.size()==2)
                    {
                        if (((sSortClauseParts[1]).left(1).toLowerCase() == 'd'))
                            sSortOrder = 'D';
                    }

                }
            }

            //Now build the actual clause:
            sSortClause = smdgQueryBuilder.buildSortClause(sSortColumn, sSortOrder);
            
        }
        catch (Exception ex)
        {
            if (smdgEx.RaiseNew(ex))
                throw new smdgInvalidSortException('Invalid sort clause', ex);
        }
        return sSortClause;
    }
    private static List<String> AddFilters(smdgRequest request, Map<String, smdgField> mfields)
    {
        system.debug('smdgQueryEngine:AddFilters ' + JSON.serialize(request.filters));
        List<String> UserWhereClauses = new List<String>();
        for (smdgFilter filter : request.filters)
        {
            if (string.isblank(filter.filteroperator))
                filter.filteroperator = '=';

            smdgField databasefield = mfields.get(filter.smdgFieldID);
            if (databasefield.canFilter)
            {
                String clause = smdgQueryBuilder.BuildFilterClause( databasefield.ColumnName, databasefield.FieldType, filter.filterOperator, filter.filterValue);
                if (!String.isBlank(clause))
                     UserWhereClauses.add(clause);
            }
        }
        return UserWhereClauses;
    }

}