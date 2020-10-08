/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class smdgQueryEngineTest {



    static testMethod void TestBooleanFilter()
    {
        //Generate test data: an account and an opportunity:
        String testdata= smdgTestData.GenerateTestSampleData();

        STring erlid = smdgTestData.GenerateTestsmdg();
        String stringfield = smdgTestData.GenerateTestsmdgFieldString(erlid);
        String datefield = smdgTestData.GenerateTestsmdgFieldDate(erlid);
        String booleanfield = smdgTestData.GenerateTestsmdgFieldBoolean(erlid);
        String picklistfield = smdgTestData.GenerateTestsmdgFieldPicklist(erlid);

        Test.startTest();

        //Generate a request:
        smdgREquest req = new smdgREquest();
        req.smdgTag ='CustomObject:' + smdgTestData.TestsmdgName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke normal list:
        smdgResult result = getresult(req);
        system.assertEquals(2, result.FullQueryCount,'TestBooleanFilter: Expected rowcount=2 from load');

        //create a filter for TRUE:
        List<smdgFilter> Filters = new List<smdgFilter>();
        smdgFilter newfilter = new smdgFilter();
        newfilter.smdgFieldID = booleanfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='true';
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result2 = getResult(req);
        system.assertEquals(2, result2.FullQueryCount,'TestBooleanFilter: Expected rowcount=2 from is is_valid__c filter');
        system.assertEquals(false, result2.isError,'TestBooleanFilter: Expected no error with  boolean=true filter');

        //create a filter for FALSE:
        filters.clear();
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = booleanfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='false';
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result3 = getResult(req);
        system.assertEquals(0, result3.FullQueryCount,'TestBooleanFilter: Expected rowcount=0 from is is_valid=false filter');
        system.assertEquals(false, result3.isError,'TestBooleanFilter: Expected no error with  boolean=false filter');

        //invalid value
        filters.clear();
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = booleanfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='teapot';
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result4 = getResult(req);
        system.assertEquals(true, result4.isError,'TestBooleanFilter: Expected error with invalid boolean filter');


        Test.stopTest();
    }
    static testMethod void TestPicklistFilter()
    {
        //Generate test data: an account and an opportunity:
        String testdata= smdgTestData.GenerateTestSampleData();

        STring erlid = smdgTestData.GenerateTestsmdg();
        String stringfield = smdgTestData.GenerateTestsmdgFieldString(erlid);
        String datefield = smdgTestData.GenerateTestsmdgFieldDate(erlid);
        String booleanfield = smdgTestData.GenerateTestsmdgFieldBoolean(erlid);
        String picklistfield = smdgTestData.GenerateTestsmdgFieldPicklist(erlid);

        //Prep test catching values:
        Boolean errorThrown=false;
        String errorMsg = '';
        Test.startTest();

        //Generate a request:
        smdgREquest req = new smdgREquest();
        req.smdgTag = 'CustomObject:' + smdgTestData.TestsmdgName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke:
        smdgResult  result = getresult(req);
        system.assertEquals(2, result.FullQueryCount,'TestPicklistFilter: Expected rowcount=2 from load');
        system.assertEquals(false, result.isError,'TestPicklistFilter: No error expected');

        //create a filter
        List<smdgFilter> Filters = new List<smdgFilter>();
        smdgFilter newfilter = new smdgFilter();
        newfilter.smdgFieldID = picklistfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='Prospecting';
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result2 = getresult(req);
        system.assertEquals(0, result2.FullQueryCount,'TestPicklistFilter: Expected rowcount=0 from picklist filter=prospecting');
        system.assertEquals(false, result2.isError,'TestPicklistFilter: No error expected filter = prospecting');
        smdg_field__c f = [select id, field_style__c from smdg_field__c where smdg__r.id = :testdata limit 1];
        f.field_style__c = 'Age';
        update f;
        //test with a filter that returns 1 row:
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = picklistfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='Age';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result3 = getresult(req);
        system.assertEquals(1, result3.FullQueryCount,'TestPicklistFilter: Expected rowcount=1 from filter=Age');
        system.assertEquals(false, result3.isError,'TestPicklistFilter: No error expected: filter=Age lost');

        Test.stopTest();
    }
    static testMethod void TestDateFilter()
    {
        //Generate test data: an account and an opportunity:
        String testdata=smdgTestData.GenerateTestSampleData();

        STring erlid = smdgTestData.GenerateTestsmdg();
        String stringfield = smdgTestData.GenerateTestsmdgFieldString(erlid);
        String datefield = smdgTestData.GenerateTestsmdgFieldDate(erlid);
        String datetimefield = smdgTestData.GenerateTestsmdgFieldDateTime(erlid);
        String booleanfield = smdgTestData.GenerateTestsmdgFieldBoolean(erlid);
        String picklistfield = smdgTestData.GenerateTestsmdgFieldPicklist(erlid);


        Test.startTest();

        //Generate a request:
        smdgREquest req = new smdgREquest();
        req.smdgTag = 'CustomObject:' + smdgTestData.TestsmdgName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke:
        smdgResult  result = getresult(req);
        system.assertEquals(0, result.FullQueryCount,'Expected rowcount=2 from load');

        //create a filter that forces zero rows:
        List<smdgFilter> Filters = new List<smdgFilter>();
        smdgFilter newfilter = new smdgFilter();
        newfilter.smdgFieldID = datefield;
        newfilter.FilterOperator='LAST_WEEK';
        newfilter.filtervalue='=';
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result2 = getresult(req);
        system.assertEquals(0, result2.FullQueryCount,'Expected rowcount=0 from date filter');

        //filter with thisweek
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = datefield;
        newfilter.FilterOperator='THIS_WEEK';
        newfilter.filtervalue='=';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result3 = getresult(req);
        system.assertEquals(false, result3.isError,'Date filter this week: ' + result3.ErrorMessage);
        system.assertEquals(2, result3.FullQueryCount,'Expected rowcount=2 from filter');

        //test with a real date filter
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = datefield;
        Date d = Date.today();
        String sd = d.year() + '-' + String.valueOf(d.month()).leftpad(2).replaceall(' ','0') + '-' + String.valueOf(d.day()).leftpad(2).replaceall(' ','0')  ;
        newfilter.FilterOperator='=';
        newfilter.filtervalue=sd;
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result4 = getresult(req);
        system.assertEquals(false, result4.isError,'Date filter today: ' + result4.ErrorMessage);
        system.assertEquals(2, result4.FullQueryCount,'Date filter today: mismatch');

        //test with a real date filter
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = datefield;
        date d2 = DAte.today().addDays(-1);
        String sd2 = d2.year() + '-' + d2.month() + '-' + d2.day() ;

        newfilter.FilterOperator='=';
        newfilter.filtervalue=sd2;
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result5 = getresult(req);
        system.assertEquals(0, result5.FullQueryCount,'Expected rowcount=0 from date filter yesterday');

        //test with a real date filter
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = datefield;
        newfilter.FilterOperator='GT';
        newfilter.filtervalue=sd2;
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result6 = getresult(req);
        system.assertEquals(2, result6.FullQueryCount,'Expected rowcount=2 from date filter greater than yesterday');

        //Less than test
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = datefield;
        newfilter.FilterOperator='LT';
        newfilter.filtervalue=sd2;
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result7 = getresult(req);
        system.assertEquals(0, result7.FullQueryCount,'Expected rowcount=0 from date filter less than yesterday');

        //Invalid date
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = datefield;
        newfilter.FilterOperator='LT';
        newfilter.filtervalue='an invalid date';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result8 = getresult(req);
        system.assertEquals(true, result8.isError, 'expected error for invalid date format' );


        Test.stopTest();
    }

    static testMethod void TestDateTimeFilter()
    {
        //generate test data of: one smdg, with two columns - name and [namespace]apiname
        String testdata= smdgTestData.GenerateTestSampleData();
        //Generate the querying smdg
        STring erlid = smdgTestData.GenerateTestsmdg();
        smdgTestData.GenerateTestsmdgFieldString(erlid);
        smdgTestData.GenerateTestsmdgFieldDate(erlid);
        String datetimefield = smdgTestData.GenerateTestsmdgFieldDateTime(erlid);
        smdgTestData.GenerateTestsmdgFieldBoolean(erlid);
        smdgTestData.GenerateTestsmdgFieldPicklist(erlid);


        Test.startTest();

        //Generate a request:
        smdgREquest req = new smdgREquest();
        req.smdgTag = 'CustomObject:' + smdgTestData.TestsmdgName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke:
        smdgResult  result = getresult(req);
        system.assertEquals(0, result.FullQueryCount,'Expected rowcount=2 from load');

        //create a literal filter:
        List<smdgFilter> Filters = new List<smdgFilter>();
        smdgFilter newfilter = new smdgFilter();
        newfilter.smdgFieldID = datetimefield;
        newfilter.FilterOperator='LAST_WEEK';
        newfilter.filtervalue='ABC';
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result2 = getresult(req);
        system.assertEquals(0, result2.FullQueryCount,'Expected rowcount=0 from datetime filter last week');

        //filter with thisweek
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = datetimefield;
        newfilter.FilterOperator='THIS_WEEK';
        newfilter.filtervalue='DEF';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result3 = getresult(req);
        system.assertEquals(2, result3.FullQueryCount,'Expected rowcount=2 from filter this week');

        //test with a real date filter
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = datetimefield;
        Date d = Date.today();
        String sd = d.year() + '-' + String.valueOf(d.month()).leftpad(2).replaceall(' ','0') + '-' + String.valueOf(d.day()).leftpad(2).replaceall(' ','0')  ;
        newfilter.FilterOperator='=';
        newfilter.filtervalue=sd;
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result4 = getresult(req);
        system.assertEquals(false, result4.isError,'Expected no error from date filter today: ' + result4.ErrorMessage);
        system.assertEquals(2, result4.FullQueryCount,'Expected rowcount=2 from date filter today');

        //GT
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = datetimefield;
        newfilter.FilterOperator='GT';
        newfilter.filtervalue=sd;
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result5 = getresult(req);
        system.assertEquals(false, result5.isError,'Expected no error from datetime GT ' + result4.ErrorMessage);
        system.assertEquals(0, result5.FullQueryCount,'Expected rowcount=2 from datetime GT ');

        //LT
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = datetimefield;
        newfilter.FilterOperator='LT';
        newfilter.filtervalue=sd;
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result6 = getresult(req);
        system.assertEquals(false, result6.isError,'Expected no error from LT datetime filter ' + result4.ErrorMessage);
        system.assertEquals(0, result6.FullQueryCount,'Expected rowcount=2 from LT datetime filter ');


        Test.stopTest();
    }

    static testMethod void TestDefaultFilter()
    {
        //Generate test data: an account and an opportunity:
        String testdata=smdgTestData.GenerateTestSampleData();

        STring erlid = smdgTestData.GenerateTestsmdg();

        String stringfield = smdgTestData.GenerateTestsmdgFieldString(erlid);

        Test.startTest();

        //Generate a request:
        smdgRequest req = new smdgREquest();
        req.smdgTag = 'CustomObject:' + smdgTestData.TestsmdgName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;
        req.sortOrder='A';
        req.sortColumn=stringfield;

        //Now invoke normal list:
        smdgResult result = getresult(req);
        system.assertEquals(2, result.FullQueryCount, 'expected two rows in results');

        //Now add a server side filter
        smdg__c smdg2 = [select id, name, filter__c from smdg__c where id=:erlid];

        smdg2.filter__c = 'apiname__c like \'na%\'';
        update smdg2;
        smdgResult result2 = getresult(req);
        system.assertEquals(1, result2.FullQueryCount, 'Server side filter');

        TEst.stopTest();

    }
    static testMethod void TestFilterCacheing()
    {
        String testdata=smdgTestData.GenerateTestSampleData();

        STring erlid = smdgTestData.GenerateTestsmdg();
        String stringfield = smdgTestData.GenerateTestsmdgFieldString(erlid);
        String datefield = smdgTestData.GenerateTestsmdgFieldDate(erlid);
        String booleanfield = smdgTestData.GenerateTestsmdgFieldBoolean(erlid);
        String picklistfield = smdgTestData.GenerateTestsmdgFieldPicklist(erlid);

        //Prep test catching values:
        Boolean errorThrown=false;
        String errorMsg = '';
        Test.startTest();

        //Generate a request:
        smdgREquest req = new smdgRequest();
        req.smdgTag = 'CustomObject:' + smdgTestData.TestsmdgName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke normal list:
        smdgResult result = getresult(req);
        system.assertEquals(2, result.FullQueryCount,'Expected rowcount=2 from load');

        //create a filter for =:
        List<smdgFilter> Filters = new List<smdgFilter>();
        smdgFilter newfilter = new smdgFilter();
        newfilter.smdgFieldID = stringfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue=smdgNamespaceUtility.GetNamespace() + 'APIName__c';
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result2 = getResult(req);
        system.assertEquals(1, result2.FullQueryCount,'Expected rowcount=1 from = filter');

        //Filter should now be cached - so try and do a normal load and count the results:
        String results3 = smdgController.GetsmdgInitialLoad(testdata, 'CustomObject:' + smdgTestDAta.TestsmdgName, '', '',10);

        smdgInitialLoad initial2 = (smdgInitialLoad)JSON.deserialize(results3, smdgInitialLoad.class);
        system.debug(initial2.Results.query);
        system.assertEquals(false, initial2.Results.isError,'Should be able to execute.');

        Test.stopTest();

    }
    static testMethod void TestStringFilter()
    {
        //Generate test data:
        //one smdg, with two columns - name and [namespace]apiname
        String testdata=smdgTestData.GenerateTestSampleData();
        //String s2 = smdgTestData.GenerateTestsmdgFieldString(testdata);
        //String n2 = smdgTestData.GenerateTestsmdgFieldStringName(testdata);

        //and the filterer
        STring erlid = smdgTestData.GenerateTestsmdg();
        String stringfield = smdgTestData.GenerateTestsmdgFieldString(erlid);
        String namefield = smdgTestData.GenerateTestsmdgFieldStringName(erlid);
        String datefield = smdgTestData.GenerateTestsmdgFieldDate(erlid);
        String booleanfield = smdgTestData.GenerateTestsmdgFieldBoolean(erlid);
        String picklistfield = smdgTestData.GenerateTestsmdgFieldPicklist(erlid);

        //Prep test catching values:
        Boolean errorThrown=false;
        String errorMsg = '';
        Test.startTest();

        //Generate a request:
        smdgREquest req = new smdgREquest();
        req.smdgTag = 'CustomObject:' + smdgTestData.TestsmdgName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke normal list:
        smdgResult result = getresult(req);
        system.assertEquals(2, result.FullQueryCount,'Load with no filter');

        //create a filter for =:
        List<smdgFilter> Filters = new List<smdgFilter>();
        smdgFilter newfilter = new smdgFilter();
        newfilter.smdgFieldID = stringfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='Name';
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result2 = getResult(req);
        system.assertEquals(1, result2.FullQueryCount,'Query with = filter');

        //Invalid filter test
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = 'an invalid value';
        newfilter.FilterOperator='NOT=';
        newfilter.filtervalue='Banana';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result31 = getresult(req);
        system.assertEquals(true, result31.isError,'Expected error with invalid filter field specified');


        //NOT= test
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = stringfield;
        newfilter.FilterOperator='NOT=';
        newfilter.filtervalue='Banana';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result32 = getresult(req);
        system.assertEquals(2, result32.FullQueryCount,'not= filter');


        //STARTS test
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = stringfield; //apiname
        newfilter.FilterOperator='STARTS';
        newfilter.filtervalue='Na';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result3 = getresult(req);
        system.debug('zzzzzzz');
        system.debug(result3.query);
        system.debug(result3.errormessage);
        system.assertEquals(1, result3.FullQueryCount,'Starts with filter');

        //ENDS test
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = stringfield;
        newfilter.FilterOperator='ENDS';
        newfilter.filtervalue='ame';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result35 = getresult(req);
        system.assertEquals(1, result35.FullQueryCount,'Expected rowcount=1 from ends filter');

        //ENDS test #2
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = stringfield;
        newfilter.FilterOperator='ENDS';
        newfilter.filtervalue='__c';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result36 = getresult(req);
        system.assertEquals(1, result36.FullQueryCount,'Expected rowcount=1 from ends filter');


        //Contains
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = stringfield;
        newfilter.FilterOperator='CONTAINS';
        newfilter.filtervalue='ame'; //part of 'test'
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result4 = getresult(req);
        system.assertEquals(2, result4.FullQueryCount,'Expected rowcount=1 from contains filter');

        //2nd test for contains
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = stringfield;
        newfilter.FilterOperator='CONTAINS';
        newfilter.filtervalue='APIN'; // not part of 'test'
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result5 = getresult(req);
        system.assertEquals(1, result5.FullQueryCount,'Expected rowcount=1 from  contains filter');

        // test for NOT contains
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = stringfield;
        newfilter.FilterOperator='NOTCONTAINS';
        newfilter.filtervalue='elephant'; //  part of 'test'
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result6 = getresult(req);
        system.assertEquals(2, result6.FullQueryCount,'Expected rowcount=2 from notcontains filter');

        // negative test for NOT contains
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = stringfield;
        newfilter.FilterOperator='NOTCONTAINS';
        newfilter.filtervalue='__c'; //  part of 'test'
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result7 = getresult(req);
        system.assertEquals(1, result7.FullQueryCount,'Expected rowcount=1 from negative notcontains filter');


        Test.stopTest();
    }


    static testMethod void TestAllRows()
    {
        String testdata= smdgTestData.GenerateTestSampleData();

        String erlid = smdgTestData.GenerateTestsmdg();
        String stringfield = smdgTestData.GenerateTestsmdgFieldString(erlid);
        
        Test.startTest();

        //Generate a request:
        smdgREquest req = new smdgREquest();
        req.smdgTag = 'CustomObject:' + smdgTestData.TestsmdgName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;

        //Now invoke normal list:
        smdgResult result = getresult(req);
        system.assertEquals(2, result.FullQueryCount,'Expected rowcount=2 from load');

        //Now delete a row and try again:
        smdg_Field__c row1 = [select id from smdg_field__c where smdg__c = :testdata limit 1];
        delete row1;

        smdgResult result2 = getResult(req);
        system.assertEquals(1, result2.FullQueryCount,'Expected rowcount=1 with deleted row');
        system.assertEquals(false, result2.isError,'Expected no error with deleted row');

        //Now set All_Rows = true and try again
        smdg__c erl = [select id, All_rows__c from smdg__c where id = :erlid limit 1];
        erl.all_rows__c = true;
        update erl; 

        smdgResult result3 = getResult(req);
        system.assertEquals(2, result3.FullQueryCount,'Expected rowcount=1 with deleted row');
        system.assertEquals(false, result3.isError,'Expected no error with deleted row');
        
        Test.stopTest();
    }
    static testMethod void TestNumberFilter()
    {
        //Generate test data: an account and an opportunity:
        String testdata= smdgTestData.GenerateTestSampleData();

        STring erlid = smdgTestData.GenerateTestsmdg();
        String stringfield = smdgTestData.GenerateTestsmdgFieldString(erlid);
        String datefield = smdgTestData.GenerateTestsmdgFieldDate(erlid);
        string numberfield = smdgTestData.GenerateTestsmdgFieldNumber(erlid);
        String booleanfield = smdgTestData.GenerateTestsmdgFieldBoolean(erlid);
        String picklistfield = smdgTestData.GenerateTestsmdgFieldPicklist(erlid);


        Test.startTest();

        //Generate a request:
        smdgREquest req = new smdgREquest();
        req.smdgTag = 'CustomObject:' + smdgTestData.TestsmdgName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke normal list:
        smdgResult result = getresult(req);
        system.assertEquals(2, result.FullQueryCount,'Expected rowcount=2 from load');

        //create a filter for TRUE:
        List<smdgFilter> Filters = new List<smdgFilter>();
        smdgFilter newfilter = new smdgFilter();
        newfilter.smdgFieldID = numberfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='5';
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result2 = getResult(req);
        system.assertEquals(0, result2.FullQueryCount,'Expected rowcount=0 from fieldorder=number filter');
        system.assertEquals(false, result2.isError,'Expected no error with  fieldorder=number filter');

        //create a filter for FALSE:
        filters.clear();
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = numberfield;
        newfilter.FilterOperator='GT';
        newfilter.filtervalue='1';
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result3 = getResult(req);
        system.assertEquals(1, result3.FullQueryCount,'Expected rowcount=1 from is fieldorder>1 filter');
        system.assertEquals(false, result3.isError,'Expected no error with  fieldorder>1 filter');


        filters.clear();
        newfilter = new smdgFilter();
        newfilter.smdgFieldID = numberfield;
        newfilter.FilterOperator='LT';
        newfilter.filtervalue='10';
        filters.add(newfilter);
        req.Filters = filters;

        smdgResult result4 = getResult(req);
        system.assertEquals(2, result4.FullQueryCount,'Expected rowcount=2 from is fieldorder<10 filter');
        system.assertEquals(false, result4.isError,'Expected no error with  amount<10 filter');


        Test.stopTest();
    }

    static smdgResult GetResult(smdgRequest req)
    {
        String results = smdgController.getsmdgResult(JSON.serialize(req));
        smdgResult result = (smdgResult)JSON.deserialize(results, smdgResult.class);
        return result;

    }
}