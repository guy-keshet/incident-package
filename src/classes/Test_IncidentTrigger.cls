@isTest(seeAllData=false)
private class Test_IncidentTrigger {

    public static void createIncidentWithCaseRecords(Integer howManyIncidents, Integer howManyIncCases) {
        keshet__IncidentClosedCaseStatus__c testRecord = new keshet__IncidentClosedCaseStatus__c(Name='test',keshet__StatusName__c='Closed',keshet__Close_Reason__c='Other');
        insert testRecord;
        
        List<keshet__Incident__c> incidents = new List<keshet__Incident__c>();
        
        for(Integer i=0;i<howManyIncidents;i++) {
            keshet__Incident__c a = new keshet__Incident__c(Name='TestInc' + i,
                                                            keshet__Console_Label__c='test label', keshet__Note_to_Customers__c='notes');
            incidents.add(a);
        }
        insert incidents;
        
        Contact testContact = new Contact(lastname='testIncidentTrigger',email='testinc@mailinator.com');
        insert testContact;
        
        List<Case> cases = new List<Case>();
        for (Integer j=0;j<howManyIncidents;j++) {
            keshet__Incident__c incident = incidents[j];            
            // For each incident just inserted, add cases
            for (Integer k=howManyIncCases*j;k<howManyIncCases*(j+1);k++) {
                cases.add(new Case(keshet__Incident__c=incident.id,
                                   subject='Test'+k,
                                   contactId=testContact.id
                                  ));
            }
        }
        insert cases;      
    }
    public static testMethod void updateTrigger_nochange(){
        createIncidentWithCaseRecords(2,2);
        List<keshet__Incident__c> incidents = [select id from keshet__Incident__c where Name LIKE 'TestInc%'];
        
        for (integer i=0;i<incidents.size();i++){
            incidents[i].keshet__Console_Label__c  = 'updated '+i;
        }
        update incidents;
        
        List<keshet__Incident__c> UpdateIncidents = [select id from keshet__Incident__c where keshet__Console_Label__c LIKE 'updated%'];
        System.assertEquals(incidents.size(),UpdateIncidents.size());          
    }
    
    public static testMethod void updateTrigger_nochange_volume(){
        createIncidentWithCaseRecords(2,100);
        List<keshet__Incident__c> incidents = [select id from keshet__Incident__c where Name LIKE 'TestInc%'];
        
        for (integer i=0;i<incidents.size();i++){
            incidents[i].keshet__Console_Label__c  = 'updated '+i;
        }
        update incidents;
        
        List<keshet__Incident__c> UpdateIncidents = [select id from keshet__Incident__c where keshet__Console_Label__c LIKE 'updated%'];
        System.assertEquals(incidents.size(),UpdateIncidents.size()); 
    } 
    
    public static testMethod void updateTrigger_closecases(){
        createIncidentWithCaseRecords(2,2);
        List<keshet__Incident__c> incidents = [select id from keshet__Incident__c where Name LIKE 'TestInc%'];
        
        for (integer i=0;i<incidents.size();i++){
            incidents[i].keshet__Case_Closed_Comment__c   = 'updated '+i;
            incidents[i].keshet__Status__c = 'Resolved';
        }
        update incidents;
        
        List<keshet__Incident__c> UpdateIncidents = [select id from keshet__Incident__c where keshet__Case_Closed_Comment__c LIKE 'updated%'];
        System.assertEquals(incidents.size(),UpdateIncidents.size());   
        List<Case> ClosedCases = [select id from Case where subject like 'Test%' and status = 'Closed'];
        System.assertEquals(ClosedCases.size(),4);
    }
    
       public static testMethod void updateTrigger_closecases_volume(){
        createIncidentWithCaseRecords(2,500);
        List<keshet__Incident__c> incidents = [select id from keshet__Incident__c where Name LIKE 'TestInc%'];
        
        for (integer i=0;i<incidents.size();i++){
            incidents[i].keshet__Case_Closed_Comment__c   = 'updated '+i;
            incidents[i].keshet__Status__c = 'Resolved';
        }
        update incidents;
        
        List<keshet__Incident__c> UpdateIncidents = [select id from keshet__Incident__c where keshet__Case_Closed_Comment__c LIKE 'updated%'];
        System.assertEquals(incidents.size(),UpdateIncidents.size());   
        List<Case> ClosedCases = [select id from Case where subject like 'Test%' and status = 'Closed'];
        System.assertEquals(ClosedCases.size(),1000);
    }
}