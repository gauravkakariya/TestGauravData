
/**************Script to Create ARPP Detail records******************/
Id rtId = [Select Id from RecordType where sobjectType ='Account' and Name='Client'].Id;
List<Account> lstAccount = [Select id from Account where Entity_Status__c = 'Active' and RecordTypeId=:rtId and Id = '001W0000005xb4UIAQ'];

List<Account> lstEntity = [SELECT Id,Name FROM Account WHERE Id IN: lstAccount OR Parent_Entity__c IN: lstAccount];
System.debug('---------------------lstEntity----'+lstEntity);

Map<Id, Approve_Action_Plan__c> mapNewIdToActionPlan = new Map<Id, Approve_Action_Plan__c>([Select isWill_del__c, isWill__c, isWillExecTracker__c, isSIPexecutionTracker__c, isNewMutualFund__c, isNewLI__c, isMFsipETCreated__c, isLumpsumExecTracker__c, isInsuranceExecutionTracker__c, isExecutionTracker__c, isETcreated__c, Transaction_Type__c, Tenure_of_Insurance__c, SystemModstamp, Sum_Assured_Rs__c, Suggested_LumpSum_Action__c, Suggested_Cover__c, Scheme_Name__c, SIP_Action__c, SIP_Action_Amount__c, Remarks__c, Product__c, Product_Name__c, Premium_Amount_Rs__c, Policy_Type__c, Policy_Name__c, Option__c, Name, MF_SIPRemark__c, MF_LumpsumRemark__c, Lumpsum_Gold__c, Lumpsum_Equity__c, Lumpsum_Debt__c, Lumpsum_Action__c, LastModifiedDate, LastModifiedById, LastActivityDate, Item_Type__c, IsDeleted, Investment_Asset__c, Insured__c, Insurance__c, InsuranceRemark__c, Installments__c, Id, Goal__c, Fund__c, Current_SIP__c, CurrencyIsoCode, CreatedDate, CreatedById, Category__c, Asset_Class__c, Amount__c, Amount_Per_Installment__c, Action_Amount__c, Account__c, AP_Status__c From Approve_Action_Plan__c where Account__c IN: lstEntity]);


//local variables
List<ARPP_Detail__c> lstARPPDetail = new List<ARPP_Detail__c>();
Map<String, List<Approve_Action_Plan__c>> mapItemTypeTolstAAP = new Map<String, List<Approve_Action_Plan__c>>();
Map<String, Product_Master__c> mapProductNameToPM = new Map<String, Product_Master__c>();
List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
String strQuery = ' Select Insurance__r.Policy_Type__c, ';
Map<String, Schema.SObjectField> mapAAPFieldNameToFieldDescribe = Approve_Action_Plan__c.sObjectType.getDescribe().fields.getMap();

//Create Dynamic query
for(String strField : mapAAPFieldNameToFieldDescribe.keySet())
{
	strQuery += strField +',';
}
strQuery = strQuery.substring(0, strQuery.length() - 1);
Set<Id>  setAAPId = new Set<Id>();
setAAPId.addAll(mapNewIdToActionPlan.keySet());

strQuery += ' from Approve_Action_Plan__c where Id IN: setAAPId  ';	

Set<String> setProductName = new Set<String>();

//Execute query and create map of Item type to Action Plan .
for(Approve_Action_Plan__c objAAP : Database.query(strQuery))
{
	//Check ET is opened or Not.
	Boolean isET = objAAP.isSIPexecutionTracker__c || objAAP.isLumpsumExecTracker__c || objAAP.isInsuranceExecutionTracker__c;
	if(isET && objAAP.Item_Type__c != '' && objAAP.Item_Type__c != 'Recmmended Insurance')
	{
		if(!mapItemTypeTolstAAP.containsKey(objAAP.Item_Type__c))
			mapItemTypeTolstAAP.put(objAAP.Item_Type__c, new List<Approve_Action_Plan__c>{objAAP});
		else
			mapItemTypeTolstAAP.get(objAAP.Item_Type__c).add(objAAP);
		
		//Collect all SIP and Lumpsum product Name.	
		if(objAAP.Item_Type__c == 'SIP' || objAAP.Item_Type__c == 'Lumpsum')
			setProductName.add(objAAP.Product_Name__c);
	}
}

