 String selRecordTypeId =( InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c);
 
 
 
 Map<Id, Investment_Asset__c> investmentMap= new Map<Id, Investment_Asset__c>([
                                                SELECT Id,
                                                    AMC_Name__c , Purchase_Price__c,Fund__c,Units__c,Purchase_NAV__c,Monthly_SIP_Amount__c,RecordTypeId,Entity__c,Scheme_Name_Text__c,Acquisition_Date__c,Quantity__c,Description__c,
                                                    Face_Value__c,Coupon_Rate__c,Maturity_Value__c,Asset_Type__c,Maturity_Date__c 
                                                    ,Is_Include_In_HLV_Inv_Asset__c
                                                FROM 
                                                    Investment_Asset__c 
                                                WHERE RecordTypeId =: selRecordTypeId
												and DAY_IN_MONTH(createddate) = 1
                                            ]);    
											
											
system.debug('***********investmentMap******'+investmentMap);



Map<String, Product_Master__c> mapProductNameToPM = new Map<String, Product_Master__c>();
List<Investment_Asset__c> lstinvestment = new List<Investment_Asset__c>();
set<string> setSchemeName = new set<string>();
Map<Id, Investment_Asset__c> mapinvestmentIdToAsset = new Map<Id, Investment_Asset__c>();

//MAP Action Plan Proudct with Actual Product Name
Map<String, String> mapActionPlanProductNameToProductMasterName = new Map<String, String>();

for(Action_Plan_Product__c objActionPlanProduct : [select Action_Plan_Product_Name__c, Product_Name__c from Action_Plan_Product__c Where CreatedDate = Today])
	mapActionPlanProductNameToProductMasterName.put(objActionPlanProduct.Action_Plan_Product_Name__c, objActionPlanProduct.Product_Name__c);

//Execute query and create map of Item type to Action Plan .
for(Investment_Asset__c objInv : investmentMap.values())
{
	mapinvestmentIdToAsset.put(objInv.Id, objInv);
	setSchemeName.add(objInv.Scheme_Name_Text__c);
	
}

//retrieve all Products where Proudct type = Mutual Fund
List<Product_Master__c> lstSIPorLumpsumPM = [Select
												Product_Name__c, ProductType__c, Investment_Type__c From Product_Master__c where  ProductType__c = 'Mutual Fund' and Is_Active__c = true];
												
mapProductNameToPM = new Map<String, Product_Master__c>();
for(Product_Master__c objPM : lstSIPorLumpsumPM)
			mapProductNameToPM.put(objPM.Product_Name__c, objPM);
			
//Update Investment_Asset__c
	
	for(Investment_Asset__c objinvestment : investmentMap.values())	
	{
		Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(objinvestment.Scheme_Name_Text__c));
		if(objPM != null)
		{
			objinvestment.Scheme_Name_Text__c = objPM != null && objPM.Product_Name__c != null ? objPM.Product_Name__c : objinvestment.Scheme_Name_Text__c;
			lstinvestment.add(objinvestment);
		}	
	}
List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();


Map<Id, Approve_Action_Plan__c> mapNewIdToActionPlan = new Map<Id, Approve_Action_Plan__c>([Select isSIPexecutionTracker__c, isNewMutualFund__c, isNewLI__c, isMFsipETCreated__c, isLumpsumExecTracker__c, isInsuranceExecutionTracker__c, isExecutionTracker__c, isETcreated__c, Transaction_Type__c, Tenure_of_Insurance__c, SystemModstamp, Sum_Assured_Rs__c, Suggested_LumpSum_Action__c, Suggested_Cover__c, Goal__c,Scheme_Name__c, SIP_Action__c, SIP_Action_Amount__c, Product__c, Product_Name__c, Premium_Amount_Rs__c, Policy_Type__c, Policy_Name__c, Option__c, Name, Lumpsum_Action__c, LastModifiedDate, LastModifiedById, LastActivityDate, Item_Type__c, IsDeleted, Investment_Asset__c, Insured__c, Insurance__c,  Installments__c, Id,Current_SIP__c,Asset_Class__c, Amount__c, Amount_Per_Installment__c, Action_Amount__c, Account__c, AP_Status__c From Approve_Action_Plan__c where Investment_Asset__c IN : mapinvestmentIdToAsset.keySet()]);

			
//Update Action Plan where Item type is SIP
	
	for(Approve_Action_Plan__c objAAP : mapNewIdToActionPlan.values())	
	{
		Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(objAAP.Scheme_Name__c));	
		if(objPM != null && objAAP.Investment_Asset__c != null)
		{
			objAAP.Product__c = objPM != null ? objPM.Id : null;
			objAAP.Scheme_Name__c = objPM.Product_Name__c != null ? objPM.Product_Name__c : null;
			lstApproveActionPlan.add(objAAP);
		}
	}


system.debug('********lstApproveActionPlan'+lstApproveActionPlan.size());
	

if(lstinvestment.size() > 0)
	update lstinvestment;

//Update Action Plan Record	
if(!lstApproveActionPlan.isEmpty())
	update lstApproveActionPlan;
	
	
	

	
	
	
	


