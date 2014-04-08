
/************** Tested Script to Create ARPP Detail records******************/
Id rtId = [Select Id from RecordType where sobjectType ='Account' and Name='Client'].Id;
//Parent Entity
List<Account> lstAccount = [Select id from Account where Entity_Status__c = 'Active' and RecordTypeId=:rtId and CALENDAR_YEAR(createddate) = 2013 and Id IN ('0012000000yK1z0AAC')];
//Collect All child entities.
List<Account> lstEntity = [SELECT Id,Name FROM Account WHERE Id IN: lstAccount OR Parent_Entity__c IN: lstAccount];
//Action Plan record without Current Running SIP and LUMPSUM
Map<Id, Approve_Action_Plan__c> mapNewIdToActionPlan = new Map<Id, Approve_Action_Plan__c>([Select isWill__c, isWillExecTracker__c, isSIPexecutionTracker__c, isNewMutualFund__c, isNewLI__c, isMFsipETCreated__c, isLumpsumExecTracker__c, isInsuranceExecutionTracker__c, isExecutionTracker__c, isETcreated__c, Transaction_Type__c, Tenure_of_Insurance__c, SystemModstamp, Sum_Assured_Rs__c, Suggested_LumpSum_Action__c, Suggested_Cover__c, Scheme_Name__c, SIP_Action__c, SIP_Action_Amount__c, Remarks__c, Product__c, Product_Name__c, Premium_Amount_Rs__c, Policy_Type__c, Policy_Name__c, Option__c, Name, MF_SIPRemark__c, MF_LumpsumRemark__c, Lumpsum_Gold__c, Lumpsum_Equity__c, Lumpsum_Debt__c, Lumpsum_Action__c, LastModifiedDate, LastModifiedById, LastActivityDate, Item_Type__c, IsDeleted, Investment_Asset__c, Insured__c, Insurance__c, InsuranceRemark__c, Installments__c, Id, Goal__c, Fund__c, Current_SIP__c, CurrencyIsoCode, CreatedDate, CreatedById, Category__c, Asset_Class__c, Amount__c, Amount_Per_Installment__c, Action_Amount__c, Account__c, AP_Status__c From Approve_Action_Plan__c where Account__c IN: lstEntity and Investment_Asset__c = null]);


//local variables
List<ARPP_Detail__c> lstARPPDetail = new List<ARPP_Detail__c>();
Map<String, List<Approve_Action_Plan__c>> mapItemTypeTolstAAP = new Map<String, List<Approve_Action_Plan__c>>();
Map<String, Product_Master__c> mapProductNameToPM = new Map<String, Product_Master__c>();
List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
Set<String> setProductName = new Set<String>();

Map<Id, Account> mapIdToEntity = new Map<Id, Account>([Select Id, Parent_Entity__c from Account where Id IN : lstEntity]);
//MAP Action Plan Proudct with Actual Product Name
Map<String, String> mapActionPlanProductNameToProductMasterName = new Map<String, String>();
for(Action_Plan_Product__c objActionPlanProduct : [select Action_Plan_Product_Name__c, Product_Name__c from Action_Plan_Product__c])
	mapActionPlanProductNameToProductMasterName.put(objActionPlanProduct.Action_Plan_Product_Name__c, objActionPlanProduct.Product_Name__c);

//Execute query and create map of Item type to Action Plan .
for(Approve_Action_Plan__c objAAP : mapNewIdToActionPlan.values())
{
	//Check ET is opened or Not.
	Boolean isET = objAAP.isSIPexecutionTracker__c || objAAP.isLumpsumExecTracker__c || objAAP.isInsuranceExecutionTracker__c;
	if(isET && objAAP.Item_Type__c != '' && objAAP.Item_Type__c != 'Recmmended Insurance')
	{
		if(!mapItemTypeTolstAAP.containsKey(objAAP.Item_Type__c))
			mapItemTypeTolstAAP.put(objAAP.Item_Type__c, new List<Approve_Action_Plan__c>{objAAP});
		else
			mapItemTypeTolstAAP.get(objAAP.Item_Type__c).add(objAAP);
	}
}

