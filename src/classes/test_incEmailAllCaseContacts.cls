@isTest(seeAllData=false)
private class test_incEmailAllCaseContacts {
    public static testMethod void testGetIncident(){
        keshet__Incident__c testRecord = new keshet__Incident__c(Name='TestInc',
                                                        keshet__Console_Label__c='test label', 
                                                        keshet__Note_to_Customers__c='notes');
        insert testRecord;
        system.debug(testRecord.id);       
        keshet__Incident__c testRec = IncidentEmailAllCaseContactsController.getIncident(testRecord.Id);
        System.assertEquals(testRec.ID,testRecord.Id);
    }
    public static testMethod void testEmailAllCaseContacts(){
        Integer emailLimitBefore=Limits.getEmailInvocations();
    	keshet__Incident__c testRecord = new keshet__Incident__c(Name='TestInc',
                                                        keshet__Console_Label__c='test label', 
                                                        keshet__Note_to_Customers__c='notes',
                                                        keshet__Email_customers__c = true,
                                                        keshet__emailSubject__c = 'test email',
        												keshet__customerEmailText__c = 'test text',
        												keshet__fromAddress__c = 'test@mailinator.com');
        insert testRecord;
        Contact testContact = new Contact(lastname='testIncidentTrigger',email='testinc@mailinator.com');
        insert testContact;
        List<Case> cases = new List<Case>();           
        for (Integer k=0;k<3;k++) {
            cases.add(new Case(keshet__Incident__c=testRecord.id,
                               subject='Test'+k,
                               contactId=testContact.id));
        }
        insert cases;
        string status= IncidentEmailAllCaseContactsController.emailAllCaseContacts(testRecord.id);
        System.assertEquals(status,'success');
    }
}