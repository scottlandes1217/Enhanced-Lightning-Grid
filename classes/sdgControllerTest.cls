/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public with sharing class smdgControllerTest {
    /*
    static testMethod void GetsmdgTest()
    {
        //Generate test data
        String testid = smdgTestData.GenerateTestSampleData();

        //Prep test catching values:
        Boolean errorThrown=false;
        String errorMsg = '';
        Test.startTest();

        //Test all params missing:
        try
        {
            smdg e = smdgLoaderFactory.Loadsmdg('', '', '', '');

        }
        catch (smdgException ex)
        {
            errorThrown = true;
            errorMsg = ex.getMessage();
        }
        system.assertEquals(true, errorThrown, 'Expected an smdgException with no parameters');

        try
        {
            //smdgController smdgObj = new smdgController();
            smdg e = smdgLoaderFactory.Loadsmdg(testid, 'Opportunities', '','');

        }
        catch (smdgException ex)
        {
            errorThrown = true;
            errorMsg = ex.getMessage();
        }
        system.assertEquals(true, errorThrown, 'Expected an smdgException with no fieldset');

        Test.stopTest();
    }



    static testMethod void TestCustomObjInitialLoad()
    {
        //Generate test data: an account and an opportunity:
        String testdata=smdgTestData.GenerateTestSampleData();

        STring smdgid = smdgTestData.GenerateTestsmdg();
        //do not generate any fields to get an error

        Test.startTest();

        String results = smdgController.GetsmdgInitialLoad(testdata, '', '', smdgTestData.TestsmdgName);
        //json payload so parse
        smdgInitialLoad initial = (smdgInitialLoad)JSON.deserialize(results, smdgInitialLoad.class);
        system.assertEquals(true, initial.isError,'Expected error for smdg with no fields');
        Test.stopTest();
    }

    static testMethod void TestInvalidCustomObject()
    {
        //Generate test data: an account and an opportunity:
        String testdata=smdgTestData.GenerateTestSampleData();

        STring erlid = smdgTestData.GenerateTestsmdg();
        //create invalid row:
        smdg_Field__c efield = new smdg_Field__c();
        efield.apiname__c='notavalidname';
        efield.FieldOrder__c=1;
        efield.smdg__c= erlid;
        efield.is_valid_field__c=true;

        //Prep test catching values:
        Boolean errorThrown=false;
        String errorMsg = '';
        Test.startTest();

        try
        {
            insert efield;

        }
        catch (DMLException ex)
        {
            errorThrown = true;
        }

        Test.stopTest();
        system.assertEquals(true, errorThrown, 'Expected invalid field to throw exception as invalid');

    }

    static testMethod void TestsmdgInitialLoad()
    {
        //Generate test data: an account and an opportunity:
        String testdata=smdgTestData.GenerateTestSAmpleDAta();

        STring erlid = smdgTestData.GenerateTestsmdg();
        smdgTestData.GenerateTestsmdgFieldString(erlid);
        smdgTestData.GenerateTestsmdgFieldDate(erlid);
        smdgTestData.GenerateTestsmdgFieldBoolean(erlid);
        smdgTestData.GenerateTestsmdgFieldPicklist(erlid);

        //Prep test catching values:
        Boolean errorThrown=false;
        String errorMsg = '';
        Test.startTest();

        //Test Happy Path
        String results = smdgController.GetsmdgInitialLoad(testdata, smdgTestData.TestsmdgName, '', '');
        //json payload so parse
        smdgInitialLoad initial = (smdgInitialLoad)JSON.deserialize(results, smdgInitialLoad.class);
        system.assertEquals(2, initial.results.filteredrowcount,'Expected rowcount=2 from load');
        system.assertEquals(2, initial.results.data.size(),'Expected data size=1 from load');
        system.assertEquals(false, initial.isError,'No error expected: initial');

        //Test UnHappy Path
        errorThrown=false;
        errorMsg = '';

        String results2 = smdgController.GetsmdgInitialLoad(testdata, '', '', '');
        smdgInitialLoad initial2 = (smdgInitialLoad)JSON.deserialize(results2, smdgInitialLoad.class);
        system.assertEquals(true, initial2.isError, 'Expected handled error loading invalid Parent ID');
        system.assertEquals(false, initial.isError,'No error expected: initial2 ');
        //Test Unhappy Path

        errorThrown=false;
        errorMsg = '';
        String results3 = smdgController.GetsmdgInitialLoad(testdata, '', '', 'invalid value');
        smdgInitialLoad initial3  = (smdgInitialLoad)JSON.deserialize(results3, smdgInitialLoad.class);
        system.assertEquals(true, initial3.isError, 'Expected handled error loading invalid smdg Tag');
        system.assertEquals(false, initial.isError,'No error expected: initial3 ');

        Test.stopTest();
    }

    static smdgResult GetResult(smdgRequest req)
    {
        String results = smdgController.getsmdgResult(JSON.serialize(req));
        smdgResult result = (smdgResult)JSON.deserialize(results, smdgResult.class);
        return result;

    }

    static testMethod void TestSort()
    {
        //Generate test data:
        String testdata=smdgTestData.GenerateTestSampleData();

        STring erlid = smdgTestData.GenerateTestsmdg();
        String stringfield = smdgTestData.GenerateTestsmdgFieldString(erlid);
        String datefield = smdgTestData.GenerateTestsmdgFieldDate(erlid);
        String booleanfield = smdgTestData.GenerateTestsmdgFieldBoolean(erlid);
        String picklistfield = smdgTestData.GenerateTestsmdgFieldPicklist(erlid);
        smdgTestData.GenerateTestsmdgFieldTraverseString(erlid);

        Test.startTest();

        //Generate a request:
        smdgRequest req = new smdgRequest();
        req.smdgTag = smdgTestData.TestsmdgName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;
        req.sortOrder='A';
        req.sortColumn=stringfield;

        //Now invoke normal list:
        smdgResult result = getresult(req);
        //Test this is sorted?
        system.assertEquals(2, result.filteredrowcount, 'expected two rows in sort results');
        smdg_field__c o = (smdg_field__c)result.data[0];
        system.assertEquals('Name', o.sortablegrid__APIName__c, 'Expected');
        system.assertEquals(false, result.isError,'Should not get error with valid sort value');

        //Test descending sort
        req.sortOrder='D';
        smdgResult result2 = getresult(req);

        //Test this is sorted?
        system.assertEquals(2, result.filteredrowcount, 'expected two rows in sort results');
        smdg_field__c o2 = (smdg_field__c)result.data[0];
        system.assertNotEquals('sortablegrid__APIName__c', o2.sortablegrid__APIName__c, 'Expected changed order');
        system.assertEquals(false, result.isError,'Should not get error with valid sort value');


        //test invalid sort
        req.sortColumn='Account.Name';
        smdgResult result3 = getresult(req);
        //should have an error:
        system.assertEquals(true, result3.isError,'Should get error with invalid sort value');

    }

    static testMethod void TestInvalidsmdg()
    {
        //Generate test data: an account and an opportunity:
        String testdatarecordid= smdgTestData.GenerateTestSampleData();

        STring erlid = smdgTestData.GenerateTestsmdg();
        String stringfield = smdgTestData.GenerateTestsmdgFieldString(erlid);
        String datefield = smdgTestData.GenerateTestsmdgFieldDate(erlid);
        String booleanfield = smdgTestData.GenerateTestsmdgFieldBoolean(erlid);
        String picklistfield = smdgTestData.GenerateTestsmdgFieldPicklist(erlid);

        Test.startTest();

        //Generate a request:
        smdgRequest req = new smdgRequest();
        req.smdgTag = smdgTestData.TestsmdgName;
        req.ParentRecordID = testdatarecordid;
        req.pageid=1;
        req.pagesize=5;

        system.debug('request: ' + JSON.serialize(req));
        //Now invoke normal list:
        smdgResult result = getresult(req);
        system.debug('result: ' + JSON.serialize(result));
        system.assertEquals(false, result.isError,'TestInvalidsmdg: No error expected with valid smdg');
        system.assertEquals(2, result.filteredrowcount,'TestInvalidsmdg: Expected 2 smdgfields as this is a valid smdg');

        //Update smdg:
        smdg__c smdg = [select id, is_valid__c from smdg__c where id = :erlid limit 1];
        smdg.is_valid__c = false;
        update smdg;
        smdg = [select is_valid__c from smdg__c where id = :erlid limit 1];

        system.debug('set ' + smdg.id + ' to ' + smdg.is_valid__c + ' - should fail now');
        system.debug(JSON.serialize(smdg));
        smdgResult result2 = getResult(req);

        system.assertNotEquals('', result2.ErrorMessage,'Expected error message with is_valid=false');

        system.assertEquals(null, result2.filteredrowcount,'Expected rowcount=0 as this is now invalid smdg');
        system.assertEquals(true, result2.isError,'Expected error with is_valid=false');

        Test.stopTest();
    }
    */
}