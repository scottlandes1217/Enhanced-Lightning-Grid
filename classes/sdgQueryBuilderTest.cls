/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class smdgQueryBuilderTest {
    static testMethod void BuildFilterClauseString()
        {
            test.startTest();
            string result = smdgQueryBuilder.BuildFilterClause('abc', 'STRING', '=', '123');
            system.assertEquals(' abc = \'123\' ',result, 'STRING EQUALS');

            result = smdgQueryBuilder.BuildFilterClause('abc', 'STRING', 'NOT=', '123');
            system.assertEquals(' abc != \'123\' ',result, ' STRING NOT EQUALS');

            result = smdgQueryBuilder.BuildFilterClause('abc', 'STRING', 'CONTAINS', '123');
            system.assertEquals(' abc like \'%123%\' ',result, 'STRING CONTAINS');

            result = smdgQueryBuilder.BuildFilterClause('abc', 'STRING', 'NOTCONTAINS', '123');
            system.assertEquals(' (NOT abc like \'%123%\') ',result, 'STRING NOT CONTAINS');

            result = smdgQueryBuilder.BuildFilterClause('abc', 'STRING', 'STARTS', '123');
            system.assertEquals(' abc like \'123%\' ', result, 'STRING STARTS');

            result = smdgQueryBuilder.BuildFilterClause('abc', 'STRING', 'ENDS', '123');
            system.assertEquals(' abc like \'%123\' ',result, 'STRING ENDS');
            test.stopTest();
    }
    static testMethod void BuildFilterClauseNumber()
        {
            test.startTest();
            string result = smdgQueryBuilder.BuildFilterClause('abc', 'INTEGER', '=', '123');
            system.assertEquals(' abc = 123 ',result, 'NUMBER EQUALS');

            result = smdgQueryBuilder.BuildFilterClause('abc', 'INTEGER', 'GT', '123');
            system.assertEquals(' abc > 123 ',result, ' NUMBER GT');

            result = smdgQueryBuilder.BuildFilterClause('abc', 'INTEGER', 'LT', '123');
            system.assertEquals(' abc < 123 ',result, 'NUMBER LT');
 
            result = smdgQueryBuilder.BuildFilterClause('abc', 'DOUBLE', '=', '123.5');
            system.assertEquals(' abc = 123.5 ',result, 'DOUBLE EQUALS');

            result = smdgQueryBuilder.BuildFilterClause('abc', 'DOUBLE', 'GT', '123.5');
            system.assertEquals(' abc > 123.5 ',result, ' DOUBLE GT');

            result = smdgQueryBuilder.BuildFilterClause('abc', 'DOUBLE', 'LT', '123.5');
            system.assertEquals(' abc < 123.5 ',result, 'DOUBLE LT');

            test.stopTest();
    }

    static testMethod void BuildFilterClausePicklist()
        {
            test.startTest();
            string result = smdgQueryBuilder.BuildFilterClause('abc', 'PICKLIST', '=', 'HAPPY');
            system.assertEquals(' abc = \'HAPPY\' ',result, 'PICKLIST =');

            result = smdgQueryBuilder.BuildFilterClause('abc', 'PICKLIST', '=', '');
            system.assertEquals('  ',result, 'PICKLIST blank');

test.stopTest();
        }

        static testmethod void ProcessMergeFieldsTest()
        {
            test.startTest();
            string result = smdgQueryBuilder.ProcessMergeFields('select name from account', '123');
            system.assertEquals('select name from account',result, 'MergeFields No data');
            
            result = smdgQueryBuilder.ProcessMergeFields('a string #userid# to merge', '123');
            system.assertEquals('a string \'' + userinfo.getUserId() + '\' to merge',result, 'MergeFields userid');
            
            result = smdgQueryBuilder.ProcessMergeFields('select #Id# from account', '123');
            system.assertEquals('select 123 from account',result, 'MergeFields parentid');
            
            test.stopTest();
        }
}