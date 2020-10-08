/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class smdgVerificationTest {

    static testmethod void TestsmdgInvalidObjectName()
    {
        smdg__c smdg = new smdg__c();
        smdg.name = 'asillyname';
        smdg.smdg_tag__c = smdg.name;
        smdg.sObjectName__c = 'an impossible object name';
        smdg.is_valid__c = true;
        test.startTest();
        Boolean errorThrown = false;
        try
        {
            insert smdg;
        }
        catch (Exception ex)
        {
            errorthrown = true;
        }
        system.assertequals(True, errorThrown, 'Expected smdg error on invalid object name' );
        smdg.is_valid__c = false;
        errorthrown = false;
        try
        {
            insert smdg;
        }
        catch (Exception ex)
        {
            errorthrown = true;
        }
        system.assertequals(False, errorThrown, 'Expected no smdg error as marked invalid' );
        Test.stopTest();
    }
    static testmethod void TestsmdgValidObjectName()
    {
        smdg__c smdg = new smdg__c();
        smdg.name = 'a title';
        smdg.smdg_tag__c = smdg.name;
        smdg.sObjectName__c = 'account';
        smdg.is_valid__c = true;
        test.startTest();
        Boolean errorThrown = false;
        try
        {
            insert smdg;
        }
        catch (Exception ex)
        {
            errorthrown = true;
        }
        system.assertequals(False, errorThrown, 'Expected no error on object name' );
        //reload item:
        smdg = [select sObjectName__c from smdg__c where id = :smdg.Id limit 1];

        system.assertequals(smdg.sObjectName__c, 'Account', 'Should have changed name from account to Account 1');
        system.assertnotequals(smdg.sObjectName__c, 'account', 'Should have changed name from account to Account 2');

        Test.stopTest();
    }
    static testmethod void VerifysmdgForce()
    {
        smdg__c smdg = new smdg__c();
        smdg.name = 'asillyname';
        smdg.smdg_tag__c = smdg.name;
        smdg.sObjectName__c = 'an impossible object name';
        smdg.is_valid__c = false;
        insert smdg;
        test.startTest();
        Boolean errorThrown = false;
        List<smdg__c> smdgs = new List<smdg__c>();
        smdgs.add(smdg);
        smdg.is_valid__c = true;  //but not committed;
        system.assertequals(smdg.is_valid__c, true, 'smdg should now be valid before test');
        Boolean result = false;
        try
        {
            result = smdgVerification.Verifysmdg(smdgs, true);

        }
        catch (Exception ex)
        {
            errorthrown = true;
        }
        system.assertequals(smdg.is_valid__c, false, 'smdg should now be invalid');

    }
    static testmethod void TestsmdgParentNameCase()
    {
        smdg__c smdg = new smdg__c();
        smdg.name = 'whatever';
        smdg.smdg_tag__c = smdg.name;
        smdg.sObjectName__c = 'Contact';
        smdg.is_valid__c = true;
        smdg.Parent_Field_Name__c = 'account.id';
        test.startTest();

        Boolean errorThrown = false;
        try
        {
            insert smdg;
        }
        catch (Exception ex)
        {
            errorthrown = true;
        }
        //reload item:
        smdg = [select Parent_Field_Name__c from smdg__c where id = :smdg.Id limit 1];

        system.assertequals(errorThrown, false, 'smdg should not be invalid');
        system.assertNotEquals(smdg.Parent_Field_Name__c, 'account.id', 'Parent field name should have changed 1');
        system.assertEquals(smdg.Parent_Field_Name__c, 'Account.Id', 'Parent field name should have changed 2');
        test.stopTest();

    }

    static testmethod void TestsmdgParentNotId()
    {
        smdg__c smdg = new smdg__c();
        smdg.name = 'whatever';
        smdg.smdg_tag__c = smdg.name;
        smdg.sObjectName__c = 'Contact';
        smdg.is_valid__c = true;
        smdg.Parent_Field_Name__c = 'account.Name';
        test.startTest();

        Boolean errorThrown = false;
        try
        {
            insert smdg;
        }
        catch (Exception ex)
        {
            errorthrown = true;
        }
        //reload item:
        //smdg = [select Parent_Field_Name__c from smdg__c where id = :smdg.Id limit 1];

        system.assertequals(errorThrown, true, 'smdg should  be invalid');
        test.stopTest();

    }
    static testmethod void TestsmdgParentNotIdMarkInvalid()
    {
        smdg__c smdg = new smdg__c();
        smdg.name = 'whatever';
        smdg.smdg_tag__c = smdg.name;
        smdg.sObjectName__c = 'Contact';
        smdg.is_valid__c = false;
        smdg.Parent_Field_Name__c = 'account.Name';
        test.startTest();
        insert smdg;
        List<smdg__c> smdgs = new List<smdg__c>();
        smdgs.add(smdg);
        Boolean errorThrown = false;
        try
        {

            smdg.is_valid__c = true;
            system.assertequals(smdg.is_valid__c, true, 'Should be valid before test');
            smdgVerification.Verifysmdg(smdgs, true);
        }
        catch (Exception ex)
        {
            errorthrown = true;
        }
        //reload item:
        smdg = [select is_valid__c, Parent_Field_Name__c from smdg__c where id = :smdg.Id limit 1];

        system.assertequals(errorThrown, false, 'Should not throw an error');
        system.assertequals(smdg.is_valid__c, false, 'Should be invalid as name not id');

        test.stopTest();

    }

    static testmethod void TestsmdgParentInvalidMarkInvalid()
    {
        smdg__c smdg = new smdg__c();
        smdg.name = 'whatever';
        smdg.smdg_tag__c = smdg.name;
        smdg.sObjectName__c = 'Contact';
        smdg.is_valid__c = false;
        smdg.Parent_Field_Name__c = 'account.name';
        test.startTest();
        insert smdg;
        List<smdg__c> smdgs = new List<smdg__c>();
        smdgs.add(smdg);
        Boolean errorThrown = false;
        try
        {

            smdg.is_valid__c = true;
            smdg.Parent_Field_Name__c = 'account.zoop';

            system.assertequals(smdg.is_valid__c, true, 'Should be valid before test');
            smdgVerification.Verifysmdg(smdgs, true);
        }
        catch (Exception ex)
        {
            errorthrown = true;
        }
        //reload item:
        smdg = [select is_valid__c, Parent_Field_Name__c from smdg__c where id = :smdg.Id limit 1];

        system.assertequals(errorThrown, false, 'Should not throw an error');
        system.assertequals(smdg.is_valid__c, false, 'Should be invalid as name invalid');

        test.stopTest();

    }

    static testmethod void TestsmdgParentInvalidName()
    {
        smdg__c smdg = new smdg__c();
        smdg.name = 'whatever';
        smdg.smdg_tag__c = smdg.name;
        smdg.sObjectName__c = 'Contact';
        smdg.is_valid__c = true;
        smdg.Parent_Field_Name__c = 'account.Twinkles';
        test.startTest();

        Boolean errorThrown = false;
        try
        {
            insert smdg;
        }
        catch (Exception ex)
        {
            errorthrown = true;
        }
        system.assertequals(errorThrown, true, 'smdg should be invalid with an invalid parent name');
        test.stopTest();

    }

    static testmethod void VerifysmdgAndFieldsTest()
    {
        String s = smdgTestData.GenerateTestSampleData();
        smdgTestData.GenerateTestsmdgFieldString(s);

        List<String> ids = new List<String>();
        ids.add(s);

        test.startTest();

        Boolean result = smdgVerification.VerifysmdgAndFields(ids);
        system.assertEquals(true,result, 'Should be able to save this smdg');
        //Load item again
        smdg__c smdg = [select id, is_valid__c, sObjectName__c from smdg__c where id = :s];
        system.assertEquals(true,smdg.is_valid__c, 'smdg should now be valid');

        Test.stopTest();

    }

    static testmethod void TestsmdgFieldPath()
    {
        String smdgid = smdgTestDAta.GenerateTestsmdg();

        smdg_Field__c efield = new smdg_Field__c();
        efield.apiname__c='amounts';
        efield.FieldOrder__c=5;
        efield.is_valid_field__c = true;
        efield.smdg__c= smdgid;
        Test.startTest();
        Boolean errorThrown =false;
        try
        {
            insert efield;
        }
        catch (DMLException ex)
        {
            errorThrown = true;
        }

        system.assertEquals( errorThrown, true, 'Expected error for invalid field name');

        errorThrown =false;
        try
        {
            efield.apiname__c = smdgNamespaceUtility.GetNamespace() + 'apiname__c';
            insert efield;
        }
        catch (DMLException ex)
        {
            errorThrown = true;
        }

        system.assertEquals( errorThrown, false, 'Expected no error for valid field name');


    }

    static testmethod void TestsmdgFieldPathVerify()
    {
        String smdgid = smdgTestDAta.GenerateTestsmdg();

        smdg_Field__c efield = new smdg_Field__c();
        efield.apiname__c=smdgNamespaceUtility.GetNamespace() + 'apiname__c';
        efield.FieldOrder__c=5;
        efield.is_valid_field__c = true;
        efield.smdg__c= smdgid;
        insert efield;
        List<smdg_Field__c> smdgfields = new list<smdg_field__c>();
        smdgfields.add(efield);

        Test.startTest();
        Boolean errorThrown =false;
        try
        {
            efield.apiname__c='amounts';
            Boolean hasErrors = smdgVerification.VerifysmdgFields(smdgfields, true);
            system.assertEquals(true, hasErrors, 'Should not be able to save this smdg field');

        }
        catch (DMLException ex)
        {
            errorThrown = true;
        }
        //Load item again
        efield = [select id, is_valid_field__c, apiname__c from smdg_field__c where id = :efield.id limit 1];

        system.assertEquals(true,efield.is_valid_field__c, 'smdg field should now be invalid');

        system.assertEquals( errorThrown, false, 'Expected no error for invalid field name');

        errorThrown =false;
        string emsg = '';
        try
        {
            efield.apiname__c = smdgNamespaceUtility.GetNamespace() + 'apiname__c';
            update efield;
        }
        catch (DMLException ex)
        {
            emsg = ex.getMessage();
            errorThrown = true;
        }

        system.assertEquals( errorThrown, false, 'Expected no error for valid field name: ' + emsg);


    }

}