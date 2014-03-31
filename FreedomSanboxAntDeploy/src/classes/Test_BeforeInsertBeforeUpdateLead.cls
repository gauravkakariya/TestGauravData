//Created on 1/8/12 By Aditi Satpute during Partner Portal related implementation
 
@isTest
private class Test_BeforeInsertBeforeUpdateLead {

    static testMethod void myUnitTest() {
    	Contact con;
    
    	List<User> standardUser = [select Id from user where usertype = 'Standard' and Profile.Name like '%System Admin%' limit 1];
       System.runAs(standardUser[0])
       {
       		     
       		Lead newLead=new Lead(LastName='Test Lead',Status='Open',MobilePhone='313241',Age__c=30);
	    	insert newLead;  
	       	//Account created for enabling Partner Portal
	       	//Date : 1/8/12 , Code Added By: Aditi 
	       	Account partnerAcc=new Account(Name='Parner Account Test',RecordTypeId=RecTypes__c.getInstance('General_Business').Record_Type_Value__c);
	       	insert partnerAcc;

	       	//Contact created for enabling Partner Portal	       
	       	//Date : 1/8/12 , Code Added By: Aditi 
	      	con=new Contact(FirstName='Parner Contact Test', LastName='Contact',AccountId= partnerAcc.id);
	       	insert con;
	       	
	       		//Need to comment below ===============================
	       	/*Account partnerAcc1 = new Account(Name='Parner Account Test',RecordTypeId=RecTypes__c.getInstance('General_Business').Record_Type_Value__c);
	       	insert partnerAcc1;
	  	 	List<Account> acc = [select id,Logo__c, Email_ID__c, Company_Address__c, Phone, Name from Account where RecordTypeId = :RecTypes__c.getInstance('General_Business').Record_Type_Value__c]; 
			*/
	//  	list<Lead_Platform_User__c> lstLeads = 	new list<Lead_Platform_User__c>();
	    	//Lead_Platform_User__c lead1 = new Lead_Platform_User__c(Virtual_Partner__c = acc[0].id,/*Need to comment below */First_Name__c = 'Platform', Name = 'User', Lead_Status__c = 'Converted', Lead_Source__c = 'Web', Mobile__c = '9898989898', Age__c = 23);
	    	//insert lead1;
	    	//lstLeads.add(lead1);
	    	//=====================================================
	    }
       //Role created for Partner Portal
       //Date : 1/8/12 , Code Added By: Aditi 
      /*  List <UserRole> ur1 = [select Id from UserRole where   PortalType='Partner' limit 1];
  	   
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
  	   	 		   	 	
  	   	 	Account PatnersClientAcc=new Account(LastName='Partners Client',FirstName='PQR',RecordTypeId= RecTypes__c.getInstance ('AccountClient').Record_Type_Value__c); //Gaurav
  	   	 	//'01220000000DnK3AAK');
	       	upsert PatnersClientAcc;
	       	
	       	Lead PartnersLead=new Lead(LastName='Partners Lead',Status='Open',MobilePhone='312421',Age__c=30);
	       	insert PartnersLead;
	       	
	       
  	   }*/
    }
}