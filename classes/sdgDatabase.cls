/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
public with sharing class smdgDatabase {

public static integer CountQuery(string query, Boolean DisableSharing)
    {
        system.debug('disable sharing: ' + DisableSharing);
        if (DisableSharing)
        {
            smdgDatabaseWithoutSharing ws = new smdgDatabase.smdgDatabaseWithoutSharing();
            return ws.CountQuery(query );
        }
        else
        {
            smdgDatabaseWithSharing ws = new smdgDatabase.smdgDatabaseWithSharing();
            return ws.CountQuery(query );
        }
        
    }
    public static List<SObject> Query(string query, Boolean DisableSharing)
    {
        system.debug('disable sharing: ' + DisableSharing);
        if (DisableSharing)
        {
            smdgDatabaseWithoutSharing ws = new smdgDatabase.smdgDatabaseWithoutSharing();
            return ws.Query(query );
        }
        else
        {
            smdgDatabaseWithSharing ws = new smdgDatabase.smdgDatabaseWithSharing();
            return ws.Query(query );
        }
        
    }
    public with sharing class smdgDatabaseWithSharing {
        public integer CountQuery(string query)
        {
            return database.countQuery(query);
        }

        public List<SObject> Query(string query)
        {
            return database.Query(query);
        }
    }

    private without sharing class smdgDatabaseWithoutSharing{
        public integer CountQuery(string query)
        {
            return database.countQuery(query);
        }

        public List<SObject> Query(string query)
        {
            return database.Query(query);
        }
    }

}