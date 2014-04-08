@isTest
 private class TestWebFormController
 {
	 public static testMethod void testWebController()
	 {
	    List<WebFormController.checkboxes> checkboxesListforContact=new List<WebFormController.checkboxes>();
	    List<WebFormController.checkboxes> checkboxesListforCareers=new List<WebFormController.checkboxes>();
	   
	   	TestData_Ffreedom testData = new TestData_Ffreedom();
	   	
	    Lead ldRecord;
	    WebFormController wcf = new WebFormController();

	    Lead ld = wcf.getLead();
	    ld = testData.init_Lead();
	   /* ld.FirstName='FirstName';
	    ld.LastName='LastName';
	    ld.Occupation__c='Student';
	    ld.Location__c='Agra';
	    ld.MobilePhone='9876543210';*/    
	    checkboxesListforContact=wcf.getCheckboxesListforContact();
	    WebFormController.checkboxes contactCheckbox= checkboxesListforContact.get(1);
	    contactCheckbox.selected=true;

		/* Deployment : Prajakta Sanap */	    
	    //ID ProfileID = [ Select id from Profile where name = 'Ffreedom Team'].id;
	//   User user = new User( email='test-user@fakeemail.com', profileid = ProfileID, UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Ffreedom', LastName = 'Team' );
	 //  insert user;
	   
	    Lead objLead = testData.init_Lead();
	    insert objLead;
	    ldRecord = objLead;
	   /* Campaign camp = new Campaign (Name='Website - Contact Us Leads');
	    insert camp;
	    System.debug('**************Campaign'+camp);*/
	   // System.assertEquals(ldRecord.Id,ld.Id) ;
	    System.assertEquals(ldRecord.Status,'Open');
	    System.assertEquals(ldRecord.LeadSource,'Web');
	    PageReference pageRef=wcf.insertContactUsInfo(); 
	     
	    String url=pageRef.getUrl();
	    System.assertEquals(url,'/apex/thankyou');
	   
	   // cm.CampaignId
	    //ld=null;   
	    //ldRecord=null;
	    //wcf=null;
	    wcf = new WebFormController();
	    ld= wcf.getLead();
	    ld.FirstName='FirstName';
	    ld.LastName='LastName';
	    ld.Street='S.V.Road';
	    ld.City='Agra';
	    ld.PostalCode='400053';
	    ld.State='MahaRashtra';
	    ld.Country='india';
	    ld.MobilePhone='9876543210';
	    ld.Email='rupesh@gmail.com';
	   
	    ld.tempReportDate__c = System.Today();
	    wcf.getreportTime();
	    wcf.reportTimeValue = '9:45';
	    //ld.Appointment_Time__c=t;
	    ld.Description='DescriptionDescription';
	    
	    /* Deployment : Prajakta Sanap */
	    Campaign camp1=new Campaign(Name='Website - Complimentary Consultation Leads');
	    insert camp1;
	    pageRef=wcf.insertComplConsInfo(); 
	    ld=null;
	    pageRef=null;
	     
	    wcf = new WebFormController();
	    ld= wcf.getLead();
	    //ldRecord =new Lead();
	   //pageRef=new PageReference();
	    ld.FirstName='Marina';
	    ld.LastName='Beach';
	    ld.MobilePhone='9876543210';
	    ld.Alternate_Mobile__c='1234567890';
	    ld.Email='rupesh@gmail.com';
	    ld.Description='Cover letter'; 
	    checkboxesListforCareers=wcf.getcheckboxesListforCareers();
	    WebFormController.checkboxes careersCheckbox= checkboxesListforCareers.get(1);
	    careersCheckbox.selected=true;
	    
	    /* Deployment : Prajakta Sanap */
	    Campaign camp2=new Campaign(Name='Website - Careers Campaign');
	    insert camp2;
	    PageReference page=wcf.insertCareersPageInfo(); 
	    
	    String str=page.getUrl();
	    ldRecord =[select Id,Status,LeadSource from Lead where FirstName='Marina' LIMIT 1];
	    System.assertEquals(ldRecord.Id,ld.Id) ;
	    System.assertEquals(ldRecord.Status,'Open');
	    System.assertEquals(ldRecord.LeadSource,'Web');
	    System.assertEquals(str,'/apex/thankyou');
	    
	    ld=null;
	    pageRef=null;
	    ldRecord=null;
	    
	 }
 }