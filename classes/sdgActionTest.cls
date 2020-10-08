/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class smdgActionTest {


    static testMethod void GetCreate()
    {
        test.startTest();
        smdgAction f = new smdgAction();
        test.stopTest();
        system.assertNotEquals(null,f, 'smdgActionTest: Expected a smdgAction to be created.');

    }

 static testMethod void GetCreateFull()
    {
        test.startTest();
        smdgAction f = new smdgAction('1', 'a label', 'an event', 'STRING', '[]', 'iconname', 1);
        test.stopTest();
        system.assertNotEquals(null,f, 'smdgFieldTest:GetCreateFull: Expected a rich smdgField to be created.');
        system.assertEquals('iconname', f.icon, 'smdgActionTest:GetCreateFull: Expected action to be saved');
    }
     static testMethod void GetCreateNoOrder()
    {
        test.startTest();
        smdgAction f = new smdgAction('2', 'first item', 'an event', 'STRING', '[]', 'iconname',1);
        smdgAction f2 = new smdgAction('1', 'second item', 'an event', 'STRING', '[]', 'iconname');
        test.stopTest();
        system.assertNotEquals(null,f, 'smdgFieldTest:GetCreateNoOrder: Order in constructor: Expected a rich smdgField to be created.');
        system.assertNotEquals(null,f2, 'smdgFieldTest:GetCreateNoOrder:  No Order in constructore: Expected a rich smdgField to be created.');
        system.assertEquals('iconname', f.icon, 'smdgActionTest:GetCreateNoOrder: Expected action to be saved');
    }

}