/*
	Revision History:
	
    Version     Version Author     Date           Comments
    1.0			Anupam/Aditi	   28/12/12		 Test Class for Executon Tracker Trigger Handler.
*/


public class Test_ExecutionTrackerHandler 
{
	@isTest(SeeAllData=true)
	public static  void testExecutionTrackerHandler()
	{
		ID profileID = [Select id from Profile where name = 'Financial Planner'].id;
      	User objUser = new User(email='test-user@fakeemail1.com', profileid = profileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
        insert objUser;
        
        //Profile objBPProfile = [select id  from Profile where UserType = 'PowerPartner' limit 1];
        //User partnerUser = [select Id,ContactId from User where profileid =: objBPProfile.id and IsActive = true limit 1];
        //Contact objContact;
        //Account objPartnerAccount;
        /*if(partnerUser.ContactId != null)
        {
        	objContact = [select AccountId from Contact where id =: partnerUser.ContactId];
			objPartnerAccount = [select Id, Name, Channel_Manager__c from Account where id =: objContact.AccountId];
        }*/
        
        
        Profile prof = [select id  from profile where usertype = 'PowerPartner' limit 1];
        RecordType objRT_General = [Select Id from RecordType where Name = 'General' and SobjectType = 'Account'];
		Account objPartnerAccount = new Account(Name='Test',Expected_Return_on_Investment__c=10,Equity__c=10,Gold__c=10,Debt__c=10,
									Income_Growth_Rate__c=10,Inflation_Rate__c=10,Default_Estimated_Life_Expectancy__c='58',Number_Of_Months__c=10,
									Gold_Growth_Rate__c=10,	Stock_Growth_Rate__c=10,Default_Retirement_Age__c='60', 
									RecordTypeId = objRT_General.Id,Related_To__c ='Business Partner');
	    insert objPartnerAccount;
        Contact objContact = new Contact(FirstName='Parner Contact Test', 
    									LastName='Contact',
    									AccountId= objPartnerAccount.id);
    	insert objContact;
        
        User partnerUser = new User(email='partner-user@fakeemail1.com', profileid = prof.Id, UserName='test-userPartner@fakeemail1.com', 
                                    alias='tuser12', CommunityNickName='tuser12',TimeZoneSidKey='America/New_York', ContactId = objContact.Id,
                                    LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Partner_Fname1',
                                    LastName = 'Test_Partner_Lname1' );
        insert partnerUser;
        
        
        
		RecordType objRT = [Select Id from RecordType where Name = 'Client' and SobjectType = 'Account'];
		
		//Insert Account Records
		List<Account> lstAccount = new List<Account>();
		Account objAccount = new Account(LastName='Test',FirstName='Test',Adjustment_Factor__c='2',OwnerId = objUser.Id,
	                       PersonTitle='TestData', PersonBirthdate= system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463713234',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034, Residential_Status_del__c='own', Retirement_Age__c='58', Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041, Relationship_to_Entity__pc='husband', RecordTypeId = objRT.Id);
	    lstAccount.add(objAccount);
	    
	    Account objAccount1 = new Account(LastName='Test',FirstName='Test',Adjustment_Factor__c='2',OwnerId = objUser.Id,
	                       PersonTitle='TestData', PersonBirthdate= system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034, Residential_Status_del__c='own', Retirement_Age__c='58', Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041, Relationship_to_Entity__pc='husband', RecordTypeId = objRT.Id);
	    lstAccount.add(objAccount1);
	    
    	Account objBPAccount = new Account(LastName='Test BP',Adjustment_Factor__c='2', OwnerId = partnerUser.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463723467',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Business Partner',
	                       RecordTypeId = objRT.Id);
	    lstAccount.add(objBPAccount);
	    insert lstAccount;
	    
	    
	    objBPAccount.Related_To__c = 'Business Partner';
	    update objBPAccount;
	    
	    Investment_Asset__c invest = new Investment_Asset__c(Entity__c=objAccount.id, Scheme_Name_Text__c='Kotak',Monthly_SIP_Amount__c=10000, 
      														RecordTypeId=InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c,
      														Asset_Type__c='Equity - Diversified',Action__c='Hold - Change of broker');
        insert invest;
      	List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
		Approve_Action_Plan__c AppActionLumpsum = new Approve_Action_Plan__c(Transaction_Type__c='New Sip', Remarks__c='test SIP',Account__c=objAccount.id,
															Investment_Asset__c = invest.id,
				     										Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40,
				     										Category__c='Equity',isExecutionTracker__c =true);
		lstApproveActionPlan.add(AppActionLumpsum);
		
		
		Approve_Action_Plan__c AppActionGeneral = new Approve_Action_Plan__c (Transaction_Type__c='New Sip', Remarks__c='test SIP',Account__c=objAccount.id,
     										Amount__c=10000,Fund__c='HDFC Top 200 Fund',Amount_Per_Installment__c=400,Option__c='Growth',Installments__c=40, Item_Type__c = 'General Insurance',
     										Category__c='Equity');
		lstApproveActionPlan.add(AppActionGeneral);
		
		insert lstApproveActionPlan;
		
		ID ProfileID1 = [ Select id from Profile where name = 'Financial Planner'].id;
      	User userobj = new User(email='test-user@fakeemail11.com', profileid = ProfileID1, UserName='test-user@fakeemail11.com', 
      	 							alias='tuser111', CommunityNickName='tuser11',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname11',
      	 						    LastName = 'Test_Parent_Lname11' );

        insert userobj;
        
		//Operations User
      	User objOpsTeamUser = new User( email='test-user@fakeemail.com', profileid = profileID1, UserName='operationuser@fakeemail.com', 
      	 							alias='opsuser1', CommunityNickName='opsuser',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'OpsFirstName',
      	 						    LastName = 'OpsLastName' );
        insert objOpsTeamUser;
      	
      	Workstation__c objWorkstation = new Workstation__c(Member_Engagement__c = objAccount.OwnerId,
															   		Financial_Planner__c = objAccount.OwnerId,
															   		Operations__c = objOpsTeamUser.Id);
		insert objWorkstation;
		
		Workstation__c objBPWorkstation = new Workstation__c(Member_Engagement__c = objBPAccount.OwnerId,
															   		Financial_Planner__c = objPartnerAccount.Channel_Manager__c,
															   		Operations__c = objOpsTeamUser.Id);
		insert objBPWorkstation;
		
		system.debug('*********objBPWorkstation.Operations__c**********'+objBPWorkstation.Operations__c);
		
		
		//Execution Tracker Records Assigned to Operations
      	List<Execution_Tracker__c> lstETrecs = new List<Execution_Tracker__c>();
      	List<Execution_Tracker__c> lstNewETrecs = new List<Execution_Tracker__c>();
      	Execution_Tracker__c objMET3 = new Execution_Tracker__c(Approve_Action_Plan__c = AppActionGeneral.id, Agreed_Amount__c=100, Application_Status__c='Opened',
      																Owner__c = objOpsTeamUser.Id, Entity_Name__c = objAccount.Id, Type__c='General Isurance', 
      																ET_Status__c='Assigned to Operations');
      	lstETrecs.add(objMET3);
      	Execution_Tracker__c objnewMET3 = new Execution_Tracker__c(Approve_Action_Plan__c = AppActionGeneral.id, Agreed_Amount__c=200, 
      																Owner__c = objOpsTeamUser.Id, Entity_Name__c = objAccount.Id, Type__c='General Isurance', 
      																ET_Status__c='Assigned to Operations',Application_Status__c = 'Opened');
      	lstNewETrecs.add(objnewMET3);
      	
      	
      	Execution_Tracker__c objMET4 = new Execution_Tracker__c(Approve_Action_Plan__c = AppActionGeneral.id, Agreed_Amount__c=100, Application_Status__c='',
      																Owner__c = objOpsTeamUser.Id, Entity_Name__c=objAccount.Id, Type__c='General Isurance', 
      																ET_Status__c='Assigned to MET');
      	lstETrecs.add(objMET4);
      	Execution_Tracker__c objnewMET4 = new Execution_Tracker__c(Approve_Action_Plan__c = AppActionGeneral.id, Agreed_Amount__c=200, 
      																Owner__c = objOpsTeamUser.Id, Entity_Name__c = objAccount.Id, Type__c='General Isurance', 
      																ET_Status__c='Assigned to Operations',Application_Status__c = 'Opened');
      	lstNewETrecs.add(objnewMET4);
      	
      	
      	Execution_Tracker__c objMET5 = new Execution_Tracker__c(Approve_Action_Plan__c = AppActionGeneral.id, Agreed_Amount__c = 100, Application_Status__c = '',
      																Owner__c = objOpsTeamUser.Id, Entity_Name__c = objAccount1.Id, Type__c='General Isurance', 
      																ET_Status__c='Assigned to MET');
      	lstETrecs.add(objMET5);
      	Execution_Tracker__c objnewMET5 = new Execution_Tracker__c(Approve_Action_Plan__c = AppActionGeneral.id, Agreed_Amount__c=200, 
      																Owner__c = objOpsTeamUser.Id, Entity_Name__c = objAccount.Id, Type__c='General Isurance', 
      																ET_Status__c='Assigned to Operations',Application_Status__c = 'Opened');
      	lstNewETrecs.add(objnewMET5);
      	
      	
      	
  		//Execution Tracker Records Assigned to MET. Business Partner ET records
      	Execution_Tracker__c objBPMET1 = new Execution_Tracker__c(Approve_Action_Plan__c=AppActionLumpsum.id, Agreed_Amount__c=100,Application_Status__c='Opened',
  																	Owner__c = objOpsTeamUser.Id,Entity_Name__c=objBPAccount.Id,Type__c='Lumpsum',
  																	ET_Status__c='Assigned to Operations');
      	lstETrecs.add(objBPMET1);
      	Execution_Tracker__c objnewBPMET1 = new Execution_Tracker__c(Approve_Action_Plan__c = AppActionLumpsum.id, Agreed_Amount__c=200,
      																Owner__c = objOpsTeamUser.Id, Entity_Name__c = objBPAccount.Id, Type__c='Lumpsum', 
      																ET_Status__c='Assigned to Operations',Application_Status__c = 'Opened');
      	lstNewETrecs.add(objnewBPMET1);

      	//General Insurance
      	Execution_Tracker__c objBPMET3 = new Execution_Tracker__c(Approve_Action_Plan__c=AppActionGeneral.id, Agreed_Amount__c = 100,Application_Status__c='',
      																Owner__c = objOpsTeamUser.Id, Entity_Name__c=objBPAccount.Id,Type__c = 'General Isurance',
      																ET_Status__c='Assigned to MET');
      	lstETrecs.add(objBPMET3);
      	Execution_Tracker__c objnewBPMET3 = new Execution_Tracker__c(Approve_Action_Plan__c = AppActionGeneral.id, Agreed_Amount__c=200,
      																Owner__c = objOpsTeamUser.Id, Entity_Name__c = objBPAccount.Id, Type__c='General Isurance', 
      																ET_Status__c='Assigned to Operations',Application_Status__c = 'Opened');
      	lstNewETrecs.add(objnewBPMET3);
      	
      	
      	
      	Execution_Tracker__c objBPMET4 = new Execution_Tracker__c(Approve_Action_Plan__c=AppActionGeneral.id, Agreed_Amount__c = 100,Application_Status__c='',
      																Owner__c = objOpsTeamUser.Id, Entity_Name__c=objBPAccount.Id,Type__c='General Isurance',
      																ET_Status__c='Assigned to MET');
      	lstETrecs.add(objBPMET4);
      	Execution_Tracker__c objnewBPMET4 = new Execution_Tracker__c(Approve_Action_Plan__c = AppActionGeneral.id, Agreed_Amount__c=200,
      																Owner__c = objOpsTeamUser.Id, Entity_Name__c = objBPAccount.Id, Type__c='General Isurance', 
      																ET_Status__c='Assigned to Operations',Application_Status__c = 'Opened');
      	lstNewETrecs.add(objnewBPMET4);

		insert lstETrecs;
		insert lstNewETrecs;
		
		
		ExecutionTrackerHandler objExecutionTrackerHandler = new ExecutionTrackerHandler();
		objExecutionTrackerHandler.onBeforeUpdate(lstNewETrecs,lstETrecs);
		//objExecutionTrackerHandler.onAfterUpdate(lstNewETrecs,lstETrecs);
		
		//Update check 
	/*	List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
		List<Execution_Tracker__c> lstOldET = new List<Execution_Tracker__c>();
		//for Business Partner Entity
		lstOldET.add(objBPMET1);
		objBPMET1.Agreed_Amount__c = 50;
		objBPMET1.ET_Status__c = 'Assigned to Operations';
		objBPMET1.Application_Status__c = 'Opened';
		lstET.add(objBPMET1);
		System.debug('------------------------New-----'+lstET);
		System.debug('------------------------Old-----'+lstOldET);
		
		objBPMET3.Agreed_Amount__c = 50;
		objBPMET3.ET_Status__c = 'Assigned to Operations';
		objBPMET3.Application_Status__c = 'Opened';
		lstET.add(objBPMET3);
		
		objBPMET4.Agreed_Amount__c = 50;
		objBPMET4.ET_Status__c = 'Assigned to Operations';
		objBPMET4.Application_Status__c = 'Opened';
		lstET.add(objBPMET4);
		
		//for Ffreedom Entity
		objMET3.Agreed_Amount__c = 50;
		objMET3.ET_Status__c = 'Assigned to Operations';
		objMET3.Application_Status__c = 'Opened';
		lstET.add(objMET3);
		
		objMET4.Agreed_Amount__c = 50;
		objMET4.ET_Status__c = 'Assigned to Operations';
		objMET4.Application_Status__c = 'Opened';
		lstET.add(objMET4);
		
		objMET5.Agreed_Amount__c = 50;
		objMET5.ET_Status__c = 'Assigned to Operations';
		objMET5.Application_Status__c = 'Opened';
		lstET.add(objMET5);
		
		//update lstET;
		
		lstET = new List<Execution_Tracker__c>();
		//for Business Partner Entity
		objBPMET1.Agreed_Amount__c = 20;
		lstET.add(objBPMET1);
		
		objBPMET3.Agreed_Amount__c = 20;
		lstET.add(objBPMET3);
		
		objBPMET4.Agreed_Amount__c = 20;
		lstET.add(objBPMET4);
		
		//for Ffreedom Entity
		objMET3.Agreed_Amount__c = 20;
		lstET.add(objMET3);
		
		objMET4.Agreed_Amount__c = 20;
		lstET.add(objMET4);
		
		objMET5.Agreed_Amount__c = 20;
		lstET.add(objMET5);
		
		//update lstET;*/
	
		
	}
}