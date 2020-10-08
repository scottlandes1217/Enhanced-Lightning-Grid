/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
global with sharing class smdgFilter
{
    global string smdgFieldID;
    global string FilterOperator;
    global string FilterValue;

global smdgFilter()
{

}
    global smdgFilter(string smdgFieldID, string FilterOperator, string FilterValue)
    {
        this.smdgFieldID = smdgFieldID;
        this.FilterOperator = FilterOperator;
        this.FilterValue = FilterValue;
    }


}