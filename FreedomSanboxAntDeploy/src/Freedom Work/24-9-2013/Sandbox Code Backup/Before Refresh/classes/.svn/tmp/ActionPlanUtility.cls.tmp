/*
    Revision History:
    
    Version     Version Author     Date           Comments
    1.0         Gaurav  Kakariya   5/8/2013       To Show SIP,Lumpsum and Insurance name on Actionplan page instead of textbox 
    
*/

public with sharing class ActionPlanUtility 
{
	private static final String MEDICAL = 'Medical';
	private static final String CRITICAL_ILLNESS = 'Critical Illness';
	private static final String TOPUP= 'Top Up';
	private static final String DISABILITY= 'Disability';
	private static final String PERSONAL_ACCIDENT= 'Personal Accident';
	private static final String VEHICLE= 'Vehicle';
	private static final String HOUSEHOLDERS= 'Householders';
	private static final String OTHER= 'Other';
	
	private List<Product_Master__c> lstProductMaster;
	
	//Constructor
	public ActionPlanUtility()
	{
		lstProductMaster = [Select Product_Name__c, Product_Manufacturer__c, ProductType__c,Is_Active__c,
								   Policy_Type__c, Upfront_Commission__c,Trail_Commission__c ,Investment_Type__c
								From Product_Master__c Where Is_Active__c = true];  
	}
	
	//This method return the General Insurance Policy Type
	public List<SelectOption> getInsurancePolicyTypes()
	{
		 List<SelectOption> options = new List<SelectOption>();
		 options.add(new SelectOption(MEDICAL,MEDICAL));
		 options.add(new SelectOption(CRITICAL_ILLNESS,CRITICAL_ILLNESS));
		 options.add(new SelectOption(TOPUP,TOPUP));
		 options.add(new SelectOption(DISABILITY,DISABILITY));
		 options.add(new SelectOption(PERSONAL_ACCIDENT,PERSONAL_ACCIDENT));
		 options.add(new SelectOption(VEHICLE,VEHICLE));
		 options.add(new SelectOption(HOUSEHOLDERS,HOUSEHOLDERS));
		 options.add(new SelectOption(OTHER,OTHER));
		return options;
	}
	
	//This method return the Insurance(General/Life) Type Product Name
	public List<String> getProductType(String policyType)
	{
		List<String> lstProductNameOptions = new List<String>();
										    
		for(Product_Master__c objProductMaster : lstProductMaster)
		{   
			if(objProductMaster.Policy_Type__c == policyType  || 
				objProductMaster.Investment_Type__c == policyType)
				lstProductNameOptions.add(objProductMaster.Product_Name__c);
		}
		return lstProductNameOptions;
	}
	
	 //To Retrieve Product Name using Policy Type
    public String retrieveInsurance(List<String> lstOptions)
    {
    	String strProductName = '';
    	
    	for(String strInsuranceProductName :lstOptions)
    	{
    		strProductName += '"' + strInsuranceProductName + '"'+',';
    	}
    	
    	strProductName = strProductName.removeEnd(','); 
    	return strProductName;
    }
	
}//end of ActionPlanUtility