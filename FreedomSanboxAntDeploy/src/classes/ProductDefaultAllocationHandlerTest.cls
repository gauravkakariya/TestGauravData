/*
    Revision History:
    Version     Version Author    Date              Comments
    1.0         Prajakta Sanap   28/11/2013   1. Test Class for ProductDefaultAllocationTrigger
                                 
*/


@isTest
private class ProductDefaultAllocationHandlerTest 
{
    public static User objUser1;
    public static Business_Unit__c objBU1;
    public static Department__c objDept1;
    public static Department__c objDept2;
    public static Department__c objDept3;
    public static Department__c objDept4;
    
    public static Team_Member__c objTM1;
    public static Team_Member__c objTM2;
    public static Team_Member__c objTM3;
    public static Team_Member__c objTM4;
    
    public static Account virtualAcc1;
    public static Account objAccount;
    public static TestData_Ffreedom testData;
    
    public static Product_Manufacturer_Master__c objPMM;
    public static Product_Master__c objProductMaster;
    public static Product_Default_Allocation__c objPDA;
    
    
    
    @isTest
    public static void TestData() 
    {
    	testData = new TestData_Ffreedom();
    	
    	List<User> lstUser = new List<User>();
    	objUser1 = testData.initializeUser();
    	lstUser.add(objUser1);
    	insert lstUser;
    	
    	List<Business_Unit__c> lstBU = new List<Business_Unit__c>();
    	objBU1 = testData.init_Business_Unit('BU1');
    	lstBU.add(objBU1);
    	insert lstBU;
    	
    	List<Department__c> lstDepartment = new List<Department__c>();
    	objDept1 = testData.init_Department('PST', objBU1.Id);
    	objDept2 = testData.init_Department('MST', objBU1.Id);
    	objDept3 = testData.init_Department('FPA', objBU1.Id);
    	objDept4 = testData.init_Department('MST2 (Operations)', objBU1.Id);
    	
    	lstDepartment.add(objDept1);
    	lstDepartment.add(objDept2);
    	lstDepartment.add(objDept3);
    	lstDepartment.add(objDept4);
    	insert lstDepartment;
    	
    	List<Team_Member__c> lstTeam_Member = new List<Team_Member__c>();
    	objTM1 = testData.init_Team_Member(objUser1.Id, objDept1.Id);
    	objTM2 = testData.init_Team_Member(objUser1.Id, objDept2.Id);
    	objTM3 = testData.init_Team_Member(objUser1.Id, objDept3.Id);
    	objTM4 = testData.init_Team_Member(objUser1.Id, objDept4.Id);
    	
    	lstTeam_Member.add(objTM1);
    	lstTeam_Member.add(objTM2);
    	lstTeam_Member.add(objTM3);
    	lstTeam_Member.add(objTM4);
    	insert lstTeam_Member;
    	
    	List<Account> lstVirtualAcc = new List<Account>();
    	virtualAcc1 = testData.initVirtualAccount();
    	virtualAcc1.Business_Unit__c = objBU1.Id;
    	virtualAcc1.PST_Team_Member__c = objTM1.Id;
    	virtualAcc1.MST_Team_Member__c = objTM2.Id;
    	virtualAcc1.FPA_Team_Member__c = objTM3.Id;
    	virtualAcc1.OPS_Team_Member__c = objTM4.Id;
    	lstVirtualAcc.add(virtualAcc1);
    	insert lstVirtualAcc;
    	
    	objAccount = testData.initializeAccount();
    	objAccount.Business_Unit__c = objBU1.Id;
    	objAccount.Virtual_Partner__c = virtualAcc1.Id;
    	objAccount.PST_Team_Member__c = objTM1.Id;
    	objAccount.MST_Team_Member__c = objTM2.Id;
    	objAccount.FPA_Team_Member__c = objTM3.Id;
    	objAccount.OPS_Team_Member__c = objTM4.Id;
    	objAccount.OwnerId = objUser1.Id;
	    insert objAccount;
	    
	    Schema.DescribeSObjectResult DESCRIBE_RESULT = Product_Default_Allocation__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_PM = Product_Master__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MASTER = DESCRIBE_RESULT_PM.getRecordTypeInfosByName();
	    
	    objPMM = testData.init_PMM('Birla1', 'Birla1', True);
	    insert objPMM; 
	    objProductMaster = testData.init_ProductMaster(objPMM, 'Life Insurance', 'Birla Sun Life Dynamic Bond Fund', 'No', 'Insurance', 'Life Insurance');
		objProductMaster.RecordTypeId = RECORD_TYPE_INFO_MASTER.get('Life Insurance').getRecordTypeId();  													
	    insert objProductMaster;
	    system.debug('------------objProductMaster-----------------'+objProductMaster);
	    objPDA = testData.init_Product_Default_Allocation(objBU1, objProductMaster, 1, 0, 3, 20, '', '');
	    
	    insert objPDA; 
    }
    
    @isTest
    public static void DupeCheckforSequenceTest() 
    {
    	TestData();
    	Schema.DescribeSObjectResult DESCRIBE_RESULT = Product_Default_Allocation__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
	    Test.startTest();
		try
		{
			Product_Default_Allocation__c objProd = new Product_Default_Allocation__c();
		    objProd = testData.init_Product_Default_Allocation(objBU1, objProductMaster, 1, 0, 3, 20, '', '');
			insert objProd;	 
		}
		catch(Exception e)
		{
			//System.Assert(e.getMessage().contains('Duplicate'));
		}   													
	    Test.stopTest();
    }
    
    @isTest
    public static void DupeCheckofProductForSamePartnerTest() 
    {
    	TestData();
    	Schema.DescribeSObjectResult DESCRIBE_RESULT = Product_Default_Allocation__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
	    Test.startTest();
		try
		{
			Product_Default_Allocation__c objProd = new Product_Default_Allocation__c();
		    objProd = testData.init_Product_Default_Allocation_Partner(virtualAcc1, objProductMaster, 1, 0, 3, 20, '', '');
			insert objProd;	 
		}
		catch(Exception e)
		{
			//System.Assert(e.getMessage().contains('Duplicate'));
		}   													
	    Test.stopTest();
    }
}