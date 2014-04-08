/*
 *@Author: Anju G
 *@since :24th Jan 2011
 *@Description:FamilyMemberDetailContoller is controller class for Personal Details Landing Page
 */

public class FamilyMemberDetailController
{
    public String entityId{get;set;}
    public List<Account> acc {get;set;}
    public List<Account> newAcc {get;set;}
    public boolean isNew {get;set;}
    public boolean isclient{get;set;}
    public FamilyMemberInfoService fmservice;
    public FamilyMemberInfoBean fmBean;
    //Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
    public Boolean isDisplaySaveButton{get;set;}
    public Boolean isDisplayFamilyDetails{get;set;}
    public Boolean isChequeDetails{get;set;}
     
    public FamilyMemberDetailController (ApexPages.StandardController controller) 
    {
       fmservice = new FamilyMemberInfoService();
       fmBean = new FamilyMemberInfoBean();
       newAcc = new List<Account>();
       isNew = false;
       //Code Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
       isDisplaySaveButton = true;
        isChequeDetails = false;
       
       acc = new List<Account>();
       entityId = Apexpages.currentPage().getParameters().get('entityId');
        /* 
       if(entityId != null && entityId != '')
	       {
	            Account accId = fmservice.getEntity(entityId);
	            if(accId.Parent_Entity__c == null)
	            {
	                isclient = true;
	            }
	            acc = fmservice.getFamilyDetails(entityId); 
	            //Added Code on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	            User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
	            if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
	            {
	            	isDisplaySaveButton = false;
	            }
	       }
       */
      
      Integer countPurchaseOrderRecord = [Select count() From Purchase_Order__c  Where Entity__c =: entityId And 
      									 		 Product_Type__c ='Base Product'And Is_Cancel__c = false ];
      									 		
      if(countPurchaseOrderRecord > 0)
      {
      	   if(entityId != null && entityId != '')
	       {
	       		Date ProductizedFPLaunchDate = (TopUpGoal__c.getInstance('Top Up').ProductizedFP_launch_date__c != null) 
	       										? TopUpGoal__c.getInstance('Top Up').ProductizedFP_launch_date__c 
	       										: date.newinstance(2013, 4, 27);
	       		
	       	//2005-10-08T01:02:03Z Productized 
	       		Account objAccount  = [Select CreatedDate,(Select Id From Cheque_Details__r) From Account a Where a.Id =: entityId];
				if(objAccount.Cheque_details__r.size() == 0 && objAccount.CreatedDate > ProductizedFPLaunchDate)
				{
					isChequeDetails = true;
					//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please Create Cheque Details Record'));
					return;
				}
				isDisplayFamilyDetails = false;
	            Account accId = fmservice.getEntity(entityId);
	            if(accId.Parent_Entity__c == null)
	            {
	                isclient = true;
	            }
	            acc = fmservice.getFamilyDetails(entityId); 
	            //Added Code on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	            User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
	            if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
	            {
	            	isDisplaySaveButton = false;
	            }
	       }
	       
	  } 
      else
      {
      	isDisplayFamilyDetails = true;
      	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Purchase Order is not available. Please create Purchase Order.'));
      	return;
      }  
      
          
    }
    
    /**
        This function is used to save the record from familyMemberDetail page
    */
    public pageReference save()
    {
        pageReference pageRef=null;
        List<Account> newAccToInsert = new List<Account>();
        try
        {
            for (Account ac : acc) 
            {
                if  (ac.FirstName == null || ac.FirstName == '')
                {
                    throw new ValidationException(Label.firstNameRequired); 
                }
                else if(ac.LastName == null || ac.LastName == '' )
                {
                    throw new ValidationException(Label.lastNameRequired); 
                 }
                if (ac.id == null) 
                {
                    if (entityId != null && entityId != '') 
                    {
                        ac.Parent_Entity__c = entityId;
                    }
                    newAccToInsert.add(ac);
                }
            }
    
        	if (newAccToInsert.size()>0) 
        	{
            	fmservice.addNewMembers(newAccToInsert); 
        	}
        
       	    newAcc = new List<Account>();
        	pageRef = new pageReference ('/apex/FamilyMemberDetail?entityId='+entityId+
                                                 '&tabname=Financial Planning');
       	    pageRef.setRedirect(true); 
     	} 
     	catch(ValidationException e) 
     	{
       	    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
        }    
    	catch(Exception ex)
    	{
         	ApexPages.addMessages(ex);
    	}
     	return pageRef;
    }
    
   /**
    This function is used to cancel the newly inserted row before saving
    */
    public Pagereference cancel()
    {
        if (acc.size()>0) 
        {
             for (integer i=0;i<acc.size();i++) 
             {
                if (acc.get(i).FirstName == null && acc.get(i).LastName==null) 
                {
                    acc.remove(i);    
                }
            }
       }
       pageReference pageRef = new pageReference ('/apex/FamilyMemberDetail?entityId='+entityId+
                                                   '&tabname=Financial Planning');
       pageRef.setRedirect(true); 
       return pageRef;
    }
    
   /**
    This function is used to navigate to the income page
    */
    public pageReference Next()
    {
        pageReference pageRef = new pageReference ('/apex/IncomeSummaryPage?entityId='+entityId+
                                                   '&tabname=Financial Planning');
        return pageRef;
    }
    
    /**
    This function is used to add new member 
    */
    public pageReference AddNewMember()
    {
        Account acctemp = new Account();
        acctemp.RecordTypeId = fmService.getPersonRecordType(Label.accountFamily).Record_Type_Value__c;
        newAcc.add(acctemp);
        acc.add(acctemp);  
        isNew = true;
        return null;
    }
    
    /**
    This function is used to navigate to familyInfoPage to add details for an entity
    */
    public pageReference AddDetails()
    {
        
        String accId = Apexpages.currentPage().getParameters().get('accid');
        String parentId = Apexpages.currentPage().getParameters().get('parentAcc');
        if(accId != null && accId != '')
        {
            pageReference pageRef;
            if (parentId == null || parentId =='') 
            {
                pageRef = new pageReference ('/apex/familyInfoPage?entityId='+accid+
                                             '&RecType=client&tabname=Financial Planning');
            }
            else
            {
                pageRef = new pageReference ('/apex/familyInfoPage?fentityId='+accid+'&entityId='+
                                             parentId+'&RecType=family&tabname=Financial Planning');
            }
            return pageRef;
        }
        else
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,Label.addDetailsValidation);
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
}