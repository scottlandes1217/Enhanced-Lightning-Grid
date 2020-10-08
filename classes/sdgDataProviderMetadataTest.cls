/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public with sharing class smdgDataProviderMetadataTest {

    private static testmethod void isSelectableTest()
    {
        system.assertequals(false, smdgDataProviderMetadata.isUserSelectable(), 'smdgDataProviderMetadataTest:isUserSelectable Should not be userSelectable');

    }
    static testMethod void loadsmdg()
    {
        string tag = smdgDataProviderType.Metadata.name() + ':smdg_Designer_Fields';

        test.startTest();
        //not actually interested in whether this works - only the structure
        smdg s = smdgDataProviderFactory.Loadsmdg(tag,'','','');
        system.assertNotEquals(null, s, 'smdgMetadataDataProviderTest:loadsmdg returned null');

        system.debug(json.serialize(s));
        system.assertNotEquals(0, s.smdgFields.size(), 'smdgMetadataDataProviderTest:loadsmdg:Fields on example data provider');
        system.assertNotEquals(0, s.smdgActions.size(), 'smdgMetadataDataProviderTest:loadsmdg:Actions on example data provider');
        test.stopTest();

    }
    static testMethod void getData()
    {
        string tag = smdgDataProviderType.Metadata.name() + ':smdg_Designer_Fields';

        test.startTest();

        smdgREquest req = new smdgREquest();
        req.smdgTag = tag;
        req.pageid=1;
        req.pagesize=5;

        smdgresult sr = smdgDataProviderFactory.getData(req);
        system.assertEquals(0, sr.FullQueryCount, 'smdgMetadataDataProviderTest:getData:Fields: No Fields to load');

        req.ParentRecordID = smdgTestData.GenerateTestSampleData();

        smdgresult sr2 = smdgDataProviderFactory.getData(req);
        system.assertNotEquals(0, sr2.FullQueryCount, 'smdgMetadataDataProviderTest:getData:Fields: Fields to load expected');

        test.stopTest();


    }

    
}