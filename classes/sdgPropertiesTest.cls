/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class smdgPropertiesTest {

    static testMethod void TestList()
    {
        test.startTest();
        //Generate SOSL response: doesn't work in deployment
        //Id [] fixedSearchResults= new Id[1];
        //ApexClass classobj = [select id from apexclass where name = 'smdgDataProviderCustomExample' and namespaceprefix = :smdgNamespaceUtility.getNamespace() limit 1];

        //fixedSearchResults[0] = classobj.id;
        //Test.setFixedSearchResults(fixedSearchResults);


        smdgProperties props1 = new smdgProperties();
        VisualEditor.DynamicPickListRows items1 = props1.getValues();
        integer i = database.countquery ('SELECT count() FROM smdgDefaults__mdt');
        system.debug('count: ' + i);
        system.assertnotequals(0, items1.size(),  'smdgPropertiesTest:TestList Should be at least some items in smdgDefaults');
        //we can't know how many items there are though
        Boolean hasMeta = false;
        Boolean hasCustom = false;
        Boolean hasApex = false;
        for (VisualEditor.DataRow item: items1.getDataRows())
        {
            if (item.getValue()!=null)
            {
                if (String.valueOf((item.getvalue())).startswithignorecase(smdgDataProviderType.Metadata.name()))
                    hasMeta = true;
                if (String.valueOf((item.getvalue())).startswithignorecase(smdgDataProviderType.CustomObject.name()))
                    hasCustom = true;
                if (String.valueOf((item.getvalue())).startswithignorecase(smdgDataProviderType.Apex.name()))
                    hasApex = true;
            }
        }
        system.assertEquals(true, hasMeta, 'smdgPropertiesTest:TestList: Expected a metadata data provider (part of package)');
        system.assertEquals(false, hasCustom, 'smdgPropertiesTest:TestList: Expected no custom data providers');
        system.assertEquals(false, hasApex, 'smdgPropertiesTest:TestList: Expected no apex data provider - so SOSL results set');

        //now add one
        smdgtestdata.GenerateTestsmdg();
        //And try again
        smdgProperties props2 = new smdgProperties();
        VisualEditor.DynamicPickListRows items2 = props2.getValues();
        system.assertequals(items1.size()+1, items2.size(), 'smdgPropertiesTest:TestList: Should be 1 more item');

        //now get default:
        VisualEditor.DataRow defaultitem =  props2.getDefaultValue();
        system.assertEquals(smdgProperties.DefaultLabel, defaultitem.getlabel(),'smdgPropertiesTest:TestList: Expected Relationship editor item as default');
        test.stopTest();
    }
}