//retrieve all Products where Investment type either SIP or Lumpsum 
List<Product_Master__c> lstSIPorLumpsumPM = [Select (Select Upfront_Commission__c, Trail_Commission__c from Commissions__r where Active__c = true limit 1), 
												Product_Name__c, ProductType__c, Investment_Type__c 
											From Product_Master__c where Product_Name__c IN: setProductName and (Investment_Type__c = 'SIP' or Investment_Type__c = 'Lumpsum')];
//ARPP record on SIP product 
if(mapItemTypeTolstAAP.containsKey('SIP'))
{
	mapProductNameToPM = new Map<String, Product_Master__c>();
	
	//Collect SIP product from commen list.
	for(Product_Master__c objPM : lstSIPorLumpsumPM)
		if(objPM.Investment_Type__c == 'SIP')
			mapProductNameToPM.put(objPM.Product_Name__c, objPM);
			
	//Execute SIP Action Plan and create ARPP detail record for each.
	for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('SIP'))	
	{
		Product_Master__c objPM = mapProductNameToPM.get(objAAP.Product_Name__c);
		Commission__c objComm = objPM != null && objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null ;
		ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
		
		//Calcualte Action Plan Trail & Upfront Commission for SIP
		objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
		objARPPDetail.Product__c = objPM != null && objComm != null? objPM.Id : null;
		objARPPDetail.Commission__c = objComm != null? objComm.Id : null;
		objARPPDetail.Entity__c = objAAP.Account__c;
		
		objARPPDetail.Action_Plan_Amount__c = objAAP.Amount__c;
		objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null ? (objComm.Upfront_Commission__c * 12 * objAAP.Amount__c)/100 : 0;
		Double trailComm = 0;
		Double amount = objAAP.Amount__c;
		Integer installment = objAAP.Installments__c <= 12  ? Integer.valueOf(objAAP.Installments__c) : 12;
		if(objPM != null )
			for(Integer i = 0; i < installment ; i++)
			{
				trailComm += (amount * objComm.Trail_Commission__c)/100;
				amount += objAAP.Amount__c;
			}
		objARPPDetail.Action_Plan_Trial_Comm_Amount__c = trailComm;
		
		objARPPDetail.Type__c = objAAP.Item_Type__c;
		objARPPDetail.Remark__c = (objPM == null ? 'Product Detail is not Found' : (objComm == null ? 'Commission Detail is not found' : ''));
		
		lstARPPDetail.add(objARPPDetail);
		
		objAAP.Product__c = objPM != null ? objPM.Id : null;
		lstApproveActionPlan.add(objAAP);
	}
}

//Lumpsum Product
if(mapItemTypeTolstAAP.containsKey('Lumpsum'))
{									
	mapProductNameToPM = new Map<String, Product_Master__c>();
	for(Product_Master__c objPM : lstSIPorLumpsumPM)
		if(objPM.Investment_Type__c == 'Lumpsum')
			mapProductNameToPM.put(objPM.Product_Name__c, objPM);
	
	for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('Lumpsum'))	
	{
		Product_Master__c objPM = mapProductNameToPM.get(objAAP.Product_Name__c);
		Commission__c objComm =  objPM != null && objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null ;
		ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
		
		//Calcualte Action Plan Trail & Upfront Commission for Lumpsum
		objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
		objARPPDetail.Product__c = objPM != null ? objPM.Id : null;
		objARPPDetail.Entity__c = objAAP.Account__c;
		objARPPDetail.Commission__c = objComm != null? objComm.Id : null;
		
		objARPPDetail.Action_Plan_Amount__c = objAAP.Amount__c;
		objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null ? (objComm.Upfront_Commission__c * 12 * objAAP.Amount__c)/100 : 0;
		objARPPDetail.Action_Plan_Trial_Comm_Amount__c =  objPM != null && objComm != null ? (objComm.Trail_Commission__c * 12 * objAAP.Amount__c)/100 : 0;
		
		objARPPDetail.Type__c = objAAP.Item_Type__c;
		objARPPDetail.Remark__c = (objPM == null ? 'Product Detail is not Found' : (objComm == null ? 'Commission Detail is not found' : ''));
		
		lstARPPDetail.add(objARPPDetail);
		
		objAAP.Product__c = objPM != null ? objPM.Id : null;
		lstApproveActionPlan.add(objAAP);
	}
}

