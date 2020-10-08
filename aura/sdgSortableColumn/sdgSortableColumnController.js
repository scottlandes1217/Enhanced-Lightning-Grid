({
    doInit: function (component, event, helper) {
        // alert('init column');
    },
    sort: function (component, event, helper) {
        var field = component.get("v.smdgField");

        if (field.isEncrypted) {
            alert('Cannot sort encypted field');
        }
        else {

            //throw an event to parent:
            if (component.get("v.isSorted")) {
                if (component.get("v.SortOrder") == "A") {
                    component.set("v.SortOrder", "D");
                }
                else {
                    component.set("v.SortOrder", "A");
                }
            }
            else {
                component.set("v.SortOrder", "A");
            }

            var compEvent = component.getEvent("smdgSortableColumnSort");
            component.set("v.isSorted", true);

            compEvent.setParams({
                "smdgFieldID": component.get("v.smdgField").ID,
                "SortOrder": component.get("v.SortOrder")
            });
            compEvent.fire();
        }
    },
    sortchanged: function (component, event, handler) {

        if (component.get("v.smdgField").ID == component.get("v.CurrentSortedColumn")) {
            if (component.get("v.CurrentSortedOrder") == "A") {
                component.set("v.isSortedD", false);
                component.set("v.isSortedA", true);
            }
            else {
                component.set("v.isSortedA", false);
                component.set("v.isSortedD", true);
            }
        }
        else {
            component.set("v.isSortedA", false);
            component.set("v.isSortedD", false);
        }
    }
})