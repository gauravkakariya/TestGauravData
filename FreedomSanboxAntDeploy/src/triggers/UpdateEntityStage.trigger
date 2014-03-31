/*
    Revision History:
    
    Version     Version Author  Date        Comments
    1.0         Manasi Ranade   23/1/2012   Issue id : 00001447: Code to add delete entity 
                                                        button related functionality
    1.0         Mahesh          03/07/2012  As the field Entity Stage is getting updated by workflows, I am commenting code of Trigger.isUpdate
*/
trigger UpdateEntityStage on Account (before update,before delete) 
{
   if(Trigger.isDelete)
    {
        /*Set<Id> accountIdSet = new Set<Id>();
        for(Account objAccount: trigger.old)
        {
            accountIdSet.add(objAccount.Id);
        }
        BeforeDeleteOnAccountController.DeleteEntityRelatedRecords(accountIdSet);
        */
    }
        
    /*Mahesh : As the field Entity Stage is getting updated by workflows, I am commenting below code*
    if(Trigger.isUpdate)
    {
        for(Integer i=0; i<Trigger.size; i++){
            if(Trigger.old[i].Cheque_Received_Date__c== null && Trigger.new[i].Cheque_Received_Date__c !=null 
                    && Trigger.new[i].Data_Collection_Date__c==null 
                    && Trigger.new[i].Plan_Writing_Date__c==null 
                    && Trigger.new[i].Plan_Approved_Date__c==null 
                    && Trigger.new[i].Execution_Completion_Dates__c==null )//&& Trigger.new[i].Plan_Presented_Date__c==null 
                    {
                Trigger.new[i].Entity_Stage__c = 'Data Collection';
            }
            else if(Trigger.old[i].Data_Collection_Date__c== null && Trigger.new[i].Data_Collection_Date__c !=null
                    && Trigger.new[i].Plan_Writing_Date__c==null
                    && Trigger.new[i].Plan_Approved_Date__c==null 
                    && Trigger.new[i].Execution_Completion_Dates__c==null)//&& Trigger.new[i].Plan_Presented_Date__c==null 
                    {
                Trigger.new[i].Entity_Stage__c = 'Plan Writing';
            }
            else if(Trigger.old[i].Plan_Writing_Date__c== null && Trigger.new[i].Plan_Writing_Date__c !=null 
                    && Trigger.new[i].Plan_Approved_Date__c==null 
                    && Trigger.new[i].Execution_Completion_Dates__c==null)//&& Trigger.new[i].Plan_Presented_Date__c==null 
                   {
                Trigger.new[i].Entity_Stage__c = 'Plan Presentation';
            }
            /*else if(Trigger.old[i].Plan_Presented_Date__c== null && Trigger.new[i].Plan_Presented_Date__c !=null  
                    && Trigger.new[i].Plan_Approved_Date__c==null 
                    && Trigger.new[i].Execution_Completion_Dates__c==null){
                Trigger.new[i].Entity_Stage__c = 'Plan Approval';
            }*
            else if(Trigger.old[i].Plan_Approved_Date__c== null && Trigger.new[i].Plan_Approved_Date__c !=null 
                    && Trigger.new[i].Execution_Completion_Dates__c==null){
                Trigger.new[i].Entity_Stage__c = 'Execution in Progress';
            }
            else if(Trigger.old[i].Execution_Completion_Dates__c== null && Trigger.new[i].Execution_Completion_Dates__c !=null){
                Trigger.new[i].Entity_Stage__c = 'Execution Completed';
            }
        }
    }*/
}