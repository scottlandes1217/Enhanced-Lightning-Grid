/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
global with sharing class smdg
{
    global smdgInternal internalData ;
    global String sObjectName;
    global List<smdgAction> smdgActions;
    global List<smdgField> smdgFields;

    global smdg()
    {
        throw new smdgDeprecatedException('smdg requires a parameterized constructor');
    }

    global smdg(String sUniqueKey)
    {
        smdgInternal einternal = new smdgInternal();
        eInternal.sUniqueKey = sUniqueKey;
        this.internalData = einternal;
    }
    global smdg(String objectname, String ParentFieldName, String sObjectName, String sFilter, String sDefaultSort, String sUniqueKey)
    {
        this.sObjectName = objectName;

        smdgInternal einternal = new smdgInternal();
        einternal.ParentFieldName = ParentFieldName;
        eInternal.sObjectName = sObjectName;
        eInternal.sFilter = sFilter;
        eInternal.sDefaultSort = sDefaultSort;
        eInternal.sUniqueKey = sUniqueKey;
        eInternal.AllRows = false;
        this.internalData = einternal;
    }
    global smdg(String objectname, String ParentFieldName, String sObjectName, String sFilter, String sDefaultSort, String sUniqueKey, Boolean AllRows)
    {
        this.sObjectName = objectName;

        smdgInternal einternal = new smdgInternal();
        einternal.ParentFieldName = ParentFieldName;
        eInternal.sObjectName = sObjectName;
        eInternal.sFilter = sFilter;
        eInternal.sDefaultSort = sDefaultSort;
        eInternal.sUniqueKey = sUniqueKey;
        eInternal.AllRows = AllRows;
        this.internalData = einternal;
    }




}