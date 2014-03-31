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
	
	
	//private List<Product_Master__c> lstProductMaster;
	//private List<Product_Master__c> lstProductMasterForET;
	
	
	//Constructor
	public ActionPlanUtility()
	{
		
			/*lstProductMaster = [Select Product_Name__c, Product_Manufacturer__c,Product_Manufacturer__r.Name, ProductType__c,Is_Active__c,
								   Policy_Type__c, Investment_Type__c, Asset_Class__c,
								   	(Select Min_Year_Value__c, Max_Year_Value__c, Min_Months__c, Max_Months__c, 
								   	Upfront_Commission__c, Trail_Commission__c from Commissions__r where Active__c = true)  
								From Product_Master__c Where Is_Active__c = true and Is_Recommended__c = true];  */
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
	public List<String> getProductType(String policyType,List<Product_Master__c> lstProductMaster)
	{
		List<String> lstProductNameOptions = new List<String>();
										    
		for(Product_Master__c objProductMaster : lstProductMaster)
		{   
			if(objProductMaster.ProductType__c == policyType)
				lstProductNameOptions.add(objProductMaster.Product_Name__c);
		}
		return lstProductNameOptions;
	}
	
	//This method return the Loan Type  : Added by Aditi Satpute : 5/12/13 - Add On Enhancement
	public List<SelectOption> getLoanType(List<Product_Master__c> lstProductMaster)
	{
		Set<String> setLoanType = new Set<String>();
		for(Product_Master__c objPMLoan : lstProductMaster)
    	{
    		if(objPMLoan.Asset_Class__c == 'Loans')
    		{
    			setLoanType.add(objPMLoan.Investment_Type__c);
    		}
    	}
        List<selectOption> options = new List<selectOption>();
        for(String strLoanType: setLoanType) 
        {
            options.add(new selectOption(strLoanType,strLoanType));
        }
        return options;
	}
	
	//This method return the Bond Type  : Added by Aditi Satpute : 17/12/13 - Add On Enhancement
	public List<SelectOption> getBondType()
	{
		List<SelectOption> options = new List<SelectOption>();
	 	options.add(new SelectOption('Tax Saving','Tax Saving'));
	 	options.add(new SelectOption('Tax Free','Tax Free'));
	 	options.add(new SelectOption('Capital gain','Capital gain'));
		return options;
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
    public String getProductName(String productType,List<Product_Master__c> lstProductMaster)
    {
    	String strProductName = '';
    	/*List<Product_Master__c> lstProductMaster = [Select Product_Name__c, Product_Manufacturer__c, ProductType__c,Is_Active__c,
														   Policy_Type__c, Investment_Type__c
													From Product_Master__c Where Is_Active__c = true 
													and ProductType__c =: productType];*/
														
		for(Product_Master__c objProductName : lstProductMaster)
    	{
    		if(objProductName.ProductType__c == productType)
    		{
    			strProductName += '"' + objProductName.Product_Name__c + '"'+',';
    		}
    	}
    	
    	strProductName = strProductName.removeEnd(','); 
    	return strProductName;						
								
    }
    
     //Get product name for Execution tracker to display autocomplete
    public String getLoanProductName(String productType,String investmentType,List<Product_Master__c> lstProductMaster)
    {
    	String strProductName = '';
    	/*List<Product_Master__c> lstProductMaster = [Select Product_Name__c, Product_Manufacturer__c, ProductType__c,Is_Active__c,
														   Policy_Type__c, Investment_Type__c
													From Product_Master__c Where Is_Active__c = true 
													and ProductType__c =: productType and Investment_Type__c =: investmentType];*/
														
		for(Product_Master__c objProductName : lstProductMaster)
    	{
    		if(objProductName.Investment_Type__c == investmentType && objProductName.ProductType__c == productType)
    		{
    			strProductName += '"' + objProductName.Product_Name__c + '"'+',';
    		}
    	}
    	
    	strProductName = strProductName.removeEnd(','); 
    	system.debug('****strProductName*********'+strProductName);
    	return strProductName;						
								
    }
    
     //Get product name for Fixed Deposit to display autocomplete
    public String getFixedDepositProductName(String productType,String productManufacturer,List<Product_Master__c> lstProductMaster)
    {
    	String strProductName = '';
    	/*List<Product_Master__c> lstProductMaster = [Select Product_Name__c, Product_Manufacturer__c,Product_Manufacturer__r.Name, ProductType__c,Is_Active__c,
														   Policy_Type__c, Investment_Type__c
													From Product_Master__c Where Is_Active__c = true 
													and ProductType__c =: productType and Product_Manufacturer__r.Name =: productManufacturer];*/
														
		for(Product_Master__c objProductName : lstProductMaster)
    	{
    		Set<String> lstFixedDepositPM  = new Set<String>();
    		if(objProductName.ProductType__c == productType)
    		{
    			if(objProductName.Product_Manufacturer__c == productManufacturer)
    			{
    				strProductName += '"' + objProductName.Product_Name__c + '"'+',';
    			}
    		/*	if(mapCompanyNameToProducts.containskey(objProductName.Product_Manufacturer__c))
   				{
   					system.debug('****mapCompanyNameToProducts.contains*********'+mapCompanyNameToProducts);
   					lstFixedDepositPM = mapCompanyNameToProducts.get(objProductName.Product_Manufacturer__c);
   					lstFixedDepositPM.add(objProductName.Product_Name__c);
	   				mapCompanyNameToProducts.put(objProductName.Product_Manufacturer__c,lstFixedDepositPM);
   				}
   				else
   				{
   					lstFixedDepositPM.add(objProductName.Product_Name__c);
   					mapCompanyNameToProducts.put(objProductName.Product_Manufacturer__c,lstFixedDepositPM);
   				}
   				system.debug('****mapCompanyNameToProducts*********'+mapCompanyNameToProducts);*/
    		}
    	}
    	
    	strProductName = strProductName.removeEnd(','); 
    	system.debug('****strProductName*********'+strProductName);
    	return strProductName;						
								
    }
     
    public Long getProductPremiumAmount(String policyName,Long SumAssured,Decimal customerAge,Decimal noOfSpouse,Decimal noOfChild)
    {
    	system.debug('--customerAge---'+customerAge);	
    	system.debug('--noOfSpouse---'+noOfSpouse);	
    	system.debug('--noOfChild---'+noOfChild);	
    	List<Product_Premium__c> lstPremiumProduct = [Select Sum_Assured__c, Start_Age__c, Spouse__c, Product_Name__c, 
    											Premium_Amount__c, End_Age__c,Child__c From Product_Premium__c 
    											where Product_Name__r.Product_Name__c = :policyName];
    	system.debug('--lstPremiumProduct.size()---'+lstPremiumProduct.size());				
    	List<Product_Premium__c> lstPossiblePremium = new List<Product_Premium__c>();
    	for(Product_Premium__c objPremiumProduct :  lstPremiumProduct)		
    	{
    		system.debug('--objPremiumProduct---'+objPremiumProduct);	
    		if(customerAge >= objPremiumProduct.Start_Age__c && customerAge <= objPremiumProduct.End_Age__c)
    		{
    			if(objPremiumProduct.Spouse__c == noOfSpouse && objPremiumProduct.Child__c == noOfChild)
    			{
    				if(objPremiumProduct.Sum_Assured__c == SumAssured)
    				{
    					if(objPremiumProduct.Premium_Amount__c != null)
    						return objPremiumProduct.Premium_Amount__c.round();
    				}
    				else
    				{
    					Long calculatedPremium = ((SumAssured*objPremiumProduct.Premium_Amount__c)/objPremiumProduct.Sum_Assured__c).round();
    					return calculatedPremium;
    				}
    			}
    			else
    			{
    				lstPossiblePremium.add(objPremiumProduct);
    			}
    		}
    	}
    	
		for(Product_Premium__c objPP : lstPossiblePremium)
		{
			if(objPP.Spouse__c == -1 && objPP.Child__c == -1)
			{
				if(objPP.Sum_Assured__c == SumAssured)
				{
					if(objPP.Premium_Amount__c != null)
						return objPP.Premium_Amount__c.round();
				}
			}
		}								
    	return 0;
    }
    
    
  /*  
     //Get product name for Fixed Deposit to display autocomplete
    public String getFixedDepositProductName(String productType,String productManufacturer)
    {
    	String strProductName = '';
    	List<Product_Master__c> lstProductMaster = [Select Product_Name__c, Product_Manufacturer__c,Product_Manufacturer__r.Name, ProductType__c,Is_Active__c,
														   Policy_Type__c, Investment_Type__c
													From Product_Master__c Where Is_Active__c = true 
													and ProductType__c =: productType and Product_Manufacturer__c =: productManufacturer];
														
		for(Product_Master__c objProductName : lstProductMaster)
    	{
    		if(objProductName.Product_Manufacturer__c == productManufacturer)
    		{
    			strProductName += '"' + objProductName.Product_Name__c + '"'+',';
    		}
    	}
    	
    	strProductName = strProductName.removeEnd(','); 
    	system.debug('****strProductName*********'+strProductName);
    	return strProductName;						
								
    }
    */
   
   	//To get map of Equity, Debt, Gold Mutual Fund to its corresponding products
    public map<String, set<String>> mapMutualFundTosetProducts(Id PartnerId, Id BizUnitId)
    {
    	map<String, set<String>> mapMutualFundTosetProducts = new map<String, set<String>>();
    	List<Product_Default_Allocation__c> productAllocationList = [Select Sequence_No__c,RecordTypeId,Product__c,Partner__c,Name,Id,
    													Business_Unit__c, Asset_Class__c ,Investment_Type__c, Product__r.Product_Name__c
    													,RecordType.Name
    													From Product_Default_Allocation__c p 
    													where (Asset_Class__c = 'Equity' or Asset_Class__c = 'Debt' or Asset_Class__c = 'Gold')
    													and /*Investment_Type__c = 'Life Insurance'
    													and*/ (Business_Unit__c =: BizUnitId or Partner__c =: PartnerId)
    													and RecordType.Name != 'Basket Product'
    													and Sequence_No__c != null order by Sequence_No__c asc];
    	system.debug('-------productAllocationList---------'+productAllocationList);												
    	set<String> setEquity = new set<String>();
    	set<String> setDebt = new set<String>();
    	set<String> setGold = new set<String>();	
    	
    	for(Product_Default_Allocation__c obj : productAllocationList)
    	{
    		if(obj.Asset_Class__c == 'Equity' && obj.Investment_Type__c == 'Equity MF')
    		{
	    		if(setEquity.size() == Integer.valueOf(Label.Default_Product_Display_Count))
	    			break;
	    		if(obj.Partner__c != null && obj.RecordType.Name == 'Partner Products')
	    		{
	    			setEquity.add(obj.Product__r.Product_Name__c);
	    		}
    		}
    		if(obj.Asset_Class__c == 'Debt' && obj.Investment_Type__c == 'Debt MF')
    		{
	    		if(setDebt.size() == Integer.valueOf(Label.Default_Product_Display_Count))
	    			break;
	    		if(obj.Partner__c != null && obj.RecordType.Name == 'Partner Products')
	    		{
	    			setDebt.add(obj.Product__r.Product_Name__c);
	    		}
    		}
    		if(obj.Asset_Class__c == 'Gold' && obj.Investment_Type__c == 'Gold MF')
    		{
	    		if(setGold.size() == Integer.valueOf(Label.Default_Product_Display_Count))
	    			break;
	    		if(obj.Partner__c != null && obj.RecordType.Name == 'Partner Products')
	    		{
	    			setGold.add(obj.Product__r.Product_Name__c);
	    		}
    		}
    	}
    	
    	if(setEquity.size() < Integer.valueOf(Label.Default_Product_Display_Count))
    	{
    		for(Product_Default_Allocation__c obj : productAllocationList)
	    	{
	    		if(setEquity.size() == Integer.valueOf(Label.Default_Product_Display_Count))
    				break;
	    		if(obj.Business_Unit__c != null && obj.RecordType.Name == 'Business Unit Products' && obj.Asset_Class__c == 'Equity' && obj.Investment_Type__c == 'Equity MF')
	    		{
		    		setEquity.add(obj.Product__r.Product_Name__c);
		    		system.debug('-------setEquity--Business-------'+setEquity);
	    		}
	    	}
	    	
    	}
    	mapMutualFundTosetProducts.put('Equity', setEquity);
    	
    	
    	if(setDebt.size() < Integer.valueOf(Label.Default_Product_Display_Count))
    	{
    		for(Product_Default_Allocation__c obj : productAllocationList)
	    	{
	    		if(setDebt.size() == Integer.valueOf(Label.Default_Product_Display_Count))
    				break;
	    		if(obj.Business_Unit__c != null && obj.RecordType.Name == 'Business Unit Products' && obj.Asset_Class__c == 'Debt' && obj.Investment_Type__c == 'Debt MF')
	    		{
		    		setDebt.add(obj.Product__r.Product_Name__c);
		    		system.debug('-------setDebt--Business-------'+setDebt);
	    		}
	    	}
    	}
    	mapMutualFundTosetProducts.put('Debt', setDebt);
    	
    	if(setGold.size() < Integer.valueOf(Label.Default_Product_Display_Count))
    	{
    		for(Product_Default_Allocation__c obj : productAllocationList)
	    	{
	    		if(setGold.size() == Integer.valueOf(Label.Default_Product_Display_Count))
    				break;
	    		if(obj.Business_Unit__c != null && obj.RecordType.Name == 'Business Unit Products' && obj.Asset_Class__c == 'Gold' && obj.Investment_Type__c == 'Gold MF')
	    		{
		    		setGold.add(obj.Product__r.Product_Name__c);
		    		system.debug('-------setGold--Business-------'+setGold);
	    		}
	    	}
    	}
    	mapMutualFundTosetProducts.put('Gold', setGold);
    		
    	system.debug('-------mapMutualFundTosetProducts--util-------'+mapMutualFundTosetProducts);								
    	return mapMutualFundTosetProducts;
    	
    }
   	
    //To get map of Life Insurance to its corresponding products
    public map<String, set<String>> mapLifeInsTosetProducts(Id PartnerId, Id BizUnitId)
    {
    	map<String, set<String>> mapLifeInsTosetProducts = new map<String, set<String>>();
    	List<Product_Default_Allocation__c> productAllocationList = [Select Sequence_No__c,RecordTypeId,Product__c,Partner__c,Name,Id,
    													Business_Unit__c, Asset_Class__c ,Investment_Type__c, Product__r.Product_Name__c
    													,RecordType.Name
    													From Product_Default_Allocation__c p 
    													where Asset_Class__c = 'Insurance' 
    													//and Investment_Type__c = 'Life Insurance'
    													and (Business_Unit__c =: BizUnitId or Partner__c =: PartnerId)
    													and RecordType.Name != 'Basket Product'
    													and Sequence_No__c != null order by Sequence_No__c asc];
    	system.debug('-------productAllocationList---LI------'+productAllocationList);												
    	set<String> setProducts = new set<String>();	
    	
    	for(Product_Default_Allocation__c obj : productAllocationList)
    	{
    		if(setProducts.size() == Integer.valueOf(Label.Default_Product_Display_Count))
    			break;
    		if(obj.Partner__c != null && obj.RecordType.Name == 'Partner Products' && obj.Investment_Type__c == 'Life Insurance')
    		{
    			setProducts.add(obj.Product__r.Product_Name__c);
	    		system.debug('-------setProducts--partner-------'+setProducts);
    		}
    	}
    	if(setProducts.size() < Integer.valueOf(Label.Default_Product_Display_Count))
    	{
    		for(Product_Default_Allocation__c obj : productAllocationList)
	    	{
	    		if(setProducts.size() == Integer.valueOf(Label.Default_Product_Display_Count))
    				break;
	    		if(obj.Business_Unit__c != null && obj.RecordType.Name == 'Business Unit Products' && obj.Investment_Type__c == 'Life Insurance')
	    		{
		    		setProducts.add(obj.Product__r.Product_Name__c);
		    		system.debug('-------setProducts--Business-------'+setProducts);
	    		}
	    	}
    	}	
    	mapLifeInsTosetProducts.put('Life Insurance Default Products', setProducts);
    	system.debug('-------Life Insurance--util-------'+mapLifeInsTosetProducts);
    	
    	/*--------------------------------------------------Health Insurance----------------------------------------------------*/
    	setProducts = new set<String>();	
    	for(Product_Default_Allocation__c obj : productAllocationList)
    	{
    		if(setProducts.size() == Integer.valueOf(Label.Default_Product_Display_Count))
    			break;
    		if(obj.Partner__c != null && obj.RecordType.Name == 'Partner Products' && obj.Investment_Type__c == 'Health Insurance')
    		{
    			setProducts.add(obj.Product__r.Product_Name__c);
	    		system.debug('-------setProducts--Health  partner-------'+setProducts);
    		}
    	}
    	if(setProducts.size() < Integer.valueOf(Label.Default_Product_Display_Count))
    	{
    		for(Product_Default_Allocation__c obj : productAllocationList)
	    	{
	    		if(setProducts.size() == Integer.valueOf(Label.Default_Product_Display_Count))
    				break;
	    		if(obj.Business_Unit__c != null && obj.RecordType.Name == 'Business Unit Products' && obj.Investment_Type__c == 'Health Insurance')
	    		{
		    		setProducts.add(obj.Product__r.Product_Name__c);
		    		system.debug('-------setProducts--Business---Health ----'+setProducts);
	    		}
	    	}
    	}	
    	mapLifeInsTosetProducts.put('Health Insurance', setProducts);
    	
    	/*--------------------------------------------------Critical Illness-------------------------------------------------------*/
    	setProducts = new set<String>();	
    	for(Product_Default_Allocation__c obj : productAllocationList)
    	{
    		if(setProducts.size() == Integer.valueOf(Label.Default_Product_Display_Count))
    			break;
    		if(obj.Partner__c != null && obj.RecordType.Name == 'Partner Products' && obj.Investment_Type__c == 'Critical Illness')
    		{
    			setProducts.add(obj.Product__r.Product_Name__c);
	    		system.debug('-------setProducts--partner--Critical Illness-----'+setProducts);
    		}
    	}
    	if(setProducts.size() < Integer.valueOf(Label.Default_Product_Display_Count))
    	{
    		for(Product_Default_Allocation__c obj : productAllocationList)
	    	{
	    		if(setProducts.size() == Integer.valueOf(Label.Default_Product_Display_Count))
    				break;
	    		if(obj.Business_Unit__c != null && obj.RecordType.Name == 'Business Unit Products' && obj.Investment_Type__c == 'Critical Illness')
	    		{
		    		setProducts.add(obj.Product__r.Product_Name__c);
		    		system.debug('-------setProducts--Business---Critical Illness----'+setProducts);
	    		}
	    	}
    	}	
    	mapLifeInsTosetProducts.put('Critical Illness', setProducts);
    	
    	/*--------------------------------------------------Accident Benefit---------------------------------------------------------*/
    	
    	setProducts = new set<String>();	
    	for(Product_Default_Allocation__c obj : productAllocationList)
    	{
    		if(setProducts.size() == Integer.valueOf(Label.Default_Product_Display_Count))
    			break;
    		if(obj.Partner__c != null && obj.RecordType.Name == 'Partner Products' && obj.Investment_Type__c == 'Accident Benefit')
    		{
    			setProducts.add(obj.Product__r.Product_Name__c);
	    		system.debug('-------setProducts--partner----Accident Benefit---'+setProducts);
    		}
    	}
    	if(setProducts.size() < Integer.valueOf(Label.Default_Product_Display_Count))
    	{
    		for(Product_Default_Allocation__c obj : productAllocationList)
	    	{
	    		if(setProducts.size() == Integer.valueOf(Label.Default_Product_Display_Count))
    				break;
	    		if(obj.Business_Unit__c != null && obj.RecordType.Name == 'Business Unit Products' && obj.Investment_Type__c == 'Accident Benefit')
	    		{
		    		setProducts.add(obj.Product__r.Product_Name__c);
		    		system.debug('-------setProducts--Business----Accident Benefit---'+setProducts);
	    		}
	    	}
    	}	
    	mapLifeInsTosetProducts.put('Accident Benefit', setProducts);
    	
    	/*--------------------------------------------------Top Up---------------------------------------------------------*/
    	setProducts = new set<String>();	
    	for(Product_Default_Allocation__c obj : productAllocationList)
    	{
    		if(setProducts.size() == Integer.valueOf(Label.Default_Product_Display_Count))
    			break;
    		if(obj.Partner__c != null && obj.RecordType.Name == 'Partner Products' && obj.Investment_Type__c == 'Top Up')
    		{
    			setProducts.add(obj.Product__r.Product_Name__c);
	    		system.debug('-------setProducts--partner----Top Up--'+setProducts);
    		}
    	}
    	if(setProducts.size() < Integer.valueOf(Label.Default_Product_Display_Count))
    	{
    		for(Product_Default_Allocation__c obj : productAllocationList)
	    	{
	    		if(setProducts.size() == Integer.valueOf(Label.Default_Product_Display_Count))
    				break;
	    		if(obj.Business_Unit__c != null && obj.RecordType.Name == 'Business Unit Products' && obj.Investment_Type__c == 'Top Up')
	    		{
		    		setProducts.add(obj.Product__r.Product_Name__c);
		    		system.debug('-------setProducts--Business----Top Up---'+setProducts);
	    		}
	    	}
    	}	
    	mapLifeInsTosetProducts.put('Top Up', setProducts);
    	    		
    	system.debug('-------General Insurance--util-------'+mapLifeInsTosetProducts);									
    	return mapLifeInsTosetProducts;
    }
    
    
   
}//end of ActionPlanUtility