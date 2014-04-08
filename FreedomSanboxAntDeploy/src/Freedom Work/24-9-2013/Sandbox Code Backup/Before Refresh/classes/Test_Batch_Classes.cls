/*
	
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         --           	   --	  		Initial Draft
    2.0			Manasi			   30/06/2011	Issue id : F0061 : 
    											Created test method testUpdateCurrentAgeFormBirthdate() for 
    											UpdateCurrentAgeFormBirthdateOfEntity batch class.
*/					  							
@isTest
 private class Test_Batch_Classes {
 	
 	
 	//This is the test method for CreateSummaryReport Batch class
	public static testMethod void testCreateSummary() {
		Test.StartTest();
		List <Purchase_Sales_Report__c> purchaseSalesList = new List<Purchase_Sales_Report__c>();
		List <Portfolio_Report__c> portfolioList = new List<Portfolio_Report__c>();
		
		Date CurrentDate =  date.newinstance(2010, 1, 1);
		Date navDate =  date.newinstance(2011, 1, 1);
		Account act = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active');
        insert act;
		
		/*Portfolio_Report__c pf1 = new Portfolio_Report__c(Entity__c=act.Id,UniqueName__c='UniqueName1',Asset_Class__c='Equity : Shares',  Scheme_Scrip_Name__c='Birla Sun Life',Transaction_Type__c='SIP', Current_Value__c=2000,Portfolio_Type__c='EQ',Units_Quanitity__c=100,Purchase_Amount__c=2000,Folio_Number__c ='1',Absolute_Ret__c=10,Annualized_Ret__c=20,Dividend_Reivestment__c ='Yes',Nav_p__c=5,Gain__c=10);
    	portfolioList.add(pf1);
    	Portfolio_Report__c pf2 = new Portfolio_Report__c(Entity__c=act.Id,UniqueName__c='UniqueName2',Asset_Class__c='Debt: Floating Rate ',  Scheme_Scrip_Name__c='Kotak Mahindra',Transaction_Type__c='SIP', Current_Value__c=2000,Portfolio_Type__c='MF',Units_Quanitity__c=100,Purchase_Amount__c=2000,Folio_Number__c ='2',Absolute_Ret__c=10,Annualized_Ret__c=20,Dividend_Reivestment__c ='Yes',Nav_p__c=5,Gain__c=10);
    	portfolioList.add(pf2);
    	insert portfolioList;*/
		
		/*Purchase_Sales_Report__c PS1=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName1',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Birla Sun Life',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=100, DividendReivestment__c='Yes', Transaction__c='Sales');
  		purchaseSalesList.add(PS1);
  		Purchase_Sales_Report__c PS2=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Kotak Mahindra',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=0, DividendReivestment__c='Yes', Transaction__c='Purchase');
  		purchaseSalesList.add(PS2);
  		Purchase_Sales_Report__c PS3=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Kotak Mahindra',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=0, DividendReivestment__c='Yes', Transaction__c='Purchase');
  		purchaseSalesList.add(PS3);*/
  		Purchase_Sales_Report__c PS4=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Kotak Mahindra',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=0, DividendReivestment__c='Yes', Transaction__c='Purchase');
  		purchaseSalesList.add(PS4);
  		insert purchaseSalesList;
  		
  	    
        CreateSummaryReport createSR=new CreateSummaryReport();
        createSR.query='Select p.Units__c, p.Unique_Name__c, p.Type__c, p.Transaction__c, p.Scheme_Name__c, p.Product__c, p.Net_Gain__c, p.NAV__c, p.NAV_Date__c, p.Id, p.Folio_Number__c, p.Entity__c, p.Days__c, p.Current_Value__c, p.Current_Date__c, p.CurrencyIsoCode, p.Annualized_Return__c, p.Amount__c, p.Absolute_Return__c From Purchase_Sales_Report__c p LIMIT 20';
        createSR.email='tech@ffreedom.in';
        database.executebatch(createSR);
  	    Test.StopTest();
	}
	
	//This is the test method for CreatePortfolioReport Batch class
	public static testMethod void testCreatePortfolioReport() {
		Test.StartTest();
		List <Purchase_Sales_Report__c> purchaseSalesList = new List<Purchase_Sales_Report__c>();
		List <Temp_Purchase_Report__c> portfolioList = new List<Temp_Purchase_Report__c>();
		
		Date CurrentDate =  date.newinstance(2010, 1, 1);
		Date navDate =  date.newinstance(2011, 1, 1);
		Account act = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active');
        insert act;
		
		Temp_Purchase_Report__c pf1 = new Temp_Purchase_Report__c( Product__c=1,Entity__c=act.Id,UniqueName__c='UniqueName1',Asset_Class__c='Equity : Shares',  Scheme_Scrip_Name__c='Bharti AXA - Equity Fund Eco (G)', Current_Value__c=2000,Units_Quanitity__c=100,Purchase_Amount__c=2000,Folio_Number__c ='1',Absolute_Ret__c=10,Annualized_Ret__c=20,Nav_p__c=5,Gain__c=10, Sales_Units__c=0);
    	portfolioList.add(pf1);
    	Temp_Purchase_Report__c pf2 = new Temp_Purchase_Report__c( Product__c=1,Entity__c=act.Id,UniqueName__c='UniqueName2',Asset_Class__c='Debt: Floating Rate ',  Scheme_Scrip_Name__c='Bharti AXA - Treasury Adv Ret (G)',Current_Value__c=2000,Units_Quanitity__c=100,Purchase_Amount__c=2000,Folio_Number__c ='2',Absolute_Ret__c=10,Annualized_Ret__c=20,Nav_p__c=5,Gain__c=10,Sales_Units__c=-10);
    	portfolioList.add(pf2);
    	insert portfolioList;
	
		
		Purchase_Sales_Report__c PS1=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName1',Units__c=10,Absolute_Return__c=10,Scheme_Name__c='Birla Sun Life',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=100, Type__c='NOR',DividendReivestment__c='Yes', Transaction__c='Purchase');
  		purchaseSalesList.add(PS1);
  		Purchase_Sales_Report__c PS2=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Scheme_Name__c='Kotak Mahindra',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=0, Type__c='DIR', DividendReivestment__c='Yes', Transaction__c='Purchase');
  		purchaseSalesList.add(PS2);
  		Purchase_Sales_Report__c PS3=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Scheme_Name__c='Kotak Mahindra',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=0, Type__c='DVP', DividendReivestment__c='Yes', Transaction__c='Purchase');
  		purchaseSalesList.add(PS3);
  		Purchase_Sales_Report__c PS4=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Scheme_Name__c='Kotak Mahindra',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=0,Type__c='STI', DividendReivestment__c='Yes', Transaction__c='Purchase');
  		purchaseSalesList.add(PS4);
  		Purchase_Sales_Report__c PS5=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Scheme_Name__c='Kotak Mahindra',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=0, Type__c='SIP', DividendReivestment__c='Yes', Transaction__c='Purchase');
  		purchaseSalesList.add(PS5);
  		Purchase_Sales_Report__c PS6=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Scheme_Name__c='Kotak Mahindra',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=0, Type__c='DVP', DividendReivestment__c='Yes', Transaction__c='Sales');
  		purchaseSalesList.add(PS6);
  		insert purchaseSalesList;
  		
  	    
        CreatePortfolioReport createSR=new CreatePortfolioReport();
        createSR.query='Select p.Units__c, p.Unique_Name__c, p.Type__c, p.Transaction__c, p.Asset_Class__c,p.Scheme_Name__c, p.Product__c, p.Net_Gain__c, p.NAV__c, p.NAV_Date__c, p.Id, p.Folio_Number__c, p.Entity__c, p.Days__c, p.Current_Value__c, p.Current_Date__c, p.CurrencyIsoCode, p.Annualized_Return__c, p.Amount__c, p.Absolute_Return__c From Purchase_Sales_Report__c p where Entity__c=\''+act.Id+'\' ORDER BY Nav_Date__c ASC LIMIT 20';
        createSR.email='tech@ffreedom.in';
        database.executebatch(createSR);
  	    Test.StopTest();
	}
	
	//This is the test method for CalculateSalesUnit Batch class
	public static testMethod void testCalculateSalesUnit() {
		Test.StartTest();
		List <Purchase_Sales_Report__c> purchaseSalesList = new List<Purchase_Sales_Report__c>();
		List <Portfolio_Report__c> portfolioList = new List<Portfolio_Report__c>();
		
		Date CurrentDate =  date.newinstance(2010, 1, 1);
		Date navDate =  date.newinstance(2011, 1, 1);
		Account act = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active');
        insert act;
		
		Portfolio_Report__c pf1 = new Portfolio_Report__c(Entity__c=act.Id,UniqueName__c='UniqueName1',Asset_Class__c='Equity : Shares',  Scheme_Scrip_Name__c='Birla Sun Life',Transaction_Type__c='SIP', Current_Value__c=2000,Portfolio_Type__c='EQ',Units_Quanitity__c=100,Purchase_Amount__c=2000,Folio_Number__c ='1',Absolute_Ret__c=10,Annualized_Ret__c=20,Dividend_Reivestment__c ='Yes',Nav_p__c=5,Gain__c=10);
    	portfolioList.add(pf1);
    	Portfolio_Report__c pf2 = new Portfolio_Report__c(Entity__c=act.Id,UniqueName__c='UniqueName2',Asset_Class__c='Debt: Floating Rate ',  Scheme_Scrip_Name__c='Kotak Mahindra',Transaction_Type__c='SIP', Current_Value__c=2000,Portfolio_Type__c='MF',Units_Quanitity__c=100,Purchase_Amount__c=2000,Folio_Number__c ='2',Absolute_Ret__c=10,Annualized_Ret__c=20,Dividend_Reivestment__c ='Yes',Nav_p__c=5,Gain__c=10);
    	portfolioList.add(pf2);
    	insert portfolioList;
		
		Purchase_Sales_Report__c PS1=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName1',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Birla Sun Life',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=100, DividendReivestment__c='Yes', Transaction__c='Sales');
  		purchaseSalesList.add(PS1);
  		Purchase_Sales_Report__c PS2=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Kotak Mahindra',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=0, DividendReivestment__c='Yes', Transaction__c='Sales');
  		purchaseSalesList.add(PS2);
  		Purchase_Sales_Report__c PS3=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Kotak Mahindra',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=0, DividendReivestment__c='Yes', Transaction__c='Sales');
  		purchaseSalesList.add(PS3);
  		Purchase_Sales_Report__c PS4=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Kotak Mahindra',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=0, DividendReivestment__c='Yes', Transaction__c='Sales');
  		purchaseSalesList.add(PS4);
  		Purchase_Sales_Report__c PS5=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Kotak Mahindra',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=0, DividendReivestment__c='Yes', Transaction__c='Sales');
  		purchaseSalesList.add(PS5);
  		Purchase_Sales_Report__c PS6=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Kotak Mahindra',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=0, DividendReivestment__c='Yes', Transaction__c='Sales');
  		purchaseSalesList.add(PS6);
  		insert purchaseSalesList;
  		
  	    
        CalculateSalesUnits createSR=new CalculateSalesUnits();
        createSR.query='Select p.Units__c, p.Unique_Name__c, p.Type__c, p.Transaction__c, p.Scheme_Name__c, p.Product__c, p.Net_Gain__c, p.NAV__c, p.NAV_Date__c, p.Id, p.Folio_Number__c, p.Entity__c, p.Days__c, p.Current_Value__c, p.Current_Date__c, p.CurrencyIsoCode, p.Annualized_Return__c, p.Amount__c, p.Absolute_Return__c From Purchase_Sales_Report__c p where Transaction__c=\'Sales\'ORDER BY Nav_Date__c ASC LIMIT 20';
        createSR.email='tech@ffreedom.in';
        database.executebatch(createSR);
  	    Test.StopTest();
	}
	
	// This is the test method for CalculateReturnsforSummaryReport Batch class
	public static testMethod void testCalculateSummaryReturns() {
  		Test.StartTest();
		List <Purchase_Sales_Report__c> purchaseSalesList = new List<Purchase_Sales_Report__c>();
		List <Portfolio_Report__c> portfolioList = new List<Portfolio_Report__c>();
		
		Date CurrentDate =  date.newinstance(2010, 1, 1);
		Date navDate =  date.newinstance(2011, 1, 1);
		Account act = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active');
        insert act;
		
		Portfolio_Report__c pf1 = new Portfolio_Report__c(Entity__c=act.Id,UniqueName__c='UniqueName1',Asset_Class__c='Equity : Shares',  Scheme_Scrip_Name__c='Birla Sun Life',Transaction_Type__c='SIP', Current_Value__c=2000,Portfolio_Type__c='EQ',Units_Quanitity__c=100,Purchase_Amount__c=2000,Folio_Number__c ='1',Absolute_Ret__c=10,Annualized_Ret__c=20,Dividend_Reivestment__c ='Yes',Nav_p__c=5,Gain__c=10);
    	portfolioList.add(pf1);
    	Portfolio_Report__c pf2 = new Portfolio_Report__c(Entity__c=act.Id,UniqueName__c='UniqueName2',Asset_Class__c='Debt: Floating Rate ',  Scheme_Scrip_Name__c='Kotak Mahindra',Transaction_Type__c='SIP', Current_Value__c=2000,Portfolio_Type__c='MF',Units_Quanitity__c=100,Purchase_Amount__c=2000,Folio_Number__c ='2',Absolute_Ret__c=10,Annualized_Ret__c=20,Dividend_Reivestment__c ='Yes',Nav_p__c=5,Gain__c=10);
    	portfolioList.add(pf2);
    	insert portfolioList;
		
		
  	    CalculateReturnsforSummaryReport crs=new CalculateReturnsforSummaryReport();
        crs.query='Select Gain__c, Units_Quanitity__c, Scheme_Scrip_Name__c, Product__c, Purchase_Amount__c, Portfolio_Type__c, Folio_Number__c, Current_Value__c,Absolute_Ret__c,Annualized_Ret__c,UniqueName__c,Nav_p__c From Portfolio_Report__c LIMIT 20';
        crs.email='tech@ffreedom.in';
        database.executebatch(crs);
        Test.StopTest();
	}
	
	// This is the test method for CalculateReturnsforPFReport Batch class
