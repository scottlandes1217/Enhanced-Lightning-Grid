/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class smdgDataProviderRelationshipTest {

    private static testmethod void isSelectableTest()
    {
        system.assertequals(false, smdgDataProviderRelationship.isUserSelectable(), 'smdgDataProviderRelationshipTest:isUserSelectable Should not be userSelectable');

    }
    static testMethod void loadsmdg()
    {
        //create an smdg
        String smdgid = smdgTestData.GenerateTestSampleData();

        test.startTest();
        smdg s = smdgDataProviderFactory.Loadsmdg(smdgDataProviderType.Relationship.name(),smdgid,smdgNamespaceUtility.GetNamespace() + 'smdgFields__r', '');

        //Should be only the ID field - as the fieldset won't exist
        system.assertEquals(1, s.smdgFields.size(), 'Fields on relationship data provider (default fieldset)');
        system.assertEquals(null, s.smdgActions, 'No actions on relationship data provider');

        test.stopTest();

    }
    static testMethod void getDataFieldSet()
    {
        Id smdgid = smdgTestData.GenerateTestSampleData();

        test.startTest();

        smdgREquest req = new smdgRequest();
        req.smdgTag = smdgDataProviderType.Relationship + ':';
        req.FieldSetName = smdgNamespaceUtility.GetNamespace() +'default';
        req.ParentRecordID = smdgid;
        req.RelationshipName = smdgNamespaceUtility.GetNamespace() + 'smdgFields__r';
        req.pageid=1;
        req.pagesize=5;
        smdgresult sr = smdgDataProviderFactory.getData(req);

        system.assertEquals(2, sr.FullQueryCount, 'Two rows in test data');


        test.stopTest();

    }
    static testMethod void getDataDefault()
    {
        Id smdgid = smdgTestData.GenerateTestSampleData();

        test.startTest();

        smdgREquest req = new smdgRequest();
        req.smdgTag = smdgDataProviderType.Relationship + ':';
        req.FieldSetName = '';
        req.ParentRecordID = smdgid;
        req.RelationshipName = smdgNamespaceUtility.GetNamespace() + 'smdgFields__r';
        req.pageid=1;
        req.pagesize=5;
        smdgresult sr = smdgDataProviderFactory.getData(req);

        system.assertEquals(2, sr.FullQueryCount, 'Two rows in test data');


        test.stopTest();

    }
}