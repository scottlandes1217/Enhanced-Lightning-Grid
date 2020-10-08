/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
public with sharing class smdgDesigner {
    @AuraEnabled
    public static string GetNamespace()
    {
        return smdgNamespaceUtility.GetNamespace();
    }
    
    @AuraEnabled
    public static Integer GetNewFieldOrder( String smdgRecordId)
    {
        Integer retvalue = 1;
        try
        {
            
            smdgSecurity.CanQuery('smdgDesigner:GetNewFieldOrder', 'smdg_Field__c', 'FieldOrder__c', '', smdgNamespaceUtility.GetNamespace(),true);
            
            AggregateResult[] groupedResults = [SELECT Max(FieldOrder__c) current FROM smdg_Field__c where smdg__c = : smdgRecordId];
            Object maxValueObj = groupedResults[0].get('current');
            Integer maxValueInt = Integer.valueOf(maxValueObj);
            retvalue =  maxValueInt + 1;
            
        }
        catch (Exception ex)
        {
            //Ignore - Just return a value regardless
        }
        return retvalue;
    }
    
    @AuraEnabled
    public static List<AuraFieldSelectOption> GetSObjectFields(String sObjectType, String smdgRecordId)
    {
        List<AuraFieldSelectOption> objects = new List<AuraFieldSelectOption>();
        objects.add(new AuraFieldSelectOption('','', ''));
        
        try
        {
            if (String.isNotBlank(smdgRecordId) && STring.isBlank(sObjectType))
            {
                Id recordId = (Id)smdgRecordId;
                smdg__c smdg = [select id, sObjectName__c from smdg__c where id = :recordId limit 1];
                sObjectType =smdg.sObjectName__c;
            }
            
            Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(new String[]{sObjectType});
            Map<String, Schema.SObjectField> sofs = descResult[0].fields.getMap();
            
            for (Schema.SObjectField sof : sofs.values())
            {
                Schema.DescribeFieldResult dfr =  sof.getDescribe();
                List<Schema.sObjectType> refTos = dfr.getReferenceTo();
                for (schema.SObjectType ref : refTos)
                {
                    if (sof.getDescribe().getRelationshipName()!=null)
                    {
                        objects.add( new AuraFieldSelectOption( sof.getDescribe().getRelationshipName(), ref.getDescribe().getName(), dfr.getLabel() + '-->' + ref.getDescribe().getLabel()  ));
                        
                    }
                }
                objects.add(new AuraFieldSelectOption(dfr.getname(), '', dfr.getlabel()));
            }
            objects.sort();
            
        }
        catch (Exception ex)
        {
            //probably an apex handler - so ignore for now
        }
        return objects;
    }
    
    
}