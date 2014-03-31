/*  CreateProcessFlowTrackerHandler class is using to create set of WFlow tracker to associated with Entity on After entity creation.
    Creating new task for first flow tacker record with workflow Tracker Details.
*  
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Gaurav            8-OCt-2013        Initial Draft
*/
public without sharing class CreateProcessFlowTrackerHandler 
{
    //Method call on Client Entity Creation.
    public void createFlowTempateWithTracker(map<Id, Account> mapIdToAccount)
    {
        List<Workflows_Tracker_Master__c> lstWFlowMasterTemplate = new List<Workflows_Tracker_Master__c>();
        List<Workflows_Tracker_Details__c> lstFlowTracker = new List<Workflows_Tracker_Details__c>();
        List<Workflows_Tracker_Details__c> lstNewWFTrackerDetails = new List<Workflows_Tracker_Details__c>();
        
        //Client recordType Id
        Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
        Id clientRecordTypeId =  RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId();  
        
        
        //Get Wflow Details record type for Workflow Details object
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WORKFLOW_TRACKER = Workflows_Tracker_Details__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFTRACKER = DESCRIBE_RESULT_WORKFLOW_TRACKER.getRecordTypeInfosByName();
        Id wFlowTrackerDataRecordType =  RECORD_TYPE_INFO_MAP_WFTRACKER.get('EntityWflowDetail').getRecordTypeId();  
        
        //Get Wflow Details record type for Workflow Master object
        Schema.DescribeSObjectResult DESCRIBE_RESULT_WORKFLOW_MASTER = Workflows_Tracker_Master__c.SobjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_WFMASTER = DESCRIBE_RESULT_WORKFLOW_MASTER.getRecordTypeInfosByName();
        Id wFlowMasterDataRecordType =  RECORD_TYPE_INFO_MAP_WFMASTER.get('EntityWflowDetail').getRecordTypeId();  
        
        
        //"Workflow Flow Template" recordtype Id.
        Id rtIdOfWFlowTemplate = [Select Id,SobjectType from RecordType where Name = 'WFlowTemplate' and SobjectType='Workflows_Tracker_Master__c'].Id;
        
        
        //list contain Workflow Flow Master record with its Workflow Tracker records.
        List<Workflows_Tracker_Master__c> lstMasterFlowsTemplate= [Select Skip_Weekends__c,Workflow_Tracker_Detail_Status__c,Tracker_Type__c,RecordType.Name,Status__c,Parent_Account__c,Is_Active__c,Description__c, RecordTypeId, Name, 
                                                                (Select Name, Subject__c, Related_Workflow_Details_Date__c,Event_Master__r.Escalation_Event_Master__c,Workflows_Tracker_Master__r.Parent_Account__c,Channel_Type__c,Days_After__c,Event_Master__c,Parent_Workflows_Tracker_Details__c , Due_Date__c, 
                                                                 Workflows_Tracker_Master__c, Parent_Workflows_Tracker_Details__r.Subject__c,Comments__c, Department__c,Priority__c, Task_Sequence__c,Task_Id__c,
                                                                 Status__c From Workflows_Tracker_Details__r) 
                                                         From Workflows_Tracker_Master__c 
                                                         where RecordType.Name = 'WFlowTemplate' AND Tracker_Type__c='EntityWFlowTracker' LIMIT 1];
                                                         
        
        system.debug('outside-->' + lstMasterFlowsTemplate); 
        list<Workflows_Tracker_Details__c> wFlowTrackerDetailsTemplates = new list<Workflows_Tracker_Details__c>();
        //Workflow Flow Master Template is not Empty
        if(!lstMasterFlowsTemplate.isEmpty())
        {     
            wFlowTrackerDetailsTemplates = lstMasterFlowsTemplate[0].Workflows_Tracker_Details__r;
            system.debug('lstMasterFlowsTemplate-->' + lstMasterFlowsTemplate);          
            //Create Detail Workflow Flow Master record for each client entity.                                                              
            for(Account objEntity : mapIdToAccount.values())
            {
                
                //Entity must be client type.
                if(objEntity.RecordTypeId == clientRecordTypeId)
                {   
                    Workflows_Tracker_Master__c objWorkFlowMaster = new Workflows_Tracker_Master__c();
                    system.debug('objEntity-->' + objEntity);
                    objWorkFlowMaster = lstMasterFlowsTemplate[0].clone();
                    system.debug('objEntity123 -->' + objWorkFlowMaster);
                    objWorkFlowMaster.Parent_Account__c = objEntity.Id;       
                    objWorkFlowMaster.RecordTypeId = wFlowMasterDataRecordType ;        
                    objWorkFlowMaster.Name = 'Entity Workflow Tracker Details';
                    objWorkFlowMaster.Workflow_Tracker_Detail_Status__c= '0/18';        
                    lstWFlowMasterTemplate.add(objWorkFlowMaster);
                }
             }
            
            //Insert Workflow Flow Master record
            if(!lstWFlowMasterTemplate.isEmpty())
            {
            	system.debug('lstWFlowMasterTemplate --> ' + lstWFlowMasterTemplate);
                insert lstWFlowMasterTemplate;
            }
   			system.debug('**********lstWFlowMasterTemplate11*****'+lstWFlowMasterTemplate.size());
   			system.debug('**********wFlowTrackerDetailsTemplates*****'+wFlowTrackerDetailsTemplates.size() );
            if(lstWFlowMasterTemplate.size() > 0 && wFlowTrackerDetailsTemplates.size() > 0)   
            {
            	list<Workflows_Tracker_Details__c> wFLowTrackerDetailsToInsert = new list<Workflows_Tracker_Details__c>();
            	for(Workflows_Tracker_Master__c wFlowMasterInst : lstWFlowMasterTemplate){
	                for(Workflows_Tracker_Details__c wFlowTrackerTemplateInst : wFlowTrackerDetailsTemplates){
	                    Workflows_Tracker_Details__c wFlowDetailInst = new Workflows_Tracker_Details__c ();
	                    wFlowDetailInst = wFlowTrackerTemplateInst.clone(false,true,false,false);
	                    wFlowDetailInst.RecordTypeId = wFlowTrackerDataRecordType;
	                    wFlowDetailInst.Workflows_Tracker_Master__c = wFlowMasterInst.Id;
	                    system.debug('wFlowMasterInst --> ' + wFlowMasterInst.Id);
	                    wFLowTrackerDetailsToInsert.add(wFlowDetailInst);
	                }
            	}
            	
            	//
                system.debug('wFlowTrackerDetailsTemplates --> ' + wFlowTrackerDetailsTemplates);
                if(wFLowTrackerDetailsToInsert != null && wFLowTrackerDetailsToInsert.size() > 0)
                {
                	
                    insert wFLowTrackerDetailsToInsert;
                    system.debug('wFLowTrackerDetailsToInsert --> ' + wFLowTrackerDetailsToInsert);
                }
                
                //for loop to get all inserted records which are having parent self look up fields as not null
                //in this for loop create a map of <ac Id, list<subject of Parent EFTD>> and a list of all parent subjects and list of WFTD having parent look up as not null
                //query EFTD where accId IN map.keySet() and subject in list - list
                // 1st for -- > lstWFlowDetail
                // 2nd for --> lstEntityWorkFlowTrackerDetail
                // if(lstWFlowDetail.ParentMaster.Accountid == lstEntityWorkFlowTrackerDetail.Parent.AccountiD && lstWFlowDetail.ParentWFTD.subject == lstEntityWorkFlowTrackerDetail.subject){\
                // 	assign lstWFlowDetail.parentWFTD = lstEntityWorkFlowTrackerDetail
            	// }
            	
                Map<Id, List<String>> mapAccountIdtolstParentWFlowMasterSubject = new Map<Id, List<String>>();
                List<String> lstParentWFlowMasterSubject = new List<String>();
                List<Workflows_Tracker_Details__c> lstWFlowDetail = new List<Workflows_Tracker_Details__c>();
                List<Workflows_Tracker_Details__c> lstUpdateEntityWFlowTracker = new List<Workflows_Tracker_Details__c>();
                List<string> wftDetailsInsertedIds = new list<string>();
                Map<Id, Workflows_Tracker_Details__c> mapWFlowTrackerIdToWFlowDetail = new  Map<Id, Workflows_Tracker_Details__c>();
                
                for(Workflows_Tracker_Details__c objWFTrackerDetailsInst : wFLowTrackerDetailsToInsert){
                	wftDetailsInsertedIds.add(objWFTrackerDetailsInst.Id);
                }
                
                List<Workflows_Tracker_Details__c> wFLowTrackerDetailsToInserted = [Select Name,Parent_Workflows_Tracker_Details__r.Subject__c, Subject__c, Days_After__c, Due_Date__c, Parent_Workflows_Tracker_Details__c,Parent_Workflows_Tracker_Details__r.Workflows_Tracker_Master__r.Parent_Account__c ,
						                                                                         Workflows_Tracker_Master__c, Comments__c, Priority__c, Task_Sequence__c, Workflows_Tracker_Master__r.Parent_Account__c,
						                                                                         Status__c 
				                                                                         From Workflows_Tracker_Details__c WHERE Id IN:wftDetailsInsertedIds];
                for(Workflows_Tracker_Details__c objWFTrackerDetails : wFLowTrackerDetailsToInserted)
                {
                	if(objWFTrackerDetails.Parent_Workflows_Tracker_Details__c != null && 
                		(objWFTrackerDetails.Parent_Workflows_Tracker_Details__r.Subject__c != null || objWFTrackerDetails.Parent_Workflows_Tracker_Details__r.Subject__c != ''))
                	{
	                 	if(!mapAccountIdtolstParentWFlowMasterSubject.containsKey(objWFTrackerDetails.Workflows_Tracker_Master__r.Parent_Account__c)){
	                 		mapAccountIdtolstParentWFlowMasterSubject.put(objWFTrackerDetails.Workflows_Tracker_Master__r.Parent_Account__c , new List<String>{objWFTrackerDetails.Parent_Workflows_Tracker_Details__r.Subject__c});
	                 		system.debug('objWFTrackerDetails ------->' + objWFTrackerDetails.Workflows_Tracker_Master__r.Parent_Account__c);
	                 	}
						else{
							mapAccountIdtolstParentWFlowMasterSubject.get(objWFTrackerDetails.Workflows_Tracker_Master__r.Parent_Account__c).add(objWFTrackerDetails.Parent_Workflows_Tracker_Details__r.Subject__c);
						}
						lstParentWFlowMasterSubject.add(objWFTrackerDetails.Parent_Workflows_Tracker_Details__r.Subject__c)	;
						lstWFlowDetail.add(objWFTrackerDetails);
                	}	
                }
                system.debug('****lstParentWFlowMasterSubject***************'+lstParentWFlowMasterSubject);   
                system.debug('****lstWFlowDetail***************'+lstWFlowDetail);
                system.debug('****mapAccountIdtolstParentWFlowMasterSubject.keySet()***************'+mapAccountIdtolstParentWFlowMasterSubject.keySet());      
                	
                if(mapAccountIdtolstParentWFlowMasterSubject != null && lstParentWFlowMasterSubject.size() > 0) 
                {
	                List<Workflows_Tracker_Details__c> lstEntityWorkFlowTrackerDetail = [Select Name, Subject__c, Days_After__c, Due_Date__c, Parent_Workflows_Tracker_Details__c,Parent_Workflows_Tracker_Details__r.Workflows_Tracker_Master__r.Parent_Account__c ,
						                                                                         Workflows_Tracker_Master__c, Comments__c, Priority__c, Task_Sequence__c, Workflows_Tracker_Master__r.Parent_Account__c,
						                                                                         Status__c 
				                                                                         From Workflows_Tracker_Details__c 
			                                                                      		 Where Workflows_Tracker_Master__r.Parent_Account__c IN: mapAccountIdtolstParentWFlowMasterSubject.keySet()
			                                                                          			 and Subject__c IN: lstParentWFlowMasterSubject];
	               
	               	system.debug('****lstEntityWorkFlowTrackerDetail***************'+lstEntityWorkFlowTrackerDetail); 
	                if(lstEntityWorkFlowTrackerDetail != null && lstEntityWorkFlowTrackerDetail.size() > 0)
	                {
		                for(Workflows_Tracker_Details__c objWFlowTrackerDetail : lstWFlowDetail)
		                {
		                	system.debug('****objWFlowTrackerDetail***************'+objWFlowTrackerDetail); 
		                	
		                	for(Workflows_Tracker_Details__c objEntityWFlowTrackerDetail : lstEntityWorkFlowTrackerDetail)
			                {
			                	system.debug('****objEntityWFlowTrackerDetail***************'+objEntityWFlowTrackerDetail); 
			                	
			                	if(objWFlowTrackerDetail.Workflows_Tracker_Master__r.Parent_Account__c == objEntityWFlowTrackerDetail.Workflows_Tracker_Master__r.Parent_Account__c && objWFlowTrackerDetail.Parent_Workflows_Tracker_Details__r.Subject__c == objEntityWFlowTrackerDetail.Subject__c)
			                	{
			                		system.debug('****objEntityWFlowTrackerDetail.Id***************'+objEntityWFlowTrackerDetail.Id); 
			                		
			                		objWFlowTrackerDetail.Parent_Workflows_Tracker_Details__c = objEntityWFlowTrackerDetail.Id;
			                		mapWFlowTrackerIdToWFlowDetail.put(objWFlowTrackerDetail.Id,objWFlowTrackerDetail);
			                		lstUpdateEntityWFlowTracker.add(objWFlowTrackerDetail);
			                	}	
			                	
			                }
		                	
		                }
	                }    
	                system.debug('****lstUpdateEntityWFlowTracker***************'+lstUpdateEntityWFlowTracker);
	                
	                //update Wflow tracker
                    if(mapWFlowTrackerIdToWFlowDetail != null && mapWFlowTrackerIdToWFlowDetail.keyset() != null)
                        	update mapWFlowTrackerIdToWFlowDetail.values();
                        	
	                //update Wflow tracker
		            //if(!lstUpdateEntityWFlowTracker.isEmpty())
		             //   update lstUpdateEntityWFlowTracker;
	                   
                }
                /*
                *Code to update status of all Workflow tracker details having sequence as 1
                */
                
                if(wFLowTrackerDetailsToInsert!= null)
                {//Collect all new created Flow Tracker where Task Sequence = 1
                    List<Workflows_Tracker_Details__c> lstFirstTaskFlowTracker = [Select Name, Subject__c, Days_After__c, Due_Date__c, 
                                                                         Workflows_Tracker_Master__c, Comments__c, Priority__c, Task_Sequence__c, Workflows_Tracker_Master__r.Parent_Account__c,
                                                                         Status__c From Workflows_Tracker_Details__c where Id IN: wFLowTrackerDetailsToInsert and Task_Sequence__c = 1];
                    List<Workflows_Tracker_Details__c> lstFirstTaskFlowTrackerToUpdate = new List<Workflows_Tracker_Details__c>(); 
                    if(lstFirstTaskFlowTracker.size() != 0)                                                          
                    {   
                        for(Workflows_Tracker_Details__c objWFTrackerDetails : lstFirstTaskFlowTracker)
                        {
                            objWFTrackerDetails.Status__c = Label.In_Progress;
                            system.debug('****objWFTrackerDetails.Status__c***************'+objWFTrackerDetails.Status__c);
                            lstFirstTaskFlowTrackerToUpdate.add(objWFTrackerDetails);
                            system.debug('****lstFirstTaskFlowTrackerToUpdate*************'+lstFirstTaskFlowTrackerToUpdate);
                        }
                        
                        if(!lstFirstTaskFlowTrackerToUpdate.isEmpty())
                            update lstFirstTaskFlowTrackerToUpdate;
                        
                    }       
                }
            }
        }
    }
            
}