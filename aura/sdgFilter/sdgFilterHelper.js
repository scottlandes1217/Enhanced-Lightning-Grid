({

    getERLPicklist: function (component) {
        var action = component.get("c.getPicklistOptions");
        action.setParams({
            "smdgFieldID": component.get("v.smdgField.Id")
        });

        //Set up the callback
        var self = this;
        action.setCallback(this, function (actionResult) {
            results = JSON.parse(actionResult.getReturnValue());
            component.set("v.picklistvalues", results);
        });
        $A.enqueueAction(action);
    },
    fireUpdate: function (component, paramvalue, paramoperator) {
        if (paramvalue == null) {
            paramvalue = '';
        }
        var compEvent = component.getEvent("smdgFilterUpdate");
        compEvent.setParams({
            "smdgFieldID": component.get("v.smdgField").ID,
            "FilterOperator": paramoperator,
            "FilterValue": paramvalue
        });
        compEvent.fire();
    }
})