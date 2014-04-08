@isTest
private class GlobalAssumptionControllerTest {
	static GlobalAssumptionController GlobalAssumptionPlan;
	static Account acc;
	static List<User> standardUser;
	public static final Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
	public static final Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
	
	public static void testData()
	{
		Account partnerAcc,partnerAcc1;
	    Contact con;
	    Entity_Global_Assumption__c ega;
		
	   standardUser = [select Id from user where usertype = 'Standard' and Profile.Name like '%System Admin%' limit 1];
       System.runAs(standardUser[0])
       {
       		acc = new Account(LastName='ABC',FirstName='PQR',RecordTypeId = RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId());
	      	upsert acc;
	      	
	       	partnerAcc = new Account(Name='Parner Account Test',RecordTypeId = RecTypes__c.getInstance('General_Business').Record_Type_Value__c);
	       	insert partnerAcc;
	       	
	       	con = new Contact(FirstName='Parner Contact Test', LastName='Contact',AccountId= partnerAcc.id);
	       	insert con;
	       	
	       	//need to comment below
    		//=========================================For Virtual Partner================================================================================================
	       	/*partnerAcc1=new Account(Name='Parner Account Test',RecordTypeId=RecTypes__c.getInstance('General_Business').Record_Type_Value__c);
         	insert partnerAcc1;
	       	
			Id clientRecId=RecTypes__c.getInstance('AccountClient').Record_Type_Value__c;
  			Account act = new Account(FirstName='ABC',LastName='XYZ',RecordTypeId=clientRecId ,Related_To__c = 'Virtual Partner');
        	insert act;
        	*/
        	//==============================================================================================================================================================
	       	ega=new Entity_Global_Assumption__c(Account__c=partnerAcc.id,Expected_Return_on_Investment__c=30,Income_Growth_Rate__c=3,Inflation_Rate__c=6,Number_Of_Months__c=5);
       		upsert ega;  
       }
   }
   
  static testMethod void virtualEntityTest() 
    {
    	Test.startTest();
    	standardUser = [select Id from user where usertype = 'Standard' and Profile.Name like '%System Admin%' limit 1];
    	Account partnerAcc1 = new Account(Name='Partner Account Test',RecordTypeId=RecTypes__c.getInstance('General_Business').Record_Type_Value__c, Related_To__c = 'Virtual Partner');
        insert partnerAcc1;
	       	
    	List<Account> lstAccount = new List<Account>();
    	Account objAccount = new Account(LastName = 'ABC', FirstName='PQR', Adjustment_Factor__c='2',
	                       				  PersonTitle = 'TestData', PersonBirthdate = system.today(), PersonHomePhone = '54623676', PersonMobilePhone = '5463712345',
	                       				  Alternate_Mobile__c = '356475', PersonEmail = 'sgdh@test.com', Alternate_E_Mail_Address__c =' test@test.com',
				                          Retirement_Year__c = 2034, Residential_Status_del__c = 'own', Retirement_Age__c = '58', Estimated_Life_Expectancy__c = '67',
				                          Estimated_Life_EndYear__c = 2041, Relationship_to_Entity__pc = 'husband', Related_To__c = 'Virtual Partner',
				                          RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c);
	    lstAccount.add(objAccount);
	    
	    Account objFamily = new Account(LastName = 'ABC', FirstName='PQR',Dependent__c=objAccount.Id,
	    								RecordTypeId = RecTypes__c.getInstance('AccountFamily').Record_Type_Value__c);
	    lstAccount.add(objFamily);
	    insert lstAccount;
	    
	    Entity_Global_Assumption__c objGlobal1 = new Entity_Global_Assumption__c 
	    										(Expected_Return_on_Investment__c = 8,
	    										Income_Growth_Rate__c = 14,
	                                  			Inflation_Rate__c = 10, 
	                                  			Account__c = objAccount.Id,
	                                  			Number_Of_Months__c = 50,
	                                  			Stock_Growth_Rate__c = 14,
	                                  			Gold_Growth_Rate__c = 10,	   /* Prajakta - FP changes - 01-04-2013 */
	                                  			Default_Estimated_Life_Expectancy__c = '80',
	                                  			Default_Retirement_Age__c = '60',
	                                  			No_of_Goals__c = 2,
												Data_Collection_Analysis_Control__c = 'Introduction1; Test1',
										 		Financial_Planing_Output_Report__c = 'Personal Information1;Test2',
												Goals_Allowed_List__c = 'Retirement1;Test3');
	    insert objGlobal1;
	    objAccount.Related_To__c = 'Virtual Partner';
	    objAccount.Virtual_Partner__c = partnerAcc1.Id;
	    update objAccount;
	    
	 
	    Entity_Global_Assumption__c objGlobal = new Entity_Global_Assumption__c 
	    										(Expected_Return_on_Investment__c = 8,
	    										Income_Growth_Rate__c=14,
	                                  			Inflation_Rate__c=10,
	                                  			Account__c=partnerAcc1.Id,
	                                  			Number_Of_Months__c=50,
	                                  			Stock_Growth_Rate__c=14,
	                                  			Gold_Growth_Rate__c=10,	   /* Prajakta - FP changes - 01-04-2013 */
	                                  			Default_Estimated_Life_Expectancy__c='80',
	                                  			Default_Retirement_Age__c='60',
	                                  			No_of_Goals__c = 2,
												Data_Collection_Analysis_Control__c = 'Introduction1; Test1',
										 		Financial_Planing_Output_Report__c= 'Personal Information1;Test2',
												Goals_Allowed_List__c ='Retirement1;Test3');
	                                  		    
	    insert objGlobal;                              			
	    
	    Apexpages.currentPage().getParameters().put('entityId',objAccount.id);
	    GlobalAssumptionController GlobalAssumptionPlan1 = new GlobalAssumptionController();
	    
	    Goal_Profile__c goalProfile2;
	    System.runAs(standardUser[0])
	    {
	    	goalProfile2=new Goal_Profile__c(account__c=objAccount.id,Goal_Profile_Type__c='Customize',Debt_Allocation__c=23,Equity_Allocation__c=32,Gold_allocation__c=33);
	        insert goalProfile2;
	    }
	    
	   GlobalAssumptionPlan1.display();
	   GlobalAssumptionPlan1.save();
	   GlobalAssumptionPlan1.cancel();
	   test.stopTest();
	}
   
    public static testMethod void GlobalAssumptionTest1()
    {
	    Test.startTest();
	    testData();
	    Apexpages.currentPage().getParameters().put('entityId',acc.id);
	    GlobalAssumptionPlan=new GlobalAssumptionController();
	    Goal_Profile__c goalProfile2;
	    System.runAs(standardUser[0])
	    {
	    	goalProfile2=new Goal_Profile__c(account__c=acc.id,Goal_Profile_Type__c='Customize',Debt_Allocation__c=23,Equity_Allocation__c=32,Gold_allocation__c=33);
	        insert goalProfile2;
	    }
	    system.assertNotEquals(null,goalProfile2.id);

	    GlobalAssumptionPlan.display();
	    GlobalAssumptionPlan.save();
		GlobalAssumptionPlan.cancel();   
	    test.stopTest();
	}
	
	
}