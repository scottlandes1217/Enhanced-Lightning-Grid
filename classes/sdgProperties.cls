/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
global class smdgProperties  extends VisualEditor.DynamicPickList{
    public static final string DefaultLabel = '--Select--';
    private  VisualEditor.DynamicPickListRows getDataRows()
    {
        List<smdg__c> smdgs = [select id, smdg_tag__c from smdg__c order by smdg_tag__c];
        VisualEditor.DynamicPickListRows  Values = new VisualEditor.DynamicPickListRows();
        set<String> existing = new set<string>();
        values.addrow(new VisualEditor.DataRow(DefaultLabel,null));
        values.addrow(new VisualEditor.DataRow(smdgDataProviderType.Relationship.name(),smdgDataProviderType.Relationship.name()));
        for (smdg__c smdg: smdgs)
        {
            values.addrow(new VisualEditor.DataRow(smdgDataProviderType.CustomObject.name() + ':' + smdg.smdg_tag__c, smdgDataProviderType.CustomObject.name() + ':' + smdg.smdg_tag__c));
            existing.add(smdg.smdg_tag__c);
        }

        for (smdgDefaults__mdt d:  [SELECT MasterLabel, DeveloperName FROM smdgDefaults__mdt])
        {
            values.addrow(new VisualEditor.DataRow(smdgDataProviderType.Metadata.name() + ':' + d.MasterLabel, smdgDataProviderType.Metadata.name() + ':' + d.DeveloperName));
        }
        List<String> custominterfaces = InterfaceImplementors();
        for(String s: custominterfaces)
        {
             values.addrow(new VisualEditor.DataRow(smdgDataProviderType.Apex.name() + ':' + s, smdgDataProviderType.Apex.name() + ':' + s));

        }

        return Values;
    }

    private static List<ApexClass> searchedclasses;

    private List<ApexClass> SearchClasses(string interfacename)
    {
        if (searchedclasses==null)
        {
            searchedclasses = (ApexClass[])[FIND :interfacename
                                            IN ALL FIELDS
                                            RETURNING ApexClass(Id, Name)][0];
        
        }

        return searchedclasses;
    }

    private List<String> InterfaceImplementors()
    {
        String interfacename = 'smdgIDataProvider';
    	List<ApexClass> classes = SearchClasses(interfacename);

        List<String> dataproviders = new List<String>();
        //Don't know how to test this:
        try
        {
                for (ApexClass ac : classes)
                {
                    if (ac.Name.toLowerCase() != interfacename.ToLowerCase())
                    {
                        Object o = Type.forName(ac.Name).newInstance();
                        if (o instanceOf smdgIDataProvider)
                        {
                            smdgIDataProvider dp = (smdgIDataProvider)o;
                            if ( dp.isUserSelectable())
                            {
                                dataproviders.add( ac.name);
                            }
                        }
                    }
                }
        }
        catch (Exception ex) {
            //Ignore this - I don't  know how to recover this:
            system.debug(LoggingLevel.ERROR, 'Unable to parse custom interfaces: smdgProperties.InterfaceImplementors');
        }
        return dataproviders;

    }
    global override VisualEditor.DataRow getDefaultValue(){

        VisualEditor.DataRow defaultValue = getDataRows().get(0);
        return defaultValue;
    }

    global override VisualEditor.DynamicPickListRows getValues() {
        return getDataRows();
    }
}