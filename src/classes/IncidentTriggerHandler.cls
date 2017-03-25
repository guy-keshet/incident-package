public class IncidentTriggerHandler {
    //Method to update cases on an incident update: 
    // update status to closed if incident status is 'Resolved' or 'Archived', if the case is not already closed.
    // Use incident case close comments to update the case case closed comments
    Final static string ResolvedIncidentStatus = 'Resolved';
    Final static string ArchivedIncidentStatus = 'Archived'; 
    Final static string ActiveIncidentStatus = 'Active';

    public static void handleAfterUpdate(List<keshet__Incident__c> incidents, Map <Id,keshet__Incident__c> oldIncidents) { 
        //Create case closed picklist values    
        string CaseClosedStatus;
        string CaseClosedReason;
        
        List<keshet__IncidentClosedCaseStatus__c> myCS = keshet__IncidentClosedCaseStatus__c.getall().values();
        if (myCS.size()>0){
           if (myCS[0].keshet__StatusName__c != null)
                CaseClosedStatus = myCS[0].keshet__StatusName__c;
           else //default value
                CaseClosedStatus = 'closed';
           if (myCS[0].keshet__Close_Reason__c != null)
                CaseClosedReason = myCS[0].keshet__Close_Reason__c;
           else //Default value
                CaseClosedReason = 'Incident closed';
            }
        
        //get all cases linked to updated incidents       
        //get all cases
        
        Map<ID, Case> CasesMap = new Map<ID, case>([Select id, keshet__Incident__c,IsClosed from Case where incident__c in :incidents]);
        //create map of incidents
        Map<Id, keshet__Incident__c> IncidentMap = new Map<Id, keshet__Incident__c>();
     
        for(keshet__Incident__c inc : incidents)
        {
             IncidentMap.put(inc.id, inc);
        }
        //list of cases to be updated
        List<Case> UpdatedCases = new List<Case>();
        List<CaseComment> NewComments = new List<CaseComment>() ;
          
        for (Case c:CasesMap.values())
        {
            keshet__Incident__c currentIncident = IncidentMap.get(c.keshet__Incident__c);
            
            keshet__Incident__c oldIncident = oldIncidents.get(currentIncident.ID);
             //Only treat resolved or archived incidents, when they change from active
                if ((currentIncident.status__c == ResolvedIncidentStatus) || (currentIncident.status__c == ArchivedIncidentStatus))
                {
                    //Close cases, if incident just changed from active to resolved or archived
                    if ((c.IsClosed == false) && (oldIncident.status__c==ActiveIncidentStatus))
                    {
                        c.status = CaseClosedStatus;
                        c.reason = CaseClosedReason;
                        CaseComment com = new CaseComment();
                        com.ParentId = c.id;
                        if (currentIncident.keshet__Case_Closed_Comment__c != '')
                            com.CommentBody= currentIncident.keshet__Case_Closed_Comment__c ;
                        else
                            com.CommentBody = 'Incident Resolved/Archived';
                        NewComments.add(com);
                        UpdatedCases.add(c);                   
                     }//if case is open and old inc status is archived/resolved
                }//if curr inc status is archived/resolved           	 
        }//close for case loop
         
        try{
            system.debug('trying case updates');
            if ((NewComments != null) && (!NewComments.isEmpty()))
            { system.debug('about to insert comments');
             insert NewComments;}
            if ((UpdatedCases!=null) && !UpdatedCases.isEmpty() )
            {system.debug('about to update cases');
             update UpdatedCases;}
        } catch (DMLException e){
            system.debug('Oh Oh - Error: ' + e.getMessage());
            for (Case c : UpdatedCases) {
                c.addError('There was a problem closing the case');
            }
        }  
    }//close method handleAfterUpdate
}