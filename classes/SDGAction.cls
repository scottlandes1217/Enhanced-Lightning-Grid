/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
global with sharing class smdgAction  implements Comparable 
{
    global string Id;
    global string Label;
    global string Event;
    global string Type;
    global string Payload;
    global string Icon;
    global integer actionOrder;

    global smdgAction()
    {
    }
  
    global smdgAction(String Id, String Label, String Event, String Type, String Payload, String Icon)
    {
        this.Id = Id;
        this.Label = Label;
        this.Event = Event;
        this.Type = Type;
        this.Payload = Payload;
        this.Icon = Icon;
    }
    global smdgAction(String Id, String Label, String Event, String Type, String Payload, String Icon, integer actionorder)
    {
        this.Id = Id;
        this.Label = Label;
        this.Event = Event;
        this.Type = Type;
        this.Payload = Payload;
        this.Icon = Icon;
        this.actionOrder = actionOrder;
    }
    // Compare action based on the actionorder.
    public Integer compareTo(Object compareTo) {
        // Cast argument to wrapper
        smdgAction compareToAction = (smdgAction)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (actionorder > compareToAction.actionOrder) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (actionorder < compareToAction.actionorder) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }
}