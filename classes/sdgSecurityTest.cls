/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class smdgSecurityTest {

     public   static User CreateUser(String partialUserName)
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        String username=UserInfo.getOrganizationId() + partialUserName + 'standarduser@testorg.com';
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName=username);
        return u;
    }

    static testmethod void CanQuery()
    {
        //Test Admin can see stuff:
        //
        Boolean userCanQuery = false; 
        userCanQuery = smdgSecurity.CanQuery('smdgSecurityTest:CanQuery', 'smdg__c', 'is_valid__c', 'name', smdgNamespaceUtility.GetNamespace(), false);
        system.assertEquals(true, userCanQuery, 'Admin should be able to query smdg__c' );

        userCanQuery = smdgSecurity.CanQuery('smdgSecurityTest:CanQuery','smdg__c', 'is_invalid_field__c', 'name', smdgNamespaceUtility.GetNamespace(), false);
        system.assertEquals(false, userCanQuery, 'Admin should not be able to query an invalid field on smdg__c' );
		Boolean isGoodError = false;
        boolean isBadError = false;
        try
        {
           userCanQuery = smdgSecurity.CanQuery('smdgSecurityTest:CanQuery','smdg__c', 'is_invalid_field__c', 'name', smdgNamespaceUtility.GetNamespace(), true);
         
        }
        catch(smdgSecurity.smdgInvalidPermissionsException smdgex)
        {
            isGoodError = true;
        }
        catch(exception ex)
        {
            isBadError = true;
        }
        system.assertEquals(false, userCanQuery, 'Admin should not be able to query an invalid field on smdg__c (2)' );
        system.assertEquals(true, isGoodError, 'Should receive smdgInvalidPermissionsException if Admin query an invalid field on smdg__c' );
        system.assertEquals(false, isBadError, 'Received raw exception on Admin query an invalid field on smdg__c' );
        
		
        User u = CreateUser('1');
        system.runAs(u) {
            userCanQuery = smdgSecurity.CanQuery('smdgSecurityTest:CanQuery', 'smdg__c', 'is_valid__c', 'name', smdgNamespaceUtility.GetNamespace(), false);
        }
        system.assertEquals(false, userCanQuery, 'Normal user should not be able to query smdg__c' );

    }
}