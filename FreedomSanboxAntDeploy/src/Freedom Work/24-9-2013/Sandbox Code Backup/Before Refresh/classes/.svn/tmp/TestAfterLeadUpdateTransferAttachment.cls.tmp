/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     23/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class TestAfterLeadUpdateTransferAttachment 
{
    static testMethod void AfterLeadUpdateTransferAttachmentTest() 
    {
    	Test.startTest();
    	List<Question_Option_List__c> lstQuesOptionList = new List<Question_Option_List__c>();
    	List<Question_Bank_List__c> lstQuesBankList = new List<Question_Bank_List__c>();
    	List<Questionnaire__c> lstQuestionnaire = new List<Questionnaire__c>();
    	List<XRay_ScoreCard__c> lstScoreCardTest = new List<XRay_ScoreCard__c>();
    	List<Option_Detail__c> lstOptionsScorecards = new List<Option_Detail__c>();
    	Account partnerAcc,partnerAcc1;
		Contact con;
	 	Entity_Global_Assumption__c ega;
        List<User> standardUser = [select Id from user where usertype = 'Standard' and Profile.Name like '%System Admin%' limit 1];
        System.runAs(standardUser[0])
        {
    	/* Lead  */
    		TestData_Ffreedom testData = new TestData_Ffreedom();
    		
	    	Lead objLead = new Lead();
	    	objLead.LastName = 'TestLastName';
	    	objLead.LeadSource = 'Web';
	    	objLead.MobilePhone = '9090909090';
	    	insert objLead;
	    	objLead.MobilePhone = '222';
	    	update objLead;
	    	//need to comment below
	    	//=========================================For Virtual Partner===================================================================================
	    	 
	    	partnerAcc1 = testData.init_GeneralAccount();
	        insert partnerAcc1;
			Account objAccount = testData.initializeAccount();
		    insert objAccount;
		 	/* List<Account> acc = [select id,Logo__c, Email_ID__c, Company_Address__c, Phone, Name from Account where RecordTypeId = :RecTypes__c.getInstance('General_Business').Record_Type_Value__c]; 
	    	 
	    	 Lead newLd = new Lead(LastName = 'Tesqqqqt', Status='Converted',Virtual_Partner__c = acc[0].id);//Need to comment below 
				insert newLd;
	    	
	    	 Database.LeadConvert lc = new database.LeadConvert();
		        lc.setLeadId(newLd.Id);
		        lc.setConvertedStatus('Converted');
		        system.debug('!!!!!!!!!!!!!!!  1');
			    Database.LeadConvertResult lcr = Database.convertLead(lc);
				system.debug('!!!!!!!!!!!!!!!  2');*/
				
			//============================================================================================================================	
			
	  		Account act = testData.initializeAccount();
	  		act.PAN_ID__pc='a1b2c3d4e6';
	        insert act;
			
		    //Date : 1/8/12 , Code Added By: Aditi 
		    con = testData.init_Contact(partnerAcc1);
		    //con=new Contact(FirstName='Parner Contact Test', LastName='Contact',AccountId= partnerAcc1.id);
		    insert con;
		      
		    ega = testData.initialize_GlobalAssumptions(objAccount);   	
		    //ega=new Entity_Global_Assumption__c(Account__c=objAccount.id,Expected_Return_on_Investment__c=30,Income_Growth_Rate__c=3,Inflation_Rate__c=6,Number_Of_Months__c=5);
	       	upsert ega;  
		    List <Attachment> lstAttachmnt = new List <Attachment>();
		    
			Attachment objAttachment = testData.init_Attachment(objLead);
	    	lstAttachmnt.add(objAttachment);
	    	
	    	Attachment objAttachment1 = testData.init_Attachment(objLead);
	    	lstAttachmnt.add(objAttachment1); 
	    	
	    	insert lstAttachmnt;
	    	
	    	/* Question_Bank__c  */
	    	Question_Bank__c objQuestionBank = new Question_Bank__c ();
	    	objQuestionBank.IsActive__c = true;  
	    	insert objQuestionBank;
	    	
	    	/* Question_Bank_List__c  */
	     /*  	Question_Bank_List__c quesMasters1 = new Question_Bank_List__c();
	    	quesMasters1.Question__c = 'Have you prepared a budget for household expenses?'; 
	    	quesMasters1.Criteria__c = 'Yes';
	    	quesMasters1.IsDummy__c = false;
	    	quesMasters1.Question_Type__c = 'Yes/No';
	    	//insert quesMasters1;
	    	lstQuesBankList.add(quesMasters1);
	    	
	    	Question_Bank_List__c quesMasters2 = new Question_Bank_List__c();
	    	quesMasters2.Question__c = 'If YES, do you follow your budgeting?'; 
	    	quesMasters2.IsDummy__c = false;
	    	quesMasters2.Question_Type__c = 'Yes/No';
	    	quesMasters2.Master_Parent__c = quesMasters1.Id; 
	    	quesMasters2.Parent_Question__c = quesMasters1.Id;
	   // 	insert quesMasters2;
	    	lstQuesBankList.add(quesMasters2);
	    	insert lstQuesBankList;
	    	Questionnaire__c objQuestionnaire1 = new Questionnaire__c();
	    	objQuestionnaire1.Question_Bank__c = objQuestionBank.Id;
	    	objQuestionnaire1.Question_Bank_List__c = quesMasters1.Id;
	    	objQuestionnaire1.Display_Sequence__c = '1';
	    	lstQuestionnaire.add(objQuestionnaire1); 
	    	 
	    	Questionnaire__c objQuestionnaire2 = new Questionnaire__c();
	    	objQuestionnaire2.Question_Bank__c = objQuestionBank.Id;
	    	objQuestionnaire2.Question_Bank_List__c = quesMasters2.Id;
	    	objQuestionnaire2.Display_Sequence__c = '2';
	    	lstQuestionnaire.add(objQuestionnaire2);
	    	
	    	if(!lstQuestionnaire.isEmpty())
	    		insert lstQuestionnaire;
	    	
	    	// Question_Option_List__c 
	    	Question_Option_List__c objQuesOptionList1 =  new Question_Option_List__c();
	    	objQuesOptionList1.Name = 'Yes';
	    	objQuesOptionList1.Score__c = 5;
	    	objQuesOptionList1.Question_Bank_List__c = quesMasters1.Id;
	   // 	insert objQuesOptionList1;
	    	lstQuesOptionList.add(objQuesOptionList1); 
	    	
	    	Question_Option_List__c objQuesOptionList2 =  new Question_Option_List__c();
	    	objQuesOptionList2.Score__c = 0;
	    	objQuesOptionList2.Name = 'No';
	    	objQuesOptionList2.Question_Bank_List__c = quesMasters1.Id;
	    //	insert objQuesOptionList2; 
	    	lstQuesOptionList.add(objQuesOptionList2);
	    	
	    	Question_Option_List__c objQuesOptionList3 =  new Question_Option_List__c();
	    	objQuesOptionList3.Name = 'Yes';
	    	objQuesOptionList3.Score__c = 5;
	    	objQuesOptionList3.Question_Bank_List__c = quesMasters2.Id;
	    //	insert objQuesOptionList3;
	    	lstQuesOptionList.add(objQuesOptionList3);
		
	    	Question_Option_List__c objQuesOptionList4 =  new Question_Option_List__c();
	    	objQuesOptionList4.Name = 'No';
	    	objQuesOptionList4.Score__c = 0;
	    	objQuesOptionList4.Question_Bank_List__c = quesMasters2.Id;
	    //	insert objQuesOptionList4;
	    	lstQuesOptionList.add(objQuesOptionList4);
	    	insert lstQuesOptionList;
	    	
	    	// X_Ray_Score_Card_Detail__c 
	    	
	    	List<X_Ray_Score_Card_Detail__c> lstXRayScoreCardDetail = new List<X_Ray_Score_Card_Detail__c>();
	    	X_Ray_Score_Card_Detail__c ObjXrayScoreCardDetail = new X_Ray_Score_Card_Detail__c();
	    	ObjXrayScoreCardDetail.Question_Bank__c= objQuestionBank.Id;
	    	ObjXrayScoreCardDetail.Lead__c = objLead.Id;
	    	lstXRayScoreCardDetail.add(ObjXrayScoreCardDetail);
	    	X_Ray_Score_Card_Detail__c ObjXrayScoreCardDetail1 = new X_Ray_Score_Card_Detail__c();
	    	ObjXrayScoreCardDetail1.Question_Bank__c= objQuestionBank.Id;
	    	ObjXrayScoreCardDetail1.Lead__c = objLead.Id;
	    	lstXRayScoreCardDetail.add(ObjXrayScoreCardDetail1);
	    	insert lstXRayScoreCardDetail;
	    	
	    	
	    	
	    	// XRay_ScoreCard__c 
	    	XRay_ScoreCard__c objXrayScore1 = new XRay_ScoreCard__c ();
	    	objXrayScore1.Display_Sequence__c = 1;
	    	objXrayScore1.Question_Bank_List__c = quesMasters1.Id;
	    	objXrayScore1.XRayScoreCardMaster__c = ObjXrayScoreCardDetail.Id;
	    	objXrayScore1.Score_Master__c = 5;   
	    	lstScoreCardTest.add(objXrayScore1);
	    	
	    	XRay_ScoreCard__c objXrayScore2 = new XRay_ScoreCard__c ();
	    	objXrayScore2.Display_Sequence__c = 2;
	    	objXrayScore2.Question_Bank_List__c = quesMasters2.Id;
	    	objXrayScore2.XRayScoreCardMaster__c = ObjXrayScoreCardDetail.Id;
	    	objXrayScore2.Score_Master__c = 5;   
	    	lstScoreCardTest.add(objXrayScore2);
	    	
	    	if(!lstScoreCardTest.isEmpty())
	    		insert lstScoreCardTest;
	    	
	    	
	 	
	    	Option_Detail__c objOptions1 = new Option_Detail__c();
	    	objOptions1.Answer__c = objQuesOptionList1.Id ;
	    	objOptions1.XRayScoreCard__c=  objXrayScore1.Id;
	    	lstOptionsScorecards.add(objOptions1);
	    	
	    	
	    	Option_Detail__c objOptions2 = new Option_Detail__c();
	    	objOptions2.Answer__c = objQuesOptionList3.Id;
	    	objOptions2.XRayScoreCard__c=  objXrayScore2.Id;
	    	lstOptionsScorecards.add(objOptions2);
	    	
	    	if(!lstOptionsScorecards.isEmpty())
	    		insert lstOptionsScorecards;
	   */ 	
	    	
	    	/*Lead objLead1 = [Select Id,Age__c from Lead where Id =:objLead.Id];
	      	objLead1.Age__c = 29;
	        update objLead1;	
				*/
				
			
			
        }
    	
    	//=========================================For Partner Portal===================================================================================
    	//Role created for Partner Portal
        //Date : 06/09/12 , Code Added By: Aditi 
    /*    List <UserRole> ur1 = [select Id from UserRole where   PortalType='Partner' limit 1];
  	   
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
	       	system.debug('*********U1********'+u1);
	       	
  	    }
  	    System.runAs(u1)
  	    {
  	   	 	//Account created after logging as Partner Portal User
  	   	 	//Date : 1/8/12 , Code Added By: Aditi 
  	   	  	 	
  	   	 	Account PatnersClientAcc=new Account(LastName='ABC',FirstName='PQR',Adjustment_Factor__c='2',
                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='54637',
                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
                       Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband',RecordTypeId='01220000000DnK3AAK',
                       Earning_Member__c=true);	  
	       	upsert PatnersClientAcc;
	       	
	       	Lead PartnersLead=new Lead(LastName='Partners Lead',Status='Converted',MobilePhone='312421',Age__c=30);
	       	insert PartnersLead;
	//        PartnersLead.Age__c = 31;
	//        update PartnersLead;
	        Database.LeadConvert lc1 = new database.LeadConvert();
	        lc1.setLeadId(PartnersLead.Id);
	        lc1.setConvertedStatus('Converted');
	        system.debug('!!!!!!!!!!!!!!!  1');
		    Database.LeadConvertResult lcr1 = Database.convertLead(lc1);
			system.debug('!!!!!!!!!!!!!!!  2 :lcr1'+lcr1);
	       	
	   		Entity_Global_Assumption__c ega1=new Entity_Global_Assumption__c(Account__c=PatnersClientAcc.id,Expected_Return_on_Investment__c=30,Income_Growth_Rate__c=3,Inflation_Rate__c=6,Number_Of_Months__c=5);
       	upsert ega1;  
  	//    }
  	    	//============================================================================================================================
  	    
  	    
  	    */
    	
        Test.stopTest();
    }
}