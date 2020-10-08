/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
global with sharing class smdgNativeDataProvider implements smdgDataProvider {

        global static smdgResult getData(smdg Coresmdg, smdgRequest request)
    {
        throw new smdgDeprecatedException('smdgNativeDataProvider is Deprecated');
    }

     global smdg Loadsmdg(smdg coresmdg)
    {
         throw new smdgDeprecatedException('smdgNativeDataProvider is Deprecated');

    }

}