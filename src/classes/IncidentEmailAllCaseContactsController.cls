public with sharing class IncidentEmailAllCaseContactsController {
@AuraEnabled
    public static String emailAllCaseContacts(ID incidentID){
        //SYSTEM.debug('ID sent to class is: '+incidentID);
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        keshet__Incident__c currentIncident = [select id, keshet__emailSubject__c,keshet__customerEmailText__c,keshet__fromAddress__c 
                from keshet__Incident__c where id = :incidentId];
        List<Case> CasesList = new List<case>([Select id, keshet__Incident__c, Contact.Email, ContactId 
                                               from Case 
                                               where incident__c = :incidentID and (Contact.Email <> null)]);
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress];
        
        for (Case c:CasesList)
        {
            //email customers
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String> {c.ContactId});
            mail.setSubject(currentIncident.keshet__emailSubject__c);
            mail.setPlainTextBody(currentIncident.keshet__customerEmailText__c);
            mail.setSaveAsActivity(true);
            mail.setTargetObjectId(c.ContactId);
            mail.setWhatId(c.Id);
            mail.setReplyTo(currentIncident.keshet__fromAddress__c);
             
            if ( owea.size() > 0 ) {
    			mail.setOrgWideEmailAddressId(owea.get(0).Id);
            } else {
                mail.setSenderDisplayName(currentIncident.keshet__fromAddress__c);
            }
            emailList.add(mail);    
        }
        String returnValue = 'success';
        try{
            system.debug('trying email send with ' + emailList.size() + ' emails');
            system.debug('Limit is: ' + Limits.getLimitEmailInvocations() + ' and curr invocation count is ' + Limits.getEmailInvocations());
            if ((emailList.size() > 0) && (Limits.getLimitEmailInvocations()>(Limits.getEmailInvocations()+emailList.size())))
            {
                system.debug('about to reserve');
                Messaging.reserveSingleEmailCapacity(emailList.size());
                system.debug('about to trigger email');
                Messaging.sendEmail(emailList);
            }
           
        } catch (DMLException e){
            system.debug('Oh Oh - Error: ' + e.getMessage());                          
                returnValue = 'There was a problem sending an email';            
        }
    	return returnValue;
    }
@AuraEnabled
    public static keshet__Incident__c getIncident(ID incidentId){
        keshet__Incident__c inc = [select id, keshet__emailSubject__c,keshet__customerEmailText__c,keshet__fromAddress__c 
                from keshet__Incident__c where id = :incidentId];
        return inc;
    }
}