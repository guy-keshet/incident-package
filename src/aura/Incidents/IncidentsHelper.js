({
  getIncidents: function(component) {
        var action = component.get("c.getIncidents");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.incidents", response.getReturnValue());
                this.updateTotal(component);
            }
        });
        $A.enqueueAction(action);
  },
  updateTotal : function(component) {  
      var incidents = component.get("v.incidents");
      var total = 0;
      for(var i=0; i<incidents.length; i++){
          var e = incidents[i];
          total += 1;
      }
      //Update counter used for rendering
      component.set("v.total", total);
  },//Delimiter for future code

})