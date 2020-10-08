/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public with sharing class smdgLabelsTest {
    //Instantiate teh smdgLabels object
  static testMethod void GetLabels()
  {
      List<String> labels = new List<String>();
      labels = smdgLabels.strings;
      system.assert(labels.size()>0);
  }
}