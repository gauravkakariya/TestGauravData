
/************** Tested Script to Create ARPP Detail records******************/
Id rtId = [Select Id from RecordType where sobjectType ='Account' and Name='Client'].Id;
//Parent Entity
List<Account> lstAccount = [Select id from Account where Entity_Status__c = 'Active' and RecordTypeId=:rtId and CALENDAR_YEAR(createddate) = 2013 and Id IN ('0012000000yK1z0AAC')];

//Collect All child entities.
List<Account> lstEntity = [SELECT Id,Name FROM Account WHERE Id IN: lstAccount OR Parent_Entity__c IN: lstAccount];

//Action Plan record without Current Running SIP and LUMPSUM
Map<Id, Approve_Action_Plan__c> mapNewIdToActionPlan = new Map<Id, Approve_Action_Plan__c>([Select isSIPexecutionTracker__c, isNewMutualFund__c, isNewLI__c, isMFsipETCreated__c, isLumpsumExecTracker__c, isInsuranceExecutionTracker__c, isExecutionTracker__c, isETcreated__c, Transaction_Type__c, Tenure_of_Insurance__c, SystemModstamp, Sum_Assured_Rs__c, Suggested_LumpSum_Action__c, Suggested_Cover__c, Scheme_Name__c, SIP_Action__c, SIP_Action_Amount__c, Product__c, Product_Name__c, Premium_Amount_Rs__c, Policy_Type__c, Policy_Name__c, Option__c, Name, Lumpsum_Action__c, LastModifiedDate, LastModifiedById, LastActivityDate, Item_Type__c, IsDeleted, Investment_Asset__c, Insured__c, Insurance__c,  Installments__c, Id,Current_SIP__c,Asset_Class__c, Amount__c, Amount_Per_Installment__c, Action_Amount__c, Account__c, AP_Status__c From Approve_Action_Plan__c where Account__c IN: lstEntity and Investment_Asset__c = null]);


//local variables
Map<String, List<Approve_Action_Plan__c>> mapItemTypeTolstAAP = new Map<String, List<Approve_Action_Plan__c>>();
Map<String, Product_Master__c> mapProductNameToPM = new Map<String, Product_Master__c>();
List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();

//MAP Action Plan Proudct with Actual Product Name
Map<String, String> mapActionPlanProductNameToProductMasterName = new Map<String, String>();
for(Action_Plan_Product__c objActionPlanProduct : [select Action_Plan_Product_Name__c, Product_Name__c from Action_Plan_Product__c])
	mapActionPlanProductNameToProductMasterName.put(objActionPlanProduct.Action_Plan_Product_Name__c, objActionPlanProduct.Product_Name__c);

//Execute query and create map of Item type to Action Plan .
for(Approve_Action_Plan__c objAAP : mapNewIdToActionPlan.values())
{
	//Check ET is opened or Not.
	Boolean isET = objAAP.isSIPexecutionTracker__c || objAAP.isLumpsumExecTracker__c || objAAP.isInsuranceExecutionTracker__c;
	if(isET && objAAP.Item_Type__c != '' && objAAP.Item_Type__c != 'Recommended Insurance' && objAAP.Investment_Asset__c == null)
	{
		if(!mapItemTypeTolstAAP.containsKey(objAAP.Item_Type__c))
			mapItemTypeTolstAAP.put(objAAP.Item_Type__c, new List<Approve_Action_Plan__c>{objAAP});
		else
			mapItemTypeTolstAAP.get(objAAP.Item_Type__c).add(objAAP);
		
	}
}

//retrieve all Products where Proudct type = Mutual Fund
List<Product_Master__c> lstSIPorLumpsumPM = [Select (Select Upfront_Commission__c, Trail_Commission__c from Commissions__r where Active__c = true limit 1), 
												Product_Name__c, ProductType__c, Investment_Type__c From Product_Master__c where  ProductType__c = 'Mutual Fund' and Is_Active__c = true];
mapProductNameToPM = new Map<String, Product_Master__c>();
for(Product_Master__c objPM : lstSIPorLumpsumPM)
			mapProductNameToPM.put(objPM.Product_Name__c, objPM);
			
//Update Action Plan where Item type is SIP
if(mapItemTypeTolstAAP.containsKey('SIP'))
{	
	for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('SIP'))	
	{
		Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(objAAP.Product_Name__c));		
		objAAP.Product__c = objPM != null ? objPM.Id : null;
		objAAP.Product_Name__c = objPM.Product_Name__c != null ? objPM.Product_Name__c : null;
		lstApproveActionPlan.add(objAAP);
	}
}

//Update Action Plan where Item type is Lumpsum
if(mapItemTypeTolstAAP.containsKey('Lumpsum'))
{	
	for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('Lumpsum'))	
	{
		Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(objAAP.Product_Name__c));		
		objAAP.Product__c = objPM != null ? objPM.Id : null;
		objAAP.Product_Name__c = objPM.Product_Name__c != null ? objPM.Product_Name__c : null;
		lstApproveActionPlan.add(objAAP);
	}
}

//Fetch Insurance Product
List<Product_Master__c> lstPM = [Select Product_Name__c, ProductType__c, Investment_Type__c, Policy_Type__c,
										(Select Upfront_Commission__c, Trail_Commission__c, Min_Year_Value__c, Max_Year_Value__c from Commissions__r where Active__c = true )
										From Product_Master__c where ProductType__c = 'General Insurance' OR ProductType__c = 'Life Insurance'];


//Life Insurance Product
if(mapItemTypeTolstAAP.containsKey('Life Insurance'))
{									
	mapProductNameToPM = new Map<String, Product_Master__c>();
	for(Product_Master__c objPM : lstPM)
	{
		if(objPM.ProductType__c == 'Life Insurance')
		{
			mapProductNameToPM.put(objPM.Product_Name__c, objPM);
		}
	}
	
	for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('Life Insurance'))	
	{	
		Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(objAAP.Policy_Name__c));
		
		objAAP.Product__c = objPM != null ? objPM.Id : null;
		objAAP.Policy_Name__c = objPM.Product_Name__c != null ? objPM.Product_Name__c : null;
		lstApproveActionPlan.add(objAAP);
	}
}

//General Insurance Product
if(mapItemTypeTolstAAP.containsKey('General Insurance'))
{									
	mapProductNameToPM = new Map<String, Product_Master__c>();
	for(Product_Master__c objPM : lstPM)
	{
		if(objPM.ProductType__c == 'General Insurance')
			mapProductNameToPM.put(objPM.Product_Name__c, objPM);
	}
	for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('General Insurance'))	
	{
		Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(objAAP.Product_Name__c));
		
		objAAP.Product__c = objPM != null ? objPM.Id : null;
		objAAP.Product_Name__c = objPM.Product_Name__c != null ? objPM.Product_Name__c : null;
		lstApproveActionPlan.add(objAAP);
	}
}

//Update Action Plan Record	
if(!lstApproveActionPlan.isEmpty())
	update lstApproveActionPlan;
/**************End Script to Create ARPP Detail records******************/