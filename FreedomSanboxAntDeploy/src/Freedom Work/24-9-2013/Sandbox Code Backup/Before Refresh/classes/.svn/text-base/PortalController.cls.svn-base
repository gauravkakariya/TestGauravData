/*
Revision History:
	
    Version     Version Author     Date        Comments
    1.0         --           	   --	  		Initial Draft
    2.0			Mahesh Hirugade    11/24/2011   Issue ID:F0314:
    											Added the property getUserPlannerDescription().
    											The property contains a query on User object which fetch required planner details which are shown on the 
    											page named as : Portal_MyPlanner
*/
public class PortalController{
        
    List<Account> childEntitiesList = new List<Account>();
    public string currid    { get; set; }
    private Planner_Details__c  detail;
    private User  userDetail;
    private Account act;
    List<Account> childEntities = new List<Account>(); 
    List<Purchase_Sales_Report__c> Purchase_Sales_List = new List<Purchase_Sales_Report__c>();
    List<Portfolio_Report__c> Portfolio_List = new List<Portfolio_Report__c>();
    
    Map<String, Purchase_Sales_Report__c> Map_Purchase_Sales = new    Map<String, Purchase_Sales_Report__c>();
    Map<String, Portfolio_Report__c> Map_portfolio = new    Map<String, Portfolio_Report__c>();
    List<String> UniqueKeys=new List<String>();
    
    public User getCurrentUserDetails(){
       return [select Id, 
                      Name, 
                      Email,
                      AccountId
                      from User 
                      where Id=:UserInfo.getUserId()];
    }
    
    
    public  Account getAccount(){
    	System.debug('### getAccount begin ==');
        if(act==null){
                List<Account>  parentEntities = [select Name,
                                                        PAN_ID__pc,
                                                        BillingStreet,
                                                        Account.OwnerId,
                                                        BillingState,
                                                        BillingCity,
                                                        BillingPostalCode, 
                                                        PersonMobilePhone, 
                                                        PersonBirthDate,
                                                        PersonEmail,bank_Account_Number__c,
                                                        Branch_details__c,
                                                        Bank_Name__c,
                                                        Bank_Account_Type__c,
                                                        IFSC_Number__c,
                                                        MICR_Number__c  
                                                        from Account 
                                                        where Id =:getCurrentUserDetails().AccountId];
                
                     if(parentEntities != null && !parentEntities.isEmpty()){
                         act= parentEntities[0];
                     }
        }  
        System.debug('### getAccount end ==');
        return act;
   }
   
 
   public List<Account> getChildEntities() {
   		System.debug('### getChildEntities begin ==');
        if(childEntitiesList.isEmpty() && getAccount() != null)
        {
            for(Account a: [select Id,
                                   Relationship_to_Entity__pc,
                                   Name 
                                   from Account 
                                   where Parent_Entity__c = :getAccount().Id]){
                childEntitiesList.add(a);  
            }                  
             
        }
        System.debug('### getChildEntities End ==');
        return childEntitiesList;
   }
   
  /*public User getUserDetails(){
        if(userObj==null && getAccount() != null){
               
            userObj = [select Name,
                              Email,
                              MobilePhone,
                              Title  
                              from User 
                              where Id= :getAccount().OwnerId];
        }            
        return userObj;
                
   }*/
    
    /*Commented by Mahesh to resolve issueId FS0314*/
    public Planner_Details__c getPlannerDescription(){
    if(detail==null){
    	
        List<Planner_Details__c> planDetail= [select Name,
                                                    
                                                     Email__c,
                                                     MobilePhone__c,
                                                     Description__c 
                                                     from Planner_Details__c  
                                                     where OwnerId = :getAccount().OwnerId LIMIT 1];
         if(planDetail != null && !planDetail.isEmpty() ){
                detail = planDetail[0];
         }	
    } 
    return detail;
 }
	public User getUserPlannerDescription()
	{
		System.debug('### getPlannerDescription begin ==');
		if(userDetail==null){
		    	
			List<User> planDetail= [Select Phone, Name, SmallPhotoUrl, MobilePhone, Id, Email, AboutMe From User where Id= :getAccount().OwnerId];//where Id = '005200000017ay5'];
			
			if(planDetail != null && !planDetail.isEmpty() ){
				userDetail = planDetail[0];
			}
		}
	    System.debug('### getPlannerDescription end ==');
	    return userDetail;
	}
	/* Commented by Mahesh. This property was used to form the Planner picture's file name in static resources. 
		Now the picture is picked from USER object in getPlannerDescription()*/
	
	public String getPlannerPic(){
		System.debug('### getPlannerPic Start ==');
	         String pic=getPlannerDescription().Name +'.jpg';
	     System.debug('### getPlannerPic end ==');
	         return pic.replace(' ','');
	}
	
        
}