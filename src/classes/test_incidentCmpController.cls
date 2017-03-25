@isTest
private class test_incidentCmpController {
    public static testMethod void testGetIncidents(){
        keshet__Incident__c testRecord = new keshet__Incident__c(Name='TestInc',
                                                        keshet__Console_Label__c='test label', 
                                                        keshet__Note_to_Customers__c='notes',
                                                        keshet__Status__c = 'Active');
        insert testRecord;
        system.debug(testRecord.id);       
        List<keshet__Incident__c> testRec = IncidentController.getIncidents();
        System.assertEquals(testRec.size(),1);
    }
    public static testMethod void testGetIncidentsNegative(){
        keshet__Incident__c testRecord = new keshet__Incident__c(Name='TestInc',
                                                        keshet__Console_Label__c='test label', 
                                                        keshet__Note_to_Customers__c='notes',
                                                        keshet__Status__c = 'Archived',
                                                        keshet__Case_Closed_Comment__c='test');
        insert testRecord;
        system.debug(testRecord.id);       
        List<keshet__Incident__c> testRec = IncidentController.getIncidents();
        System.assertEquals(testRec.size(),0);
    }
}