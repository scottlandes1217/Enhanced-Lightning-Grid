/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
global with sharing class smdgRelationshipDataProvider implements smdgDataProvider {

    global static smdgResult getData(smdg Coresmdg, smdgRequest request)
    {
        throw new smdgDeprecatedException('smdgRelationshipDataProvider is Deprecated');
    }

    global  smdg Loadsmdg(smdg coresmdg)
    {
         throw new smdgDeprecatedException('smdgRelationshipDataProvider is Deprecated');

    }
    global   smdg Loadsmdg(String ParentRecordID, String RelationshipName, String FieldSetName)
    {
         throw new smdgDeprecatedException('smdgRelationshipDataProvider is Deprecated');
    }

}