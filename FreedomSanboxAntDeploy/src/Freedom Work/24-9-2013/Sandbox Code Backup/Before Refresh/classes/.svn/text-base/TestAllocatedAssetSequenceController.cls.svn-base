public class TestAllocatedAssetSequenceController 
{
	@isTest(SeeAllData = true)
    static void testAllocatedAssetSequence() 
    {
        Account objAccount = new Account(LastName='Last', RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c, FirstName='First',Parent_Entity__c = null);
		insert objAccount;
		
		Goal__c objGoal = new Goal__c(Entity__c = objAccount.id, Description__c='Education');
    	insert objGoal;
    	 
    	Asset__c asset1 = new Asset__c(Entity__c = objAccount.id,Accumulated_Value__c=10000,Account_Type__c='EPF',RecordTypeId= AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c,action__c='ABC',
                                   Asset_Types__c='ABC',Current_Value__c=1000); 
     	insert asset1;
    	
        Asset__c asset2 = new Asset__c(Entity__c = objAccount.id, Accumulated_Value__c=10000, Account_Type__c='EPF', RecordTypeId = AssetRecTypes__c.getInstance('Business Assets').RecordTypeId__c, 
        								action__c='ABC', Asset_Types__c=null, Current_Value__c=1000);
     	insert asset2;
     	
        Investment_Asset__c insv = new Investment_Asset__c(Entity__c = objAccount.id, Asset_Type__c='RBI Bonds', Face_Value__c=1000, Quantity__c =10,
                                                           RecordTypeId = InvestmentAsset__c.getInstance('Fixed Income').RecordTypeId__c, action__c='ABC');
        insert insv;
        
      	Insurance__c ins = new Insurance__c(Entity__c = objAccount.id, Policy_Type__c='Whole Life', Premium_Frequency__c ='quarterly', Premium_Amount_Rs__c=1000, 
      										Tenure_of_Insurance__c = 12, Death_Benefit_Rs__c = 100000, RecordTypeId = InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c, action__c='ABC');
        insert ins;
    	
    	GoalAssetAssociation__c gasset = new GoalAssetAssociation__c(Asset__c = asset1.id, Goal__c = objGoal.id, Allocated__c = 25, Allocation_order__c = 1);
        insert gasset;
        
      	GoalInvestmentAssetAssociation__c ginv = new GoalInvestmentAssetAssociation__c(Investment_Asset__c = insv.id, Goal__c = objGoal.id, Allocated__c=60, Allocation_order__c = 2);
        insert ginv;
        
      	GoalInsuranceAssociation__c gins = new GoalInsuranceAssociation__c(Insurance__c = ins.id, Goal__c = objGoal.id, Allocated__c=30, Allocation_order__c = 3);
       	insert gins;
      
      	GoalAssetAssociation__c gasset1 = new GoalAssetAssociation__c(Asset__c = asset2.id, Goal__c = objGoal.id, Allocated__c = 25, Allocation_order__c = 4);
        insert gasset1; 
        
    	Apexpages.currentPage().getParameters().put('gid', objGoal.Id);
    	AllocatedAssetSequenceController objAllocatedAssetSequenceController = new AllocatedAssetSequenceController();
    	objAllocatedAssetSequenceController.getOrderList();
    	objAllocatedAssetSequenceController.saveOrder();
    }
 
}