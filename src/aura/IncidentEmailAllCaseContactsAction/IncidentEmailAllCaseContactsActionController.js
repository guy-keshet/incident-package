({
    doInit : function(component, event, helper) {
        // Prepare the action to load incident record
        
        var action = component.get("c.getIncident");
        //console.log(component.get("v.recordId");
        action.setParams({ incidentId : component.get("v.recordId")});

        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                component.set("v.incident", response.getReturnValue());
            } else {
                //component.set("v.hasErrors", true);
                console.log('Problem getting Incident, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
    },

    handleEmail: function(component, event, helper) {
            // Prepare the action to create the new contact
            var emailAction = component.get("c.emailAllCaseContacts");
            emailAction.setParams({
                incidentID : component.get("v.recordId")
            });

            // Configure the response handler for the action
            emailAction.setCallback(this, function(response) {
                var state = response.getState();
                if(component.isValid() && state === "SUCCESS") {
                    // Prepare a toast UI message
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Success",
                        "message": "Emails sent."
                    });

                    // Update the UI: close panel, show toast, refresh account page
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();
                    $A.get("e.force:refreshView").fire();
                }
                else if (state === "ERROR") {
                    console.log('Problem saving contact, response state: ' + state);
                }
                else {
                    console.log('Unknown problem, response state: ' + state);
                }
            });

            // Send the request to create the new contact
            $A.enqueueAction(emailAction);
    },

	handleCancel: function(component, event, helper) {
	    $A.get("e.force:closeQuickAction").fire();
    }
})