//retrieve all Products where Product type = Mutual fund
List<Product_Master__c> lstSIPorLumpsumPM = [Select (Select Upfront_Commission__c, Trail_Commission__c from Commissions__r where Active__c = true limit 1), 
												Product_Name__c, ProductType__c, Investment_Type__c 
											From Product_Master__c where ProductType__c = 'Mutual Fund' and Is_Active__c = true];

mapProductNameToPM = new Map<String, Product_Master__c>();//Collect SIP product from commen list.
for(Product_Master__c objPM : lstSIPorLumpsumPM)
		mapProductNameToPM.put(objPM.Product_Name__c, objPM);
//ARPP record on SIP product 
if(mapItemTypeTolstAAP.containsKey('SIP'))
{
	//Execute SIP Action Plan and create ARPP detail record for each.
	for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('SIP'))	
	{
		
		Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(objAAP.Product_Name__c));
		Commission__c objComm = objPM != null && objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null ;
		ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
		
		//Calcualte Action Plan Trail & Upfront Commission for SIP
		objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
		objARPPDetail.Product__c = objPM != null ? objPM.Id : null;
		objARPPDetail.Commission__c = objComm != null? objComm.Id : null;
		//objARPPDetail.Entity__c = objAAP.Account__c;
		Account objAcc = mapIdToEntity.get(objAAP.Account__c);
		objARPPDetail.Entity__c = objAcc.Parent_Entity__c != null? objAcc.Parent_Entity__c : objAcc.Id;
		objARPPDetail.Action_Plan_Amount__c = objAAP.Amount__c != null ? objAAP.Amount__c : 0;
		objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null && objAAP.Amount__c != null? (objComm.Upfront_Commission__c * 12 * objAAP.Amount__c)/100 : 0;
		Double trailComm = 0;
		Double amount = objAAP.Amount__c != null ? objAAP.Amount__c : 0;
		Integer installment = objAAP.Installments__c <= 12  ? Integer.valueOf(objAAP.Installments__c) : 12;
		if(objPM != null && objAAP.Amount__c != null)
			for(Integer i = 0; i < installment ; i++)
			{
				trailComm += (amount * objComm.Trail_Commission__c)/100;
				amount += objAAP.Amount__c;
			}
		objARPPDetail.Action_Plan_Trial_Comm_Amount__c = trailComm;
		
		objARPPDetail.Type__c = objAAP.Item_Type__c;
		objARPPDetail.Remark__c = (objPM == null ? 'Product Detail is not Found' : (objComm == null ? 'Commission Detail is not found' : ''));
		
		lstARPPDetail.add(objARPPDetail);
	}
}

