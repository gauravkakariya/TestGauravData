@isTest
private with sharing class OnEntityOwnerChangeTest 
{
	@isTest(seeAlldata=true)
    public static void testFamilyMemberOwnerChange()
    {
    	test.startTest();
    	TestData_Ffreedom tesstData = new TestData_Ffreedom();
     	//User partnerUser = tesstData.initBusinessUser();
    	//Account objBPAccount = tesstData.initBusinessAccount(partnerUser);
	    //insert objBPAccount;
	    //objBPAccount.Related_To__c = 'Business Partner';
	    //update objBPAccount;
        ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
        User userobj = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
                                    alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
                                    LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
                                    LastName = 'Test_Parent_Lname1' );

        insert userobj;
        Account PartnerAccount = tesstData.initVirtualAccount();
        insert PartnerAccount;
        List<Account> lstClientAcc = new List<Account>();
        
        Account objAccount = tesstData.initVirtualAccount(PartnerAccount);
        lstClientAcc.add(objAccount);
        Account objAccount1  = new Account(LastName='Test BP1',Adjustment_Factor__c='2', Virtual_Partner__c = PartnerAccount.Id,PAN_ID__pc='fghje4567L',
		                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463754621',
		                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',Email_Temp__c='ab1c@gmail.com',
		                       Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
		                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='wife', Related_To__c ='Virtual Partner', Plan_Generation_Date__c=system.today(),
		                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = false);
        lstClientAcc.add(objAccount1);
        insert lstClientAcc;
        
        Account child = tesstData.init_FamilyMember(objAccount);
	 	insert child;
	 	
	 	List<Lead> lstLead = new List<Lead>();
	 	Lead objLead = new Lead(FirstName='FirstName', LastName='LastName',
    							Occupation__c='Student',Location__c='Agra',
    							MobilePhone='9876543210', Street='S.V.Road',
    							City='Agra',PostalCode='400053',
    							State='MahaRashtra',Country='india',
    							Email='rupesh@gmail.com',Virtual_Partner__c = PartnerAccount.Id,
    							Company='TestCompany',Status='Open',LeadSource='Web');
    	lstLead.add(objLead);
    	
    	Lead objLead1 = new Lead(FirstName='FirstName', LastName='LastName',
    							Occupation__c='Student',Location__c='Agra',
    							MobilePhone='9876543210', Street='S.V.Road',
    							City='Agra',PostalCode='400053',
    							State='MahaRashtra',Country='india',
    							Email='rupesh@gmail.com',Virtual_Partner__c = PartnerAccount.Id,
    							Company='TestCompany',Status='Open',LeadSource='Web');
    	lstLead.add(objLead1);						
	 	insert lstLead;
	 	
	 	PartnerAccount.OwnerId = userobj.Id;
	 	PartnerAccount.Related_To__c = 'Ffreedom';
	 	update PartnerAccount;
	 	
	 	
	 	
 	  	test.stopTest();
    }

    @isTest(seeAlldata=true)
    public static void testOnEntityOwnerChange()
    {
        test.startTest();
        RecordType objRerecordType =[Select r.SobjectType, r.Name, r.IsActive From RecordType r where r.SobjectType =:'Account' and r.Name =:'Family Member' and r.IsActive =:True];
        List<Account> act = [select Id, PersonContactId from Account where Parent_Entity__c = null LIMIT 1];
        if(act.size() > 0)
        {
	        Account actChild = new Account();
	        actChild.Parent_Entity__c = act[0].Id;
	        actChild.FirstName ='Child';
	        actChild.LastName ='Entity';
	        if(objRerecordType != null)
	        {
	            actChild.RecordTypeId = objRerecordType.id;
	            insert actChild;
	            
	            ID ProfileID = [ Select id from Profile where name = 'System Administrator'].id;
	            List<User> u1 = [select Id from User where ProfileId =:ProfileID Limit 1];
	            User objuser;
	            if(u1 == null || u1.isEmpty())
	            {
	                objuser = new User( email='test-user@fakeemail.com',profileid = ProfileID, UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname' );
	                insert objuser;
	            }
	            else
	                objuser = u1[0];
	            act[0].OwnerId = objuser.id;
	            update act[0];
	            
	            //================= To chk user should be SysAdmin to change owner =============
	                         
	       /*     ID ProfId = [select Id from Profile where name = 'Customer Portal Standard - Custom'].Id;
	            List<User> usr = [select Id from User where ProfileId =:ProfId and IsActive = true Limit 1];
	            if(usr != null && usr.size()>0)
	            {
	           		system.runAs(usr[0])
	 				{
	 					if(u1 != null && u1.size() > 0)
	 					{
	 						Account objAccount = new Account();
						    objAccount.RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c; // Gaurav '01220000000DnK3';
						    objAccount.FirstName = 'TestFirst';
						    objAccount.LastName = 'TestLast';
						    objAccount.Entity_Status__c = 'Active';
						    objAccount.Agreement_Received__c = 'Yes';
						    
						   // Commented on 01Mar 2012 : because Cheque_Received_Date__c will be removed from Account object 
						    //objAccount.Cheque_Received_Date__c = Date.valueOf('2011-10-12 09:15:30');
						    
						    objAccount.Client_Category__c = 'Neutral';
						    objAccount.Description = 'Test entity description';
						    objAccount.Age__c = 25;
						    insert objAccount;
						    system.debug('*******objAccount****'+objAccount);
						    try
						    {
		            			objAccount.OwnerId = u1[0].id;
		            			update objAccount;
						    }
						    catch (Exception e)
						    {
								//System.assert(e.getMessage().contains(Label.ErrorMsgForEntityOwnerChange));
							}
	 					}
	 				}
	            }
            */
	        } 
        }
        test.stopTest();    
    }
    
}