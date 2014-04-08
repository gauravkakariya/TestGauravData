@isTest
public class Test_BatchEscalationMatrix {

    static testMethod void EscalationMatrixUnitTest()
    {
		//test.startTest();
		try{	
			String strIDs = '';
			List<UserRole> lstUserRole = [Select Name, Id From UserRole where NOT Name LIKE '%customer%' limit 1];
			List<Profile> lstProfile = [Select Name, Id From Profile];
			
			Map<String, EscalationLevels__c> mapEscalationLevels = EscalationLevels__c.getAll();
			Map<String, Id> mapRoleId = new Map<String, Id>();
			Map<String, Id> mapProfile = new Map<String, Id>();
			
			for(UserRole objRole : lstUserRole)
					mapRoleId.put(objRole.Name, objRole.Id);
			
			for(Profile objProfile : lstProfile)
					mapProfile.put(objProfile.Name, objProfile.Id);
			
			User objUserMgr =  createUser('Manager', 'Test', 'mgr', 'Test Manager', 'eternus@ffreedom.in', 'manager@ffreedom.in', 
										  mapProfile.get('Management'), mapRoleId.get('Mgr.-Financial Planning[GALAXY DELHI]'));
			Database.Saveresult MGRsaveResult = Database.insert(objUserMgr);
			/*
			for(Integer i=0; i<MGRsaveResult.size(); i++)
			{
				//System.debug('======== MGRsaveResult Email ==' + MGRsaveResult[0]);
			}
			//System.debug('======== MGRsaveResult Email ==' + MGRsaveResult + [select Id, Email from User where Id =: MGRsaveResult[0].getId()]);
			*/
			User objUserFA =  createUser('Financial', 'Advisor', 'FA', 'Financial Advisor', 'eternus@ffreedom.in', 'fa@ffreedom.in', 
										 mapProfile.get('Financial Planner'), mapRoleId.get('FPs [GALAXY DELHI]'));
			Database.Saveresult FAsaveResult = Database.insert(objUserFA);
			System.debug('======== FAsaveResult Email ==' + FAsaveResult.getId());
			//List<String> email = [select Id, Email from User where Id =: FAsaveResult.getId()];
			System.debug('======== FAsaveResult Email ==' + [select Id, Email from User where Id =: FAsaveResult.getId()]);
			
			User objUserMET =  createUser('Member', 'Engagement', 'meng', 'Test MET', 'eternus@ffreedom.in', 'membereng@ffreedom.in', 
										  mapProfile.get('Financial Planner'), mapRoleId.get('Head - Member Engagement'));
			Database.Saveresult METsaveResult = Database.insert(objUserMET);
			System.debug('======== METsaveResult Email ==' + METsaveResult);
									   
			User objUserFP =  createUser('Financial', 'Planner', 'fp', 'Test FP', 'eternus@ffreedom.in', 'finPlanner@ffreedom.in', 
										 mapProfile.get('Financial Planner'), mapRoleId.get('FPs [GALAXY DELHI]'));
			Database.Saveresult FPsaveResult = Database.insert(objUserFP);
			System.debug('======== FPsaveResult Email ==' + FPsaveResult);
			
			Id AdminId = [Select p.Name,p.Id From Profile p where p.Name ='System administrator' limit 1].Id;
			User objUserAdmin =  createUser('System admin', 'administrator', 'sadmin', 'Test Admin', 'tech@ffreedom.in', 'Testtech@ffreedom.in', 
										 AdminId, mapRoleId.get('FPs [GALAXY DELHI]'));
			
			System.runAs(objUserAdmin)
			{
	        	Id TechId = [select Id from User where name like 'Tech%' limit 1].Id; 
				
				Workstation__c objWorkstation = new Workstation__c(	Tech__c = TechId,
																	Member_Engagement__c = METsaveResult.getId(),
															   		Manager__c = MGRsaveResult.getId(),
															   		Financial_Planner__c = FPsaveResult.getId(),
															   		Advisory__c = FAsaveResult.getId());
				
				Database.Saveresult WSsaveResult = Database.insert(objWorkstation);
				System.debug('=== WSsaveResult : '+WSsaveResult);
				
				List<Account> lstAcc = New List<Account>();
	
				//Data Collection
				//		fName,lName, OwnerId, 	ChequeReceivedDate, DataCollectionDate, PlanWritingDate,PlanApprovedDate, ActionPlanGenerationDate, ExecutionCompletionDates)
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), null, null, null, null, null, 'mahesh.hirugade@eternussolutions.com'));
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), null, null, null, null, null, 'mahesh.hirugade@eternussolutions.com'));
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), null, null, null, null, null, 'mahesh.hirugade@eternussolutions.com'));


				//Data Collection
				//		fName,lName, OwnerId, 	ChequeReceivedDate, DataCollectionDate, PlanWritingDate,PlanApprovedDate, ActionPlanGenerationDate, ExecutionCompletionDates)
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today().addDays(16), null, null, null, null, 'mahesh.hirugade@eternussolutions.com'));
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today().addDays(21), null, null, null, null, 'mahesh.hirugade@eternussolutions.com'));
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today().addDays(26), null, null, null, null, 'mahesh.hirugade@eternussolutions.com'));
				
				//Plan Writing
				//		fName,lName, 						OwnerId, 	ChequeReceivedDate, DataCollectionDate, 		PlanWritingDate,			PlanApprovedDate, ActionPlanGenerationDate, ExecutionCompletionDates)
				/*lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today(), Date.today().addDays(8), null, null, null, 'mahesh.hirugade@eternussolutions.com'));
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today(), Date.today().addDays(11), null, null, null, 'mahesh.hirugade@eternussolutions.com'));
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today(), Date.today().addDays(14), null, null, null, 'mahesh.hirugade@eternussolutions.com'));
				*/
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today().addDays(-8), null, null, null, null, 'mahesh.hirugade@eternussolutions.com'));
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today().addDays(-11), null, null, null, null, 'mahesh.hirugade@eternussolutions.com'));
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today().addDays(-14), null, null, null, null, 'mahesh.hirugade@eternussolutions.com'));
				
				//Plan Approved									owner			 ChkReceived   DataCollection			 PlanWriting				PlanApproved	ActionPlanGenerationDate, ExecutionCompletionDates
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today().addDays(10), Date.today().addDays(-16), null, 			null, 						null, 'mahesh.hirugade@eternussolutions.com'));
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today().addDays(10), Date.today().addDays(-23), null, null, null, 'mahesh.hirugade@eternussolutions.com'));
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today().addDays(10), Date.today().addDays(-32), null, null, null, 'mahesh.hirugade@eternussolutions.com'));
				
				//Action Plan Generation fName,lName, 		OwnerId, 			ChequeReceived DataCollectionDate, 		PlanWriting,				PlanApprovedDate, 		ActionPlanGenerationDate, ExecutionCompletionDates)
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today().addDays(5), Date.today().addDays(10), Date.today().addDays(-4), null, null, 'mahesh.hirugade@eternussolutions.com'));
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today().addDays(5), Date.today().addDays(10), Date.today().addDays(-6), null, null, 'mahesh.hirugade@eternussolutions.com'));
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today().addDays(5), Date.today().addDays(10), Date.today().addDays(-11), null, null, 'mahesh.hirugade@eternussolutions.com'));
				
				// First Execution Complection Date
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today().addDays(10), Date.today().addDays(15), Date.today().addDays(20), Date.today().addDays(-11), null, 'mahesh.hirugade@eternussolutions.com'));
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today().addDays(10), Date.today().addDays(15), Date.today().addDays(20), Date.today().addDays(-21), null, 'mahesh.hirugade@eternussolutions.com'));
				lstAcc.add(createAccount('fName', 'lName', FPsaveResult.getId(), Date.today(), Date.today().addDays(10), Date.today().addDays(15), Date.today().addDays(20), Date.today().addDays(-31), null, 'mahesh.hirugade@eternussolutions.com'));
				
				List<Database.Saveresult> lstResult = Database.insert(lstAcc);

				for(Database.Saveresult objResult : lstResult)
				{
					strIDs += '\'' + objResult.getId() + '\' ,';
					system.debug('==== objResult');
				}
				system.debug('==== qyery###'+'Select OwnerId, Owner.Name, Owner.FirstName, Owner.Email, PersonContactId, CreatedDate, Plan__c, Email_Temp__c, Email_ID__c, ' + 
											 'Plan_Writing_Date__c, Plan_Approved_Date__c, Name, LastName, Id, FirstName, Execution_Completion_Dates__c, '+
											 'Data_Collection_Date__c, Action_Plan_Generation_Date__c, First_Execution_Completion_Date__c From Account  where Id IN ('+strIDs.subString(0, strIDs.length()-1) + ')');
	    	}
	    	/* Mahesh : 11 June 12*/
	    	Test.startTest();
			BatchEscalationMatrix objBatchEscalationMatrix = new BatchEscalationMatrix();
			objBatchEscalationMatrix.query = 'Select OwnerId, Owner.Name, Owner.FirstName, Owner.Email, PersonContactId, CreatedDate, Plan__c, Email_Temp__c, Email_ID__c, ' + 
											 'Plan_Writing_Date__c, Plan_Approved_Date__c, Name, LastName, Id, FirstName, Execution_Completion_Dates__c, '+
											 'Data_Collection_Date__c, Action_Plan_Generation_Date__c, First_Execution_Completion_Date__c, Stop_Escalation_Emails__c From Account where Id IN ('+strIDs.subString(0, strIDs.length()-1) + ')';
												
			Id batchprocessId = Database.executeBatch(objBatchEscalationMatrix,200);
			System.debug('batchprocessId=================>'+batchprocessId);
			Test.stopTest();
			/*
			Test.startTest();
			SchedulableContext SC;
			ScheduleEscalationMatrix oSchEscMatrix = new ScheduleEscalationMatrix();
			oSchEscMatrix.execute(SC);
			Test.stopTest();*/
		}
		catch(Exception e){
			System.debug('==== Exception : ' + e);
		}
		//test.stopTest();
	}
	
	private static User createUser(String fName, String lName, String alias, String cNickName, String email, String Username, Id profileID, Id roleId)
	{
		return new User(	FirstName = fName, LastName = lName, Alias = alias, Email = email, Username = Username, CommunityNickname = cNickName,
				    		UserRoleId = roleId, ProfileId = profileID, IsActive = true, TimeZoneSidKey = 'Asia/Calcutta',
							LocaleSidKey = 'en_GB', LanguageLocaleKey = 'en_US', EmailEncodingKey = 'ISO-8859-1');
	}
	
	private static Account createAccount(String fName, String lName, Id OwnerId, Date ChequeReceivedDate, Date DataCollectionDate, Date PlanWritingDate,
										 Date PlanApprovedDate, Date ActionPlanGenerationDate, Date ExecutionCompletionDates, String Email)
	{
		return new Account( FirstName = fName, LastName = lName, OwnerId = OwnerId, PersonLeadSource = 'Employee Referral', Agreement_Received__c= 'Yes', 
						   	PersonBirthdate = Date.newInstance(1990, 2, 1), Entity_Status__c='Active', CurrencyIsoCode= 'INR', Client_Category__c='WOW',
						   	Category_Description__c='Test client description', Data_Collection_Date__c = DataCollectionDate, Plan_Writing_Date__c = PlanWritingDate,
						   	Plan_Approved_Date__c = PlanApprovedDate, Action_Plan_Generation_Date__c = ActionPlanGenerationDate,
						   	Execution_Completion_Dates__c = ExecutionCompletionDates
						  );
	}
}