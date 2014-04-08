Id rtId = [Select Id from RecordType where sobjectType ='Account' and Name='Client'].Id;
List<Account> lstAccount = [Select id from Account where Entity_Status__c = 'Active' and RecordTypeId=:rtId and Id = '001W0000005xb4UIAQ'];

List<Account> lstEntity = [SELECT Id,Name FROM Account WHERE Id IN: lstAccount OR Parent_Entity__c IN: lstAccount];
System.debug('---------------------lstEntity----'+lstEntity);
Map<Id, Execution_Tracker__c> mapNewIdToET = new Map<Id, Execution_Tracker__c>([Select isTaskAssigned__c, isFormProvidedToMET__c, isAssignedToOps__c, Units__c, Unique_Execution__c, Type__c, Transaction_date__c, Transaction_Type__c, Term_No_Of_Years__c, Target_Revenue__c, Target_Date__c, SystemModstamp, Sum_Assured__c, Suggested_Amount__c, Suggested_Action_Amount__c, Status_of_Investor__c, Status__c, Sent_to_Insurance_Company__c, Send_SMS__c, Send_SMS_Datetime__c, Send_Email__c, Send_Email_Datetime__c, Scheme_Name_Policy_Name__c, STP_To_Scheme_option__c, STP_Installments__c, STP_From_Scheme_option__c, STP_Amount_per_transfer__c, SIP_Installments__c, Risk_Commencement_Date__c, Revised_Target_Date__c, Revenue_Booked__c, Renewal_Status__c, Renewal_Remark__c, Renewal_Date__c, Renewal_Alert__c, Remarks__c, Remark_OpsTeam__c, Rejected_Tracker__c, Refund_Date__c, Refund_Amount__c, Previous_Policy_Number__c, Premium__c, Preferable_Medical_date__c, Policy_update_date__c, Policy_document_received__c, Policy_Status__c, Policy_Punch_date__c, Policy_Number__c, Policy_Name__c, Policy_Document_received_date__c, Pol_Doc_Recd_Status__c, ParentExecutionTracker__c, PAN__c, PAN_No_Third_holder__c, PAN_No_Second_holder__c, PAN_No_Guardian__c, Owner__c, Overdue__c, Other_Insured_5_Name__c, Other_Insured_5_Gender__c, Other_Insured_5_DOB__c, Other_Insured_4_Name__c, Other_Insured_4_Gender__c, Other_Insured_4_DOB__c, Other_Insured_3_Name__c, Other_Insured_3_Gender__c, Other_Insured_3_DOB__c, Other_Insured_2_Name__c, Other_Insured_2_Gender__c, Other_Insured_2_DOB__c, Other_Insured_1_Name__c, Other_Insured_1_Gender__c, Other_Insured_1_DOB__c, Original_Target_Date__c, Option__c, Opportunity_Name__c, Nominee_s_Name__c, Nominee_s_DOB__c, Nominee__c, Net_Premium__c, Name_of_Third_holder__c, Name_of_Second_holder__c, Name, Mode_of_holding_in_bank_account__c, Mode_of_holding__c, Mode__c, Mode_Of_Payment__c, Mobile__c, MICR_Code__c, Login_Date__c, LastModifiedDate, LastModifiedById, LastActivityDate, Is_Floating__c, IsDeleted, Investor_Name_as_in_PAN_card__c, Investor_Name_As_in_bank_record__c, Insured__c, Insured_Name__c, Insurance_Company__c, Id, IFSC_Code__c, Holder_Name__c, Guardian_Name_as_PAN_card__c, Guardian_Name_In_case_nominee_is_minor__c, Gross_Premium__c, Goal__c, Goal_Name__c, Folio_No__c, Executed_Product__c, Executed_Product_Name__c, Executed_Amount__c, Entity__c, Entity_Name__c, Email__c, ET_Status__c, Documents_received_date__c, Description__c, DOB__c, DOB_Third_holder__c, DOB_Second_holder__c, DOB_Guardian__c, CurrencyIsoCode, CreatedDate, CreatedById, Completion_Date__c, Communication_Address__c, Comments__c, Cheque_No__c, Cheque_Amount__c, Cancelled_Reason__c, Branch_Address__c, Booked_Revenue__c, Bank_Name__c, Balance_Remaining__c, AssignToOps__c, Asset_Class_Policy_Type__c, Approve_Action_Plan__c, Application_Status__c, Application_No__c, Annualised_Premium_Amount__c, Amount__c, Agreed_Scheme_Name_to__c, Agreed_Scheme_Name_From__c, Agreed_Product__c, Agreed_Life_Insurance_Company_Name__c, Agreed_Installments__c, Agreed_General_Insurance_Company_Name__c, Agreed_Amount__c, Agreed_Amount_Per_Installment__c, Agreed_Amount_Base_Amount__c, Actual_Action_Amount__c, Action__c, Account_Type__c, Account_Number__c From Execution_Tracker__c where Entity_Name__c IN:lstEntity]);

List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
Set<Id> setAPId = new Set<Id>();
Map<Id, ARPP_Detail__c> mapAPIdToARPPDetail = new Map<Id, ARPP_Detail__c>();
List<ARPP_Detail__c> lstUpdateARPPDetail = new List<ARPP_Detail__c>();

