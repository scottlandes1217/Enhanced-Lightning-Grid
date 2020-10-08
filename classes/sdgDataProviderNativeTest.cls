/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class smdgDataProviderNativeTest {

    private static testmethod void isSelectableTest()
    {
        system.assertequals(false, smdgDataProviderNative.isUserSelectable(), 'smdgDataProviderNativeTest:isUserSelectable Should not be userSelectable');

    }

    private static testmethod void testNoFields()
    {
        string testtag = 'a string';
		String smdgID = smdgTestData.GenerateCoresmdg(testtag);
        boolean iserror = false;
        boolean isexpectederror = false;
        try
        {
            smdgDataProviderNative dp = new smdgDataProviderNative();
        	smdg newsmdg = dp.Loadsmdg(smdgDataProviderType.CustomObject.name() + ':' + testtag,'');
        }
        catch( smdgException smdgex)
        {
            isexpectederror = true;
        }
        catch (exception ex)
        {
            system.debug(ex.getMessage());
            system.debug(ex.getStackTraceString());
            iserror = true;
        }
        system.assertequals(false, iserror, 'smdgDataProviderNativeTest:testNoFields Should not throw unhandled exception');
        system.assertequals(true, isExpectedError, 'smdgDataProviderNativeTest:testNoFields Should throw with no fields');

    }
}