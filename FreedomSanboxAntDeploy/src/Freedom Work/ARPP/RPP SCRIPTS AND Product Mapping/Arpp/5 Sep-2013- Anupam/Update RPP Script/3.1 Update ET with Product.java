/************** Tested Update product with ET******************/
Id rtId = [Select Id from RecordType where sobjectType ='Account' and Name='Client'].Id;
List<Account> lstAccount = [Select id from Account where Entity_Status__c = 'Active' and RecordTypeId=:rtId and Id IN('00120000012BJw3',
'0012000000jbf5V',
'0012000000zI4BI',
'00120000011DaUF',
'0012000000s2NbV',
'00120000010Oxqk',
'0012000000yEuod')
];

List<Account> lstEntity = [SELECT Id,Name FROM Account WHERE Id IN: lstAccount OR Parent_Entity__c IN: lstAccount];

Map<Id, Execution_Tracker__c> mapNewIdToET = new Map<Id, Execution_Tracker__c>([Select Type__c, Execution_Tracker_Product__c,  Executed_Product_Name__c From Execution_Tracker__c where Entity_Name__c IN:lstEntity And ParentExecutionTracker__c = NULL and Execution_Tracker_Product__c = null and Approve_Action_Plan__r.Investment_Asset__c = null]);


//local variables
Map<String, List<Execution_Tracker__c>> mapItemTypeTolstET = new Map<String, List<Execution_Tracker__c>>();
Map<String, Product_Master__c> mapProductNameToPM = new Map<String, Product_Master__c>();
List<Execution_Tracker__c> lstExecutionTracker = new List<Execution_Tracker__c>();

Map<String, String> mapActionPlanProductNameToProductMasterName = new Map<String, String>();
for(Action_Plan_Product__c objActionPlanProduct : [select Action_Plan_Product_Name__c, Product_Name__c from Action_Plan_Product__c where CreatedDate = TODAY])
	mapActionPlanProductNameToProductMasterName.put(objActionPlanProduct.Action_Plan_Product_Name__c, objActionPlanProduct.Product_Name__c);


Set<String> setProductName = new Set<String>();

//Execute query and create map of Item type to ETs .
for(Execution_Tracker__c objET : mapNewIdToET.values())
{
	if(!mapItemTypeTolstET.containsKey(objET.Type__c ))
			mapItemTypeTolstET.put(objET.Type__c , new List<Execution_Tracker__c>{objET});
	else
		mapItemTypeTolstET.get(objET.Type__c ).add(objET);
	
	
}

//retrieve all Products where product type = Mutual fund
List<Product_Master__c> lstSIPorLumpsumPM = [Select (Select Upfront_Commission__c, Trail_Commission__c from Commissions__r where Active__c = true limit 1), 
												Product_Name__c, ProductType__c, Investment_Type__c 
											From Product_Master__c where ProductType__c = 'Mutual Fund' and Is_Active__c = true];
//ARPP record on SIP product 
mapProductNameToPM = new Map<String, Product_Master__c>();
	

for(Product_Master__c objPM : lstSIPorLumpsumPM)
		mapProductNameToPM.put(objPM.Product_Name__c, objPM);

//update ET  for with SIP proudct		
if(mapItemTypeTolstET.containsKey('SIP'))
{	
	for(Execution_Tracker__c objET : mapItemTypeTolstET.get('SIP'))	
	{
		
		Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(objET.Executed_Product_Name__c));		
		objET.Execution_Tracker_Product__c = objPM != null ? objPM.Id : null;
		objET.Executed_Product_Name__c = objPM.Product_Name__c != null ? objPM.Product_Name__c : null;
		lstExecutionTracker.add(objET);
	}
}

//Lumpsum Product
if(mapItemTypeTolstET.containsKey('Lumpsum'))
{	
	for(Execution_Tracker__c objET : mapItemTypeTolstET.get('Lumpsum'))	
	{
		Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(objET.Executed_Product_Name__c));		
		objET.Execution_Tracker_Product__c = objPM != null ? objPM.Id : null;
		objET.Executed_Product_Name__c = objPM.Product_Name__c != null ? objPM.Product_Name__c : null;
		
		lstExecutionTracker.add(objET);
	}
}

List<Product_Master__c> lstPM = [Select Product_Name__c, ProductType__c, Investment_Type__c, Policy_Type__c,
										(Select Upfront_Commission__c, Trail_Commission__c, Min_Year_Value__c, Max_Year_Value__c from Commissions__r where Active__c = true )
										From Product_Master__c where ProductType__c = 'General Insurance' OR ProductType__c = 'Life Insurance'];


//Life Insurance Product
if(mapItemTypeTolstET.containsKey('Life Insurance'))
{									
	mapProductNameToPM = new Map<String, Product_Master__c>();
	for(Product_Master__c objPM : lstPM)
	{
		if(objPM.ProductType__c == 'Life Insurance')
		{
			mapProductNameToPM.put(objPM.Product_Name__c, objPM);
		}
	}
	
	for(Execution_Tracker__c objET  : mapItemTypeTolstET.get('Life Insurance'))	
	{	
		Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(objET.Executed_Product_Name__c));
		
		objET.Execution_Tracker_Product__c = objPM != null ? objPM.Id : null;
		objET.Executed_Product_Name__c = objPM.Product_Name__c != null ? objPM.Product_Name__c : null;
		
		lstExecutionTracker.add(objET);
	}
}

//General Insurance Product
if(mapItemTypeTolstET.containsKey('General Insurance'))
{									
	mapProductNameToPM = new Map<String, Product_Master__c>();
	for(Product_Master__c objPM : lstPM)
	{
		if(objPM.ProductType__c == 'General Insurance')
			mapProductNameToPM.put(objPM.Product_Name__c, objPM);
	}
	
	for(Execution_Tracker__c objET : mapItemTypeTolstET.get('General Insurance'))	
	{
		Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(objET.Executed_Product_Name__c));
		
		objET.Execution_Tracker_Product__c = objPM != null ? objPM.Id : null;
		objET.Executed_Product_Name__c = objPM.Product_Name__c != null ? objPM.Product_Name__c : null;
		
		lstExecutionTracker.add(objET);
	}
}

//Update Action Plan Record	
if(!lstExecutionTracker.isEmpty())
	update lstExecutionTracker;
/**************End Script to Create ARPP Detail records******************/