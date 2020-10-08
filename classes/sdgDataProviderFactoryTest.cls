/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class smdgDataProviderFactoryTest {

    static testMethod void checkDeprecatedDataProviders()
    {
        Boolean isError = false;
        try{
            smdg s = new smdg();
            CustomDataProviderExample cdpe = new CustomDataProviderExample();
            cdpe.Loadsmdg(s);
            smdgRelationshipDataProvider rdp = new smdgRelationshipDataProvider();
            rdp.Loadsmdg(s);
            smdgMetadataDataProvider mdp = new smdgMetadataDataProvider();
            mdp.Loadsmdg(s);
 
        }
        catch(Exception ex)
        {
            isError = true;
            system.assertEquals(true, isError, 'smdgDataProviderFactoryTest:checkDeprecatedDataProviders');
        }
    }
    static testMethod void getClassNameTestInvalid()
    {
        Test.startTest();
        Boolean isGoodError = false;
        Boolean isBadError = false;
        try
        {
        Boolean result3 = smdgDataProviderFactory.isNameValid('something else entirely');
        }
        catch (smdgDataProviderFactory.smdgInvalidConfigurationNameException smdgex)
        {
            isGoodError = true;
        }
        catch (Exception ex)
        {
            isBadError = true;
        }
        Test.stopTest();
        system.assertEquals(true,isGoodError, 'smdgDataProviderTest:getClassNameTestInvalid: expected handled error');
        system.assertEquals(false,isBadError, 'smdgDataProviderTest:getClassNameTestInvalid: Did not expect unhandled error');

    }
    static testMethod void getClassNameTest()
    {
        Test.startTest();
        Boolean result = smdgDataProviderFactory.isNameValid('apex:testing');
        Boolean result2 = smdgDataProviderFactory.isNameValid('aPEx:smdgDataProviderApexExample');

        Boolean result4 = smdgDataProviderFactory.isNameValid('Relationship:bob');
        Boolean result5 = smdgDataProviderFactory.isNameValid('Metadata:whatever');

        Test.stopTest();
        system.assertEquals(true, result, 'smdgDataProviderFactoryTest:isNameValid Expected to be identified as false: invalid apex name');
        system.assertEquals(true, result2, 'smdgDataProviderFactoryTest:isNameValid Expected to be identified as apex class');
        system.assertEquals(true, result4, 'smdgDataProviderFactoryTest:isNameValid Expected to be identified as relationship');
        system.assertEquals(true, result5, 'smdgDataProviderFactoryTest:isNameValid Expected to be identified as metadata provider');

    }

    static testMethod void getClassTest()
    {
        Test.startTest();
        smdgIDataProvider result =  smdgDataProviderFactory.getClass('metadata:abc');
        system.debug('result1 OK');
        smdgIDataProvider result2 = smdgDataProviderFactory.getClass('aPEx:smdgDataProviderApexExample');
        system.debug('result2 OK');
        smdgIDataProvider result3 = smdgDataProviderFactory.getClass('relationship:Accounts');
        system.debug('result3 OK');
        smdgIDataProvider result4 = smdgDataProviderFactory.getClass('CustomObject:Account');
        system.debug('result4 OK');
        Test.stopTest();
        system.assertEquals(true, result instanceof smdgDataProviderMetadata, 'smdgDataProviderFactoryTest:getClass Expected to get smdgDataProviderMetadata  name');
        system.assertEquals(false, result instanceof smdgDataProviderRelationship, 'smdgDataProviderFactoryTest:getClass Expected to not get smdgDataProviderRelationship');
        system.assertEquals(true, result2 instanceof smdgDataProviderApexExample, 'smdgDataProviderFactoryTest:getClass Expected to get smdgDataProviderApexExample apex name');
        system.assertEquals(true, result3 instanceof smdgDataProviderRelationship, 'smdgDataProviderFactoryTest:getClass Expected to be identified as smdgDataProviderRelationship');
        system.assertEquals(true, result4 instanceof smdgDataProviderNative, 'smdgDataProviderFactoryTest:getClass Expected to be identified as smdgDataProviderNative');
    }

    static testMethod void getClassInvalidTest()
    {
        Test.startTest();
        Boolean hasError = false;
        try
        {
            smdgIDataProvider result = smdgDataProviderFactory.getClass('apex:testing');
        }
        catch (exception ex)
        {
            hasError = true;
        }
        Test.stopTest();
        system.assertEquals(true, hasError , 'smdgDataProviderFactoryTest:getClassInvalid Expected error as invalid apex class name');

    }
    static testMethod void getClassInvalid2Test()
    {
        Test.startTest();
        Boolean hasError = false;
        smdgIDataProvider result;
        try
        {
             result = smdgDataProviderFactory.getClass('CustomObject:zip');
        }
        catch (exception ex)
        {
            hasError = true;
        }
        Test.stopTest();
        system.assertEquals(false, hasError , 'smdgDataProviderFactoryTest:getClassInvalid2 Expected no error despite invalid sobject name');
        system.assertEquals(true, result instanceof smdgDataProviderNative, 'smdgDataProviderFactoryTest:getClass Expected to be identified as smdgDataProviderNative even though invalid sobjectname');

    }
}