/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
global with sharing class smdgDataProviderNative implements smdgIDataProvider {
    global static Boolean isUserSelectable()
    {
        return false;
    }
    global static smdgResult getData(smdg Coresmdg, smdgRequest request)
    {
        
        smdgResult result =  smdgQueryEngine.getsmdgResultRaw(Coresmdg, request);
        return result;
    }
    
    global   smdg Loadsmdg(String smdgTag, String ParentRecordId)
    {
        smdg Coresmdg = null;
        
        smdgSecurity.CanQuery('smdgDataProviderNative:Loadsmdg', 'smdg__c', 'sobjectname__c, parent_field_name__c, filter__c, default_sort__c, is_valid__c, All_Rows__c, DisableSharing__c', 'Id', smdgNamespaceUtility.GetNamespace(), true);
        smdgSecurity.CanQuery('smdgDataProviderNative:GetsmdgActions' , 'smdg_Action__c', 'event__c, action_order__c, Requires_Createable__c, requires_deletable__c, Requires_Editable__c, Action_Type__c, Event_Payload__c, Icon__c', 'id,name', smdgNamespaceUtility.GetNamespace(), true);
        smdgSecurity.CanQuery('smdgDataProviderNative:GetsmdgFields', 'smdg_Field__c', 'apiname__c,  FieldOrder__c, Field_Style__c, Hide_Filter__c, Override_Label__c', 'id,name', smdgNamespaceUtility.GetNamespace(), true);
        
        List<smdg__c> smdgs= [select id, sobjectname__c, parent_field_name__c, filter__c, default_sort__c, is_valid__c, All_Rows__c, DisableSharing__c, (select id, name, event__c, Requires_Createable__c, Requires_Editable__c, requires_deletable__c, Action_Type__c, Event_Payload__c, Icon__c, action_order__c  from smdg_actions__r), (select id, name, apiname__c,  FieldOrder__c, Field_Style__c, Hide_Filter__c, Override_Label__c  from smdgFields__r where is_valid_field__c =true) from smdg__c where smdg_Tag__c = :smdgTag ];
        if (smdgs.size()!=1)
        {
            throw new smdgException('smdgDataProviderNative:Loadsmdg: Invalid number of smdg results for name: ' + smdgTag + '. retrieved: ' + smdgs.size());
        }
        else
        {
            //Now we can load this:
            smdg__c e;
            e = smdgs[0];
            
            system.debug('smdgDataProviderNative:Loadsmdg:Validity: ' + e.is_valid__c);
            if (!e.is_valid__c)
            {
                system.debug('This is an invalid smdg');
                throw new smdgException('smdg: ' + smdgTag + ' is marked as invalid');
            }
            
            Coresmdg = new smdg(e.sObjectName__c, e.Parent_Field_Name__c,  e.sobjectname__c,  e.Filter__c,  e.Default_Sort__c, e.Id, e.All_Rows__c );
            Coresmdg.internalData.DisableSharing = e.DisableSharing__c;

            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(Coresmdg.sObjectName);
            if (targetType==null)
            {
                system.debug('smdgDataProviderNative:Loadsmdg: invalid sObjectName');
                throw new smdgException('smdgDataProviderNative: Invalid sObjectName provided - are you missing a namespace?');
            }
            Id CoresmdgId = Coresmdg.InternalData.sUniqueKey;

            List<smdg_Field__c> fields = e.smdgfields__r;
            if (fields!=null)
                Coresmdg.smdgFields = GetsmdgFields(fields, targetType);
          
            List<smdg_Action__c> actions = e.smdg_actions__r;
            if (actions!=null)
                Coresmdg.smdgActions = GetsmdgActions(actions, e.sObjectName__c);
        }
        return coresmdg;
    }
    
    private  List<smdgAction> GetsmdgActions(List<smdg_Action__c> actions, String sObjectName)
    {
        

        List<smdgAction> results = smdgMapper.MapTosmdgActions(sObjectName, actions);
        results.sort();
        return results;
    }
    private  List<smdgField> GetsmdgFields(List<smdg_field__c> fields, Schema.SObjectType targetType )
    {
        
        if (fields.size()==0)
        {
            throw new smdgException('smdgDataProviderNative:GetsmdgFields: smdg has no fields');
        }
        
        //Now convert to fields - do FLS checks as well
        List<smdgField> results = smdgMapper.MapTosmdgFields(targetType, fields, true);
        results.sort();
        return results;
        
    }

    
}