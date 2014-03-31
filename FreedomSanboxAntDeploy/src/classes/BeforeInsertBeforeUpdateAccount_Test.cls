/** 
Revision History:
 
*   Version     Version Author     Date         Comments
*   1.0         Manasi Ranade      19-06-2011   Created Following 3 Functions for testing BeforeInsertBeforeUpdateAccount
												1)insertTestDataForBirthDateNotNullCondition : 
													This will execute trigger's 1st condition.
												2)insertTestDataForNullBirthDateAndAgeNotNull :
													This will execute trigger's 2nd condition.
												3)insertTestDataForBirthDateAndAgeBothNull :
													
	2.0  		Prajakta Sanap     26/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/													

@isTest
private class BeforeInsertBeforeUpdateAccount_Test 
{
	static BeforeInsertBeforeUpdateAccount_Test objBeforeInsertBeforeUpdateAccount_Test;
	static List<User> standardUser;
	static Account objAccTest;
	static Account acc;
	static Id idAccount; 
	static List<Entity_Global_Assumption__c> objGlobalAssumptionList;
	static List<Goal__c> objGoalList;
	static Id goalId; 
    public static void insertTestDataForBirthDateNotNullCondition()
	{	
		/* Deployment : Prajakta Sanap */
		objAccTest = new Account(FirstName='Test_Fname1',LastName='Test_Lname'
								,Entity_Status__c='Active',PersonBirthdate = system.today().addYears(-25)); // Value of addYears is changed from -26 to -25 
		upsert objAccTest;
		system.debug('new account values-----------'+objAccTest);
		Integer iCurrentAge =Integer.valueOf([SELECT Current_Age__c FROM Account WHERE Id =: objAccTest.id][0].Current_Age__c);
		System.debug('**********iCurrentAge:'+iCurrentAge);
		idAccount = objAccTest.id;
	}
	
	//Test Date for BeforeInsertBeforeUpdateAccount trigger
	public static void insertTestDataForNullBirthDateAndAgeNotNull()
	{	
		objAccTest = new Account(FirstName='Test_Fname1',LastName='Test_Lname'
								,Entity_Status__c='Active',Current_Age__c = 26);
		upsert objAccTest;
		Integer iCurrentAge = Integer.valueOf([SELECT Current_Age__c FROM Account WHERE Id =: objAccTest.id][0].Current_Age__c);
		System.debug('**********iCurrentAge1:'+iCurrentAge);
		/* Deployment : Prajakta Sanap */
		idAccount = objAccTest.id;
	}
	
	//Test Date for BeforeInsertBeforeUpdateAccount trigger
	public static void insertTestDataForBirthDateAndAgeBothNull()
	{	
		objAccTest = new Account(FirstName='Test_Fname1',LastName='Test_Lname',Entity_Status__c='Active');
		upsert objAccTest;
		Integer iCurrentAge =Integer.valueOf([SELECT Current_Age__c FROM Account WHERE Id =: objAccTest.id][0].Current_Age__c);
		System.debug('**********iCurrentAge2:'+iCurrentAge);
		idAccount = objAccTest.id;
	}
	
	
	//Execute test classes for BeforeInsertBeforeUpdateAccount trigger 
	static testMethod void BeforeInsertBeforeUpdateAccountTest() 
    { 
    	 Test.startTest();
    	 insertTestDataForBirthDateNotNullCondition();
    	 insertTestDataForNullBirthDateAndAgeNotNull();
    	 insertTestDataForBirthDateAndAgeBothNull();
    	 Test.stopTest();
    }
    
	  //Need to comment below ===============================
	/* static testMethod void CopyLeadFields4 () 
    {
    	test.startTest();
    	Account partnerAcc,partnerAcc1;
	Contact con;
    	standardUser = [select Id from user where usertype = 'Standard' and Profile.Name like '%System Admin%' limit 1];
       System.runAs(standardUser[0])
       {
       		acc=new Account(LastName='ABC',FirstName='PQR',RecordTypeId=RecTypes__c.getInstance('AccountClient').Record_Type_Value__c); //Prajakta
	      	upsert acc;
	       
	       	partnerAcc=new Account(Name='Parner Account Test',RecordTypeId=RecTypes__c.getInstance('General_Business').Record_Type_Value__c);
	       	insert partnerAcc;
	       	con=new Contact(FirstName='Parner Contact Test', LastName='Contact',AccountId= partnerAcc.id);
	       	insert con;
	       	
	       	List<Account> lstAccInsert = new List<Account>();
	  	  	list<Lead> Leadlst = new list<Lead>();
	  	  	Lead_Platform_User__c objcustLead = new Lead_Platform_User__c(First_Name__c = 'Platform', Name = 'User', Lead_Status__c = 'Converted', Lead_Source__c = 'Web', Mobile__c = '9898989898', Age__c = 23);
	    	insert objcustLead;
	    	Lead Lead_1 = new Lead(FirstName = 'Original', LastName = 'Lead',Status = 'Open',LeadSource = 'Web'
	    					, MobilePhone = '9898989898', Age__c = 23 , Platform_User_Lead__c = objcustLead.Id);
	    	insert Lead_1;
	    	//Leadlst.add(Lead_1);
	    	//insert Leadlst;
	  		Id clientRecId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c;
	  		system.debug('LLLLLLLLLLLLLLLLLead_1.id:'+Lead_1.id);
			Account act11 = new Account(FirstName='ABC',LastName='XYZ',RecordTypeId=clientRecId, Referred_by_Lead__c = Lead_1.id);
       		lstAccInsert.add(act11);
       		
	        system.debug('==========partnerAcc1=========='+act11);	  	 	
	  	 	
	  	 	Account partnerAcc11=new Account(Name='Parner Account Test',RecordTypeId=RecTypes__c.getInstance('General_Business').Record_Type_Value__c);
	       	lstAccInsert.add(partnerAcc11);
	       	System.debug('Start===============>');
	       	insert lstAccInsert;
	       	System.debug('End===============>');
	       	system.debug('==========partnerAcc11=========='+partnerAcc11);
	  	    List<Account> acc1 = [select id,Logo__c, Email_ID__c, Company_Address__c, Phone, Name from Account where RecordTypeId = :RecTypes__c.getInstance('General_Business').Record_Type_Value__c];
	  	    list<Lead> Leadlst1 = new list<Lead>();
	    	Lead Lead_11 = new Lead(FirstName = 'Original', LastName = 'Lead',Status = 'Open',LeadSource = 'Web', MobilePhone = '9898989898', Age__c = 23,
	    	                        Virtual_Partner__c = acc1[0].id );//Need to comment below
	    	insert Lead_11;
	    	system.debug('==========Lead_11=========='+Lead_11);
	    	Leadlst1.add(Lead_11);
			
       }
    	
		List <UserRole> ur1 = [select Id from UserRole where   PortalType='Partner' limit 1];
  	   
  	    Profile prof = [select id 
                      from profile 
                     where usertype = 'PowerPartner'
                     limit 1];
  	    ID PartnerProfileID =prof.id;
  	    User u1;
  	    if(ur1!=null && ur1.size() > 0)
  	    {
	    	 u1 = new User(Workstations__c = 'All',userroleid=ur1[0].id,ContactId= con.id, email='test-user@fakeemail.com',ProfileId = PartnerProfileID,UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname' );
	       insert u1;
  	    }
  	    System.runAs(u1)
  	    {
  	   	 	Account PatnersClientAcc=new Account(LastName='Partners Client',FirstName='PQR',RecordTypeId=RecTypes__c.getInstance('AccountClient').Record_Type_Value__c); //Prajakta
	       	upsert PatnersClientAcc;
  	    }
   
    	/*Profile profi = [select id from profile where Name = 'Standard Platform User Custom' limit 1];
  	    ID PlatformProfileID = profi.id;
  	   
  	    User u12;
  	    {
    	    u12 = new User(Workstations__c = 'All', email='test1-user@fakeemail.com',ProfileId = PlatformProfileID,UserName='test1-user@fakeemail.com', alias='tuser11', CommunityNickName='tuser11',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test1_Parent_Fname', LastName = 'Test1_Parent_Lname' );
	        insert u12;
	        system.debug('==========u12=========='+u12);
  	    }
  	    System.runAs(u12)
	    {
	    	List<Account> accInsertList = new List<Account>();
	    	partnerAcc1=new Account(Name='Parner Account Test',RecordTypeId=RecTypes__c.getInstance('General_Business').Record_Type_Value__c);
	    	insert partnerAcc1;
	    	List<Lead_Platform_User__c> CustomLeadInsertList = new List<Lead_Platform_User__c>();
	    	Lead_Platform_User__c lead2 = new Lead_Platform_User__c(First_Name__c = 'Platform', Name = 'User', Lead_Status__c = 'Converted', Lead_Source__c = 'Web', Mobile__c = '9898989898', Age__c = 23);
	    	CustomLeadInsertList.add(lead2);
	    	
	    	//Need to comment below : acc
	  	 	List<Account> lstAcc = [select id,Logo__c, Email_ID__c, Company_Address__c, Phone, Name from Account where RecordTypeId = :RecTypes__c.getInstance('General_Business').Record_Type_Value__c]; 
	    	system.debug('WQWWWWWWWWWWWWWWW Acc:'+lstAcc);
	    	list<Lead_Platform_User__c> lstLeads = 	new list<Lead_Platform_User__c>();
	    	Lead_Platform_User__c lead1 = new Lead_Platform_User__c(Virtual_Partner__c = lstAcc[0].id,/*Need to comment below First_Name__c = 'Platform', Name = 'User', Lead_Status__c = 'Converted', Lead_Source__c = 'Web', Mobile__c = '9898989898', Age__c = 23);
	    	CustomLeadInsertList.add(lead1);
	    	system.debug('WQWWWWWWWWWWWWWWW lead1:'+lead1);
	    	insert CustomLeadInsertList;
	  	 	
	  	 	Id clientRecId=RecTypes__c.getInstance('AccountClient').Record_Type_Value__c;
			Account act = new Account(FirstName='ABC',LastName='XYZ',RecordTypeId=clientRecId, Referred_by_CustomLead__c = lead2.id);
       		accInsertList.add(act);
		
	  		insert accInsertList;
	  	}
	  		
	    test.stopTest();
    }*/
    
	 //=====================================================
}