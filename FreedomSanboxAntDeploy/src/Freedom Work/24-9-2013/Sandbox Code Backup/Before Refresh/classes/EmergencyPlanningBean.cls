/*

	Revision History:
	
    Version     Version Author   Date        	Comments
    1.0         Samruddhi P 	 17/02/2011	  	EmergencyPlanningBean is bean class for EmergencyPlanningPage in Analysis Section
    2.0  		Manasi 			 28/11/2011     Issue Id: FS0395 : 1. Overwirte the emergencyFundAmount if it is filled from UI
    															   2. Created new property strEntity to use in the query
*/
public class EmergencyPlanningBean{
    public Double totalMonthlyExpense {get; set;}
    public Double noOfMonths {get; set;}
    //FS0395
    public String strEntity {get; set;}
    public Double emergencyFundAmount {
        get{
	        if(totalMonthlyExpense!=null & noOfMonths!=null){ 
	            emergencyFundAmount = totalMonthlyExpense * noOfMonths ;
	        }
	        else
	            emergencyFundAmount = 0;
	        /** Eternus Solutions       **/
			/** Author  : Manasi Ranade **/
			/** Issue Id: FS0395      	**/
			/** Date    : 3/1/2012 	    **/
			/** Purpose : Overwirte the emergencyFundAmount if it is filled from UI
			/****************************************************/
			if(strEntity != null)
			{
	        	List<Goal__c> goalLst = [Select Cost_of_Goal_Annual__c from Goal__c where Goal_Type__c='Emergency Fund' and Entity__c =: strEntity];
	            if(goalLst != null && goalLst.size() > 0 )
	            {
	            	Goal__c objGoal = goalLst[0];
	            	if(objGoal.Cost_of_Goal_Annual__c != null && objGoal.Cost_of_Goal_Annual__c != 0)
	           			emergencyFundAmount = objGoal.Cost_of_Goal_Annual__c;
	            }
			}
            return emergencyFundAmount;
        }
        set;
    }
            
    public List<EmergencyActionPlanBean> apBeanList{
        get{
            if(apBeanList==null){
                apBeanList=new List<EmergencyActionPlanBean>();
            }
        return apBeanList;    
        }
        set;
    }
    
    public Double total{
        get{
            total=0;
            for(EmergencyActionPlanBean apBean: apBeanList){
                if(apBean.Amount!=null)
                    total=total+apBean.Amount;
            }
        return total;
        }
        set;
    }           
}