/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
global with sharing class smdgDataProviderRelationship implements smdgIDataProvider {
    global static Boolean isUserSelectable()
    {
        return false;
    }
    global static smdgResult getData(smdg Coresmdg, smdgRequest request)
    {
        smdgResult result =  smdgQueryEngine.getsmdgResultRaw(Coresmdg, request);
        return result;
    }

        global   smdg Loadsmdg(String smdgTag, String ParentRecordId)
    {
        throw new smdgException('Branching logic incorrect in smdgDataProviderRelationship');

    }
    global   smdg Loadsmdg(String ParentRecordID, String RelationshipName, String FieldSetName)
    {

        ID objId ;
        system.debug('smdgDataProviderRelationship:Loadsmdg:' + Relationshipname);

        Schema.SObjectType sobjectTypeParent;
        Schema.SObjectType sobjectTypeChild;

        Schema.DescribeSobjectResult descresult;
        Schema.sObjectField  ParentFieldObj;

        Schema.ChildRelationship relationship;
        Map<String, Schema.FieldSet> FsMap;
        Schema.FieldSet fieldsetobj;
        List<Schema.ChildRelationship> cs;

        try
        {
            objId = ID.valueOf( ParentRecordID);
            sobjectTypeParent = objId.getSObjectType();
            descresult = sobjectTypeParent.getDescribe();
            cs = descResult.getChildRelationships();
            system.debug('smdgDataProviderRelationship:Loadsmdg: ParentObject:' + descresult.getName());
        }
        catch (exception e)
        {
            throw new smdgException ('smdgDataProviderRelationship:Loadsmdg: Unable to identify & describe the sObjectType of this record.  This component can only be configured to use a relationship when it exists on an Record Detail page.');
        }

        List<String> RelationshipNames = new List<STring>();
        List<String> FieldsetNames = new List<STring>();

        for(Schema.ChildRelationship c : cs)
        {
            if (STring.isNotBlank(c.GetRelationshipName()))
            {
                RelationshipNames.add(c.GetRelationshipName());
            }
            if (c.GetRelationshipName() ==RelationshipName)
            {
                relationship = c;
                sObjectTypeChild = c.getChildsObject();
                system.debug('smdgDataProviderRelationship:Found:' + sobjectTypeChild);
                ParentFieldObj = c.getField();
            }
        }

        if(relationship == null)
        {
            throw new smdgException('smdgDataProviderRelationship: Unable to get the Relationship details.  Valid values for RelationshipName for this record are: ' + String.join(RelationshipNames,', '));
        }
        smdg e = new  smdg( sObjectTypeChild.getDescribe().Name, ParentFieldObj.getDescribe().Name,  sObjectTypeChild.getDescribe().Name, '', '', smdgDataProviderType.Relationship.name() + ':' + Relationshipname + ':' + FieldSetName, false);

        fsMap = sObjectTypeChild.getDescribe().FieldSets.getMap();
        for (string key : fsMap.keySet()) {
            FieldsetNames.add(key);
        }

        if (fsMap.containsKey(fieldsetname))
        {
            fieldSetObj = fsMap.get(fieldsetname);
            e.smdgFields = GetsmdgFieldsFromFieldSet(fieldsetobj, sObjectTypeChild);
        }
        else if (String.isblank(fieldsetname))
        {
            e.smdgFields = GetsmdgDefaultField(sObjectTypeChild);
        }
        else
        {
            throw new smdgException ('Unable to get fieldset and fields for this relationship type.  Valid values for the fieldsetname are: ' + STring.join(FieldsetNames,', '));
        }

        system.debug('smdgDataProviderRelationship:Loadsmdg: sObjectName:' + e.sObjectName);
        return e;
    }
    private List<smdgField> GetsmdgDefaultField(sObjectType sotChild)
    {
        List<smdgField> smdgFields = new List<smdgField>();
        smdgField idfield;

        Map<String, Schema.SObjectField> FieldMap =  sotChild.getDescribe().fields.getMap();
        for(SObjectField sof: fieldmap.values())
        {
            DescribeFieldResult dfr = sof.getDescribe();
            if (dfr.isNameField())
            {
                smdgField namefield = smdgMapper.MapField(dfr,dfr.getName(), dfr.getName(), false,'', null, 1);
                if (namefield!=null)
                {
                    smdgFields.add(namefield);
                }
            }

        }
        if (smdgFields.size()==0)
        {
            //Didn't find a name so add the id:
            Schema.DescribeFieldResult dr = new smdgPathParser('Id', sotChild).getDescribe();

            smdgField newfield = smdgMapper.MapField(dr,'Id', 'Id', false,'', null, 1);
            if (newfield!=null)
            {
                smdgFields.add(newfield);
            }
        }

        return smdgFields;
    }

    private  List<smdgField> GetsmdgFieldsFromFieldSet(Schema.FieldSet fieldSetObj, SobjectType sotChild)
    {
        List<Schema.FieldSetMember> fieldSetMemberList =  fieldSetObj.getFields();
        List<smdgField> smdgFields = new List<smdgField>();
        smdgField newfield;
        double iFieldCounter = 0;
        for (Schema.FieldSetMember fsm: fieldsetmemberList)
        {
            try
            {
                Schema.DescribeFieldResult dr = new smdgPathParser(fsm.FieldPath, sotChild).getDescribe();
                //Only allow access if current field is user visible
                if (dr.isAccessible())
                {
                    iFieldCounter++;
                    newfield = smdgMapper.MapField(dr,fsm.FieldPath, fsm.FieldPath, false,'', null, ifieldCounter);
                    if (newfield!=null)
                    {
                        smdgFields.add(newfield);
                    }
                }
            }
            catch (exception ex)
            {
                //This error could be because the package is restricted so let user know this:
                throw new smdgException('smdgDataProviderRelationship:GetsmdgFieldsFromFieldSet Could not access fields listed in the field set - are restrictions on the package enabled?');
            }

        }
        return smdgFields;
    }

}