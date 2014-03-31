@isTest
private class Test_ClientPointsCalculator {
	static testMethod void ClientPointsCalculatorTest()
	{
			Test.startTest();
			User u = [select Id,Name from User where Name ='Bharti Punjabi'];
			List<Account> accounts =new List<Account>();
			Date CheckReceiveddate = date.today().addDays(-3);
			Date planAppDate = date.today().addDays(-10);
			ID accOwnerId = u.Id;
			
			/* Commented statements on 05Mar 2012 : because Cheque_Received_Date__c,Amount_Received__c,Amount_2nd_Installment__c will be removed from Account object */
			//Account act1 = new Account(FirstName='Test_Fname1',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='Web', Cheque_Received_Date__c=CheckReceiveddate,Category_Description__c='Test Description',Amount_Received__c=10000,Agreement_Received__c='Yes',Client_Category__c='Neutral',OwnerId = accOwnerId,Plan_Approved_Date__c=planAppDate,Plan_Writing_Date__c=planAppDate-10,Data_Collection_Date__c=planAppDate-12);//Plan_Presented_Date__c=planAppDate-1,
			Account act1 = new Account(FirstName='Test_Fname1',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='Web', 
								Category_Description__c='Test Description',Agreement_Received__c='Yes',Client_Category__c='Neutral',
								OwnerId = accOwnerId,Plan_Approved_Date__c=planAppDate+13,Plan_Writing_Date__c=planAppDate+12,
								Action_Plan_Generation_Date__c = planAppDate+14,
								Data_Collection_Date__c=planAppDate+11);
			//Plan_Presented_Date__c=planAppDate-1,Cheque_Received_Date__c=CheckReceiveddate,Amount_Received__c=10000,
			accounts.add(act1);
			
			//Account act2 = new Account(FirstName='Test_Fname2',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='Corp Comm',Cheque_Received_Date__c=CheckReceiveddate,Category_Description__c='Test Description',Amount_Received__c=10000,Agreement_Received__c='Yes',Client_Category__c='Neutral',OwnerId = accOwnerId,Plan_Approved_Date__c=planAppDate,Plan_Writing_Date__c=planAppDate-10,Data_Collection_Date__c=planAppDate-12);//Plan_Presented_Date__c=planAppDate-1,
			Account act2 = new Account(FirstName='Test_Fname2',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='Corp Comm'
							,Category_Description__c='Test Description',Agreement_Received__c='Yes',Client_Category__c='Neutral',
							OwnerId = accOwnerId,Plan_Approved_Date__c=planAppDate+13,Plan_Writing_Date__c=planAppDate+12,
							Data_Collection_Date__c=planAppDate+11,Action_Plan_Generation_Date__c = planAppDate+14);
			//Plan_Presented_Date__c=planAppDate-1,Cheque_Received_Date__c=CheckReceiveddate,Amount_Received__c=10000,
			accounts.add(act2);
			
			//Account act3 = new Account(FirstName='Test_Fname3',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='Employee Referal',Cheque_Received_Date__c=CheckReceiveddate,Category_Description__c='Test Description',Amount_Received__c=10000,Agreement_Received__c='Yes',Client_Category__c='Neutral',OwnerId = accOwnerId,Plan_Approved_Date__c=planAppDate,Plan_Writing_Date__c=planAppDate-10,Data_Collection_Date__c=planAppDate-12);//Plan_Presented_Date__c=planAppDate-1,
			Account act3 = new Account(FirstName='Test_Fname3',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='Employee Referal',
						Category_Description__c='Test Description',Agreement_Received__c='Yes',Client_Category__c='Neutral',
						OwnerId = accOwnerId,Plan_Approved_Date__c=planAppDate+13,Plan_Writing_Date__c=planAppDate+12,
						Data_Collection_Date__c=planAppDate+11,Action_Plan_Generation_Date__c = planAppDate+14);
			//Plan_Presented_Date__c=planAppDate-1,Cheque_Received_Date__c=CheckReceiveddate,Amount_Received__c=10000,
			accounts.add(act3);
			
			//Account act4 = new Account(FirstName='Test_Fname4',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='Lead Engines',Cheque_Received_Date__c=CheckReceiveddate,Category_Description__c='Test Description',Amount_Received__c=10000,Agreement_Received__c='Yes',Client_Category__c='Neutral',OwnerId = accOwnerId,Plan_Approved_Date__c=planAppDate,Plan_Writing_Date__c=planAppDate-10,Data_Collection_Date__c=planAppDate-12);//Plan_Presented_Date__c=planAppDate-1,
			Account act4 = new Account(FirstName='Test_Fname4',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='Lead Engines',
							Cheque_Received_Date__c=CheckReceiveddate,Category_Description__c='Test Description',Agreement_Received__c='Yes',
							Client_Category__c='Neutral',OwnerId = accOwnerId,Plan_Approved_Date__c=planAppDate+13,Plan_Writing_Date__c=planAppDate+12,
							Data_Collection_Date__c=planAppDate+11,Action_Plan_Generation_Date__c = planAppDate+14);
			//Plan_Presented_Date__c=planAppDate-1,Cheque_Received_Date__c=CheckReceiveddate,Amount_Received__c=10000,
			accounts.add(act4);
			
			//Account act5 = new Account(FirstName='Test_Fname5',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='NDC',Cheque_Received_Date__c=CheckReceiveddate,Category_Description__c='Test Description',Amount_Received__c=10000,Amount_2nd_Installment__c=5000,Agreement_Received__c='Yes',Client_Category__c='Neutral',OwnerId = accOwnerId,Plan_Approved_Date__c=planAppDate,Plan_Writing_Date__c=planAppDate-10,Data_Collection_Date__c=planAppDate-12);//Plan_Presented_Date__c=planAppDate-1,
			Account act5 = new Account(FirstName='Test_Fname5',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='NDC',
							Category_Description__c='Test Description',Agreement_Received__c='Yes',Client_Category__c='Neutral',
							OwnerId = accOwnerId,Plan_Approved_Date__c=planAppDate+13,Plan_Writing_Date__c=planAppDate+12,
							Data_Collection_Date__c=planAppDate+11,Action_Plan_Generation_Date__c = planAppDate+14);
			//Plan_Presented_Date__c=planAppDate-1,Cheque_Received_Date__c=CheckReceiveddate,Amount_Received__c=10000,Amount_2nd_Installment__c=5000,
			accounts.add(act5);
			
			//Account act6 = new Account(FirstName='Test_Fname6',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='Seminar MKT',Cheque_Received_Date__c=CheckReceiveddate,Category_Description__c='Test Description',Amount_Received__c=10000,Amount_2nd_Installment__c=5000,Agreement_Received__c='Yes',Client_Category__c='Neutral',OwnerId = accOwnerId,Plan_Approved_Date__c=planAppDate,Plan_Writing_Date__c=planAppDate-10,Data_Collection_Date__c=planAppDate-12);//Plan_Presented_Date__c=planAppDate-1,
			Account act6 = new Account(FirstName='Test_Fname6',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='Seminar MKT',
							Category_Description__c='Test Description',Agreement_Received__c='Yes',Client_Category__c='Neutral',
							OwnerId = accOwnerId,Plan_Approved_Date__c=planAppDate+13,Plan_Writing_Date__c=planAppDate+12,
							Data_Collection_Date__c=planAppDate+11,Action_Plan_Generation_Date__c = planAppDate+14);
			//Plan_Presented_Date__c=planAppDate-1,Cheque_Received_Date__c=CheckReceiveddate,Amount_Received__c=10000,Amount_2nd_Installment__c=5000,
			accounts.add(act6);
			
			//Account act7 = new Account(FirstName='Test_Fname7',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='Seminar WS',Cheque_Received_Date__c=CheckReceiveddate,Category_Description__c='Test Description', Cheque_Received_Date_2__c=CheckReceiveddate, Amount_Received__c=10000,Amount_2nd_Installment__c=5000,Agreement_Received__c='Yes',Client_Category__c='Neutral',OwnerId = accOwnerId,Plan_Approved_Date__c=planAppDate,Plan_Writing_Date__c=planAppDate-10,Data_Collection_Date__c=planAppDate-12);//Plan_Presented_Date__c=planAppDate-1,
			Account act7 = new Account(FirstName='Test_Fname7',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='Seminar WS',
							Category_Description__c='Test Description', Agreement_Received__c='Yes',Client_Category__c='Neutral',
							OwnerId = accOwnerId,Plan_Approved_Date__c=planAppDate+13,Plan_Writing_Date__c=planAppDate+12,
							Data_Collection_Date__c=planAppDate+11,Action_Plan_Generation_Date__c = planAppDate+14);
			//Plan_Presented_Date__c=planAppDate-1,Cheque_Received_Date__c=CheckReceiveddate,Cheque_Received_Date_2__c=CheckReceiveddate, Amount_Received__c=10000,Amount_2nd_Installment__c=5000,
			accounts.add(act7);
			
	        //Account act8 = new Account(FirstName='Test_Fname8',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='Database',Cheque_Received_Date__c=CheckReceiveddate,Category_Description__c='Test Description',Amount_2nd_Installment__c=5000,Agreement_Received__c='Yes',Client_Category__c='Neutral',OwnerId = accOwnerId);
	        Account act8 = new Account(FirstName='Test_Fname8',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='Database',
	        				Category_Description__c='Test Description',Agreement_Received__c='Yes',Client_Category__c='Neutral',
	        				OwnerId = accOwnerId,Action_Plan_Generation_Date__c = planAppDate+14);
	        //Cheque_Received_Date__c=CheckReceiveddate,Amount_2nd_Installment__c=5000,
	        accounts.add(act8);
	        
	        //Account act9 = new Account(FirstName='Test_Fname9',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='FP Referal',Cheque_Received_Date__c=CheckReceiveddate,Category_Description__c='Test Description',Amount_2nd_Installment__c=5000,Agreement_Received__c='Yes',Client_Category__c='Neutral',OwnerId = accOwnerId);
	        Account act9 = new Account(FirstName='Test_Fname9',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='FP Referal',
	        				Category_Description__c='Test Description',Agreement_Received__c='Yes',Client_Category__c='Neutral',
	        				OwnerId = accOwnerId,Action_Plan_Generation_Date__c = planAppDate+14);
	        //Cheque_Received_Date__c=CheckReceiveddate,Amount_2nd_Installment__c=5000,
	        //Account act10 = new Account(FirstName='Test_Fname10',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='Lead Referal',Cheque_Received_Date__c=CheckReceiveddate,Category_Description__c='Test Description',Amount_Received__c=10000,Amount_2nd_Installment__c=5000,Agreement_Received__c='Yes',Client_Category__c='Neutral',OwnerId = accOwnerId);
	        Account act10 = new Account(FirstName='Test_Fname10',LastName='Test_Lname',Entity_Status__c='Active',PersonLeadSource='Lead Referal',
	        				Category_Description__c='Test Description',Agreement_Received__c='Yes',Client_Category__c='Neutral',
	        				OwnerId = accOwnerId,Action_Plan_Generation_Date__c = planAppDate+14);
	        //Cheque_Received_Date__c=CheckReceiveddate,Amount_Received__c=10000,Amount_2nd_Installment__c=5000,
	      	accounts.add(act9);
	      	accounts.add(act10);
	      	insert accounts;
	      		      
	      List<Execution_Tracker__c>lstExcution = new   List<Execution_Tracker__c>();
	      Execution_Tracker__c objExe1 = new Execution_Tracker__c(Entity_Name__c= act1.Id,Completion_Date__c=planAppDate,Original_Target_Date__c=planAppDate-1,Opportunity_Name__c='Investments',Target_Revenue__c=5000);
	      lstExcution.add(objExe1);
	      Execution_Tracker__c objExe2 = new Execution_Tracker__c(Entity_Name__c= act1.Id,Completion_Date__c=planAppDate,Original_Target_Date__c=planAppDate-1,Opportunity_Name__c='LifeInsurance',Target_Revenue__c=5000);
	      lstExcution.add(objExe2);
	      Execution_Tracker__c objExe3 = new Execution_Tracker__c(Entity_Name__c= act1.Id,Completion_Date__c=planAppDate,Original_Target_Date__c=planAppDate-1,Opportunity_Name__c='SIP',Target_Revenue__c=5000);
	      lstExcution.add(objExe3);
	      Execution_Tracker__c objExe4 = new Execution_Tracker__c(Entity_Name__c= act1.Id,Completion_Date__c=planAppDate,Original_Target_Date__c=planAppDate-1,Opportunity_Name__c='Real Estate',Target_Revenue__c=5000);
	      lstExcution.add(objExe4);
	       
	      Execution_Tracker__c objExe5 = new Execution_Tracker__c(Entity_Name__c= act2.Id,Completion_Date__c=planAppDate,Original_Target_Date__c=planAppDate-1,Opportunity_Name__c='Investments',Target_Revenue__c=5000);
	      lstExcution.add(objExe5);
	      Execution_Tracker__c objExe6 = new Execution_Tracker__c(Entity_Name__c= act2.Id,Completion_Date__c=planAppDate,Original_Target_Date__c=planAppDate-1,Opportunity_Name__c='LifeInsurance',Target_Revenue__c=5000);
	      lstExcution.add(objExe6);
	      Execution_Tracker__c objExe7 = new Execution_Tracker__c(Entity_Name__c= act2.Id,Completion_Date__c=planAppDate,Original_Target_Date__c=planAppDate-1,Opportunity_Name__c='SIP',Target_Revenue__c=5000);
	      lstExcution.add(objExe7);
	      Execution_Tracker__c objExe8 = new Execution_Tracker__c(Entity_Name__c= act2.Id,Completion_Date__c=planAppDate,Original_Target_Date__c=planAppDate-1,Opportunity_Name__c='Real Estate',Target_Revenue__c=5000);
	      lstExcution.add(objExe8);
	      insert(lstExcution);
	      
			ClientPointsCalculator objClientPointsCal = new ClientPointsCalculator();
			objClientPointsCal.setStartDate('01/01/2009');
	        objClientPointsCal.setEndDate('11/11/2011');
	        Map<String,FP_Roles__c> userRoleMapOfPlanner = FP_Roles__c.getAll();
	        set<ID> idSetofPlanner = new set<ID>();
			if(userRoleMapOfPlanner.size() > 0)
			{
				for(String strName :userRoleMapOfPlanner.keySet())
				{
					//if(strName !='Mgr[GALAXY DELHI]'&& strName!= 'Mgr[GALAXY MUMBAI 1]'&& strName!='Mgr[GALAXY MUMBAI II ]')
						FP_Roles__c objPlanner = userRoleMapOfPlanner.get(strName);
						idSetofPlanner.add(objPlanner.Id__c);
				}
			}
			
	        //UserRole ur = [select Id, Name from UserRole where Name = 'Fps[AMETHYST MUMBAI]'];
	        Map<ID,String> mapIdList = new Map<ID,String>();
	        List<User> lstUser = [Select Id,Name,UserRoleId from User where UserRoleId IN :idSetofPlanner];
	        for(User objUser : lstUser){
	        	mapIdList.put(objUser.Id, objUser.Name);
	        }
	        
	        objClientPointsCal.idList = mapIdList; 
	        
	        System.assertEquals('01/01/2009', objClientPointsCal.getStartDate());
	        System.assertEquals('11/11/2011', objClientPointsCal.getEndDate());
			objClientPointsCal.getEntityNonReferralPointsPerWS();
			objClientPointsCal.getChildDetailsPointList();
			objClientPointsCal.calculatePoints();
			
	Test.stopTest();
	}
}