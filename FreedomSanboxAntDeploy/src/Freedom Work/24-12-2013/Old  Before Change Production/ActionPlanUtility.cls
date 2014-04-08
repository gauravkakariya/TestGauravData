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
	//private static final String DISABILITY= 'Disability';
	private static final String PERSONAL_ACCIDENT= 'Personal Accident';
	private static final String VEHICLE= 'Vehicle';
	private static final String HOUSEHOLDERS= 'Householders';
	private static final String OTHER= 'Other';
	
	
	
	//Added on : 24/10/13 : Adit Satpute - LI Capping Removal Changes
	private static final String TERM_LIFE = 'Term Life';
	private static final String WHOLE_LIFE = 'Whole Life';
	private static final String ENDOWMENT = 'Endowment';
	private static final String ULIP_EQUITY= 'ULIP - Equity';
	private static final String PENSION_PLAN= 'Pension Plan';
	private static final String MONEY_BACK= 'Money-Back';
	private static final String CHILDREN= 'Children\'s';
	private static final String ULIP_DEBT= 'ULIP - Debt';
	
	
	private List<Product_Master__c> lstProductMaster;
	private List<Product_Master__c> lstProductMasterForET;
	
	//Constructor
	public ActionPlanUtility()
	{
		lstProductMaster = [Select Product_Name__c, Product_Manufacturer__c, ProductType__c,Is_Active__c,
								   Policy_Type__c, Investment_Type__c
								From Product_Master__c Where Is_Active__c = true and Is_Recommended__c = true];  
	}
	
	//This method return the General Insurance Policy Type
	public List<SelectOption> getInsurancePolicyTypes()
	{
		 List<SelectOption> options = new List<SelectOption>();
		 options.add(new SelectOption(MEDICAL,MEDICAL));
		 options.add(new SelectOption(CRITICAL_ILLNESS,CRITICAL_ILLNESS));
		 options.add(new SelectOption(TOPUP,TOPUP));
		 //options.add(new SelectOption(DISABILITY,DISABILITY));
		 options.add(new SelectOption(PERSONAL_ACCIDENT,PERSONAL_ACCIDENT));
		 options.add(new SelectOption(VEHICLE,VEHICLE));
		 options.add(new SelectOption(HOUSEHOLDERS,HOUSEHOLDERS));
		 options.add(new SelectOption(OTHER,OTHER));
		return options;
	}
	
	//This method return the Life Insurance Policy Type - Aditi : 24/10/13 - LI CAPPING REMOVAL CHANGES
	public List<SelectOption> getLifeInsurancePolicyTypes()
	{
		 List<SelectOption> options = new List<SelectOption>();
		 options.add(new SelectOption(TERM_LIFE,TERM_LIFE));
		 options.add(new SelectOption(WHOLE_LIFE,WHOLE_LIFE));
		 options.add(new SelectOption(ENDOWMENT,ENDOWMENT));
		 options.add(new SelectOption(ULIP_DEBT,ULIP_DEBT));
		 options.add(new SelectOption(PENSION_PLAN,PENSION_PLAN));
		 options.add(new SelectOption(MONEY_BACK,MONEY_BACK));
		 options.add(new SelectOption(CHILDREN,CHILDREN));
		 options.add(new SelectOption(ULIP_EQUITY,ULIP_EQUITY));
		 options.add(new SelectOption(OTHER,OTHER));
		return options;
	}
	
	//This method return the Insurance(General/Life) Type Product Name
	public List<String> getProductType(String policyType)
	{
		List<String> lstProductNameOptions = new List<String>();
										    
		for(Product_Master__c objProductMaster : lstProductMaster)
		{   
			if(objProductMaster.ProductType__c == policyType)
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
    
    //Get product name for Execution tracker to display autocomplete
    public String getProductName(String productType)
    {
    	String strProductName = '';
    	List<Product_Master__c> lstProductMaster = [Select Product_Name__c, Product_Manufacturer__c, ProductType__c,Is_Active__c,
														   Policy_Type__c, Investment_Type__c
													From Product_Master__c Where Is_Active__c = true 
													and ProductType__c =: productType];
														
		for(Product_Master__c objProductName : lstProductMaster)
    	{
    		strProductName += '"' + objProductName.Product_Name__c + '"'+',';
    	}
    	
    	strProductName = strProductName.removeEnd(','); 
    	return strProductName;						
								
    }
   
       
   
}//end of ActionPlanUtility