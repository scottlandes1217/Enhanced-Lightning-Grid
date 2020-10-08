/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public with sharing class smdgObjectEventHandlerTest {


    static testMethod void DeleteTestUnauthorised()
    {

        // Setup test data
        // This code runs as the system user

        User u1 = smdgSecurityTest.CreateUser('1');
        user u2 = smdgSecurityTest.CreateUser('2');
        String smdgid = '';

        System.runAs(u1) {
            smdgid = smdgTestData.GenerateTestsmdg();

        }
        List<smdg__c> smdgs = [select id from smdg__c where id = :smdgid];
        system.assertequals(1,smdgs.size(), 'Should be 1 smdg');

        System.runAs(u2) {
            String results = smdgObjectEventHandler.DeleteObject(smdgid);
            system.debug(results);
        }
        smdgs = [select id from smdg__c where id = :smdgid];
        system.assertequals(1,smdgs.size(), 'Should still be 1 smdg as user cannot delete');
        //As original user again
        System.runAs(u1) {
            String results2 = smdgObjectEventHandler.DeleteObject(smdgid);
            system.debug(results2);
        }
        smdgs = [select id from smdg__c where id = :smdgid];
        system.assertequals(1,smdgs.size(), 'Should still be 1 smdg as u1 does not have crud rights');

        //Now back as admin
        String results3 = smdgObjectEventHandler.DeleteObject(smdgid);
        system.debug(results3);

        smdgs = [select id from smdg__c where id = :smdgid];
        system.assertequals(0,smdgs.size(), 'Should be 0 smdg as admin has delete all');

    }
    static testMethod void DeleteTest()
    {
        //Create records:
        Account a = new Account();
        a.Name = 'Account1';
        insert a;
        String aID = a.id;

        //test for it's existence
        List<Account> test1 = [select id from account where id = :aID];
        system.assert(test1.size()==1,'Test account was not created');

        //Now try to delete it:
        String results = smdgObjectEventHandler.DeleteObject(aID);

        //should be deleted
        List<Account> test2 = [select id from account where id = :aID];
        system.assert(test1.size()!=0,'Test account was not deleted');


        //Now test for invalid id (by using same ID again)
        String results2 = smdgObjectEventHandler.DeleteObject(aID);
        system.assert(results2.contains('You do not have permission to delete this record'), 'Should have thrown an error at deleting invalid ID');

    }

    static testMethod void RecordTypeTest()
    {
        //Cannot test record types within test classes so simply assert no error:
        try
        {
            String results = smdgObjectEventHandler.GetRecordTypes('Account');
            system.assert(true);
        }
        catch (exception ex)
        {
            system.assert(false, 'error occurred when retrieving record types');
        }


    }



}