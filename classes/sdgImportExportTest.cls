/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public with sharing class smdgImportExportTest {

    static testMethod void exportValidTest()
    {
        //generate a test smdg:
        String sid = smdgTestDAta.GenerateTestSampleData();
        smdgTestData.GenerateAction(sid);
        Test.startTest();
        String s = smdgImportExport.Exportsmdg(sid);
        List<smdg__c> smdgs = [select id from smdg__c where id = :sid];
        delete smdgs;
        integer istart = database.countQuery('select count() from smdg__c');
        try
        {
       		 string s2 = smdgImportExport.Importsmdg(s);
        }
        catch (exception ex)
        {
            system.debug(ex.getMessage() + ' : ' + ex.getCause() + ' : ' + ex.getStackTraceString());
            system.assert(false, ex.getStackTraceString());
        }
        integer ifinish = database.countQuery('select count() from smdg__c');
        Test.stopTest();
        system.assertEquals(0, istart, 'Expected 0 smdg to start');
        system.assertEquals(1, ifinish, 'Expected an smdg to be created');


    }

    static testMethod void importInvalidVersionTest()
    {
        //generate a test smdg, export, change version, and try to import:
        String sid = smdgTestDAta.GenerateTestSampleData();
        smdgTestData.GenerateAction(sid);

        String s = smdgImportExport.Exportsmdg(sid);
        smdgExportFormat pak;

        pak = (smdgExportFormat)JSON.deserializeStrict(s, smdgExportFormat.class);
        pak.version = 2;
        s = JSON.serialize(pak);

        List<smdg__c> smdgs = [select id from smdg__c where id = :sid];
        delete smdgs;
        Test.startTest();
        Boolean haserrors = false;
        try
        {
            string s2 = smdgImportExport.Importsmdg(s);
        }
        catch (exception ex)
        {
            haserrors = true;
        }
        Test.stopTest();
        system.assertEquals(true,haserrors, 'Expected exception due to pak version');


    }

    static testMethod void importInvalidFormaTest()
    {
        //generate a test smdg, export, edit and try to import:
        String sid = smdgTestData.GenerateTestSampleData();
        smdgTestData.GenerateAction(sid);

        String s = smdgImportExport.Exportsmdg(sid);
        //make it invalid
        s = s.left(s.length() -2);

        List<smdg__c> smdgs = [select id from smdg__c where id = :sid];
        delete smdgs;
        Test.startTest();
        Boolean haserrors = false;
        try
        {
            string s2 = smdgImportExport.Importsmdg(s);
        }
        catch (exception ex)
        {
            haserrors = true;
        }
        Test.stopTest();
        system.assertEquals(true,haserrors, 'Expected exception due to invalid payload version');


    }
}