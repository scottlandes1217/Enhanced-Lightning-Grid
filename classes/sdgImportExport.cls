/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
public with sharing class smdgImportExport {
    static integer CURRENTVERSION = 1;
    @AuraEnabled
    public static String Exportsmdg(String Id)
    {
        smdgExportFormat pak = new smdgExportFormat();
        pak.version = CURRENTVERSION;
        smdg__c smdg = [select name, smdg_tag__c, default_sort__c, filter__c, is_valid__c, Parent_Field_Name__c,  sObjectName__c, All_Rows__c, DisableSharing__c, (select name, APIName__c, Field_Style__c, FieldOrder__c, Hide_Filter__c, is_valid_field__c, Override_Label__c, smdg__c from smdgFields__r),  (select name, Action_Order__c, Action_Type__c, Event__c, Event_Payload__c, Requires_Createable__c, Requires_Deletable__c, Requires_Editable__c, smdg__c, Icon__c from smdg_Actions__r)  from smdg__c where id = :Id limit 1];
        smdg.Id = null;
        for(smdg_field__c field : smdg.smdgFields__r)
        {
            field.id = null;
            field.smdg__c = null;
        }
        for(smdg_action__c action : smdg.smdg_Actions__r)
        {
            action.id = null;
            action.smdg__c = null;
        }
        pak.smdg = smdg;
        String payload = JSON.serialize(pak);
        return payload;
    }
    @AuraEnabled
    public static String Importsmdg(String payload)
    {

        String Id;
        smdgExportFormat pak;
        try
        {
            pak = (smdgExportFormat)JSON.deserializeStrict(payload, smdgExportFormat.class);
        }
        catch (Exception ex)
        {
            throw new AuraHandledException('Unable to parse payload.  Please check you copied correctly.');
        }

        if (pak.version == CURRENTVERSION)
        {
            try
            {
                smdg__c smdg = pak.smdg;
                insert smdg;
                for(smdg_action__c action : smdg.smdg_Actions__r)
                {
                    action.smdg__c = smdg.id;
                }
                for(smdg_field__c field : smdg.smdgFields__r)
                {

                    field.smdg__c = smdg.id;
                }
                insert smdg.smdg_Actions__r;
                insert smdg.smdgFields__r;
                ID = smdg.Id;
            }
            catch (Exception ex)
            {
                throw new AuraHandledException('Unable to insert payload: ' + ex.getMessage());
            }
        }
        else
        {
            throw new AuraHandledException('Invalid version provided - you cannot import this version into this org.');
        }
        return ID;
    }
    public static smdg__c Getsmdg(String payload)
    {

        String Id;
        smdgExportFormat pak;
        try
        {
            pak = (smdgExportFormat)JSON.deserializeStrict(payload, smdgExportFormat.class);
        }
        catch (Exception ex)
        {
            system.debug(ex.getMessage());
            throw new smdgException('smdgImportExport:Getsmdg: Unable to parse payload.  Please check you copied correctly.');
        }
        smdg__c smdg;

            try
            {
                smdg = pak.smdg;

            }
            catch (Exception ex)
            {
                throw new AuraHandledException('Unable to insert payload: ' + ex.getMessage());
            }

        return smdg;
    }
}