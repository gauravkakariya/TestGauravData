//Service Deliverables
public with sharing class ServiceDeliverablesCreation
{
	public Service_Deliverables__c createServiceDeliverables(Date chkReceivedDt,ID accRenewalId,String strStartOfFinancialYear,String strEndOfFinancialYear,String strRecType)
	{
		Service_Deliverables__c objServiceDetails = new Service_Deliverables__c();
		Integer iCurrentYear = Date.today().year();
		Integer iCurrentMonth = Date.today().month();
		if(iCurrentMonth <= 3) //If the selected month is Jan,Feb,March
			iCurrentYear = --iCurrentYear;
		strStartOfFinancialYear = String.valueOf(iCurrentYear) + '-' +strStartOfFinancialYear;
		strEndOfFinancialYear = String.valueOf(++iCurrentYear) + '-' + strEndOfFinancialYear;
		objServiceDetails.Start_Date__c = date.valueOf(strStartOfFinancialYear);
		objServiceDetails.End_Date__c = date.valueOf(strEndOfFinancialYear);
		objServiceDetails.Expiration_Date__c = chkReceivedDt.addYears(1);
		objServiceDetails.RelatedAccount__c = accRenewalId;
		objServiceDetails.RecordTypeId = strRecType;
		return objServiceDetails;
	}
}