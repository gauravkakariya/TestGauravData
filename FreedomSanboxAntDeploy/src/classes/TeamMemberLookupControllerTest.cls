/**
 * This class contains unit tests for validating the behavior of Apex classes

 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TeamMemberLookupControllerTest {

    static testMethod void teamMemberUnitTest() {
        
        Business_Unit__c objBusinessUnit = getBusinessUnit();
    	insert objBusinessUnit;
    	
    	//List<Department__c> lstDeparment = getDepartment(objBusinessUnit.Id);
    	
    	List<Department__c> lstDepartment = new List<Department__c>();
     	Department__c objDeparment1 = new Department__c(Name = 'PSTDept1',Type_of_Department__c='PSTDep', Business_Unit__c = objBusinessUnit.Id );
     	Department__c objDeparment2 = new Department__c(Name = 'MSTDept1',Type_of_Department__c='MSTDept', Business_Unit__c = objBusinessUnit.Id  );
     	Department__c objDeparment3 = new Department__c(Name = 'MST2Dept1',Type_of_Department__c='MST2Dept', Business_Unit__c = objBusinessUnit.Id  );
        Department__c objDeparment4 = new Department__c(Name = 'FPADept1',Type_of_Department__c='FPADept', Business_Unit__c = objBusinessUnit.Id );
     	
     	lstDepartment.add(objDeparment1);
     	lstDepartment.add(objDeparment2);
     	lstDepartment.add(objDeparment3);
     	lstDepartment.add(objDeparment4);	
     	
        insert lstDepartment;
        
        List<Team_Member__c> lstTeamMember = new List<Team_Member__c>();
       	List<User>  lstUser = new List<User>();
     	/*
      	User objUser4 = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test1-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser31',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );
      	 						    
      	User objUser1 = new User(email='test1-user@fakeemail2.com', profileid = ProfileID, UserName='test2-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser32',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-4',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname2',
      	 						    LastName = 'Test_Parent_Lname2' ); 	
      	 						    
      	User objUser2 = new User(email='test1-user@fakeemail3.com', profileid = ProfileID, UserName='test3-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser33',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-3',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname3',
      	 						    LastName = 'Test_Parent_Lname3' ); 	
      	 						    
      	User objUser3 = new User(email='test1-user@fakeemail4.com', profileid = ProfileID, UserName='test4-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser34',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-2',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname4',
      	 						    LastName = 'Test_Parent_Lname24' ); 	
      	 						     						     						    					    
        lstUser.add(objUser4);
        lstUser.add(objUser1);
        lstUser.add(objUser2);
        lstUser.add(objUser3); 
        
        //insert lstUser;
        */
     	Team_Member__c objTeamMember1 = new Team_Member__c(Name ='PSTTeam1', Department__c = objDeparment1.Id, Status__c= 'Active');
     	Team_Member__c objTeamMember2 = new Team_Member__c(Name ='MSTTeam1',  Department__c = objDeparment2.Id, Status__c= 'Active');
     	Team_Member__c objTeamMember3 = new Team_Member__c(Name ='MSTTeam1', Department__c = objDeparment3.Id, Status__c= 'Active'); //, Team_Member__c= objUser2.Id);
     	Team_Member__c objTeamMember4 = new Team_Member__c(Name ='FPATeam1',  Department__c = objDeparment4.Id, Status__c= 'Active');//,Team_Member__c= objUser3.Id);
     	
     	lstTeamMember.add(objTeamMember1);
     	lstTeamMember.add(objTeamMember2);
     	lstTeamMember.add(objTeamMember3);
     	lstTeamMember.add(objTeamMember4);
     	
       // List<Team_Member__c> lstTeamMember = getTeamMember(lstDeparment[0].Id, lstDeparment[1].Id, lstDeparment[2].Id, lstDeparment[3].Id);
        insert lstTeamMember;
        
       Test.startTest();   
	   PageReference pageRef = Page.TeamMemberLookup;
       pageRef.setRedirect(true);
	     
	   ApexPages.currentPage().getParameters().put('lksrch', 'PSTTeam1'); 
	   ApexPages.currentPage().getParameters().put('BU_Name', 'BussinessUnit1'); 
	   ApexPages.currentPage().getParameters().put('TM_Type', 'PSTDep'); 
	   
	   
	  // ApexPages.StandardController std = new ApexPages.StandardController(objTeamMember1);        
       TeamMemberLookupController objTeamMemberLookupController	 = new TeamMemberLookupController();
       objTeamMemberLookupController.saveAccount();
       objTeamMemberLookupController.search();
       objTeamMemberLookupController.getFormTag();
        objTeamMemberLookupController.getTextBox();
       Test.stopTest();
    }
    
     private static Business_Unit__c getBusinessUnit()
     {
     	Business_Unit__c objBusinessUnit = new Business_Unit__c(Name = 'BussinessUnit1', Short_Code__c= 'BU1',Business_Unit_Name__c='BussinessUnit1');
     	return objBusinessUnit;
     }
}