/*	public static testMethod void testCalculateReturnsforPFReport() {
		Test.StartTest();
		List <Purchase_Sales_Report__c> purchaseSalesList = new List<Purchase_Sales_Report__c>();
		List <Temp_Purchase_Report__c> portfolioList = new List<Temp_Purchase_Report__c>();
		
		Date CurrentDate =  date.newinstance(2010, 1, 1);
		Date navDate =  date.newinstance(2011, 1, 1);
		Account act = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active');
        insert act;
		
		Temp_Purchase_Report__c pf1 = new Temp_Purchase_Report__c( Product__c=1,Entity__c=act.Id,UniqueName__c='UniqueName1',Asset_Class__c='Equity : Shares',  Scheme_Scrip_Name__c='Bharti AXA - Equity Fund Eco (G)', Current_Value__c=2000,Units_Quanitity__c=100,Purchase_Amount__c=2000,Folio_Number__c ='1',Absolute_Ret__c=10,Annualized_Ret__c=20,Nav_p__c=5,Gain__c=10);
    	portfolioList.add(pf1);
    	Temp_Purchase_Report__c pf2 = new Temp_Purchase_Report__c( Product__c=1,Entity__c=act.Id,UniqueName__c='UniqueName2',Asset_Class__c='Debt: Floating Rate ',  Scheme_Scrip_Name__c='Bharti AXA - Treasury Adv Ret (G)',Current_Value__c=2000,Units_Quanitity__c=100,Purchase_Amount__c=2000,Folio_Number__c ='2',Absolute_Ret__c=10,Annualized_Ret__c=20,Nav_p__c=5,Gain__c=10);
    	portfolioList.add(pf2);
    	insert portfolioList;
	
  		
  		
  	    CalculateReturnsforPFReport crs=new CalculateReturnsforPFReport();
        crs.query='Select Gain__c, Units_Quanitity__c, Scheme_Scrip_Name__c, Dividend__c, STP_Switch__c,Dividend_Reinvested__c,Product__c, Purchase_Amount__c, Folio_Number__c, Current_Value__c,Absolute_Ret__c,Annualized_Ret__c,UniqueName__c,Nav_p__c From Temp_Purchase_Report__c LIMIT 20';
        crs.email='tech@ffreedom.in';
        database.executebatch(crs);
        Test.StopTest();
	}
	*/
	// This is the test method for CalculateReturnsforDetailReport batch class
	public static testMethod void testCalculateDetailReturns() {
		List <Purchase_Sales_Report__c> purchaseSalesList = new List<Purchase_Sales_Report__c>();
		List <Portfolio_Report__c> portfolioList = new List<Portfolio_Report__c>();
		
		Date CurrentDate =  date.newinstance(2010, 1, 1);
		Date navDate =  date.newinstance(2011, 1, 1);
		Account act = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active');
        insert act;
		
		Portfolio_Report__c pf1 = new Portfolio_Report__c(Entity__c=act.Id,UniqueName__c='UniqueName1',Asset_Class__c='Equity : Shares',  Scheme_Scrip_Name__c='Birla Sun Life',Transaction_Type__c='SIP', Current_Value__c=2000,Portfolio_Type__c='EQ',Units_Quanitity__c=100,Purchase_Amount__c=2000,Folio_Number__c ='1',Absolute_Ret__c=10,Annualized_Ret__c=20,Dividend_Reivestment__c ='Yes',Nav_p__c=5,Gain__c=10);
    	portfolioList.add(pf1);
    	Portfolio_Report__c pf2 = new Portfolio_Report__c(Entity__c=act.Id,UniqueName__c='UniqueName2',Asset_Class__c='Debt: Floating Rate ',  Scheme_Scrip_Name__c='Kotak Mahindra',Transaction_Type__c='SIP', Current_Value__c=2000,Portfolio_Type__c='MF',Units_Quanitity__c=100,Purchase_Amount__c=2000,Folio_Number__c ='2',Absolute_Ret__c=10,Annualized_Ret__c=20,Dividend_Reivestment__c ='Yes',Nav_p__c=5,Gain__c=10);
    	portfolioList.add(pf2);
    	insert portfolioList;
		
		Purchase_Sales_Report__c PS1=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName1',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Birla Sun Life',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=100, DividendReivestment__c='Yes', Transaction__c='Sales');
  		purchaseSalesList.add(PS1);
  		Purchase_Sales_Report__c PS2=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Kotak Mahindra',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=0, DividendReivestment__c='Yes', Transaction__c='Purchase');
  		purchaseSalesList.add(PS2);
  		Purchase_Sales_Report__c PS3=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Kotak Mahindra',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=0, DividendReivestment__c='Yes', Transaction__c='Purchase');
  		purchaseSalesList.add(PS3);
  		Purchase_Sales_Report__c PS4=new Purchase_Sales_Report__c(Current_Date__c=CurrentDate,Days__c=10,NAV_Date__c=navDate,Product__c=100,Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Kotak Mahindra',Net_Gain__c=10,NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=0, DividendReivestment__c='Yes', Transaction__c='Purchase');
  		purchaseSalesList.add(PS4);
  		insert purchaseSalesList;
  		
  		Test.StartTest();
  		CalculateReturnsforDetailReport crd = new CalculateReturnsforDetailReport();
  		crd.query = 'Select p.Units__c, p.Unique_Name__c, p.Type__c, p.Transaction__c, p.Scheme_Name__c, p.Product__c, p.Net_Gain__c, p.NAV__c, p.NAV_Date__c, p.Id, p.Folio_Number__c, p.Entity__c, p.Days__c, p.Current_Value__c, p.Current_Date__c, p.CurrencyIsoCode, p.Annualized_Return__c, p.Amount__c, p.Absolute_Return__c From Purchase_Sales_Report__c p LIMIT 20';
        crd.email= 'tech@ffreedom.in';
        database.executebatch(crd);
  		Test.stopTest();
	}
	
	
	// This is the test method for CalculateSipDueDates batch class
	 static testMethod void testCalculateSipDueDates() {
        Test.StartTest();
        Date   startDate=  date.newInstance(2010,1,1);
        Date   endDate=  startDate.addYears(10);
        Date dueDate = System.today();
        
		List<SIP_Tracker__c > AllSips = new List<SIP_Tracker__c >();
		Account act = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active');
        insert act;
        
        SIP_Tracker__c sip1 =  new SIP_Tracker__c(Entity__c=act.Id,Scheme__c='abc',Frequency__c='Daily', SIP_Start_Date__c=startDate,SIP_End_Date__c=endDate,Folio_Number__c='1235',SIP_Amount__c=1000,Due_Date__c=dueDate  );
        AllSips.add(sip1);
        SIP_Tracker__c sip2 =  new SIP_Tracker__c(Entity__c=act.Id,Scheme__c='abc',Frequency__c='Monthly', SIP_Start_Date__c=startDate,SIP_End_Date__c=endDate,Folio_Number__c='1235',SIP_Amount__c=1000,Due_Date__c=dueDate  );
        AllSips.add(sip2);
        SIP_Tracker__c sip3 =  new SIP_Tracker__c(Entity__c=act.Id,Scheme__c='abc',Frequency__c='Weekly', SIP_Start_Date__c=startDate,SIP_End_Date__c=endDate,Folio_Number__c='1235',SIP_Amount__c=1000,Due_Date__c=dueDate  );
        AllSips.add(sip3);
        SIP_Tracker__c sip4 =  new SIP_Tracker__c(Entity__c=act.Id,Scheme__c='abc',Frequency__c='Quarterly', SIP_Start_Date__c=startDate,SIP_End_Date__c=endDate,Folio_Number__c='1235',SIP_Amount__c=1000,Due_Date__c=dueDate  );
        AllSips.add(sip4);
        insert AllSips;
        
        CalculateSipNextDueDates calSip=new CalculateSipNextDueDates();
       // calSip.query='Select s.Frequency__c, s.Due_Date__c From SIP_Tracker__c s where LIMIT 20';
       calSip.query='Select s.Frequency__c, s.Due_Date__c From SIP_Tracker__c s where Entity__c= \''+act.id+'\'';
        calSip.email='tech@ffreedom.in';
        database.executebatch(calSip); 
        Test.stopTest();
    }
    
     // This is the test method for CalInsuranceDueDate batch class
	static testMethod void testCalInsuranceDueDate() {
        Test.StartTest(); 
        Date   dueDate1=  System.today();
        Date   dueDate2=  dueDate1.addDays(10);
        date endDate = dueDate1.addYears(10);
		List<Insurance__c> AllInsurances = new List<Insurance__c>();
		Account act = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active');
        insert act;
        
        Insurance__c ins1 = new Insurance__c( Entity__c=act.Id,Premium_Due_date__c=dueDate1,Insurance_Company__c='abc',  Premium_End_Date__c=endDate, Sum_Assured_Rs__c=3000,Premium_Frequency__c='Annually',Premium_Amount_Rs__c =10000,Policy_Type__c='Other',Categories__c='Gold');
  		AllInsurances.add(ins1);
  		Insurance__c ins2 = new Insurance__c( Entity__c=act.Id,Premium_Due_date__c=dueDate2,Insurance_Company__c='xyz', Premium_End_Date__c=endDate, Sum_Assured_Rs__c=3000,Premium_Frequency__c='Annually',Premium_Amount_Rs__c =10000,Policy_Type__c='Term Life',Categories__c='Real Estate');	 
  		AllInsurances.add(ins2);
  		insert AllInsurances;
  		
  		CalculateInsuranceNextDueDates calInsurance=new CalculateInsuranceNextDueDates();
        calInsurance.query='Select i.Premium_Frequency__c,  i.Premium_Due_date__c From Insurance__c i where Entity__c= \''+act.id+'\'';
        calInsurance.email='tech@ffreedom.in';
        database.executebatch(calInsurance); 
  	    Test.StopTest();
    }
    
    // This is the test method for UpdateTribalFlagToFalseForLead batch class
    static testMethod void testUpdateTribalFlagToFalseForLead() {
    	Test.StartTest();
    	Lead ld1 = new Lead(FirstName='Test_Lead_Fname',LastName='Test_Lead_Lname',Status='Open',Tribal_Activity_Flag__c=True);
        insert ld1;
        
        UpdateTribalFlagToFalseForLead tribalActivityFalse = new UpdateTribalFlagToFalseForLead();
        tribalActivityFalse.query =' Select Tribal_Activity_Flag__c From Lead where Status != \'Converted\' LIMIT 20';
    	tribalActivityFalse.email= 'tech@ffreedom.in';
    	database.executebatch(tribalActivityFalse); 
    	Test.StopTest();
    }
    
    // This is the test method for UpdateTribalFlagToTrueForLead batch class
    static testMethod void testUpdateTribalFlagToTrueForLead() {
    	Test.StartTest();
    	Lead ld1 = new Lead(FirstName='Test_Lead_Fname',LastName='Test_Lead_Lname',Status='Open',Tribal_Activity_Flag__c=False);
        insert ld1;
        
        UpdateTribalFlagToTrueForLead tribalActivityTrue = new UpdateTribalFlagToTrueForLead();
        tribalActivityTrue.query =' Select Tribal_Activity_Flag__c From Lead where Status != \'Converted\' LIMIT 20' ;
    	tribalActivityTrue.email= 'tech@ffreedom.in';
    	database.executebatch(tribalActivityTrue); 
    	Test.StopTest(); 
    }
    
    // This is the test method for UpdateTribalFlagToTrueForAccount batch class
    static testMethod void testUpdateTribalFlagToTrueForAccount() {
    	Test.StartTest();
    	List<Account> accList = new List<Account>();
    	
    	//mahesh : Deployment
    	Map<String, Id> mapRecordTypes = new Map<String, Id>();// Deployment : mahesh 
    	for(RecordType objRecordType : [Select SobjectType, Name, IsActive, Id, DeveloperName, Description From RecordType])
    	{
    		mapRecordTypes.put(objRecordType.Name, objRecordType.Id);
    	}
    	
    	//Account acc = [select RecordTypeId,RecordType.Name  from Account where RecordType.Name='Client' LIMIT 1];
    	//System.debug('Record Type Name:'+acc.RecordType.Name);
    	
    	/* mahesh : Deployment *
    	Account client = [select RecordTypeId  from Account where RecordType.Name='Client' LIMIT 1];
		Account influencers = [select RecordTypeId  from Account where RecordType.Name='Influencers' LIMIT 1];
		Account child = [select RecordTypeId  from Account where RecordType.Name='Family Member' LIMIT 1];
		*/
		
		/*Mahesh : Deployment */
    	//Account clientEntity = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active',RecordTypeId=client.RecordTypeId,Tribal_Activity_Flag__c=False);
    	Account clientEntity = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active',RecordTypeId = mapRecordTypes.get('Client'),Tribal_Activity_Flag__c=False);
    	accList.add(clientEntity);
    	//Account influencer1 = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active',RecordTypeId=influencers.RecordTypeId,Category__c='Press',Tribal_Activity_Flag__c=False);
    	Account influencer1 = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active',RecordTypeId=mapRecordTypes.get('Family Member'),Category__c='Press',Tribal_Activity_Flag__c=False);
    	accList.add(influencer1);
    	//Account influencer2 = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active',RecordTypeId=influencers.RecordTypeId,Category__c='Vendors',Tribal_Activity_Flag__c=False);
    	Account influencer2 = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active',RecordTypeId=mapRecordTypes.get('Influencers'),Category__c='Vendors',Tribal_Activity_Flag__c=False);
    	accList.add(influencer2);
    	//Account familyMember = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active',RecordTypeId=child.RecordTypeId,Tribal_Activity_Flag__c=False);
    	Account familyMember = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active',RecordTypeId=mapRecordTypes.get('Client'),Tribal_Activity_Flag__c=False);
    	accList.add(familyMember);
        insert accList;
        
        UpdateTribalFlagToTrueForAccount tribalActivityTrue = new UpdateTribalFlagToTrueForAccount();
    	tribalActivityTrue.query ='Select Tribal_Activity_Flag__c From Account where RecordType.Name=\''+ 'Client' + '\' OR (RecordType.Name=\''+'Influencers' + '\'  AND Category__c != \'Press\') LIMIT 20';
    	tribalActivityTrue.email= 'tech@ffreedom.in';
    	database.executebatch(tribalActivityTrue); 
        
    	Test.StopTest(); 
    }
    
    // This is the test method for UpdateTribalFlagFalseForAccount batch class
     static testMethod void testUpdateTribalFlagFalseForAccount() {
    		Test.StartTest();
    	List<Account> accList = new List<Account>();
    	
    	//Account acc = [select RecordTypeId,RecordType.Name  from Account where RecordType.Name='Client' LIMIT 1];
    	//System.debug('Record Type Name:'+acc.RecordType.Name);
    	
    	//mahesh : Deployment
    	Map<String, Id> mapRecordTypes = new Map<String, Id>();// Deployment : mahesh 
    	for(RecordType objRecordType : [Select SobjectType, Name, IsActive, Id, DeveloperName, Description From RecordType where SobjectType='Account'])
    	{
    		mapRecordTypes.put(objRecordType.Name, objRecordType.Id);
    	}
    	
		/* Mahesh : Deployment *
    	Account client = [select RecordTypeId  from Account where RecordType.Name='Client' LIMIT 1];
		Account influencers = [select RecordTypeId  from Account where RecordType.Name='Influencers' LIMIT 1];
		Account child = [select RecordTypeId  from Account where RecordType.Name='Family Member' LIMIT 1];
		*/
		/**/
    	//Account clientEntity = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active',RecordTypeId=client.RecordTypeId,Tribal_Activity_Flag__c=True);
    	Account clientEntity = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active',RecordTypeId=mapRecordTypes.get('Client'),Tribal_Activity_Flag__c=True);
    	accList.add(clientEntity);
    	Account influencer1 = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active',RecordTypeId=mapRecordTypes.get('Influencers'),Category__c='Press',Tribal_Activity_Flag__c=True);
    	accList.add(influencer1);
    	Account influencer2 = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active',RecordTypeId=mapRecordTypes.get('Influencers'),Category__c='Vendors',Tribal_Activity_Flag__c=True);
    	accList.add(influencer2);
    	Account familyMember = new Account(FirstName='Test_Parent_Fname',LastName='Test_Parent_Lname',Entity_Status__c='Active',RecordTypeId=mapRecordTypes.get('Client'),Tribal_Activity_Flag__c=True);
    	accList.add(familyMember);
        insert accList;
       UpdateTribalFlagToFalseForAccount tribalActivityFalse = new UpdateTribalFlagToFalseForAccount();
       tribalActivityFalse.query = 'Select Tribal_Activity_Flag__c From Account where RecordType.Name=\''+ 'Client' + '\' OR (RecordType.Name=\''+'Influencers' + '\'  AND Category__c != \'Press\') LIMIT 20';
       tribalActivityFalse.email= 'tech@ffreedom.in';
       database.executebatch(tribalActivityFalse); 
    	Test.StopTest(); 
    }
	/** Eternus Solutions       **/
	/** Author  : Manasi Ranade **/
	/** Issue Id: F0061      	**/
	/** Date    : 30/06/2011 	**/
	/** Purpose : Created test method testUpdateCurrentAgeFormBirthdate() for UpdateCurrentAgeFormBirthdateOfEntity batch class.
	/****************************************************/ 
    static testMethod void testUpdateCurrentAgeFormBirthdate() {
        List <Account> accns = new List<Account>();
	    for(integer i = 0; i<20; i++)
	    {
	       Account a = new Account(
		       						   FirstName='testAccount'+'i', 
		                   			   LastName='Test_Parent_Lname',
	    					 		   PersonBirthdate = System.today().addYears(-25)
    					 		   ); 
	       accns.add(a);
	    }
      	insert accns;
        Test.StartTest();
     	UpdateCurrentAgeFormBirthdateOfEntity objUpdateCurrentAge = new UpdateCurrentAgeFormBirthdateOfEntity();
    	objUpdateCurrentAge.query =  'Select Id,PersonBirthdate,Current_Age__c,Entity_Status__c from Account LIMIT 20';
	    objUpdateCurrentAge.email= 'tech@ffreedom.in';
	    ID batchprocessid = database.executebatch(objUpdateCurrentAge,20);
     	Test.StopTest();
     	String strLastName = 'Test_Parent_Lname';
     	System.AssertEquals(database.countquery('SELECT count() FROM Account WHERE LastName =:  strLastName' ),20);
    }
	
	
}