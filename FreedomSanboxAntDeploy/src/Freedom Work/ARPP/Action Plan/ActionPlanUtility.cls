/*
    Revision History:
    
    Version     Version Author     Date           Comments
    1.0         Gaurav  Kakariya   5/8/2013       To Show SIP,Lumpsum and Insurance name on Actionplan page instead of textbox 
    
*/

public with sharing class ActionPlanUtility 
{
	private static final String strMedical = 'Medical';
	private static final String strCriticalIllness = 'Critical Illness';
	private static final String strTopUp= 'Top Up';
	private static final String strDisability= 'Disability';
	private static final String strAccident= 'Personal Accident';
	private static final String strVehicle= 'Vehicle';
	private static final String strHouseHolders= 'Householders';
	
	
	//This method return the SIP/Lumpsum Type Product Name
	public List<SelectOption> getMutualFundProductTypes(String investmentType)
	{
		List<SelectOption> options = new List<SelectOption>();
		List<Product_Master__c> lstProductMaster = [Select Product_Name__c, Product_Manufacturer__c, ProductType__c,Is_Active__c, 
														   Investment_Type__c,Upfront_Commission__c, Trail_Commission__c 
												    From Product_Master__c Where Is_Active__c = true and Investment_Type__c=:investmentType];     
											    
		for(Product_Master__c objProductMaster :lstProductMaster)
		{
			options.add(new SelectOption(objProductMaster.Product_Name__c, objProductMaster.Product_Name__c));
		}
		
		return options;
	}
	
	//This method return the Insurance(General/Life) Type Product Name
	public List<SelectOption> getInsuranceProductTypes(String policyType)
	{
		List<SelectOption> options = new List<SelectOption>();
		List<Product_Master__c> lstProductMaster = [Select Product_Name__c, Product_Manufacturer__c, ProductType__c,Is_Active__c,
														   Policy_Type__c, Upfront_Commission__c,Trail_Commission__c 
												    From Product_Master__c Where Is_Active__c = true and Policy_Type__c=:policyType];     
											    
		for(Product_Master__c objProductMaster :lstProductMaster)
		{
			options.add(new SelectOption(objProductMaster.Product_Name__c, objProductMaster.Product_Name__c));
		}
		
		return options;
	}
	
	//This method return the Insurance Policy Type
	public List<SelectOption> getInsurancePolicyTypes()
	{
		 List<SelectOption> options = new List<SelectOption>();
		 options.add(new SelectOption(strMedical,strMedical));
		 options.add(new SelectOption(strCriticalIllness,strCriticalIllness));
		 options.add(new SelectOption(strTopUp,strTopUp));
		 options.add(new SelectOption(strDisability,strDisability));
		 options.add(new SelectOption(strAccident,strAccident));
		 options.add(new SelectOption(strVehicle,strVehicle));
		 options.add(new SelectOption(strHouseHolders,strHouseHolders));
		return options;
	}
	
	//This method return the Insurance(General/Life) Type Product Name
	public List<String> getInsuranceProductTypesList(String policyType)
	{
		List<String> lstOptions = new List<String>();
		
		List<Product_Master__c> lstProductMaster = [Select Product_Name__c, Product_Manufacturer__c, ProductType__c,Is_Active__c,
														   Policy_Type__c, Upfront_Commission__c,Trail_Commission__c ,Investment_Type__c
												    From Product_Master__c Where Is_Active__c = true and (Policy_Type__c=:policyType or 
												    	 Investment_Type__c =: policyType)];     
											    
		for(Product_Master__c objProductMaster : lstProductMaster)
		{   
			lstOptions.add(objProductMaster.Product_Name__c);
		}
		return lstOptions;
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