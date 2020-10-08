/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
trigger trgsmdgField on smdg_Field__c (before insert, before update) {

    smdgVerification.VerifysmdgFields(trigger.new, false);

}