@isTest
private class Test_ConsolidatedStatementController {

    static testMethod void myUnitTest() {
         
         List<Asset__c> allAssets = new List<Asset__c>();
         List<Portfolio_Report__c> allPortfolios = new List<Portfolio_Report__c>();
         List<Insurance__c> allInsurances = new List<Insurance__c>();
         List<Loan__c> allLoans = new List<Loan__c>();
         
         Account act = new Account(FirstName='TestHello', LastName='TestWorld', Entity_Status__c='Active',Life_Insurance_Suggested_Cover__c=1000);
         insert act;
         Account child=new Account(Parent_Entity__c=act.Id,FirstName='ChildTestHello', LastName='ChildTestWorld', Entity_Status__c='Active',Life_Insurance_Suggested_Cover__c=1000);
         insert child;   
         PageReference ref = new PageReference ('apex/ConsolidatedStatement?Id='+act.Id);
         Test.setCurrentPageReference(ref);
         Portfolio_Report__c port1 = new Portfolio_Report__c( Entity__c=act.Id,Purchase_Amount__c=2000, Units_Quanitity__c=1000, Asset_Class__c='Debt: Floating Rate', Scheme_Scrip_Name__c='Birla Sun Life',Transaction_Type__c='SIP', Current_Value__c=2000,Portfolio_Type__c='EQ');
    	 allPortfolios.add(port1);
    	 Portfolio_Report__c port2 = new Portfolio_Report__c( Entity__c=act.Id,Purchase_Amount__c=2000,Units_Quanitity__c=1000,Asset_Class__c='Equity: Tax Planning', Scheme_Scrip_Name__c='Kotak Mahindra',Transaction_Type__c='SIP', Current_Value__c=2000,Portfolio_Type__c='MF');
    	 allPortfolios.add(port2);
    	 Portfolio_Report__c port3 = new Portfolio_Report__c( Entity__c=act.Id,Purchase_Amount__c=2000,Units_Quanitity__c=1000,Asset_Class__c='Debt: Short Term', Scheme_Scrip_Name__c='HDFC',Transaction_Type__c='NOR', Current_Value__c=2000,Portfolio_Type__c='EQ');
  		 allPortfolios.add(port3);
  		 Portfolio_Report__c childPortfolio = new Portfolio_Report__c( Entity__c=child.Id,Purchase_Amount__c=2000,Units_Quanitity__c=1000,Asset_Class__c='Equity: Shares', Scheme_Scrip_Name__c='HDFC',Transaction_Type__c='NOR', Current_Value__c=2000,Portfolio_Type__c='EQ');
  		 allPortfolios.add(childPortfolio);	
  		 insert allPortfolios;
  		 
  		  Asset__c asset1 = new Asset__c(Entity__c= act.Id,Account_Type__c='EPF',  Asset_Types__c='Personal Assets',Asset_Sub_Types__c='',Current_Value__c=1000.0,Categories__c='Debt');
    	  allAssets.add(asset1); 
    	  Asset__c asset2 = new Asset__c( Entity__c= act.Id,Account_Type__c='EPF', Asset_Types__c='Cash and Cash Equivalents',Asset_Sub_Types__c='Current A/c', Current_Value__c=1000,Categories__c='Others');
    	  allAssets.add(asset2);
    	  Asset__c asset3 = new Asset__c( Entity__c= act.Id,Account_Type__c='EPF', Asset_Types__c='Business Assets',Asset_Sub_Types__c='LLP', Current_Value__c=1000,Categories__c='Equity');
    	  allAssets.add(asset3);  
    	  Asset__c asset4 = new Asset__c( Entity__c= act.Id,Account_Type__c='EPF', Asset_Types__c='Post-office Savings Schemes',Asset_Sub_Types__c='National Saving Certificate (NSC)', Current_Value__c=1000,Categories__c='Real Estate');
    	  allAssets.add(asset4);
    	  Asset__c asset5 = new Asset__c(Entity__c= act.Id,Account_Type__c='EPF', Asset_Types__c='Bank Deposits',Asset_Sub_Types__c='Recurring Deposit', Current_Value__c=1000,Categories__c='Gold');
    	  allAssets.add(asset5);
    	  Asset__c asset6 = new Asset__c(Entity__c= act.Id,Account_Type__c='EPF', Asset_Types__c='Real Estate Accounts',Asset_Sub_Types__c='Land', Current_Value__c=1000,Categories__c='Gold');
    	  allAssets.add(asset6);
    	  Asset__c childAsset = new Asset__c(Entity__c= child.Id,Account_Type__c='EPF', Asset_Types__c='Bank Deposits',Asset_Sub_Types__c='Fixed Deposit', Current_Value__c=1000,Categories__c='Real Estate');
    	  allAssets.add(childAsset);        	    	  
    	  insert allAssets;
  		   		 
  		 
  		  Id lifeInsuranceId =  [select Id from RecordType where Name= 'Life Insurance' limit 1].Id;
  		  Id generalInsuranceId =  [select Id from RecordType where Name= 'General Insurance' limit 1].Id;
  		  Date dueDate = System.today();
  		  system.debug('________lifeInsuranceId_____'+lifeInsuranceId);
  		  system.debug('_______________act.Id__________'+act.Id);
  		  Insurance__c ins1 = new Insurance__c( RecordTypeId=lifeInsuranceId,Death_Benefit_Rs__c=4000, Premium_End_Date__c=dueDate,Entity__c=act.Id,Premium_Due_date__c=dueDate, Sum_Assured_Rs__c=3000,Premium_Amount_Rs__c =300,Policy_Type__c='Other',Premium_Frequency__c ='Monthly',Insurance_Company__c ='Birla',Categories__c='Gold');
  		  allInsurances.add(ins1);
  		  Insurance__c ins2 = new Insurance__c( RecordTypeId=lifeInsuranceId,Death_Benefit_Rs__c=4000,Premium_End_Date__c=dueDate,Entity__c=act.Id,Premium_Due_date__c=dueDate,Sum_Assured_Rs__c=3000,Premium_Amount_Rs__c =300,Policy_Type__c='Term Life',Premium_Frequency__c ='Monthly',Insurance_Company__c='Kotak',Categories__c='Real Estate');	 
  		  allInsurances.add(ins2);
  		  Insurance__c ins3 = new Insurance__c( RecordTypeId=lifeInsuranceId,Death_Benefit_Rs__c=4000,Premium_End_Date__c=dueDate,Entity__c=act.Id,Premium_Due_date__c=dueDate,Sum_Assured_Rs__c=3000,Premium_Amount_Rs__c =300,Policy_Type__c='Whole Life',Premium_Frequency__c ='Monthly',Insurance_Company__c='Mahindra',Categories__c='Equity');	 
  		  allInsurances.add(ins3);
  		 
  		 
  		  Insurance__c ins4 = new Insurance__c( RecordTypeId=generalInsuranceId,Entity__c=act.Id,Premium_End_Date__c=dueDate,Suggested_Cover_General_Insurance__c=2000,Premium_Due_date__c=dueDate,Sum_Assured_Rs__c=3000,Premium_Amount_Rs__c =300,Policy_Type__c='Medical',Premium_Frequency__c ='Monthly',Insurance_Company__c='Kotak',Categories__c='Real Estate');	 
  		  allInsurances.add(ins4);
  		  Insurance__c ins5 = new Insurance__c( RecordTypeId=generalInsuranceId,Entity__c=act.Id,Premium_End_Date__c=dueDate,Suggested_Cover_General_Insurance__c=2000,Premium_Due_date__c=dueDate,Sum_Assured_Rs__c=3000,Premium_Amount_Rs__c =300,Policy_Type__c='Vehicle',Premium_Frequency__c ='Monthly',Insurance_Company__c='Mahindra',Categories__c='Equity');	 
  		  allInsurances.add(ins5);
   		 
   		 
   		  Insurance__c childInsurance = new Insurance__c( RecordTypeId=lifeInsuranceId,Death_Benefit_Rs__c=4000,Premium_End_Date__c=dueDate,Entity__c=child.Id,Premium_Due_date__c=dueDate,Sum_Assured_Rs__c=3000,Premium_Amount_Rs__c =300,Policy_Type__c='Whole Life',Premium_Frequency__c ='Monthly',Insurance_Company__c='HDFC',Categories__c='Equity');	 
  		  allInsurances.add(childInsurance);	 	 
  		  //insert allInsurances;
  		   
  		  Loan__c loan1 = new Loan__c(Entity__c=act.Id,Fixed_Floating__c='Fixed',Loan_Type__c='Home Loan',Next_EMI_Date__c=dueDate,Premium_End_Date__c=dueDate, Term_No_of_years__c=2, EMI__c=1000);
  		  allLoans.add(loan1);
  		  Loan__c loan2 = new Loan__c(Entity__c=act.Id,Fixed_Floating__c='Floating',Loan_Type__c='Auto Loan',Next_EMI_Date__c=dueDate,Premium_End_Date__c=dueDate,Term_No_of_years__c=2,EMI__c=1000);
  		  allLoans.add(loan2);
  		  Loan__c loan3 = new Loan__c(Entity__c=act.Id,Fixed_Floating__c='Fixed',Loan_Type__c='Credit Card Loan',Next_EMI_Date__c=dueDate,Premium_End_Date__c=dueDate,Term_No_of_years__c=2,EMI__c=1000);
  		  allLoans.add(loan3);
  		  Loan__c loan4 = new Loan__c(Entity__c=act.Id,Fixed_Floating__c='Fixed',Loan_Type__c='Personal Loan',Next_EMI_Date__c=dueDate,Premium_End_Date__c=dueDate,Term_No_of_years__c=2,EMI__c=1000);
  		  allLoans.add(loan4);
  		  Loan__c loan5 = new Loan__c(Entity__c=act.Id,Fixed_Floating__c='Fixed',Loan_Type__c='Business Loan',Next_EMI_Date__c=dueDate,Premium_End_Date__c=dueDate,Term_No_of_years__c=2,EMI__c=1000);
  		  allLoans.add(loan5);
  		  Loan__c loan6 = new Loan__c(Entity__c=act.Id,Fixed_Floating__c='Fixed',Loan_Type__c='Other Loan',Next_EMI_Date__c=dueDate,Premium_End_Date__c=dueDate,Term_No_of_years__c=2,EMI__c=1000);
  		  allLoans.add(loan6);
  		  
  		  
  		  
  		  Loan__c loan7 = new Loan__c(Entity__c=child.Id,Fixed_Floating__c='Floating',Loan_Type__c='Student Loan',Next_EMI_Date__c=dueDate,Premium_End_Date__c=dueDate,Term_No_of_years__c=2,EMI__c=1000);
  		  allLoans.add(loan7);
  		  insert allLoans;
  		  Test.startTest();
  		  ConsolidatedStatementController csc = new ConsolidatedStatementController();
  		  List<ConsolidatedStatementController.InvestmentAssetsWrapper> equityWrapperList = csc.getEquityInvestmentAssets();
  		  List<ConsolidatedStatementController.InvestmentAssetsWrapper> debtWrapperList = csc.getDebtInvestmentAssets();
  		  List<ConsolidatedStatementController.InsuranceWrapper>  lifeInsuranceWrapperList = csc.getLifeInsuranceWrapper();
  		  List<ConsolidatedStatementController.InsuranceWrapper>  generalInsuranceWrapperList = csc.getGeneralInsuranceWrapper();
  		  List<ConsolidatedStatementController.AssetsWrapper> assetWrapperList = csc.getAssetsWrapper();
  		  List<ConsolidatedStatementController.LoanWrapper> loanWrapperList = csc.getLoanWrapper();
  		  List<ConsolidatedStatementController.SuccessionPlanningWrapper> SuccessionPlanningWrapperList = csc.getSuccessionPlanningWrapper();
  		  String emiSubtotal = csc.getEmiSubTotal();
  		  String debtInvesmentAssetsSubTotal = csc.getdebtInvestmentAssetsSubTotal();
  		  String equityInvesmentAssetsSubTotal = csc.getequityInvestmentAssetsSubTotal();
  		  List<Loan__c> Loans = csc.getAllLoans();
  		  List<Insurance__c> Insurances = csc.getAllInsurances();
  		  List<SIP_Tracker__c> getSipTrackerList = csc.getSipTracker();
  		  String chartUrl = csc.getchartURL();
	      Test.stopTest();
    }
}