/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
public with sharing class smdgDataProviderFactory  {
    public class smdgDataProviderFactoryException extends Exception {}
    public class smdgInvalidConfigurationNameException extends Exception {}
    private static final string delim = ':';

    public static Boolean isNameValid(String name)
    {
        boolean isOK = false;
        if (name.startswithignoreCase(smdgDataProviderType.Apex.name() + delim) || name.startswithignoreCase(smdgDataProviderType.Metadata.name() + delim) || name.startswithignoreCase(smdgDataProviderType.CustomObject.name() + delim) || name.startswithignoreCase(smdgDataProviderType.Relationship.name() + delim))
        {
            String[] parts = name.split(delim);
            if (parts.size()>1)
            {
                isOK = true;
            }
        }
        if (!isOK)
        {
            throw new smdgInvalidConfigurationNameException('Invalid configuration: ' + name);
        }
        return isOk;
    }

    @TestVisible
    private  static smdgIDataProvider getClass(String name)
    {
        smdgIDataProvider ret;
        try
        {
            smdgDataProviderType smdgtype = getType(name);


            String tag = GetTag(name);
            if (smdgtype == smdgDataProviderType.Relationship)
            {
                system.debug('smdgDataProviderFactory:getClass: smdgRelationshipDataProvider');

                smdgDataProviderRelationship relation = new smdgDataProviderRelationship();
                ret = relation ;
            }
            else if (smdgtype== smdgDataProviderType.Apex)
            {
                system.debug('smdgDataProviderFactory:getClass: ' + name);

                //Test it:
                try
                {
                    Type customType = Type.forName(tag);
                    Object a = customType.newInstance();
                    //is this a valid type that implements the correct interface
                    if (a instanceof smdgIDataProvider)
                    {
                        //all ok
                        ret = (smdgIDataProvider)a;
                    }
                }
                catch (smdgException smdgex)
                {
                    throw smdgex;
                }
                catch(Exception ex)
                {
                    //Invalid class name
                    throw new smdgDataProviderFactoryException('Unable to instantiate class: ' + name,ex);
                }

            }
            else if (smdgtype ==smdgDataProviderType.CustomObject)
            {
                //use the normal data provider:
                system.debug('smdgDataProviderFactory:getClass: smdgNativeDataProvider');

                smdgDataProviderNative native = new smdgDataProviderNative();
                ret= native;
            }
            else if ( smdgtype==smdgDataProviderType.Metadata)
            {
                system.debug('smdgDataProviderFactory:getClass: smdgMetadataDataProvider');
                smdgDataProviderMetadata meta = new smdgDataProviderMetadata();
                ret= meta;
            }

            if (ret!=null)
            {
                return ret;
            }
            else
            {
                throw new smdgDataProviderFactoryException('smdgDataProviderFactory:getClass: No provider available: ' + name);
            }
        }
        catch (Exception ex)
        {
            if (ex instanceof smdgException)
            {
                throw ex;
            }
            else
            {
                throw new smdgDataProviderFactoryException('Unable to get class', ex);
            }
        }
        return null;
    }
    private static smdgDataProviderType GetType(String tag)
    {
        smdgDataProviderType ret =smdgDataProviderType.Relationship; //default
        if (tag.startsWithIgnoreCase(smdgDataProviderType.Apex.name() + delim))
            ret = smdgDataProviderType.Apex;
        if (tag.startsWithIgnoreCase(smdgDataProviderType.CustomObject.name() + delim))
            ret = smdgDataProviderType.CustomObject;
        if (tag.startsWithIgnoreCase(smdgDataProviderType.Relationship.name() + delim))
            ret = smdgDataProviderType.Relationship;
        if (tag.startsWithIgnoreCase(smdgDataProviderType.Metadata.name() + delim))
            ret = smdgDataProviderType.Metadata;

        return ret;
    }

    private static string GetTag(String tag)
    {
        List<String> parts = tag.split(delim);
        parts.remove(0);

        string ret = String.join(parts,delim);

        return ret;
    }

    public  static smdgResult getData( smdgRequest request)
    {
        return getData(request, null);
    }
    public  static smdgResult getData( smdgRequest request, smdg coresmdg)
    {

        system.debug('smdgDataProviderFactory:getData: ' + request.smdgTag);
        smdgResult result = new smdgResult();
        if (coresmdg == null)
            coresmdg = Loadsmdg(request.smdgTag, request.ParentRecordId, request.RelationshipName, request.FieldSetName);
        smdgIDataProvider handler = smdgDataProviderFactory.getClass(request.smdgTag);
        system.debug('smdgDataProviderFactory:getData preparing page size');
        //Fix potential problems in the request:
        if (request.pageid ==null)
            request.pageid = 1;
        if (request.pagesize ==null)
            request.pagesize = 10;

        if (handler!=null)
        {
            try
            {
                result = handler.getData(coresmdg, request);
            }
            catch (exception ex)
            {
                if (smdgEx.RaiseNew(ex))
                    throw new smdgDataProviderFactoryException('Unable to get data from the data provider: ' + coresmdg.sObjectName + ' - ' + ex.getMessage(), ex);
            }
        }
        else
        {
            throw new smdgDataProviderFactoryException('Invalid data provider on smdg: ' + coresmdg.sObjectName);
        }

        return result;
    }

    public static smdg Loadsmdg(String smdgTag, String ParentRecordId, String RelationshipName, String FieldsetName)
    {

        smdg Coresmdg;

        if (GetType(smdgTag) == smdgDataProviderType.Relationship)
        {
            system.debug('smdgDataProviderFactory:Loadsmdg:Loading from Fieldset');
            system.debug('RelationshipName: ' + RelationshipName);

            //smdgLoaderFieldSet l = new smdgLoaderFieldset();
            smdgDataProviderRelationship dp = new smdgDataProviderRelationship();
            coresmdg = dp.Loadsmdg(ParentRecordID, RelationshipName, FieldSetName);
        }
        else
        {
            system.debug('smdgDataProviderFactory:Loadsmdg: ' + smdgTag);

            coresmdg = getClass(smdgTag).Loadsmdg(getTag(smdgTag), ParentRecordId);

        }
        return coresmdg;

    }

}