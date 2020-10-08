/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class smdgTest {

    public static testmethod void TestConstructorNoParms()
    {
        Boolean isError = false;
        try
        {
            smdg s = new smdg();
        }
        catch(exception ex)
        {
            isError = true;
        }
        system.assertEquals(true, iserror, 'smdgTest:TestConstructorNoParms');

    }
    public static testmethod void TestConstructorOneParms()
    {
        Boolean isError = false;
        string teststring = 'teapot';
        smdg s;
        try
        {
            s = new smdg(teststring);
        }
        catch(exception ex)
        {
            isError = true;
        }
        system.assertEquals(false, iserror, 'smdgTest:TestConstructorOneParms failure');
        system.assertEquals(teststring, s.internaldata.sUniqueKey, 'smdgTest:TestConstructorOneParms:InternalUniqueID missing');

    }
    public static testmethod void TestConstructorSixParms()
    {
        Boolean isError = false;
        string teststring = 'teapot';

        smdg s;
        try
        {
            s = new smdg('abc', '', 'Account', '', '',teststring);
     		// smdg(String objectname, String ParentFieldName, String sObjectName, String sFilter, String sDefaultSort, String sUniqueKey)

        }
        catch(exception ex)
        {
            isError = true;
        }
        system.assertEquals(false, iserror, 'smdgTest:TestConstructorSixParms failure');
        system.assertEquals(teststring, s.internaldata.sUniqueKey, 'smdgTest:TestConstructorSixParms:InternalUniqueID missing');

    }
    public static testmethod void TestConstructorSevenParms()
    {
        Boolean isError = false;
        string teststring = 'teapot';

        smdg s;
        try
        {
            s = new smdg('abc', '', 'Account', '', '',teststring, false);
     		// smdg(String objectname, String ParentFieldName, String sObjectName, String sFilter, String sDefaultSort, String sUniqueKey)

        }
        catch(exception ex)
        {
            isError = true;
        }
        system.assertEquals(false, iserror, 'smdgTest:TestConstructorSevenParms failure');
        system.assertEquals(teststring, s.internaldata.sUniqueKey, 'smdgTest:TestConstructorSevenParms:InternalUniqueID missing');

    }


}