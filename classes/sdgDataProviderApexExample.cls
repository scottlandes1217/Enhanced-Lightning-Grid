/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
global with sharing class smdgDataProviderApexExample implements smdgIDataProvider {
        global static Boolean isUserSelectable()
    {
        return true;
    }

    global static smdgResult getData(smdg coresmdg,  smdgRequest request)
    {
        smdgResult result = new smdgResult();

        integer dataoffset = request.pageid * request.pagesize;
        integer datalimit = request.PageSize;
        smdgSecurity.CanQuery('smdgDataProviderApexExample:getData', 'Account', '', 'name', '', true);
        
        result.data = [select name from Account ];

        result.query='smdgDataProviderApexExample';
        result.FullQueryCount = result.data.size();
        result.pagecount = 1;
        result.isError = false;
        result.ErrorMessage = '';
        return result;
    }

    global   smdg Loadsmdg(String smdgTag, String ParentRecordId)
    {
        system.debug('smdgDataProviderApexExample:Loadsmdg');
        smdg Coresmdg = new smdg( 'smdgDataProviderApexExample' );

        Coresmdg.smdgActions = getActions();
        Coresmdg.smdgFields = getFields();
        return Coresmdg;
    }

    private List<smdgAction> GetActions()
    {
        List<smdgAction> actions = new List<smdgAction>();

        actions.add(new smdgAction('1', 'New', 'e.force:createRecord', 'List Button', '{"entityApiName": "Contact"}', 'utility:new', 1));
        actions.add(new smdgAction('2', 'Edit', 'e.force:editRecord', 'Row Button', '{"recordId": "#Id#"}', 'utility:edit', 2));
        actions.add(new smdgAction('3', 'Edit2', 'e.force:editRecord', 'Row Button', '{"recordId": "#Id#"}', 'utility:edit',3 ));

        return actions;
    }

    private List<smdgField> GetFields()
    {
        List<smdgField> fields = new List<smdgField>();
        fields.add(new smdgField('1', 'My Name override', 'name', 'STRING', '', false, false, null, 1));
        fields.add( new smdgField('2', 'My ID override', 'Id', 'STRING', '', false, false, null, 2));

        return fields;
    }

}