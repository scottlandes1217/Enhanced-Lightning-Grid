/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
global with sharing class smdgDataProviderMetadata implements smdgIDataProvider {
    global static Boolean isUserSelectable()
    {
        return false;
    }

    global static smdgResult getData(smdg Coresmdg, smdgRequest request)
    {

        smdgResult result =  smdgQueryEngine.getsmdgResultRaw(Coresmdg, request);
        return result;
    }


    global smdg Loadsmdg(String smdgTag, String ParentRecordId)
    {
        smdg Coresmdg = null;
        try
        {

            smdgDefaults__mdt md = [SELECT Id, Definition__c FROM smdgDefaults__mdt where developername = :smdgTag limit 1];
     
            String definition = md.definition__c.replace('$namespace$', smdgNamespaceUtility.GetNamespace());
     
            smdg__c e =  smdgImportExport.getsmdg(definition);

            Coresmdg = smdgMapper.Convert(e, e.smdgfields__r, smdgSecurity.PermittedActions(e.sObjectName__c, e.smdg_actions__r), false);

            //now put the fields and action ids on - as they won't be in the pak payload
            integer iCounter = 1;
            coresmdg.smdgFields.sort();
            coresmdg.smdgActions.sort();
            
            for (smdgField field: coresmdg.smdgFields)
            {
                field.id = string.valueOf(icounter);
                icounter++;
            }
            for (smdgAction action: coresmdg.smdgActions)
            {
                action.id = string.valueOf(icounter);
                icounter++;
            }


            system.debug('smdgDataProviderMetadata:Loadsmdg: ' + smdgTag + ' ' + JSON.serialize(Coresmdg) );
        }
        catch (Exception ex)
        {
            throw new smdgException('smdgDataProviderMetadata:Loadsmdg: ' + smdgTag + ' : ' + ex.getMessage());
        }
        return coresmdg;
    }


}