//Lumpsum Product
if(mapItemTypeTolstAAP.containsKey('Lumpsum'))
{
	for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('Lumpsum'))	
	{
		
		Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(objAAP.Product_Name__c));
		Commission__c objComm =  objPM != null && objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null ;
		ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
		
		//Calcualte Action Plan Trail & Upfront Commission for Lumpsum
		objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
		objARPPDetail.Product__c = objPM != null ? objPM.Id : null;
		//objARPPDetail.Entity__c = objAAP.Account__c;
		Account objAcc = mapIdToEntity.get(objAAP.Account__c);
		objARPPDetail.Entity__c = objAcc.Parent_Entity__c != null? objAcc.Parent_Entity__c : objAcc.Id;
		objARPPDetail.Commission__c = objComm != null? objComm.Id : null;
		
		objARPPDetail.Action_Plan_Amount__c = objAAP.Amount__c != null ? objAAP.Amount__c : 0;
		objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null && objAAP.Amount__c != null? (objComm.Upfront_Commission__c * 12 * objAAP.Amount__c)/100 : 0;
		objARPPDetail.Action_Plan_Trial_Comm_Amount__c =  objPM != null && objComm != null && objAAP.Amount__c != null? (objComm.Trail_Commission__c * 12 * objAAP.Amount__c)/100 : 0;
		
		objARPPDetail.Type__c = objAAP.Item_Type__c;
		objARPPDetail.Remark__c = (objPM == null ? 'Product Detail is not Found' : (objComm == null ? 'Commission Detail is not found' : ''));
		
		lstARPPDetail.add(objARPPDetail);
	}
}

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
			mapProductNameToPM.put(objPM.Product_Name__c, objPM);
	}
	
	for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('Life Insurance'))	
	{	
		Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(objAAP.Policy_Name__c));
		List<Commission__c> lstCommission = objPM != null ? objPM.Commissions__r : null;
		Commission__c objComm;
		if(lstCommission != null)
		{
			for(Commission__c comm : lstCommission)
			{
				if(comm.Min_Year_Value__c <= objAAP.Tenure_of_Insurance__c && objAAP.Tenure_of_Insurance__c < comm.Max_Year_Value__c)
				{
					objComm = comm;
					break;
				}
			}
		}
		
		//Calcualte Action Plan Trail & Upfront Commission for Life Insurance
		ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
		objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
		objARPPDetail.Product__c = objPM != null ? objPM.Id : null;
		objARPPDetail.Commission__c = objComm != null? objComm.Id : null;
		//objARPPDetail.Entity__c = objAAP.Account__c;
		Account objAcc = mapIdToEntity.get(objAAP.Account__c);
		objARPPDetail.Entity__c = objAcc.Parent_Entity__c != null? objAcc.Parent_Entity__c : objAcc.Id;
		
		objARPPDetail.Action_Plan_Amount__c = objAAP.Sum_Assured_Rs__c != null ? objAAP.Sum_Assured_Rs__c: 0;
		objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null && objAAP.Sum_Assured_Rs__c != null?(objAAP.Sum_Assured_Rs__c != null ?(objComm.Upfront_Commission__c * objAAP.Sum_Assured_Rs__c)/100 : 0) : 0;
		objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
		
		objARPPDetail.Type__c = objAAP.Item_Type__c;
		objARPPDetail.Remark__c = (objPM == null ? 'Product Detail is not Found' : (objComm == null ? 'Commission Detail is not found' : ''));
		
		lstARPPDetail.add(objARPPDetail);
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
	
	//Calcualte Action Plan Trail & Upfront Commission
	for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('General Insurance'))	
	{
		Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(objAAP.Product_Name__c));
		Commission__c objComm =  objPM != null && objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null ;
		ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
		
		objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
		objARPPDetail.Product__c = objPM != null ? objPM.Id : null;
		//objARPPDetail.Entity__c = objAAP.Account__c;
		
		Account objAcc = mapIdToEntity.get(objAAP.Account__c);
		objARPPDetail.Entity__c = objAcc.Parent_Entity__c != null? objAcc.Parent_Entity__c : objAcc.Id;
		objARPPDetail.Commission__c = objComm != null? objComm.Id : null;
		
		objARPPDetail.Action_Plan_Amount__c = objAAP.Sum_Assured_Rs__c != null ? objAAP.Sum_Assured_Rs__c : 0;
		objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null && objAAP.Sum_Assured_Rs__c != null? (objAAP.Sum_Assured_Rs__c  != null ?(objComm.Upfront_Commission__c * objAAP.Sum_Assured_Rs__c )/100 : 0) : 0;
		objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
		
		objARPPDetail.Type__c = objAAP.Item_Type__c;
		objARPPDetail.Remark__c = (objPM == null ? 'Product Detail is not Found' : (objComm == null ? 'Commission Detail is not found' : ''));
		
		lstARPPDetail.add(objARPPDetail);
	}
}

//Insert Arpp Detail Record
if(!lstARPPDetail.isEmpty())
	insert lstARPPDetail;


/**************End Script to Create ARPP Detail records******************/