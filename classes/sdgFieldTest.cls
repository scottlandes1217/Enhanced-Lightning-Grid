/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class smdgFieldTest {

    static testMethod void GetCreate()
    {
        test.startTest();
        smdgField f = new smdgField();
        test.stopTest();
        system.assertNotEquals(null,f, 'smdgFieldTest: Expected a smdgField to be created.');

    }
    static testmethod void GetCreate2()
    {
          test.startTest();
        List<AuraSelectOption> opts = new List<AuraSelectOption>();
        smdgField f = new smdgField('1', 'a label', 'Name', 'STRING', '', true, false, opts);
        test.stopTest();
        system.assertNotEquals(null,f, 'smdgFieldTest:GetCreate2: Expected a rich smdgField to be created.');
        system.assertEquals(true, f.canSort, 'smdgFieldTest:GetCreate2: Expected field to be saved');
   
   }
       static testmethod void GetCreate3()
    {
          test.startTest();
        List<AuraSelectOption> opts = new List<AuraSelectOption>();
        smdgField f = new smdgField('1', 'a label', 'Name', 'STRING', '', true, false, false, opts, 1);
        test.stopTest();
        system.assertNotEquals(null,f, 'smdgFieldTest:GetCreate3: Expected a rich smdgField to be created. Not HTML formatted');
        system.assertEquals(true, f.canSort, 'smdgFieldTest:GetCreate3: Expected field to be saved');
   
   }
    static testmethod void GetCreateFullDeprecated()
    {
        Boolean isError = false;
        try
        {

            List<AuraSelectOption> opts = new List<AuraSelectOption>();
            smdgField f = new smdgField('1', 'a label', 'STRING', '',  '', false, opts);

        }
        catch(smdgDeprecatedException ex)
        {
            isError = true;
        }
        system.assertEquals(true, isError, 'smdgFieldTest:GetCreateFullDeprecated: Expected smdgDeprecatedException');

    }
    static testMethod void GetCreateFull()
    {
        test.startTest();
        List<AuraSelectOption> opts = new List<AuraSelectOption>();
        smdgField f = new smdgField('1', 'a label', 'STRING', '', '', true, false, opts, 1);
        test.stopTest();
        system.assertNotEquals(null,f, 'smdgFieldTest:GetCreateFull: Expected a rich smdgField to be created.');
        system.assertEquals(true, f.canSort, 'smdgFieldTest:GetCreateFull: Expected field to be saved');
    }
}