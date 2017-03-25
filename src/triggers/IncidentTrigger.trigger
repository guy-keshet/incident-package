trigger IncidentTrigger on keshet__Incident__c (before insert, before update, before delete, 
  after insert, after update, after delete, after undelete)  {
      
    if(Trigger.isAfter && Trigger.isUpdate) {
        IncidentTriggerHandler.handleAfterUpdate(Trigger.new,Trigger.oldMap);
        //close all cases and update
        //send email
    }
}