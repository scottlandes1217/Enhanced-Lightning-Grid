/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class smdgTestData {
    public static String TestsmdgName = 'Testsmdg';
    public static String TestSamplesmdgName = 'SampleDatasmdg';

    private  static string GenerateTestData(String smdgName)
    {
        //self referential - smdg showing smdg fields...
        string smdgid = GenerateCoresmdg(smdgName);
        List<smdg_Field__c> fields = new List<smdg_Field__c>();
        GenerateTestsmdgFieldString(smdgid, 'name', 1);
        GenerateTestsmdgFieldString(smdgid, smdgNamespaceUtility.GetNamespace() + 'apiname__c',2);

        return smdgid;
    }
    public static string GenerateCoresmdg(String smdgName)
    {
        smdg__c a = new smdg__c(Name=smdgName, smdg_tag__c = smdgName, is_valid__c=true, sobjectname__c=smdgNamespaceUtility.GetNamespace() + 'smdg_field__c', parent_field_name__c = smdgNamespaceUtility.GetNamespace() + 'smdg__r.id');
        insert a;
        system.debug('Createdsmdg: id: ' + a.id + ' - Name: ' + smdgName);
        return a.id;
    }
    public static string GenerateTestSampleData()
    {
        return GenerateTestData(TestSamplesmdgName);
    }
    public static String GenerateTestsmdg()
    {
        //Create a custom smdg:
        String id = GenerateTestData(TestsmdgName);
        GenerateAction(id);

        return Id;

    }
    public static string GenerateTestsmdgFieldStringName(String smdgID)
    {
        return GenerateTestsmdgFieldString(smdgid, 'Name',1);
    }

    public static string GenerateTestsmdgFieldString(String smdgID)
    {
        return GenerateTestsmdgFieldString(smdgid, smdgNamespaceUtility.GetNamespace() + 'APIname__c',1);
    }

    public static string GenerateTestsmdgFieldString(String smdgID, String fieldName, integer fieldorder)
    {
        //String Field
        smdg_Field__c field = new smdg_Field__c( apiname__c=fieldName, fieldOrder__c = fieldorder, smdg__c=smdgid, is_valid_field__c=true );
        insert field;
        return field.id;
    }

    /*public static string GenerateTestsmdgFieldTraverseString(String smdgID)
    {
        //String Field
        smdg_Field__c field = new smdg_Field__c( apiname__c=smdgNamespaceUtility.GetNamespace() + 'smdg__r.name', fieldOrder__c = 2, smdg__c=smdgid, is_valid_field__c=true );
        insert field;
        return field.id;
    }
*/
    public static string GenerateTestsmdgFieldNumber(String smdgID)
    {
        //String Field
        smdg_Field__c field = new smdg_Field__c( apiname__c=smdgNamespaceUtility.GetNamespace() + 'fieldorder__c', fieldOrder__c = 3, smdg__c=smdgid, is_valid_field__c=true );
        insert field;
        return field.id;

    }

    public static string GenerateTestsmdgFieldDate(String smdgID)
    {
        //Date
        smdg_Field__c field = new smdg_Field__c( apiname__c='createddate', fieldOrder__c = 4, smdg__c=smdgid, is_valid_field__c=true );
        insert field;
        return field.id;

    }
    public static string GenerateTestsmdgFieldDateTime(String smdgID)
    {
        //Date
        smdg_Field__c field = new smdg_Field__c( apiname__c='lastmodifieddate', fieldOrder__c = 5, smdg__c=smdgid, is_valid_field__c=true );
        insert field;
        return field.id;
    }
    public static string GenerateTestsmdgFieldBoolean(String smdgID)
    {
        smdg_Field__c field = new smdg_Field__c( apiname__c=smdgNamespaceUtility.GetNamespace() + 'is_valid_field__c', fieldOrder__c = 6, smdg__c=smdgid, is_valid_field__c=true );
        insert field;
        return field.id;
    }
    public static string GenerateTestsmdgFieldPicklist(String smdgID)
    {
        smdg_Field__c field = new smdg_Field__c( apiname__c=smdgNamespaceUtility.GetNamespace() + 'field_style__c', fieldOrder__c = 7, smdg__c=smdgid, is_valid_field__c=true );
        insert field;
        return field.id;
    }



    public static string GenerateAction(String smdgid)
    {
        smdg_Action__c act = new smdg_Action__c();
        act.requires_createable__c = true;
        act.Requires_Editable__c= true;
        act.Action_Type__c = 'List';
        act.event_payload__c = '{ dummy payload}';
        act.Action_Order__c=1;
        act.smdg__c = smdgid;
        act.Event__c='c.force:editRecord';
        insert act;
        return act.id;
    }
}