//Collect Approve Action plan Id and Execution Tracker record
for(Execution_Tracker__c objET : mapNewIdToET.values())
{
	if(objET.ParentExecutionTracker__c == null)
	{
		lstET.add(objET);
		setAPId.add(objET.Approve_Action_Plan__c);
	}
}

List<ARPP_Detail__c> lstARPPDetail = [Select  Product__r.Policy_Type__c, Product__r.Investment_Type__c, 
										Product__r.Product_Manufacturer__c,
										Commission__r.Upfront_Commission__c, Commission__r.Trail_Commission__c, 
										Product__r.ProductType__c, 
										Product__r.Product_Name__c, Product__c, Name, Id, 
										Execution_Tracker_upfront_Comm_Amount__c, 
										Entity__c, Entity__r.Name, Approve_Action_Plan__c, Approve_Action_Plan__r.Item_Type__c, Action_Plan_Upfront_Comm_Amount__c, 
										Action_Plan_Trial_Comm_Amount__c, Action_Plan_Amount__c, Type__c,
										Approve_Action_Plan__r.Installments__c
										From ARPP_Detail__c Where Approve_Action_Plan__c IN: setAPId];	
										
//Create Map Approve Action Plan to ARPP Detail											
for(ARPP_Detail__c objAD : lstARPPDetail )
{
	mapAPIdToARPPDetail.put(objAD.Approve_Action_Plan__c , objAD);
} 
AggregateResult[] aggr = [ Select sum(Executed_Amount__c), Approve_Action_Plan__c
                           FROM Execution_Tracker__c 
                           Where Application_Status__c ='Closed' 
                           Group By Approve_Action_Plan__c ];

Map<string, Double> mapAPIdToEA = new Map<string, Double>();       
for (AggregateResult ar : aggr)  {
 mapAPIdToEA.put(string.valueOf(ar.get('Approve_Action_Plan__c')),Double.valueOf(ar.get('expr0'))); 
    System.debug('Approve_Action_Plan__c' + ar.get('Approve_Action_Plan__c'));
    System.debug('Average amount' + ar.get('expr0'));
}

for(Execution_Tracker__c objET : lstET)
{

	//Calcualte Execution Tracker trail Commission
	
	ARPP_Detail__c objARPPDetail = mapAPIdToARPPDetail.get(objET.Approve_Action_Plan__c);
	
	if(objARPPDetail != null)
	{
		objARPPDetail.Execution_Tracker_Amount__c = mapAPIdToEA.containsKey(objET.Approve_Action_Plan__c)? mapAPIdToEA.get(objET.Approve_Action_Plan__c) :0;
		if(objARPPDetail.Type__c == 'SIP')
		{
			objARPPDetail.Execution_Tracker_upfront_Comm_Amount__c = objARPPDetail.Product__c != null && objARPPDetail.Commission__r != null? (objARPPDetail.Commission__r.Upfront_Commission__c * 12 * objARPPDetail.Execution_Tracker_Amount__c)/100 : 0;
			Double trailComm = 0;
			Double amount = objARPPDetail.Execution_Tracker_Amount__c;
			Integer installment = objARPPDetail.Approve_Action_Plan__r.Installments__c <= 12  ? Integer.valueOf(objARPPDetail.Approve_Action_Plan__r.Installments__c) : 12;			
			if(objARPPDetail.Product__c != null && objARPPDetail.Commission__r != null)
			{
				for(Integer i = 0; i < installment ; i++)
				{
					trailComm += (amount * objARPPDetail.Commission__r.Trail_Commission__c)/100;
					amount += objARPPDetail.Execution_Tracker_Amount__c;
				}
			}
			objARPPDetail.Execution_Tracker_Trial_Comm_Amount__c = trailComm;
		}
		else if(objARPPDetail.Type__c == 'Lumpsum')
		{
			
			objARPPDetail.Execution_Tracker_upfront_Comm_Amount__c = objARPPDetail.Product__c != null  && objARPPDetail.Commission__r != null ? (objARPPDetail.Commission__r.Upfront_Commission__c * 12 * objARPPDetail.Execution_Tracker_Amount__c)/100 : 0;
			objARPPDetail.Execution_Tracker_Trial_Comm_Amount__c = objARPPDetail.Product__c != null  && objARPPDetail.Commission__r != null ? (objARPPDetail.Commission__r.Trail_Commission__c * 12 * objARPPDetail.Execution_Tracker_Amount__c)/100 : 0;
		}
		else if(objARPPDetail.Type__c == 'Life Insurance' || objARPPDetail.Type__c == 'General Insurance')
		{
			objARPPDetail.Execution_Tracker_upfront_Comm_Amount__c = objARPPDetail.Product__c != null  && objARPPDetail.Commission__r != null ? (objARPPDetail.Commission__r.Upfront_Commission__c * objARPPDetail.Execution_Tracker_Amount__c)/100 : 0;
			objARPPDetail.Execution_Tracker_Trial_Comm_Amount__c = 0;
		}
		if(objET.ParentExecutionTracker__c == null)
			objARPPDetail.Execution_Tracker__c = objET.Id;			
		lstUpdateARPPDetail.add(objARPPDetail);
	}
}

//Update ARPP Detail Record
if(!lstUpdateARPPDetail.isEmpty())
{
	update lstUpdateARPPDetail;
}
