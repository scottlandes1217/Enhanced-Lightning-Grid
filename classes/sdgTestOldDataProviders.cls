/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@istest
public class smdgTestOldDataProviders {
    private static testmethod void TestMeta()
    {
        Boolean isError = false;
        try
        {


            smdgMetadataDataProvider.getData(null,null);

        }
        catch(smdgDeprecatedException ex)
        {
            isError = true;
        }
        system.assertEquals(true, isError, 'smdgTestOldDataProviders:TestMeta:GetData: Expected smdgDeprecatedException');

        isError = false;

        try
        {

            smdgMetadataDataProvider mdp = new smdgMetadataDataProvider();
            mdp.Loadsmdg(null);

        }
        catch(smdgDeprecatedException ex)
        {
            isError = true;
        }
        system.assertEquals(true, isError, 'smdgTestOldDataProviders:TestMeta:Loadsmdg: Expected smdgDeprecatedException');
    }


    private static testmethod void TestRelationship()
    {
        Boolean isError = false;
        try
        {


            smdgRelationshipDataProvider.getData(null,null);

        }
        catch(smdgDeprecatedException ex)
        {
            isError = true;
        }
        system.assertEquals(true, isError, 'smdgTestOldDataProviders:TestRelationship:GetData: Expected smdgDeprecatedException');

        isError = false;

        try
        {

            smdgRelationshipDataProvider dp = new smdgRelationshipDataProvider();
            dp.Loadsmdg(null);

        }
        catch(smdgDeprecatedException ex)
        {
            isError = true;
        }
        system.assertEquals(true, isError, 'smdgTestOldDataProviders:TestRelationship:Loadsmdg: Expected smdgDeprecatedException');

        isError = false;

        try
        {

            smdgRelationshipDataProvider dp = new smdgRelationshipDataProvider();
            dp.Loadsmdg(null, null, null);

        }
        catch(smdgDeprecatedException ex)
        {
            isError = true;
        }
        system.assertEquals(true, isError, 'smdgTestOldDataProviders:TestRelationship:Loadsmdg 3Params: Expected smdgDeprecatedException');

    }
    private static testmethod void TestCustom()
    {
        Boolean isError = false;
        try
        {


            customDataPRoviderExample.getData(null,null);

        }
        catch(smdgDeprecatedException ex)
        {
            isError = true;
        }
        system.assertEquals(true, isError, 'smdgTestOldDataProviders:TestCustom:GetData: Expected smdgDeprecatedException');

        isError = false;

        try
        {

            customDataPRoviderExample dp = new customDataPRoviderExample();
            dp.Loadsmdg(null);

        }
        catch(smdgDeprecatedException ex)
        {
            isError = true;
        }
        system.assertEquals(true, isError, 'smdgTestOldDataProviders:TestCustom:Loadsmdg: Expected smdgDeprecatedException');
    }


    private static testmethod void TestNative()
    {
        Boolean isError = false;
        try
        {


            smdgNativeDataProvider.getData(null,null);

        }
        catch(smdgDeprecatedException ex)
        {
            isError = true;
        }
        system.assertEquals(true, isError, 'smdgTestOldDataProviders:TestNative:GetData: Expected smdgDeprecatedException');

        isError = false;

        try
        {

            smdgNativeDataProvider dp = new smdgNativeDataProvider();
            dp.Loadsmdg(null);

        }
        catch(smdgDeprecatedException ex)
        {
            isError = true;
        }
        system.assertEquals(true, isError, 'smdgTestOldDataProviders:TestNative:Loadsmdg: Expected smdgDeprecatedException');
    }
}