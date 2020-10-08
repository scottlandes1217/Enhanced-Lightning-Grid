/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
trigger trgsmdg on smdg__c (before insert, before update) {
    smdgVerification.Verifysmdg(trigger.new, false);

}