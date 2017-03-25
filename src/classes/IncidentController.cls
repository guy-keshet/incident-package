public with sharing class IncidentController {
    @AuraEnabled
    public static List<Incident__c> getIncidents() {
        return [SELECT Id, Console_Label__c, Note_to_Customers__c, Self_service_label__c, Status__c, Start_date__c 
                FROM Incident__c 
                where Status__c in ('Active','Resolved') 
                order by Status__c ASC, Start_date__c ASC 
                LIMIT 1];
    }
}