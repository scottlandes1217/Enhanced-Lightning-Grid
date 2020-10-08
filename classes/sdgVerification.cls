/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
public with sharing class smdgVerification {

    public static Boolean VerifysmdgAndFields(List<string> ids)
    {
        List<smdg__c> smdgs = [select id, sObjectName__c, Parent_field_Name__c, is_valid__c from smdg__c where id in :ids];
        Boolean smdgsHasErrors = Verifysmdg(smdgs, true);
        List<smdg_field__c> fields = [select id, apiname__c, smdg__c, is_valid_field__c from smdg_field__c where smdg__c in :smdgs];
        Boolean smdgFieldsHasErrors = VerifysmdgFields(fields, true);

        Boolean canSave = (!smdgsHasErrors) && !(smdgFieldsHasErrors);
        if(canSave)
        {
            for (smdg__c smdg: smdgs)
            {
                smdg.is_valid__c = true;
            }
            for (smdg_field__c field: fields)
            {
                field.is_valid_field__c = true;
            }

            update smdgs;

            update fields;
        }
        return canSave;
    }

    public static Boolean Verifysmdg(List<smdg__c> smdgs, Boolean MarkInvalid)
    {
        Boolean hasErrors = false;
        //1. is the object name valid
        //2. is the parent field name valid and an ID/Reference field

        //Get list of sObjectNames
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        //Get case insensitive map:
        Map<String, String> gdinsensitive = new Map<String, String>();
        for(String sot : gd.keyset()) {
            String lcase = sot;//.toLowerCase();
            gdinsensitive.put(lcase, gd.get(sot).getDescribe().getName());
        }

        List<String> sobjectNames = new List<String>();
        for(smdg__c smdg : smdgs)
        {
            if (smdg.is_valid__c)
            {

                    if (gdinsensitive.containsKey(smdg.sObjectName__c.tolowercase()))
                    {
                        smdg.sObjectName__c = gdinsensitive.get(smdg.sObjectName__c.tolowercase());
                    }
                    else
                    {
                        if (MarkInvalid)
                        {
                            hasErrors = true;
                            smdg.is_valid__c = false;
                        }
                        else
                        {
                            smdg.AddError('Cannot identify sObject: ' + smdg.sObjectName__c);
                        }
                    }

                if (!String.isblank(smdg.parent_field_name__c))
                {
                    //Verify parentfieldname
                    smdgPathParser pp = new smdgPathParser(smdg.parent_field_name__c, gd.get(smdg.sObjectName__c));
                    try
                    {
                        smdg.Parent_Field_Name__c = pp.FixCase();
                        //Now test if it's an ID:
                        smdgPathParser pp2 = new smdgPathParser(smdg.parent_field_name__c, gd.get(smdg.sObjectName__c));
                        Schema.DisplayType dt = pp2.getDescribe().getType();
                        if (!((dt == Schema.DisplayType.REFERENCE) || (dt == schema.DisplayType.ID)) )
                        {
                            if (MarkInvalid)
                            {
                                hasErrors = true;
                                smdg.is_valid__c = false;
                            }
                            else
                            {
                                smdg.addError('Parent field (' + smdg.Parent_Field_Name__c + ') must be a reference or ID field.');
                            }

                        }
                        else
                        {
                            smdg.is_valid__c = true;
                        }
                    }
                    catch (Exception ex)
                    {
                        if (MarkInvalid)
                        {
                            hasErrors = true;
                            smdg.is_valid__c = false;
                        }
                        else
                        {
                            smdg.AddError('Unable to resolve path: ' + smdg.Parent_Field_Name__c);
                        }
                    }

                    }

            }
        }
        return hasErrors;

    }

    public static Boolean VerifysmdgFields(List<smdg_Field__c> smdgfields, Boolean MarkInvalid)
    {
        Boolean hasErrors = false;

        //1. is the api field name valid for the smdg__C
        List<String> ids = new List<string>();
        for(smdg_Field__c field: smdgfields)
        {
            ids.add(field.smdg__c);
        }
        Map<ID, smdg__c> mapsmdg = new Map<ID, smdg__c>();
        List<smdg__c> smdgs = [select id, sObjectName__c from smdg__c where id in :ids];
        mapsmdg.putAll(smdgs);

        for (smdg_field__c field: smdgfields)
        {
            if (field.is_valid_field__c)
            {
                smdg__c smdg = mapsmdg.get(field.smdg__c);

                    //Get list of sObjectNames
                    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
                    if (String.isBlank(field.apiName__c))
                    {
                        if (MarkInvalid)
                        {
                            field.is_valid_field__c = false;
                            hasErrors = true;
                        }
                        else
                        {
                            field.AddError('API Name is mandatory');
                        }
                    }
                    else
                    {
                        //Verify api name
                        smdgPathParser pp = new smdgPathParser(field.apiName__c, gd.get(smdg.sObjectName__c));
                        try
                        {
                            field.apiname__c = pp.FixCase();
                            field.is_valid_field__c = true;
                        }
                        catch (Exception ex)
                        {
                            if (MarkInvalid)
                            {
                                field.is_valid_field__c = false;
                                hasErrors = true;
                            }
                            else
                            {
                                field.AddError('Unable to resolve API Name: ' + field.apiname__c + ' from ' + smdg.sObjectName__c);
                            }
                        }
                    }

            }
        }
        return hasErrors;
    }

}