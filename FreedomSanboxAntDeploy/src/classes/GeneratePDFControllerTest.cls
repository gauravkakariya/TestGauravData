/*
	Revision History:
	Version     Version Author     Date        Comments

	2.0  		Prajakta Sanap     19/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.											
*/

@isTest
private class GeneratePDFControllerTest 
{
	static GeneratePDFController generatePDFCon;
	static Account family;
	static Account acc;
	static Attachment objAttachment;
	static void testData()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
		
		Contact con;
    	List<User> standardUser = testData.initStandardUser();
    	List<Account> lstAcc = new List<Account>(); 
       	System.runAs(standardUser[0])
       	{
       		Account partnerAcc = testData.initVirtualAccount();
	    	insert partnerAcc;
       		
       		Lead objLead = new Lead();
    		objLead.LastName = 'TestLastName';
    		objLead.LeadSource = 'Web';
    		objLead.MobilePhone = '9090909090';
    		insert objLead;
       
       		//Account created for enabling Partner Portal
	       	//Date : 1/8/12 , Code Added By: Aditi
	       	acc = testData.initializeAccount();
	       	lstAcc.add(acc);
	        insert lstAcc; 
			
			Entity_Global_Assumption__c objGA = [select Id, CashFlow_Projection_End_Year__c from Entity_Global_Assumption__c where Account__c =: acc.Id];
			objGA.CashFlow_Projection_End_Year__c = 'Life Expectancy';
			update objGA;
			
       		List<Goal__c> lstGoal = new List<Goal__c>();
       		Goal__c  goal1;
         	
         	Goal_Profile__c goalProfile = testData.initialize_GoalProfile(acc, 'Aggressive', 'Customized');
          	insert goalProfile;
          	goal1 = testData.initialize_Goal(acc, 'Emergency Fund', goalProfile);
        	lstGoal.add(goal1);
            
            goalProfile = testData.initialize_GoalProfile(acc, 'Moderately Aggressive', 'Customized');
          	insert goalProfile;
          	goal1 = testData.initialize_Goal(acc, 'Emergency Fund', goalProfile);
        	lstGoal.add(goal1);
        	
            goalProfile = testData.initialize_GoalProfile(acc, 'Moderate', 'Customized');
          	insert goalProfile;
          	goal1 = testData.initialize_Goal(acc, 'Emergency Fund', goalProfile);
        	lstGoal.add(goal1);

            goalProfile = testData.initialize_GoalProfile(acc, 'Moderately Conservative', 'Customized');
          	insert goalProfile;
          	goal1 = testData.initialize_Goal(acc, 'Emergency Fund', goalProfile);
        	lstGoal.add(goal1);

			goalProfile = testData.initialize_GoalProfile(acc, 'Conservative', 'Customized');
          	insert goalProfile;
          	goal1 = testData.initialize_Goal(acc, 'Emergency Fund', goalProfile);
        	lstGoal.add(goal1);
        	
        	insert lstGoal;
         	system.assertNotEquals(null,goal1.id);
         
         	List <Attachment> lstAttachmnt = new List <Attachment>();
			objAttachment = new Attachment();
    		objAttachment.ParentId = objLead.Id;
    		objAttachment.Name = 'Test';
    		objAttachment.Body = Blob.valueOf('test');
    		lstAttachmnt.add(objAttachment);
    		/*Attachment objAttachment1 = new Attachment();
    		objAttachment1.ParentId = objLead.Id;
    		objAttachment1.Name = 'Test';
    		objAttachment1.Body = Blob.valueOf('test');
    		lstAttachmnt.add(objAttachment1);*/ 
    		insert lstAttachmnt;
       		
          	//Loan__c loan1 = new  Loan__c(Principal_Amount_Outstanding__c=1000000,Entity__c=partnerAcc.id);
          	Loan__c loan1 = testData.init_Loan(partnerAcc);
          	insert loan1;
           	system.assertNotEquals(null,loan1.id);

	       	//Contact created for enabling Partner Portal	       
	       	//Date : 1/8/12 , Code Added By: Aditi 
	      	con=new Contact(FirstName='Parner Contact Test', LastName='Contact',AccountId= partnerAcc.id);
	       	insert con;
	    }
	}


	static testMethod void myUnitTest() 
	{
		testData();
       	test.startTest();
       	ApexPages.currentPage().getParameters().put('EntityId',acc.id);
       	ApexPages.currentPage().getParameters().put('attachmentId',objAttachment.id);
       	CashFlow_Projection__c objCF = new CashFlow_Projection__c(Year__c=2013,Entity__c = acc.id,Salary_Income__c=1000,Recreation_Entertainment__c=2000,
       							isProjectionDisplayed__c = true,Rental_Income__c=1000,Pension_Income__c=1000,Other_Income__c=100,Business_Income__c=1000,
       							Healthcare__c=1000,Housing__c=1000,Transportation__c=1000,Family_care__c=1000,Saving__c=1000,Loan_Repayments_EMI__c=100,
       							Food__c=1000,Other__c=1000,Utilities__c=1000,Personal__c=1000);
   		insert objCF;
       	generatePDFCon=new GeneratePDFController();
       	//String goal=generatePDFCon.goal;  
       	generatePDFCon.sendAttachmentToEntity();
       	generatePDFCon.sendEmailToEntity();
       	List<GoalMappingBean> goalMappingBeanList=generatePDFCon.goalMappingBeanList;
       	test.stopTest();
    }
    
    static testMethod void myUnitTestBPAttachment() 
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
       	List<Account> lstAcc = new List<Account>(); 
	    Account objGeneralAccount = testData.init_GeneralAccount();
	    insert objGeneralAccount;
	    Contact objBizContact = testData.init_BizContact(objGeneralAccount);
	    insert objBizContact; 
	    User partnerUser = testData.initBusinessUser(objBizContact);
	    insert partnerUser;           
        system.debug('--------partnerUser---ss-----'+partnerUser);
      	
        Account partnerAcc = testData.initBusinessAccount(partnerUser);
        insert partnerAcc;
        partnerAcc.Related_To__c = 'Business Partner';	           
        update partnerAcc; 
        
		objAttachment = new Attachment();
		objAttachment.ParentId = partnerAcc.Id;
		objAttachment.Name = 'Test';
		objAttachment.Body = Blob.valueOf('test');
		insert objAttachment;
    		
       	test.startTest();
       	ApexPages.currentPage().getParameters().put('EntityId',partnerAcc.id);
       	ApexPages.currentPage().getParameters().put('attachmentId',objAttachment.id);
       	generatePDFCon=new GeneratePDFController();
       	//String goal=generatePDFCon.goal;  
       	generatePDFCon.sendAttachmentToEntity();
       	generatePDFCon.sendEmailToEntity();
       	generatePDFCon.saveUnallocatedAssetsRemark();
       	generatePDFCon.save();
       	List<GoalMappingBean> goalMappingBeanList=generatePDFCon.goalMappingBeanList;
       	test.stopTest();
    }
    
    static testMethod void myUnitTest1() 
    {
       
       	TestData_Ffreedom testData = new TestData_Ffreedom();
       	List<Account> lstAcc = new List<Account>(); 
       	Account partnerAcc = testData.initVirtualAccount();
	   	insert partnerAcc;
	    
	    //Account acc = testData.initVirtualAccount(partnerAcc);
       	Id clientRecId=RecTypes__c.getInstance('AccountClient').Record_Type_Value__c;
	    acc=new Account(LastName='ABC',FirstName='PQR',Adjustment_Factor__c='2',
                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
                       Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',Virtual_Partner__c = partnerAcc.id,
                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='Husband',RecordTypeId=clientRecId,Email_Temp__c = 'aditi@gmail.com',
                       //01220000000DnK3AAK'
                       Earning_Member__c=true);
        acc.Related_To__c = 'Virtual Partner';	           
	    lstAcc.add(acc);
	    
        insert lstAcc; 
    	test.startTest();
        Pagereference pgRef = Page.generatePDF;
        ApexPages.currentPage().getParameters().put('EntityId',acc.id);
        pgRef.setRedirect(true); 
        generatePDFCon=new GeneratePDFController();
       	test.stopTest();
    }
    static testMethod void myUnitTest2() 
    {
        testData();
    	test.startTest();
        //Pagereference pgRef = Page.generatePDF;
        ApexPages.currentPage().getParameters().put('EntityId',acc.id);
        //pgRef.setRedirect(true); 
        generatePDFCon=new GeneratePDFController();
       	test.stopTest();
    }
    
     static testMethod void myUnitTestBusinessPartner() 
    {
    	TestData_Ffreedom testData = new TestData_Ffreedom();
       	List<Account> lstAcc = new List<Account>(); 
       	Account objGeneralAccount = testData.init_GeneralAccount();
	    insert objGeneralAccount;
	    Contact objBizContact = testData.init_BizContact(objGeneralAccount);
	    insert objBizContact;
       	User partnerUser = testData.initBusinessUser(objBizContact);
       	insert partnerUser;
       	Account partnerAcc = testData.initBusinessAccount(partnerUser);
	   	insert partnerAcc;
	    
        partnerAcc.Related_To__c = 'Business Partner';	           
        update partnerAcc; 
        
    	test.startTest();
        Pagereference pgRef = Page.generatePDF;
        ApexPages.currentPage().getParameters().put('EntityId',partnerAcc.id);
        pgRef.setRedirect(true); 
        generatePDFCon = new GeneratePDFController();
        generatePDFCon.address = 'aaa aaa, aaa aaa, aaa';
		generatePDFCon.lstAddwithComma.add('aaa aaa,aaaa aa,aaa');
		//generatePDFCon.approvedPlan();
       	test.stopTest();
    	
    }

