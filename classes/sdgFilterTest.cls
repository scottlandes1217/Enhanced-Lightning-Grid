/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class smdgFilterTest {

    static testMethod void GetCreate()
    {
        test.startTest();
        smdgFilter f = new smdgFilter();
        test.stopTest();
        system.assertNotEquals(null,f, 'smdgFilterTest: Expected a smdgFilter to be created.');

    }

 	static testMethod void GetCreateFull()
    {
        test.startTest();
        smdgFilter f = new smdgFilter('1', '=', 'APPLE');
        test.stopTest();
        system.assertNotEquals(null,f, 'smdgFilterTest:GetCreateFull: Expected a rich smdgFilter to be created.');
        system.assertEquals('=', f.filterOperator, 'smdgFilterTest:GetCreateFull: Expected filteroperator to be saved ');
        system.assertEquals('APPLE', f.filterValue, 'smdgFilterTest:GetCreateFull: Expected filtervalue to be saved ');
    }
}