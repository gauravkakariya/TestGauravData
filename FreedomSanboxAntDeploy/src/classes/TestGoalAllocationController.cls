@isTest
private class TestGoalAllocationController 
{

	static Account act ; 
    static testMethod void testGoalAllocation() 
    {
    	
    	List<Asset__c> AllAssets = new List<Asset__c>();
        List<Portfolio_Report__c> AllPortfolios = new List<Portfolio_Report__c>();
        List<Insurance__c> AllInsurances = new List<Insurance__c>();
        List<Goal__c> AllGoals = new List<Goal__c>();
          
        Double d=10;
          
        List<GoalAllocationController.Assets> AssetsList=new  List<GoalAllocationController.Assets>();
        List<GoalAllocationController.Insurances> InsurancesList=new  List<GoalAllocationController.Insurances>();
        List<GoalAllocationController.InvestmentAssets> SIPList=new  List<GoalAllocationController.InvestmentAssets>();
        List<GoalAllocationController.InvestmentAssets> InvestmentAssetsList=new  List<GoalAllocationController.InvestmentAssets>();
          
        List<GoalAssetAssociation__c> GoalAssetAssociationsList=new  List<GoalAssetAssociation__c>();
        List<GoalIAULIPAssociation__c> GoalIAULIPAssociationsList=new  List<GoalIAULIPAssociation__c>();
        List<GoalIAULIPAssociation__c> GoalIAULIPAssociationsSIPList=new  List<GoalIAULIPAssociation__c>();
        List<GoalInsuranceAssociation__c> GoalInsuranceAssociationsList=new  List<GoalInsuranceAssociation__c>();
           
        List<GoalAssetAssociation__c> GoalAssetAssociationsList1=new  List<GoalAssetAssociation__c>();
        List<GoalIAULIPAssociation__c> GoalIAULIPAssociationsList1=new  List<GoalIAULIPAssociation__c>();
        List<GoalIAULIPAssociation__c> GoalIAULIPAssociationsSIPList1=new  List<GoalIAULIPAssociation__c>();
        List<GoalInsuranceAssociation__c> GoalInsuranceAssociationsList1=new  List<GoalInsuranceAssociation__c>();
        
       
        TestData_Ffreedom testData = new TestData_Ffreedom();
		act = testData.initializeAccount();   
        insert act;
        
        Account child = testData.init_FamilyMember(act);
        insert child;   
        
        Goal_Profile__c goalProfile = testData.initialize_GoalProfile(act, 'Aggressive', 'Customized');
      	insert goalProfile;
      	
      	Goal__c goal1 = testData.initialize_Goal(act, 'Education', goalProfile);
      	AllGoals.add(goal1);
      	Goal__c goal2 = testData.initialize_Goal(act, 'Marriage', goalProfile);
    	AllGoals.add(goal2);
        Goal__c goal3 = testData.initialize_Goal(act, 'House', goalProfile);
    	AllGoals.add(goal3);            
        insert AllGoals;      
   	    
		Asset__c asset1 = testData.initialize_Asset(act, 'Land', AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c, '');   	     	  
    	AllAssets.add(asset1); 
    	Asset__c asset2 = testData.initialize_Asset(act, 'Vehicles', AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c, '');
    	AllAssets.add(asset2);
    	Asset__c asset3 = testData.initialize_Asset(act, 'Other', AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c, '');
    	AllAssets.add(asset3);  
    	Asset__c asset4 = testData.initialize_Asset(act, 'Vacation Home', AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c, '');
    	AllAssets.add(asset4);
    	Asset__c asset5 = testData.initialize_Asset(act, 'Jewelry', AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c, '');
    	AllAssets.add(asset5);
    	//Asset__c childAsset = testData.initialize_Asset(child, 'Jewelry', AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c, '');
    	Asset__c childAsset = new Asset__c(Entity__c= child.Id, Asset_Types__c='Jewelry', Current_Value__c=1000,Categories__c='Gold');
    	AllAssets.add(childAsset);        	    	  
    	insert AllAssets;
    	
    	for(Goal__c g: AllGoals)
    	{
    	 	for(Asset__c a: AllAssets)
    	 	{
    	 		GoalAssetAssociation__c g1 = testData.intialize_GoalAssetAssociation(a, g);
    	 		GoalAssetAssociationsList1.add(g1);
    	 	}
    	}
    	insert GoalAssetAssociationsList1;
    	
    	Portfolio_Report__c port1 = testData.initialize_PortfolioReport(act, 'Birla Sun Life', 'EQ');
    	AllPortfolios.add(port1);
    	Portfolio_Report__c port2 = testData.initialize_PortfolioReport(act, 'Kotak Mahindra', 'MF');
    	AllPortfolios.add(port2);
    	Portfolio_Report__c port3 =  testData.initialize_PortfolioReport(act, 'HDFC', 'NOR');
  		AllPortfolios.add(port3);
  		//Portfolio_Report__c childPortfolio =  testData.initialize_PortfolioReport(child, 'HDFC', 'NOR');
  		Portfolio_Report__c childPortfolio = new Portfolio_Report__c( Entity__c=child.Id, Scheme_Scrip_Name__c='HDFC',Transaction_Type__c='NOR', Current_Value__c=2000,Portfolio_Type__c='EQ');
  		AllPortfolios.add(childPortfolio);	
  		insert AllPortfolios;
  		
  		for(Goal__c g: AllGoals)
  		{
    	 	for(Portfolio_Report__c a: AllPortfolios)
    	 	{
    	 		GoalIAULIPAssociation__c g1 = testData.init_GoalIAULIPAssociation(g, a);
    	 		GoalIAULIPAssociationsList1.add(g1);
    	 	}
    	}
    	insert GoalIAULIPAssociationsList1;	 
  			 
  		Insurance__c ins1 = testData.initialize_Insurance(act);		  			 
  		AllInsurances.add(ins1);
  		Insurance__c ins2 = testData.initialize_Insurance(act);
  		AllInsurances.add(ins2);
  		Insurance__c ins3 = testData.initialize_Insurance(act);
  		AllInsurances.add(ins3);
  		//Insurance__c childInsurance = testData.initialize_Insurance(act);
  		Insurance__c childInsurance = new Insurance__c( Entity__c=child.Id,Sum_Assured_Rs__c=3000,Surrender_Value__c=300,Policy_Type__c='Whole Life',Policy_Number_or_Name__c='abc Insurance Plan',Insurance_Company__c='',Categories__c='Equity');	 
  		AllInsurances.add(childInsurance);	 	 
  		insert AllInsurances;
  		  
  		for(Goal__c g: AllGoals)
  		{
    	 	for(Insurance__c a: AllInsurances){
    	 		GoalInsuranceAssociation__c g1 = testData.initialize_GoalIA(a, g);
    	 		GoalInsuranceAssociationsList1.add(g1);
    	 	}
    	}
    	insert GoalInsuranceAssociationsList1;	 
  		
  		PageReference Currentreference = new PageReference('/apex/Goal_Allocation?Id='+act.Id);
  		
        Test.setCurrentPage(Currentreference);
        GoalAllocationController gac=new GoalAllocationController(); 
                   
        String GoalValue=gac.getGoalValues();                       
            
        AssetsList= gac.getAllocateAssets();
        GoalAssetAssociationsList= AssetsList.get(0).goalList;         
        GoalAssetAssociationsList.get(0).Allocation__c=null;
        gac.id=AssetsList.get(0).assetType.Id;                    
        gac.updateUnallocatedAmount() ;   
          
                 
          GoalAssetAssociationsList.get(0).Allocation__c=100;
          gac.id=AssetsList.get(0).assetType.Id;                    
          gac.updateUnallocatedAmount() ; 
           
          
        //  gac.updateAllocationAsCategories(GoalAssetAssociationsList.get(0),'Assets');
                                       
          InvestmentAssetsList= gac.getAllocateInvestmentAssets();
          GoalIAULIPAssociationsList= InvestmentAssetsList.get(0).goalList;
          GoalIAULIPAssociationsList.get(0).Allocation__c=null;
          gac.id=InvestmentAssetsList.get(0).portfolio.Id;                    
          gac.updateUnallocatedAmountForInvAssets();
          GoalIAULIPAssociationsList.get(0).Allocation__c=200;
          gac.id=InvestmentAssetsList.get(0).portfolio.Id;                    
          gac.updateUnallocatedAmountForInvAssets();
        //  gac.updateAllocationAsCategories(GoalIAULIPAssociationsList.get(0),'InvestmentAssets');             
                                                       
          SIPList= gac.getAllocateSIP();
          GoalIAULIPAssociationsSIPList= SIPList.get(0).goalList;
          GoalIAULIPAssociationsSIPList.get(0).Allocation__c=null;
          gac.id=SIPList.get(0).portfolio.Id;                
          gac.updateUnallocatedAmountForSIP();
          GoalIAULIPAssociationsSIPList.get(0).Allocation__c=200;
          gac.id=SIPList.get(0).portfolio.Id;                
          gac.updateUnallocatedAmountForSIP();
        //  gac.updateAllocationAsCategories(GoalIAULIPAssociationsList.get(0),'InvestmentAssets');       
                                                    
          InsurancesList= gac.getAllocateInsurance();
          GoalInsuranceAssociationsList= InsurancesList.get(0).goalList;
          GoalInsuranceAssociationsList.get(0).Allocation__c=null;
          gac.id=InsurancesList.get(0).insurance.Id;             
          gac.updateUnallocatedAmountForInsurance();
          GoalInsuranceAssociationsList.get(0).Allocation__c=200;
          gac.id=InsurancesList.get(0).insurance.Id;             
          gac.updateUnallocatedAmountForInsurance();
       //   gac.updateAllocationAsCategories(GoalInsuranceAssociationsList.get(0),'Insurances');
       
       
         
         Integer numberOfGoals=gac.getCount();
         PageReference pgRef=gac.updateGoals();
        /// String str=pgRef.getUrl();
       //  System.assertEquals(str,act.id);
         
       //  System.assertEquals(3,numberOfGoals);
               
    }
    