List<Product_Master__c> lstPM = [Select Upfront_Commission__c, Trail_Commission__c, Product_Name__c, ProductType__c, Investment_Type__c, Policy_Type__c,
										(Select Upfront_Commission__c, Trail_Commission__c, Min_Year_Value__c, Max_Year_Value__c from Commissions__r where Active__c = true )
										From Product_Master__c where ProductType__c = 'General Insurance' OR ProductType__c = 'Life Insurance'];


//Life Insurance Product
if(mapItemTypeTolstAAP.containsKey('Life Insurance'))
{									
	mapProductNameToPM = new Map<String, Product_Master__c>();
	for(Product_Master__c objPM : lstPM)
	{
		if(objPM.ProductType__c == 'Life Insurance')
			mapProductNameToPM.put(objPM.Product_Name__c + '~' + objPM.Policy_Type__c, objPM);
	}
	
	for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('Life Insurance'))	
	{	
		Product_Master__c objPM = mapProductNameToPM.get(objAAP.Policy_Name__c + '~' + objAAP.Insurance__r.Policy_Type__c);
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
		objARPPDetail.Entity__c = objAAP.Account__c;
		
		objARPPDetail.Action_Plan_Amount__c = objAAP.Sum_Assured_Rs__c;
		objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null ?(objAAP.Sum_Assured_Rs__c != null ?(objComm.Upfront_Commission__c * objAAP.Sum_Assured_Rs__c)/100 : 0) : 0;
		objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
		
		objARPPDetail.Type__c = objAAP.Item_Type__c;
		objARPPDetail.Remark__c = (objPM == null ? 'Product Detail is not Found' : (objComm == null ? 'Commission Detail is not found' : ''));
		
		lstARPPDetail.add(objARPPDetail);
		
		objAAP.Product__c = objPM != null ? objPM.Id : null;
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
			mapProductNameToPM.put(objPM.Product_Name__c + '~' + objPM.Policy_Type__c, objPM);
	}
	
	//Calcualte Action Plan Trail & Upfront Commission
	for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('General Insurance'))	
	{
		Product_Master__c objPM = mapProductNameToPM.get(objAAP.Product_Name__c + '~' + objAAP.Policy_Type__c);
		Commission__c objComm =  objPM != null && objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null ;
		ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
		
		objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
		objARPPDetail.Product__c = objPM != null ? objPM.Id : null;
		objARPPDetail.Entity__c = objAAP.Account__c;
		objARPPDetail.Commission__c = objComm != null? objComm.Id : null;
		
		objARPPDetail.Action_Plan_Amount__c = objAAP.Sum_Assured_Rs__c ;
		objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null ? (objAAP.Sum_Assured_Rs__c  != null ?(objComm.Upfront_Commission__c * objAAP.Sum_Assured_Rs__c )/100 : 0) : 0;
		objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
		
		objARPPDetail.Type__c = objAAP.Item_Type__c;
		objARPPDetail.Remark__c = (objPM == null ? 'Product Detail is not Found' : (objComm == null ? 'Commission Detail is not found' : ''));
		
		lstARPPDetail.add(objARPPDetail);
		
		objAAP.Product__c = objPM != null ? objPM.Id : null;
		lstApproveActionPlan.add(objAAP);
	}
}

//Insert Arpp Detail Record
if(!lstARPPDetail.isEmpty())
	insert lstARPPDetail;

//Update Action Plan Record	
if(!lstApproveActionPlan.isEmpty())
	update lstApproveActionPlan;
/**************End Script to Create ARPP Detail records******************/