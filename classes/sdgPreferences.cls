/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
public class smdgPreferences {

    public static smdgRequest GenerateRequestWithFilters(smdg smdg, String ParentRecordID, String smdgTag)
    {

        //Create a request:
        smdgRequest req = new smdgRequest();
        req.ParentRecordID = ParentRecordID;
        req.smdgTag = smdgTag;

        system.debug('smdgPreferences:GenerateRequestWithFilters');
        if (smdg.InternalData != null)
        {
            if (smdg.internalData.sUniqueKey!=null)
            {
            //Get the user preferences
            List<smdg_preferences__c> oldpref= [select filters__c from smdg_preferences__c where user__c = :UserInfo.getUserID() and smdgKey__c = :smdg.InternalData.sUniqueKey];
            if (oldpref.size()>0)
            {
                try
                {
                    system.debug('smdgPreferences:GenerateRequestWithFilters: retrieving filters');
                    req.filters = (List<smdgFilter>)JSON.deserialize(oldpref[0].filters__c, List<smdgFilter>.class);
                    Map<String, smdgFilter> mpFilters = new Map<String, smdgFilter>();
                    for (smdgFilter filter : req.filters)
                    {
                        mpFilters.put(filter.smdgFieldID, filter);
                    }
                    for(smdgField field : smdg.smdgFields)
                    {
                        if (mpFilters.containsKey(field.ID))
                            field.Preferences = mpFilters.get(field.ID);
                    }

                }
                catch(exception ex)
                {
                    //ignore this - caused by invalid/out of date filters usually
                }
            }
            }
        }
        return req;
    }

    public static void SaveFilters(smdgRequest request, String sUniqueKey)
    {
        //Save the Filters:
        String filters = JSON.serialize(request.Filters);
        smdg_preferences__c pref = new smdg_preferences__c();
        pref.User__c = UserInfo.getUserId();
        pref.Filters__c = filters;
        pref.smdgKey__c = sUniqueKey;
        if (String.isNotBlank(sUniqueKey))
        {
                try
                {
                    //Can't upsert using multiple columns so delete existing
                    if ( smdgSecurity.canQuery('smdgPreferences:SaveFilters', 'smdg_preferences__c','filters__c,user__c,smdgKey__c', '',smdgNamespaceUtility.GetNamespace(), false))
                    {

                            List<smdg_preferences__c> oldpref= [select id from smdg_preferences__c where user__c = :UserInfo.getUserID() and smdgKey__c = :sUniqueKey];
                            if (Schema.sObjectType.smdg_preferences__c.isDeletable())
                                delete oldpref;
                            if (Schema.sObjectType.smdg_preferences__c.isCreateable())
                                insert pref;
                    }
                }
                catch (DMLException ex)
                {
                    //this is probably a race condition on aura calls so ignore
                    system.debug('smdgPreferences:SaveFilters: DMLException - ignoring');
                }

        }
    }
}