    static testMethod void testGoalAllocationForChild() 
    {
    	/*
    	List<Asset__c> AllAssets = new List<Asset__c>();
        List<Portfolio_Report__c> AllPortfolios = new List<Portfolio_Report__c>();
        List<Insurance__c> AllInsurances = new List<Insurance__c>();
        List<Goal__c> AllGoals = new List<Goal__c>();
          
        Double d=10;
          
        List<GoalAllocationController.Assets> AssetsList=new  List<GoalAllocationController.Assets>();
        List<GoalAllocationController.Insurances> InsurancesList=new  List<GoalAllocationController.Insurances>();
        List<GoalAllocationController.InvestmentAssets> SIPList=new  List<GoalAllocationController.InvestmentAssets>();
        List<GoalAllocationController.InvestmentAssets> InvestmentAssetsList=new  List<GoalAllocationController.InvestmentAssets>();
          
        List<GoalAssetAssociation__c> GoalAssetAssociationsList=new  List<GoalAssetAssociation__c>();
        List<GoalIAULIPAssociation__c> GoalIAULIPAssociationsList=new  List<GoalIAULIPAssociation__c>();
        List<GoalIAULIPAssociation__c> GoalIAULIPAssociationsSIPList=new  List<GoalIAULIPAssociation__c>();
        List<GoalInsuranceAssociation__c> GoalInsuranceAssociationsList=new  List<GoalInsuranceAssociation__c>();
           
        List<GoalAssetAssociation__c> GoalAssetAssociationsList1=new  List<GoalAssetAssociation__c>();
        List<GoalIAULIPAssociation__c> GoalIAULIPAssociationsList1=new  List<GoalIAULIPAssociation__c>();
        List<GoalIAULIPAssociation__c> GoalIAULIPAssociationsSIPList1=new  List<GoalIAULIPAssociation__c>();
        List<GoalInsuranceAssociation__c> GoalInsuranceAssociationsList1=new  List<GoalInsuranceAssociation__c>();
        
        TestData_Ffreedom testData = new TestData_Ffreedom();
	
        Account child = testData.init_FamilyMember(act);
        insert child;   
        
        Goal_Profile__c goalProfile = testData.initialize_GoalProfile(act, 'Aggressive', 'Customized');
      	insert goalProfile;
      	
      	Goal__c goal1 = testData.initialize_Goal(act, 'Education', goalProfile);
      	AllGoals.add(goal1);
      	Goal__c goal2 = testData.initialize_Goal(act, 'Marriage', goalProfile);
    	AllGoals.add(goal2);
        Goal__c goal3 = testData.initialize_Goal(act, 'House', goalProfile);
    	AllGoals.add(goal3);            
        insert AllGoals;      
   	    
		Asset__c asset1 = testData.initialize_Asset(act, 'Land', AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c, '');   	     	  
    	AllAssets.add(asset1); 
    	Asset__c asset2 = testData.initialize_Asset(act, 'Vehicles', AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c, '');
    	AllAssets.add(asset2);
    	Asset__c asset3 = testData.initialize_Asset(act, 'Other', AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c, '');
    	AllAssets.add(asset3);  
    	Asset__c asset4 = testData.initialize_Asset(act, 'Vacation Home', AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c, '');
    	AllAssets.add(asset4);
    	Asset__c asset5 = testData.initialize_Asset(act, 'Jewelry', AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c, '');
    	AllAssets.add(asset5);
    	//Asset__c childAsset = testData.initialize_Asset(child, 'Jewelry', AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c, '');
    	Asset__c childAsset = new Asset__c(Entity__c= child.Id, Asset_Types__c='Jewelry', Current_Value__c=1000,Categories__c='Gold');
    	AllAssets.add(childAsset);        	    	  
    	insert AllAssets;
    	
    	for(Goal__c g: AllGoals)
    	{
    	 	for(Asset__c a: AllAssets)
    	 	{
    	 		GoalAssetAssociation__c g1 = testData.intialize_GoalAssetAssociation(a, g);
    	 		GoalAssetAssociationsList1.add(g1);
    	 	}
    	}
    	insert GoalAssetAssociationsList1;
    	
    	Portfolio_Report__c port1 = testData.initialize_PortfolioReport(act, 'Birla Sun Life', 'EQ');
    	AllPortfolios.add(port1);
    	Portfolio_Report__c port2 = testData.initialize_PortfolioReport(act, 'Kotak Mahindra', 'MF');
    	AllPortfolios.add(port2);
    	Portfolio_Report__c port3 =  testData.initialize_PortfolioReport(act, 'HDFC', 'NOR');
  		AllPortfolios.add(port3);
  		//Portfolio_Report__c childPortfolio =  testData.initialize_PortfolioReport(child, 'HDFC', 'NOR');
  		Portfolio_Report__c childPortfolio = new Portfolio_Report__c( Entity__c=child.Id, Scheme_Scrip_Name__c='HDFC',Transaction_Type__c='NOR', Current_Value__c=2000,Portfolio_Type__c='EQ');
  		AllPortfolios.add(childPortfolio);	
  		insert AllPortfolios;
  		
  		for(Goal__c g: AllGoals)
  		{
    	 	for(Portfolio_Report__c a: AllPortfolios)
    	 	{
    	 		GoalIAULIPAssociation__c g1 = testData.init_GoalIAULIPAssociation(g, a);
    	 		GoalIAULIPAssociationsList1.add(g1);
    	 	}
    	}
    	insert GoalIAULIPAssociationsList1;	 
  			 
  		Insurance__c ins1 = testData.initialize_Insurance(act);		  			 
  		AllInsurances.add(ins1);
  		Insurance__c ins2 = testData.initialize_Insurance(act);
  		AllInsurances.add(ins2);
  		Insurance__c ins3 = testData.initialize_Insurance(act);
  		AllInsurances.add(ins3);
  		//Insurance__c childInsurance = testData.initialize_Insurance(act);
  		Insurance__c childInsurance = new Insurance__c( Entity__c=child.Id,Sum_Assured_Rs__c=3000,Surrender_Value__c=300,Policy_Type__c='Whole Life',Policy_Number_or_Name__c='abc Insurance Plan',Insurance_Company__c='',Categories__c='Equity');	 
  		AllInsurances.add(childInsurance);	 	 
  		insert AllInsurances;
  		  
  		for(Goal__c g: AllGoals)
  		{
    	 	for(Insurance__c a: AllInsurances){
    	 		GoalInsuranceAssociation__c g1 = testData.initialize_GoalIA(a, g);
    	 		GoalInsuranceAssociationsList1.add(g1);
    	 	}
    	}
    	insert GoalInsuranceAssociationsList1;	 
  		
  		PageReference Currentreference = new PageReference('/apex/Goal_Allocation?Id='+act.Id);
  		
        Test.setCurrentPage(Currentreference);
        GoalAllocationController gac=new GoalAllocationController(); 
                   
        String GoalValue=gac.getGoalValues();                       
            
        AssetsList= gac.getAllocateAssets();
        GoalAssetAssociationsList= AssetsList.get(0).goalList;         
        GoalAssetAssociationsList.get(0).Allocation__c=null;
        gac.id=AssetsList.get(0).assetType.Id;                    
        gac.updateUnallocatedAmount() ;   
          
                 
          GoalAssetAssociationsList.get(0).Allocation__c=100;
          gac.id=AssetsList.get(0).assetType.Id;                    
          gac.updateUnallocatedAmount() ; 
           
          
        //  gac.updateAllocationAsCategories(GoalAssetAssociationsList.get(0),'Assets');
                                       
          InvestmentAssetsList= gac.getAllocateInvestmentAssets();
          GoalIAULIPAssociationsList= InvestmentAssetsList.get(0).goalList;
          GoalIAULIPAssociationsList.get(0).Allocation__c=null;
          gac.id=InvestmentAssetsList.get(0).portfolio.Id;                    
          gac.updateUnallocatedAmountForInvAssets();
          GoalIAULIPAssociationsList.get(0).Allocation__c=200;
          gac.id=InvestmentAssetsList.get(0).portfolio.Id;                    
          gac.updateUnallocatedAmountForInvAssets();
        //  gac.updateAllocationAsCategories(GoalIAULIPAssociationsList.get(0),'InvestmentAssets');             
                                                       
          SIPList= gac.getAllocateSIP();
          GoalIAULIPAssociationsSIPList= SIPList.get(0).goalList;
          GoalIAULIPAssociationsSIPList.get(0).Allocation__c=null;
          gac.id=SIPList.get(0).portfolio.Id;                
          gac.updateUnallocatedAmountForSIP();
          GoalIAULIPAssociationsSIPList.get(0).Allocation__c=200;
          gac.id=SIPList.get(0).portfolio.Id;                
          gac.updateUnallocatedAmountForSIP();
        //  gac.updateAllocationAsCategories(GoalIAULIPAssociationsList.get(0),'InvestmentAssets');       
                                                    
          InsurancesList= gac.getAllocateInsurance();
          GoalInsuranceAssociationsList= InsurancesList.get(0).goalList;
          GoalInsuranceAssociationsList.get(0).Allocation__c=null;
          gac.id=InsurancesList.get(0).insurance.Id;             
          gac.updateUnallocatedAmountForInsurance();
          GoalInsuranceAssociationsList.get(0).Allocation__c=200;
          gac.id=InsurancesList.get(0).insurance.Id;             
          gac.updateUnallocatedAmountForInsurance();
       //   gac.updateAllocationAsCategories(GoalInsuranceAssociationsList.get(0),'Insurances');
       
       
         
         Integer numberOfGoals=gac.getCount();
         PageReference pgRef=gac.updateGoals();
        /// String str=pgRef.getUrl();
       //  System.assertEquals(str,act.id);
         
    	*/
    	
    }
}