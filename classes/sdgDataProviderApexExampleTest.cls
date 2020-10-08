/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class smdgDataProviderApexExampleTest
 {

    static testMethod void loadsmdg()
    {
        string tag = smdgDataProviderType.Apex.name() + ':smdgDataProviderApexExample';
        //create an smdg with relevant tag:

        test.startTest();
        //not actually interested in whether this works - only the structure
        smdg s = smdgDataProviderFactory.Loadsmdg(tag,'','','');
        system.assertNotEquals(null, s, 'smdgDataProviderApexExampleTest:loadsmdg returned null');

        system.debug(json.serialize(s));
        system.assertEquals(2, s.smdgFields.size(), 'Fields on example data provider');
        system.assertEquals(3, s.smdgActions.size(), 'Actions on example data provider');
        test.stopTest();

    }
    static testMethod void getData()
    {
        string tag = smdgDataProviderType.Apex.name() + ':smdgDataProviderApexExample';

        test.startTest();

        smdgREquest req = new smdgREquest();
        req.smdgTag = tag;

        req.pageid=1;
        req.pagesize=5;
        smdgresult sr = smdgDataProviderFactory.getData(req);
        system.assertEquals(0, sr.FullQueryCount, 'No Accounts to load');
        Account a = new Account();
        a.name = 'bob';
        insert a;
        Account a2 = new Account();
        a2.name = 'united';
        insert a2;
        smdgresult sr2 = smdgDataProviderFactory.getData(req);
        system.assertEquals(2, sr2.FullQueryCount, '2 Accounts to load');

        test.stopTest();


    }
}