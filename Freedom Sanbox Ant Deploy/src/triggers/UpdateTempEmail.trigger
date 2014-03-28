/*
    Revision History:
       
    Version     Version Author     Date             Comments
    1.0         Manasi Ranade      06/07/2012       Issue ID:00001707: Added code to Calculate 'Total Cycle' which was not possible by Formula 
                                                    Field because of character limits of 5000 char in salesforce
*/
trigger UpdateTempEmail on Account (before insert,before update) {
    for(Account acc:Trigger.new){
        if(Trigger.isInsert){
                if(acc.PersonEmail != null && acc.Email_Temp__c ==null){
                    acc.Email_Temp__c=acc.PersonEmail;
                }
            }
        else if(trigger.isUpdate){
                Integer iTotalCycle = 0; 
                Account beforeUpdateAcc= Trigger.oldMap.get(acc.Id);
                if(beforeUpdateAcc.Email_Temp__c != acc.PersonEmail){
                    acc.Email_Temp__c=acc.PersonEmail;
            }
            /** Eternus Solutions       **/
            /** Author  : Manasi Ranade **/
            /** Issue Id: 00001707      **/
            /** Date    : 06/07/2012    **/
            /** Purpose : Added code to Calculate 'Total Cycle' which was not possible by Formula 
                Field because of character limits of 5000 char in salesforce**/
            String strClientRecType = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c;
            String strRecTypeID = acc.RecordTypeId;
            if(strRecTypeID.Contains(strClientRecType) || strClientRecType.Contains(strRecTypeID))
            {
                if(acc.DC_CR__c != null)//Data Collection Duration
                {
                    iTotalCycle += Integer.valueOf(acc.DC_CR__c);
                }
                if(acc.PW_DC__c != null)//Plan Writing Duration
                {
                    iTotalCycle += Integer.valueOf(acc.PW_DC__c); 
                }
                if(acc.PA_PP__c != null)//Plan Approval Duration
                {
                    iTotalCycle += Integer.valueOf(acc.PA_PP__c); 
                }
                if(acc.AP_D__c != null)//Action Plan Duration
                {
                    iTotalCycle += Integer.valueOf(acc.AP_D__c); 
                }
                // Commented on : 06/05/13 : As per discussion with Vinita
                /*if(acc.FE_CD__c != null)//First Execution Duration
                {
                    iTotalCycle += Integer.valueOf(acc.FE_CD__c); 
                }*/
                acc.Total_Cycle__c = iTotalCycle;
            }
        }
    }
}