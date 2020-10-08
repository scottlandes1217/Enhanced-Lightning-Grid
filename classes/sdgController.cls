/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
public with sharing class smdgController {


    @AuraEnabled
    public static string GetNamespace()
    {
        return JSON.serialize( smdgNamespaceUtility.GetNamespace());
    }

    @AuraEnabled
    public static String GetsmdgInitialLoad(String ParentRecordID, String smdgTag, String RelationshipName, String FieldSetName, integer DefaultPageSize)
    {
        //Create response object
        smdgInitialLoad initial = new smdgInitialLoad();
        // Salesforce bug with Lightning serializer requires re-casting this value
        //https://salesforce.stackexchange.com/questions/108355/limit-expression-must-be-of-type-integer-error-when-using-apex-variable-in-soq/108423#108423
        try {
            DefaultPageSize = Integer.valueOf(DefaultPageSize);
        }
        catch (Exception ex)
        {
            throw new AuraHandledException('Invalid DefaultPageSize provided');
        }
        
        system.debug('smdgController:GetsmdgInitialLoad:' + ParentRecordID + ':' + smdgTag + ':' + RelationshipName + ':' + FieldSetName);
        try
        {
            smdg newsmdg = smdgDataProviderFactory.Loadsmdg(smdgTag, ParentRecordId, RelationshipName, FieldsetName);
            //Create a full request:
            smdgRequest req = new smdgRequest();

            if (!String.isBlank(smdgTag))
            {
            	req = smdgPreferences.GenerateRequestWithFilters(newsmdg, ParentRecordID, smdgTag);
            } 
            req.RelationshipName = RelationshipName;
            req.FieldSetName = FieldSetName;
            req.ParentRecordID = ParentRecordID;
            req.smdgTag = smdgTag;
            req.PageSize = DefaultPageSize;

            smdgResult result = smdgDataProviderFactory.getData( req, newsmdg);
            //Blank out the internal data to save payload:
            newsmdg.InternalData = null;

            //build response object:
            initial.smdgObject = newsmdg;
            initial.results = result;
            initial.isError = false;
        }
        
        catch (smdgException ex)
        {
            initial.ErrorMessage = ex.getMessage();
            initial.isError = true;
        }
        catch (Exception standardex)
        {
            initial.ErrorMessage = standardex.getMessage();
            initial.isError = true;
        }
        return JSON.serialize(initial);
    }

    @AuraEnabled
    public static string getsmdgResult(String jsonrequest)
    {
        smdgResult results = new smdgResult();

        String resultsstring = '';
        try
        {
            system.debug('smdgController:getsmdgResult: getting request');
            smdgRequest request = (smdgRequest)JSON.deserialize(jsonrequest, smdgRequest.class);
            system.debug('smdgController:getsmdgResult: getting result');

            results = smdgDataProviderFactory.getData(request);

            results.isError=false;
        }
        catch (Exception ex)
        {
            system.debug('smdgController:getsmdgResult: Exception: ' + ex.getMessage() );
            results.ErrorMessage = ex.getMessage();
            results.isError = true;
        }
        return JSON.serialize(results);
    }
}