/*
static void testData1()
{
		 
		 
	Contact con;
    
    List<User> standardUser = [select Id from user where usertype = 'Standard' and Profile.Name like '%System Admin%' limit 1];
    List<Account> lstAcc = new List<Account>(); 
    System.runAs(standardUser[0])
    {
      	Account partnerAcc=new Account(Name='Parner Account Test',RecordTypeId=RecTypes__c.getInstance('General_Business').Record_Type_Value__c,Logo__c='aaa', Email_ID__c='aaa@gmail.com', Company_Address__c='abcd', Phone='32323');
	       insert partnerAcc;
	      	con=new Contact(FirstName='Parner Contact Test', LastName='Contact',AccountId= partnerAcc.id);
	       	insert con;
      
    }
       //Role created for Partner Portal
       //Date : 1/8/12 , Code Added By: Aditi 
       List <UserRole> ur1 = [select Id from UserRole where   PortalType='Partner' limit 1];
  	   
  	   Profile prof = [select id 
                      from profile 
                     where usertype = 'PowerPartner'
                     limit 1];
  	   ID PartnerProfileID =prof.id;
  	   User u1;
  	   if(ur1!=null && ur1.size() > 0)
  	   {
  	   		//User created for Partner Portal
  	   		//Date : 1/8/12 , Code Added By: Aditi 
	    	 u1 = new User(Workstations__c = 'All',userroleid=ur1[0].id,ContactId= con.id, email='test-user@fakeemail.com',ProfileId = PartnerProfileID,UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname' );
	       insert u1;
  	   }
  	   System.runAs(u1)
  	   {
  	   	 	//Account created after logging as Partner Portal User
  	   	 	//Date : 1/8/12 , Code Added By: Aditi 
  	   	  	 	
  	   	  	 	
  	   	 	Account PatnersClientAcc=new Account(LastName='ABC',FirstName='PQR',Adjustment_Factor__c='2',
                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='54637',
                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
                       Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='Husband',RecordTypeId='01220000000DnK3AAK',Email_Temp__c = 'aditi@gmail.com',
                       Earning_Member__c=true);	  
	       	upsert PatnersClientAcc;
	       	Lead PartnersLead=new Lead(LastName='Partners Lead',Status='Open',MobilePhone='312421',Age__c=30);
	       	insert PartnersLead;
	       	
	       	 ApexPages.currentPage().getParameters().put('EntityId',PatnersClientAcc.id);
           generatePDFCon=new GeneratePDFController();
           generatePDFCon.sendAttachmentToEntity();
           generatePDFCon.sendEmailToEntity();
          
           
	       	//generatePDFCon=new GeneratePDFController();
  	   }
	
}*/

    
  /*  static testMethod void myUnitTest1() {
       test.startTest();
       testData1();
       List<GoalMappingBean> goalMappingBeanList=generatePDFCon.goalMappingBeanList;
     
       test.stopTest();
       
       
    }*/
}