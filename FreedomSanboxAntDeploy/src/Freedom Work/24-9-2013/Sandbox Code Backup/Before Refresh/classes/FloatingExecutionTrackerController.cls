/*
	Revision History:
	
    Version     Version Author     Date           Comments
    1.0			Anupam	          2/01/13		 Created create new ET record functionality on Related list of Execution Tracker on Entity page
    1.1		    Gaurav 			  12/2/2013	      Checking the Mailing Address not null& not blank and Assign to Communication address field of ExecutionTracker object  						 
*/
 
public with sharing class FloatingExecutionTrackerController 
{
	public Boolean isProductSelection {get;set;}
	public String selectedProductType {get;set;}
	public Id entityId {get;set;}
	public Boolean isETDetail {get;set;}
	public Boolean isCreate {get;set;}
	public List<Execution_Tracker__c> lstExecutionTracker {get;set;} 
	public String selectSIPorLumpsumType {get;set;}
	public DatabaseSOQL dbSOQLObj {get; set;}
	public Execution_Tracker__c objMFExecutionTracker {get;set;}
	public Execution_Tracker__c objLIExecutionTracker {get;set;}
	public Execution_Tracker__c objGIExecutionTracker {get;set;}
	public Execution_Tracker__c objExecutionTracker {get;set;}
	
	private Account objAccount{get;set;}
	private String strAddress;
	//Constructor
	public FloatingExecutionTrackerController()
	{
		isCreate = false;
		dbSOQLObj = new DatabaseSOQL();
		entityId = ApexPages.currentPage().getParameters().get('eid');
		objAccount = [select Id,FirstName,LastName,PersonMobilePhone,PersonEmail,PersonMailingStreet, PersonMailingCountry, PersonMailingCity, PersonMailingPostalCode, PersonMailingState, PersonBirthdate,PAN_ID__pc,Bank_Account_Number2__c,OwnerId,
						Bank_Name__c,Branch_details__c,Bank_Account_Type__c,MICR_Number__c,IFSC_Number__c,Renewal_Date__c ,Related_To__c
						from Account where Id =:entityId];
						
		strAddress = '';
		objAccount.PersonMailingStreet = objAccount.PersonMailingStreet != null ? objAccount.PersonMailingStreet : ''; 
		objAccount.PersonMailingCity= objAccount.PersonMailingCity != null ? objAccount.PersonMailingCity: '';
		objAccount.PersonMailingState = objAccount.PersonMailingState!= null ? objAccount.PersonMailingState : '';
		objAccount.PersonMailingCountry = objAccount.PersonMailingCountry != null? objAccount.PersonMailingCountry :'';
		objAccount.PersonMailingPostalCode = objAccount.PersonMailingPostalCode != null? objAccount.PersonMailingPostalCode:'';
	   			
		if(objAccount.PersonMailingStreet != null && objAccount.PersonMailingCity != null && objAccount.PersonMailingState != null || 
		   objAccount.PersonMailingCountry != null && objAccount.PersonMailingPostalCode != null )
		   
				if(objAccount.PersonMailingStreet.compareTo('') ==  0 &&
				   objAccount.PersonMailingState.compareTo('') ==  0 &&
			 	   objAccount.PersonMailingCountry.compareTo('') == 0 &&
			 	   objAccount.PersonMailingPostalCode.compareTo('') == 0)
		 		strAddress = '';
	   		
	   	//Checking the Mailing Address not null& not blank and Assign to Communication address field of ExecutionTracker object  						 
		if(objAccount.PersonMailingStreet != null && objAccount.PersonMailingCity != null && objAccount.PersonMailingState != null || 
						objAccount.PersonMailingCountry != null && objAccount.PersonMailingPostalCode != null )
							
			if(objAccount.PersonMailingStreet.compareTo('') ==  0 &&
		       objAccount.PersonMailingState.compareTo('') ==  0 &&
			   objAccount.PersonMailingCity.compareTo('') ==  0 &&
			   objAccount.PersonMailingCountry.compareTo('') == 0 &&
			   objAccount.PersonMailingPostalCode.compareTo('') == 0)
					strAddress = '';	   
						 		
			else if(objAccount.PersonMailingStreet.compareTo('') ==  0 &&
					   objAccount.PersonMailingState.compareTo('') !=  0 &&
					   objAccount.PersonMailingCity.compareTo('') !=  0 &&
					   objAccount.PersonMailingCountry.compareTo('') != 0 &&
					   objAccount.PersonMailingPostalCode.compareTo('') != 0)	
					   strAddress =  objAccount.PersonMailingCity+',\n'+
   									 objAccount.PersonMailingState+', '+objAccount.PersonMailingCountry+',\n'+
   									 objAccount.PersonMailingPostalCode+'.';		
   							 
   			else if(objAccount.PersonMailingStreet.compareTo('') !=  0 &&
   					objAccount.PersonMailingState.compareTo('') ==  0 &&
   					objAccount.PersonMailingCity.compareTo('') !=  0 &&
   					objAccount.PersonMailingCountry.compareTo('') != 0 &&
   					objAccount.PersonMailingPostalCode.compareTo('') != 0)	
   						strAddress =  objAccount.PersonMailingStreet+',\n'+
   									  objAccount.PersonMailingCity+', '+objAccount.PersonMailingCountry+',\n'+
   									  objAccount.PersonMailingPostalCode+'.';		
				   									
			else if(objAccount.PersonMailingStreet.compareTo('') !=  0 &&
   					objAccount.PersonMailingState.compareTo('') !=  0 &&
   					objAccount.PersonMailingCity.compareTo('') ==  0 &&
   					objAccount.PersonMailingCountry.compareTo('') != 0 &&
   					objAccount.PersonMailingPostalCode.compareTo('') != 0)	
   						strAddress =  objAccount.PersonMailingStreet+', '+objAccount.PersonMailingState+',\n'+
   									  objAccount.PersonMailingCountry+',\n'+
   									  objAccount.PersonMailingPostalCode+'.';			
				   									
			else if(objAccount.PersonMailingStreet.compareTo('') !=  0 &&
   					objAccount.PersonMailingState.compareTo('') !=  0 &&
   					objAccount.PersonMailingCity.compareTo('') !=  0 &&
   					objAccount.PersonMailingCountry.compareTo('') == 0 &&
   					objAccount.PersonMailingPostalCode.compareTo('') != 0)	
   						strAddress =  objAccount.PersonMailingStreet+', '+objAccount.PersonMailingState+',\n'+
   							   		  objAccount.PersonMailingCity+',\n'+
				   					  objAccount.PersonMailingPostalCode+'.';				
				   									
			else if(objAccount.PersonMailingStreet.compareTo('') !=  0 &&
   					objAccount.PersonMailingState.compareTo('') !=  0 &&
   					objAccount.PersonMailingCity.compareTo('') !=  0 &&
   					objAccount.PersonMailingCountry.compareTo('') != 0 &&
   					objAccount.PersonMailingPostalCode.compareTo('') == 0)	
   						strAddress =  objAccount.PersonMailingStreet+', '+objAccount.PersonMailingState+',\n'+
   									  objAccount.PersonMailingCity+',\n'+
	   			  					  objAccount.PersonMailingCountry+'.';	   			  					  	
   		    else	 
			{
				strAddress = objAccount.PersonMailingStreet+', '+objAccount.PersonMailingCity+',\n'+
   							 objAccount.PersonMailingState+', '+objAccount.PersonMailingCountry+',\n'+
   							 objAccount.PersonMailingPostalCode+'.';
		    }			
   		else
   			strAddress = '';
		isETDetail = true;
		isProductSelection = true;
		getExecutionTracker();
	}
	
	private void getExecutionTracker()
	{
		lstExecutionTracker = new List<Execution_Tracker__c>();
		lstExecutionTracker = [Select Id, Name, Type__c, Target_Revenue__c, Remarks__c, Goal__r.Goal_Type__c, Executed_Amount__c, Booked_Revenue__c, Agreed_Amount__c, Suggested_Amount__c  
								From Execution_Tracker__c 
								where Entity_Name__c =:entityId and Is_Floating__c = true];//and Is_Floating__c = true
	}
	
	//Return to previous page on click of Back button
	public PageReference back()
	{
		return new PageReference('/' + entityId);
	}
	
	public void create()
	{
		objMFExecutionTracker = new Execution_Tracker__c ();
		//Mapping of fields from Entity
		objMFExecutionTracker.Email__c = objAccount.PersonEmail;
		objMFExecutionTracker.Investor_Name_as_in_PAN_card__c = objAccount.FirstName +' '+ objAccount.LastName;
   		objMFExecutionTracker.Mobile__c = objAccount.PersonMobilePhone;
   		objMFExecutionTracker.DOB__c = objAccount.PersonBirthdate;
   		objMFExecutionTracker.PAN__c = objAccount.PAN_ID__pc;
   		objMFExecutionTracker.Account_Number__c = objAccount.Bank_Account_Number2__c;
   		objMFExecutionTracker.Bank_Name__c = objAccount.Bank_Name__c;
   		objMFExecutionTracker.Branch_Address__c = objAccount.Branch_details__c;
   		objMFExecutionTracker.Account_Type__c = objAccount.Bank_Account_Type__c;
   		objMFExecutionTracker.MICR_Code__c = objAccount.MICR_Number__c;
   		objMFExecutionTracker.IFSC_Code__c = objAccount.IFSC_Number__c; 
   		objMFExecutionTracker.Renewal_Date__c = objAccount.Renewal_Date__c;
		objMFExecutionTracker.ET_Status__c = 'Assigned to MET';
		objMFExecutionTracker.Send_Email__c = true;
		objMFExecutionTracker.Send_Email_Datetime__c = System.now();
		objMFExecutionTracker.Send_SMS__c = true;
		objMFExecutionTracker.Send_SMS_Datetime__c = System.now();
		//Assign Personal address of entity to communication address
		//objMFExecutionTracker.Communication_Address__c = strAddress;
		
		objLIExecutionTracker = new Execution_Tracker__c ();
		//Mapping of fields from Entity
		objLIExecutionTracker.Email__c = objAccount.PersonEmail;
		objLIExecutionTracker.Investor_Name_as_in_PAN_card__c = objAccount.FirstName +' '+ objAccount.LastName;
   		objLIExecutionTracker.Mobile__c = objAccount.PersonMobilePhone;
   		objLIExecutionTracker.DOB__c = objAccount.PersonBirthdate;
   		objLIExecutionTracker.PAN__c = objAccount.PAN_ID__pc;
   		objLIExecutionTracker.Account_Number__c = objAccount.Bank_Account_Number2__c;
   		objLIExecutionTracker.Bank_Name__c = objAccount.Bank_Name__c;
   		objLIExecutionTracker.Branch_Address__c = objAccount.Branch_details__c;
   		objLIExecutionTracker.Account_Type__c = objAccount.Bank_Account_Type__c;
   		objLIExecutionTracker.MICR_Code__c = objAccount.MICR_Number__c;
   		objLIExecutionTracker.IFSC_Code__c = objAccount.IFSC_Number__c; 
   		objLIExecutionTracker.Renewal_Date__c = objAccount.Renewal_Date__c;
		objLIExecutionTracker.ET_Status__c = 'Assigned to MET';
		objLIExecutionTracker.Send_Email__c = true;
		objLIExecutionTracker.Send_Email_Datetime__c = System.now();
		objLIExecutionTracker.Send_SMS__c = true;
		objLIExecutionTracker.Send_SMS_Datetime__c = System.now();
		//objLIExecutionTracker.Communication_Address__c = strAddress;
		
		objGIExecutionTracker = new Execution_Tracker__c ();
		//Mapping of fields from Entity
		objGIExecutionTracker.Email__c = objAccount.PersonEmail;
		objGIExecutionTracker.Investor_Name_as_in_PAN_card__c = objAccount.FirstName +' '+ objAccount.LastName;
   		objGIExecutionTracker.Mobile__c = objAccount.PersonMobilePhone;
   		objGIExecutionTracker.DOB__c = objAccount.PersonBirthdate;
   		objGIExecutionTracker.PAN__c = objAccount.PAN_ID__pc;
   		objGIExecutionTracker.Account_Number__c = objAccount.Bank_Account_Number2__c;
   		objGIExecutionTracker.Bank_Name__c = objAccount.Bank_Name__c;
   		objGIExecutionTracker.Branch_Address__c = objAccount.Branch_details__c;
   		objGIExecutionTracker.Account_Type__c = objAccount.Bank_Account_Type__c;
   		objGIExecutionTracker.MICR_Code__c = objAccount.MICR_Number__c;
   		objGIExecutionTracker.IFSC_Code__c = objAccount.IFSC_Number__c; 
   		objGIExecutionTracker.Renewal_Date__c = objAccount.Renewal_Date__c;
		objGIExecutionTracker.ET_Status__c = 'Assigned to MET';
		objGIExecutionTracker.Send_Email__c = true;
		objGIExecutionTracker.Send_Email_Datetime__c = System.now();
		objGIExecutionTracker.Send_SMS__c = true;
		objGIExecutionTracker.Send_SMS_Datetime__c = System.now();
		//objGIExecutionTracker.Communication_Address__c = strAddress;
		
		isProductSelection = false;
		isETDetail = false;
		isCreate = true;
		getExecutionTracker();
	}
	
	public void editExecutionTracker()
	{
		isETDetail = false;
		isProductSelection = false;
		isCreate = false;
		objExecutionTracker = new Execution_Tracker__c ();
		objExecutionTracker = [Select Id, Name ,Type__c,Target_Revenue__c, Remarks__c, Goal__c, Goal__r.Goal_Type__c, Executed_Amount__c, Booked_Revenue__c, Agreed_Amount__c, Suggested_Amount__c  
								From Execution_Tracker__c 
								where Id =: ApexPages.currentPage().getParameters().get('etId') and Is_Floating__c = true];
	}
	
	public void updateExecutionTracker()
	{
		isETDetail = true;
		isProductSelection = true;
		isCreate = false;
		update objExecutionTracker;
		getExecutionTracker();
	}
	
	public void cancel()
	{
		isETDetail = true;
		isProductSelection = true;
		isCreate = false;
		objExecutionTracker = new Execution_Tracker__c ();
	}
	
	public void deleteExecutionTracker()
	{
		Execution_Tracker__c objET = [Select Id from Execution_Tracker__c where Id =: ApexPages.currentPage().getParameters().get('etId')];
		delete objET;
		getExecutionTracker();
	}
	
	public void saveExecutionTracker()
	{
		List<Workstation__c> lstWorkstation = [Select Member_Engagement__c, Member_Engagement__r.Name, Financial_Planner__c 
						   									 From Workstation__c 
						   									 where Financial_Planner__c = : objAccount.OwnerId or Member_Engagement__c =: objAccount.OwnerId];
		system.debug('-----lstWorkstation-----'+lstWorkstation);				   									 
		Map<Id,User> mapIdToUser = new Map<Id,User>([select Id,Name,ContactId , ManagerId, Email from User]);	
		Contact objContact;
		Account objBPAccount;
		List<Workstation__c> lstBPWorkstation = new List<Workstation__c>();
		if(mapIdToUser.containsKey(objAccount.OwnerId))
    	{
    		User objBPEntityOwnerUser = mapIdToUser.get(objAccount.OwnerId);
    		system.debug('*****objBPEntityOwnerUser*******'+objBPEntityOwnerUser);
            if(objBPEntityOwnerUser.ContactId != null)
            {
                //To fetch Contact of that particular BP User
                objContact=[select AccountId from Contact where id =: objBPEntityOwnerUser.ContactId];
                //To fetch Account with previously fetched Contact
                objBPAccount=[select Id, Email_ID__c, OwnerId, Channel_Manager__c,  Channel_Manager__r.Name,IsCreatedByPartner__c, Phone, Name from Account where id =: objContact.AccountId];    
            }
            if(objBPAccount != null)
            	lstBPWorkstation = [Select Member_Engagement__c, Member_Engagement__r.Name, Financial_Planner__c 
									From Workstation__c 
									where Financial_Planner__c = : objBPAccount.Channel_Manager__c];
    	}			   									 
		if(selectedProductType.equalsIgnoreCase('Life Insurance'))
		{  
			objLIExecutionTracker.Is_Floating__c = true;
			objLIExecutionTracker.Entity_Name__c = ApexPages.currentPage().getParameters().get('eid');
			objLIExecutionTracker.Type__c = selectedProductType;
			if(objAccount.Related_To__c == 'Business Partner')
			{
				if(lstBPWorkstation.isEmpty())
	   			{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Please add Partner Entity Channel Manager as Financial Planner in Workstation'));
		   			isCreate = true;
					isETDetail = false;
					isProductSelection = false;
		   		}
		   		else
		   		{							 
					objLIExecutionTracker.Owner__c = lstBPWorkstation[0].Member_Engagement__c;
					insert objLIExecutionTracker;
					isCreate = false;
					isETDetail = true;
					isProductSelection = true;
		   		}
			}
			else
			{
			   	if(lstWorkstation.isEmpty())
	   			{
					//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Please add Entity Owner as Financial Planner in Workstation'));
		   			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO ,Label.ET_Workstation_Exception));
		   			isCreate = true;
					isETDetail = false;
					isProductSelection = false;
		   		}
		   		else
		   		{							 
					objLIExecutionTracker.Owner__c = lstWorkstation[0].Member_Engagement__c;
					insert objLIExecutionTracker;
					isCreate = false;
					isETDetail = true;
					isProductSelection = true;
		   		}
			}
		}
		else if(selectedProductType.equalsIgnoreCase('General Insurance'))
		{
			objGIExecutionTracker.Is_Floating__c = true;
			objGIExecutionTracker.Entity_Name__c = ApexPages.currentPage().getParameters().get('eid');
			objGIExecutionTracker.Type__c = selectedProductType;
			if(objAccount.Related_To__c == 'Business Partner')
			{
				if(lstBPWorkstation.isEmpty())
	   			{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Please add Partner Entity Channel Manager as Financial Planner in Workstation'));
		   			isCreate = true;
					isETDetail = false;
					isProductSelection = false;
		   		}
		   		else
		   		{							 
					objGIExecutionTracker.Owner__c = lstBPWorkstation[0].Member_Engagement__c;
					insert objGIExecutionTracker;
					isCreate = false;
					isETDetail = true;
					isProductSelection = true;
		   		}
			}
			else
			{
			   	if(lstWorkstation.isEmpty())
	   			{
					//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Please add Entity Owner as Financial Planner in Workstation'));
		   			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO ,Label.ET_Workstation_Exception));
		   			isCreate = true;
					isETDetail = false;
					isProductSelection = false;
		   		}
		   		else
		   		{							 
					objGIExecutionTracker.Owner__c = lstWorkstation[0].Member_Engagement__c;
					insert objGIExecutionTracker;
					isCreate = false;
					isETDetail = true;
					isProductSelection = true;
		   		}
			}
			
		}
		else
		{
			objMFExecutionTracker.Is_Floating__c = true;
			objMFExecutionTracker.Entity_Name__c = ApexPages.currentPage().getParameters().get('eid');
			objMFExecutionTracker.Type__c = selectSIPorLumpsumType;
			if(objAccount.Related_To__c == 'Business Partner')
			{
				if(lstBPWorkstation.isEmpty())
	   			{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Please add Partner Entity Channel Manager as Financial Planner in Workstation'));
		   			isCreate = true;
					isETDetail = false;
					isProductSelection = false;
		   		}
		   		else
		   		{							 
					objMFExecutionTracker.Owner__c = lstBPWorkstation[0].Member_Engagement__c;
					insert objMFExecutionTracker;
					isCreate = false;
					isETDetail = true;
					isProductSelection = true;
		   		}
			}
			else
			{
			   	if(lstWorkstation.isEmpty())
	   			{
					//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Please add Entity Owner as Financial Planner in Workstation'));
		   			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO ,Label.ET_Workstation_Exception));
		   			isCreate = true;
					isETDetail = false;
					isProductSelection = false;
		   		}
		   		else
		   		{							 
					objMFExecutionTracker.Owner__c = lstWorkstation[0].Member_Engagement__c;
					insert objMFExecutionTracker;
					isCreate = false;
					isETDetail = true;
					isProductSelection = true;
		   		}
			}
		}
		getExecutionTracker();
	}
	
	 /**
    * @Description: Get family details for parent entity
    * param: None 
    * return type: List<selectOption>
    */ 
    public List<selectOption> getEntities()
    {
        List<selectOption> options = new List<selectOption>();
        List<Account> lstAllMembers = dbSOQLObj.getFamilyDetails(entityId);
        options.add(new selectOption('', '--None--'));
        for(Account acc: lstAllMembers) 
            options.add(new selectOption(acc.FirstName + ' '+ acc.LastName,acc.FirstName + ' '+ acc.LastName));
        return options;
    }
}