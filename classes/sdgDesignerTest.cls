/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class smdgDesignerTest {
    static testmethod void GetSObjectFieldsTest()
    {
        test.startTest();

        List<AuraFieldSelectOption> results = smdgDesigner.GetSObjectFields('Account', '');
        system.assertNotEquals(0, results.size(), 'Expecting multiple fields');

        test.stopTest();
    }

    static testmethod void GetNamespaceTest()
    {
        test.startTest();

        string results = smdgDesigner.GetNamespace();
        system.assertEquals(smdgNamespaceUtility.getNamespace(), results, 'Expecting namespace');

        test.stopTest();
    }
    static testmethod void GetNewFieldOrderTest()
    {
        Id smdgid = smdgTestData.GenerateTestSampleData();
        test.startTest();
        integer result = smdgDesigner.GetNewFieldOrder(smdgid);
        system.assertEquals(3, result, 'Expecting new field order');
        smdgTestData.GenerateTestsmdgFieldString(smdgid, 'name', 5);
        integer result2 = smdgDesigner.GetNewFieldOrder(smdgid);
        system.assertEquals(6, result2, 'Expecting new field order - 5+1');
        test.stopTest();

    }

    static testmethod void GetSObjectFieldsIDTest()
    {
        Id recordId = smdgTestData.GenerateTestsmdg();
        test.startTest();

        List<AuraFieldSelectOption> smdgresults = smdgDesigner.GetSObjectFields('smdg__c', '');
        //system.debug(smdgresults.size());
        List<AuraFieldSelectOption> fieldresults = smdgDesigner.GetSObjectFields('smdg_Field__c', '');
        //system.debug(fieldresults.size());
        List<AuraFieldSelectOption> smdgbyIDresults = smdgDesigner.GetSObjectFields('', recordId);
        //system.debug(smdgbyIDresults.size());
        system.assert(smdgresults.size()>10, 'Expecting multiple fields');
        system.assert(fieldresults.size()>10, 'Expecting multiple sObjectTypes');

        //test data has a sObjectName of smdg_field__c
        system.assertEquals(fieldresults.size(), smdgbyIDresults.size(), 'Expecting same data from both object name and id');

        test.stopTest();
    }

}