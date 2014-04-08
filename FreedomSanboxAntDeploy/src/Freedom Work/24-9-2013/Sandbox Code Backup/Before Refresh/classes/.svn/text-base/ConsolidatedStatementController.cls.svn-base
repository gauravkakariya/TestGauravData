public class ConsolidatedStatementController {
        private Account act;
        static Double debtInvestmentAssetsSubTotal=0;    
        static Double equityInvestmentAssetsSubTotal=0;
        static Double EmiSubTotal=0;
        private Planner_Details__c  detail;
        List<Portfolio_Report__c> equityPortfolioList = new    List<Portfolio_Report__c>();
        List<Portfolio_Report__c> debtPortfolioList = new    List<Portfolio_Report__c>();
        List<Loan__c> loanList = new List<Loan__c>();
        List<Insurance__c> insuranceList = new List<Insurance__c>();
        List<Asset__c> assetList = new List<Asset__c>();
        
        List<SIP_Tracker__c > sipList = new List<SIP_Tracker__c >();
        Map<Id,Insurance__c[]> insuranceMap = new Map<Id,Insurance__c[]>();
        Map<Id,Insurance__c[]> generalInsuranceMap = new Map<Id,Insurance__c[]>();
        Map<Id,Insurance__c[]> lifeInsuranceMap = new Map<Id,Insurance__c[]>();
        List<Account> childEntities = new List<Account>();
        Map<Id,Loan__c[]> loanMap = new Map<Id,Loan__c[]>();
         
        public ConsolidatedStatementController(){
              
        }
      
    public  Account getAccount(){
        //System.debug('User Name: '+ getCurrentUserDetails().Name);
        if(act==null){
                
                   String accId=System.currentPageReference().getParameters().get('Id');
                   List<Account>  parentEntities;
                   if(accId != null){
                    parentEntities = [select Id,
                                       Name,
                                       BillingStreet,
                                       BillingCity,
                                       BillingState,
                                       OwnerId,
                                       Will__c,
                                       Trust__c,
                                       POA__c,
                                       HUF__c,
                                       Nomination__c,
                                       PersonEmail from Account
                                       where Id =:accId];
                }   
                else{
                      User currentUser=[select Id, 
                                      Name, 
                                      Email,
                                      AccountId
                                      from User 
                                      where Id=:UserInfo.getUserId()];
                                         
                                         parentEntities = [select Name,
                                            Id,
                                            PAN_ID__pc,
                                            BillingStreet,
                                            Account.OwnerId,
                                            BillingState,
                                            BillingCity,
                                            BillingPostalCode, 
                                            PersonMobilePhone, 
                                            Will__c,
                                            Trust__c,
                                            POA__c,
                                            HUF__c,
                                            Nomination__c,
                                            Life_Insurance_Suggested_Cover__c, 
                                            PersonBirthDate,
                                            PersonEmail,bank_Account_Number__c,
                                            Branch_details__c,
                                            Bank_Name__c,
                                            Bank_Account_Type__c,
                                            IFSC_Number__c,
                                            MICR_Number__c  
                                            from Account 
                                            where Id =:currentUser.AccountId];
                                }                                        
                //System.debug('size: '+ parentEntities.size());
                     if(parentEntities != null && !parentEntities.isEmpty()){
                       // System.debug('father: '+ parentEntities[0]);
                         act= parentEntities[0];
                     }
        }  
        return act;
   }
    
   public List<Account> getChildEntities(){
                if(childEntities.isEmpty()){
                        childEntities=[select Id,Name from Account where Parent_Entity__c =: getAccount().Id];
                    //System.debug('child Name:'+childEntities[0].Name);
                }
         //System.debug('child Name:'+childEntities);
         return childEntities;      
   }
   
   public List<SIP_Tracker__c> getSipTracker(){
        sipList = [select Id,
                   Bank_Account_Number__c,
                   Entity__c, Bank_Name__c,
                   Folio_Number__c,
                   Entity__r.Name,
                   Frequency__c,
                   SIP_Amount__c,
                   Due_Date__c, 
                   SIP_Start_Date__c,
                   SIP_End_Date__c,
                   Scheme__c from SIP_Tracker__c where Entity__c = :getAccount().Id OR Entity__c IN :getChildEntities()];
        return sipList;
   }
  
   public void getManagedInvestmentAssets(){
                for(Portfolio_Report__c pr: [Select Id,
                                            Current_Value__c,
                                            Categories__c
                                            From Portfolio_Report__c where Entity__c = :getAccount().Id OR Entity__c IN :getChildEntities()]){
                        if(pr.Categories__c.equals(Label.Equity)){                              
                                         equityPortfolioList.add(pr);
                        }
                        else{
                             debtPortfolioList.add(pr);
                        }
                 }
        }
        
        public void getAssetsList(){
                for(Asset__c asset:[Select Id,
                                    Current_Value__c,
                                    Account_Type__c,
                                    Asset_Types__c,
                                    Asset_Sub_Types__c 
                                    From Asset__c where Entity__c = :getAccount().Id OR Entity__c IN :getChildEntities()]){
                        assetList.add(asset);
                 }
                // System.debug('asset size: '+assetList.size() );
        }
        
        public List<InvestmentAssetsWrapper> getEquityInvestmentAssets(){
                
                if(equityPortfolioList.isEmpty()){
                        getManagedInvestmentAssets();
                }
                Double mfEquityAmount=0;
                List<InvestmentAssetsWrapper> equityInvestmentAssetsWrapperList = new List<InvestmentAssetsWrapper>();
                if(!equityPortfolioList.isEmpty()){
                        for(Portfolio_Report__c pr:equityPortfolioList){
                                if(pr.Current_Value__c!=null){
                                        mfEquityAmount += pr.Current_Value__c;
                                }       
                        } 
                }
                equityInvestmentAssetsSubTotal = mfEquityAmount;
                if(mfEquityAmount!=0){
                        InvestmentAssetsWrapper mfEquity = new InvestmentAssetsWrapper(Label.Mutual_Funds,mfEquityAmount.round().format());
                        equityInvestmentAssetsWrapperList.add(mfEquity);
                }
                return equityInvestmentAssetsWrapperList;
        }
        
        public String getequityInvestmentAssetsSubTotal(){
                return equityInvestmentAssetsSubTotal.round().format();
        }
        
        public List<InvestmentAssetsWrapper> getDebtInvestmentAssets(){
                Double mfDebtAmount=0; 
                Double bankDepositsAmt=0;               
                Double postOfficeAmt=0;
                Double retirementAccAmt=0;
                if(assetList.isEmpty()){
                        getAssetsList();
                }
                List<InvestmentAssetsWrapper> debtInvestmentAssetsWrapperList = new List<InvestmentAssetsWrapper>();
                if(!assetList.isEmpty()){
                        for(Asset__c asset: assetList){
                                if(asset.Asset_Types__c !=null && asset.Current_Value__c!=null){
                                        if(asset.Asset_Types__c.equals(Label.Bank_Deposits)){
                                                bankDepositsAmt += asset.Current_Value__c;
                                        }
                                        else if(asset.Asset_Types__c.equals(Label.Post_Office)){
                                                postOfficeAmt += asset.Current_Value__c;
                                        }
                                        else if(asset.Asset_Types__c.equals(Label.Retirement_Accounts)){
                                                retirementAccAmt += asset.Current_Value__c;
                                        }
                                }
                                
                                
                        }
                }
                
                if(!debtPortfolioList.isEmpty()){
                        for(Portfolio_Report__c pr:debtPortfolioList){
                                if(pr.Current_Value__c!=null){
                                        mfDebtAmount += pr.Current_Value__c;
                                }       
                        } 
                }
                
                debtInvestmentAssetsSubTotal = mfDebtAmount + bankDepositsAmt + postOfficeAmt + retirementAccAmt;
                if(mfDebtAmount!=0){
                        InvestmentAssetsWrapper mfDebt = new InvestmentAssetsWrapper(Label.Mutual_Funds,mfDebtAmount.round().format());
                        debtInvestmentAssetsWrapperList.add(mfDebt);
                }
                if(bankDepositsAmt!=0){
                        InvestmentAssetsWrapper bankDeposit = new InvestmentAssetsWrapper(Label.Bank_Deposits,bankDepositsAmt.round().format());
                        debtInvestmentAssetsWrapperList.add(bankDeposit);
                }
                if(postOfficeAmt!=0){
                        InvestmentAssetsWrapper postoffice = new InvestmentAssetsWrapper(Label.PostOffice,postOfficeAmt.round().format());
                        debtInvestmentAssetsWrapperList.add(postoffice);
                }
                if(retirementAccAmt!=0){
                        InvestmentAssetsWrapper retirementAcc = new InvestmentAssetsWrapper(Label.Retirement_Accounts,retirementAccAmt.round().format());
                        debtInvestmentAssetsWrapperList.add(retirementAcc);
                }
                return debtInvestmentAssetsWrapperList;
        }
        
        public String getdebtInvestmentAssetsSubTotal(){
                return debtInvestmentAssetsSubTotal.round().format();
        }

        public void getInsurances(){
                insuranceList=[Select Id,
                               Entity__c,
                               RecordType.Name,
                               RecordTypeId,
                               Death_Benefit_Rs__c ,
                               Policy_Type__c,
                               Sum_Assured_Rs__c,
                               Policy_Number__c,
                               Insurance_Company__c,
                               Premium_Frequency__c,
                               Premium_Due_date__c,
                               Premium_Amount_Rs__c,
                               Suggested_Cover_General_Insurance__c,
                               Entity__r.Name,
                               Entity__r.Life_Insurance_Suggested_Cover__c 
                               From Insurance__c  where Entity__c = :getAccount().Id OR Entity__c IN :getChildEntities()];
                for(Insurance__c  insurance:insuranceList){                              
            if(insurance.RecordType.Name.equals(Label.General_Insurance)){
                if(!generalInsuranceMap.isEmpty() && generalInsuranceMap.containsKey(insurance.Entity__c)){
                        generalInsuranceMap.get(insurance.Entity__c).add(insurance);
                }
                
                    else{
                        List<Insurance__c> insuranceList = new List<Insurance__c>();
                        insuranceList.add(insurance);
                        generalInsuranceMap.put(insurance.Entity__c,insuranceList);
                    }
            }
            
            else if(insurance.RecordType.Name.equals(Label.Life_Insurance)){
                if(!lifeInsuranceMap.isEmpty() && lifeInsuranceMap.containsKey(insurance.Entity__c)){
                        lifeInsuranceMap.get(insurance.Entity__c).add(insurance);
                }
                else{
                        List<Insurance__c> insuranceList = new List<Insurance__c>();
                        insuranceList.add(insurance);
                        lifeInsuranceMap.put(insurance.Entity__c,insuranceList);
                    }
                
            }
                }
                
        }
        
        public  List<InsuranceWrapper> getLifeInsuranceWrapper(){
                 String policyType='';
                 List<InsuranceWrapper> lifeInsuranceWrapperList = new List<InsuranceWrapper>();
                 if(insuranceList.isEmpty()){
                        getInsurances();
                 }
                 if(!lifeInsuranceMap.isEmpty()){
                   for(Id id:lifeInsuranceMap.keySet()){
                          Double actualCover=0;
                          String policyHolder;
                          Boolean flag = true;
                          Double suggestedCover=0;
                          for(Insurance__c insurance:lifeInsuranceMap.get(id)){
                                  if(insurance.Death_Benefit_Rs__c!=null){
                                          actualCover += insurance.Death_Benefit_Rs__c;
                                  }
                                  if(flag){
                                          policyHolder=insurance.Entity__r.Name;
                                          if(insurance.Entity__r.Life_Insurance_Suggested_Cover__c!=null){
                                            suggestedCover += insurance.Entity__r.Life_Insurance_Suggested_Cover__c;
                                          }
                                          flag = false;
                                  }
                          }
                         // System.debug('policyHolder='+ policyHolder + '  ');
                        //  System.debug('suggestedCover='+ suggestedCover + '  ');
                        //  System.debug('policyType='+ policyType + '  ');
                         // System.debug('actualCover='+ actualCover + '  ');
                          InsuranceWrapper wrapper = new InsuranceWrapper(policyHolder,suggestedCover.round().format(),policyType,actualCover.round().format());
                          lifeInsuranceWrapperList.add(wrapper);
                   }
                 }
                 return lifeInsuranceWrapperList;
        }
        
        public  List<InsuranceWrapper> getGeneralInsuranceWrapper(){
                List<InsuranceWrapper> generalInsuranceWrapperList= new List<InsuranceWrapper>();
               if(!generalInsuranceMap.isEmpty()){
                  for(Id id:generalInsuranceMap.keySet()){
                          String policyHolder;
                          Boolean flag = true;
                          Map<String,Double> policy_actualCoverMap = new Map<String,Double>();
                          Map<String,Double> policy_suggestedCoverMap = new Map<String,Double>();
                          for(Insurance__c insurance:generalInsuranceMap.get(id)){
                                  if(flag){
                                          policyHolder=insurance.Entity__r.Name;
                                          flag = false;
                                  }
                                  if(insurance.Sum_Assured_Rs__c == null){
                                    insurance.Sum_Assured_Rs__c = 0;
                                  }
                                  if(!policy_actualCoverMap.isEmpty() && policy_actualCoverMap.containsKey(insurance.Policy_Type__c )){
                                          double d = policy_actualCoverMap.get(insurance.Policy_Type__c)+insurance.Sum_Assured_Rs__c;
                                          policy_actualCoverMap.put(insurance.Policy_Type__c,d);
                                  }
                                  
                                  else{  
                                          policy_actualCoverMap.put(insurance.Policy_Type__c,insurance.Sum_Assured_Rs__c);
                                          policy_suggestedCoverMap.put(insurance.Policy_Type__c,insurance.Suggested_Cover_General_Insurance__c);
                                  }
                                  
                          }
                          for(String policyType:policy_actualCoverMap.keySet()){
                                String suggestedCover = '';
                                String actualCover = '';
                                if(policy_suggestedCoverMap.get(policyType) != null){
                                  suggestedCover = policy_suggestedCoverMap.get(policyType).round().format();
                                }
                                if(policy_actualCoverMap.get(policyType) != null){
                                  actualCover =policy_actualCoverMap.get(policyType).round().format();
                                }
                                  InsuranceWrapper insWrapper = new InsuranceWrapper(policyHolder,suggestedCover,policyType,actualCover);
                                  generalInsuranceWrapperList.add(insWrapper);
                          }
                  }
               }
                return generalInsuranceWrapperList;
        } 
        
        public List<AssetsWrapper> getAssetsWrapper(){
                List<AssetsWrapper> assetsWrapperList = new List<AssetsWrapper>();
                Double realEstateAccounts = 0;
                Double businessAssets = 0;
                Double personalAssets = 0;
                Double cashAndEquivalents = 0;
                if(assetList.isEmpty()){
                        getAssetsList();
                }
                for(Asset__c asset:assetList){
                	if(asset.Current_Value__c!=null){
                        if(asset.Asset_Types__c!=null && asset.Asset_Types__c.equals(Label.Real_Estate_Accounts)){
                                realEstateAccounts += asset.Current_Value__c;
                        }
                        
                        else if(asset.Asset_Types__c!=null && asset.Asset_Types__c.equals(Label.Business_Assets)){
                                BusinessAssets += asset.Current_Value__c;
                        }
                        else if(asset.Asset_Types__c!=null && asset.Asset_Types__c.equals(Label.Personal_Assets)){
                                PersonalAssets += asset.Current_Value__c;
                        }
                        else if(asset.Asset_Types__c!=null && asset.Asset_Types__c.equals(Label.Cash_and_Cash_Equivalents)){
                                CashAndEquivalents += asset.Current_Value__c;
                        }
                	}
                }
                if(realEstateAccounts!=0){
                        AssetsWrapper real_Estate = new AssetsWrapper(Label.Real_Estate_Accounts,realEstateAccounts.round().format());
                        assetsWrapperList.add(real_Estate);
                }
                if(businessAssets!=0){
                        AssetsWrapper business_Asset = new AssetsWrapper(Label.Business_Assets,businessAssets.round().format());
                        assetsWrapperList.add(business_Asset);
                }
                if(personalAssets!=0){
                        AssetsWrapper personal_Asset = new AssetsWrapper(Label.Personal_Assets,personalAssets.round().format());
                        assetsWrapperList.add(personal_Asset);
                }
                if(cashAndEquivalents!=0){
                        AssetsWrapper cash_Equivalent = new AssetsWrapper(Label.Cash_and_Cash_Equivalents,cashAndEquivalents.round().format());
                        assetsWrapperList.add(cash_Equivalent);
                }
                return assetsWrapperList;
        }
        
        public void getLoans(){
                 
                loanList=[Select Entity__c,Fixed_Floating__c,Loan_Type__c,Next_EMI_Date__c,Loan__c.Entity__r.Name, EMI__c From Loan__c where Entity__c = :getAccount().Id OR Entity__c IN :getChildEntities()];
                        for(Loan__c loan:loanList){
                                if(!loanMap.isEmpty() && loanMap.containsKey(loan.Entity__c)){
                                        loanMap.get(loan.Entity__c).add(loan);
                                }
                                else{
                                        List<Loan__c> loans = new List<Loan__c>();
                                        loans.add(loan);
                                        loanMap.put(loan.Entity__c,loans);
                                }
                        }
        }
        
        public List<LoanWrapper> getLoanWrapper(){
                Double homeLoan=0;
                Double autoLoan=0;
                Double creditcardLoan=0;
                Double studentLoan=0;
                Double personalLoan=0;
                Double businessLoan=0;
                Double otherLoan=0;
                List<LoanWrapper> loanWrapperList = new List<LoanWrapper>();
                
                if(loanList.isEmpty()){
                        getLoans();
                }
                
                for(Loan__c loan:loanList){
                	if(loan.EMI__c!=null){
                        if(loan.Loan_Type__c.equals(Label.Home_Loan)){
                                	homeLoan += loan.EMI__c;
                        }
                        else if(loan.Loan_Type__c.equals(Label.Auto_Loan)){
                                autoLoan += loan.EMI__c;
                        }
                        else if(loan.Loan_Type__c.equals(Label.Credit_Card_Loan)){
                                creditcardLoan += loan.EMI__c;
                        }
                        else if(loan.Loan_Type__c.equals(Label.Student_Loan)){
                                studentLoan += loan.EMI__c;
                        }
                        else if(loan.Loan_Type__c.equals(Label.Personal_Loan)){
                                personalLoan += loan.EMI__c;
                        }
                        else if(loan.Loan_Type__c.equals(Label.Business_Loan)){
                                businessLoan += loan.EMI__c;
                        }
                        else if(loan.Loan_Type__c.equals(Label.Other_Loan)){
                                otherLoan += loan.EMI__c;
                        }
                	}
                } 
                EmiSubTotal = homeLoan + autoLoan + creditcardLoan + studentLoan + personalLoan + businessLoan + otherLoan;
                if(homeLoan!=0){
                        LoanWrapper home_Loan= new LoanWrapper(Label.Home_Loan,homeLoan.round().format());
                        loanWrapperList.add(home_Loan);
                }
                if(autoLoan!=0){
                        LoanWrapper auto_Loan= new LoanWrapper(Label.Auto_Loan,autoLoan.round().format());
                        loanWrapperList.add(auto_Loan); 
                }
                if(creditcardLoan!=0){
                        LoanWrapper credit_cardLoan= new LoanWrapper(Label.Credit_Card_Loan,creditcardLoan.round().format());
                        loanWrapperList.add(credit_cardLoan);
                }
                if(studentLoan!=0){
                        LoanWrapper student_Loan= new LoanWrapper(Label.Student_Loan,studentLoan.round().format());
                        loanWrapperList.add(student_Loan);
                }
                if(personalLoan!=0){
                        LoanWrapper personal_Loan= new LoanWrapper(Label.Personal_Loan,personalLoan.round().format());
                        loanWrapperList.add(personal_Loan);
                }
                if(businessLoan!=0){
                        LoanWrapper business_Loan= new LoanWrapper(Label.Business_Loan,businessLoan.round().format());
                        loanWrapperList.add(business_Loan);
                }
                if(otherLoan!=0){
                        LoanWrapper other_Loan= new LoanWrapper(Label.Other_Loan,otherLoan.round().format());
                        loanWrapperList.add(other_Loan);
                }
                
                return loanWrapperList;
        }
        
        public String getEmiSubTotal(){
                return EmiSubTotal.round().format();
        }
        
    public List<SuccessionPlanningWrapper> getSuccessionPlanningWrapper(){
        List<SuccessionPlanningWrapper> SuccessionPlanningWrapperList = new    List<SuccessionPlanningWrapper>();
        SuccessionPlanningWrapper huf = new SuccessionPlanningWrapper(getAccount().HUF__c,Label.HUF);
        SuccessionPlanningWrapperList.add(huf);
        SuccessionPlanningWrapper poa = new SuccessionPlanningWrapper(getAccount().POA__c,Label.POA);
        SuccessionPlanningWrapperList.add(poa);
        SuccessionPlanningWrapper will = new SuccessionPlanningWrapper(getAccount().Will__c,Label.Will);
        SuccessionPlanningWrapperList.add(will);
        SuccessionPlanningWrapper trust = new SuccessionPlanningWrapper(getAccount().Trust__c,Label.Trust);
        SuccessionPlanningWrapperList.add(trust);
        SuccessionPlanningWrapper nomination = new SuccessionPlanningWrapper(getAccount().Nomination__c,Label.Nomination);
        SuccessionPlanningWrapperList.add(nomination);
        
        return SuccessionPlanningWrapperList;
    }
    
   
    public List<Loan__c> getAllLoans(){
                 return loanList;
    }
    
    public List<Insurance__c> getAllInsurances(){
        return insuranceList;
    }
    
   
    public String getchartURL(){
     	Double total=equityInvestmentAssetsSubTotal + debtInvestmentAssetsSubTotal;
        Double equityPercentage = 0;
        Double debtPercentage = 0;
        if(total!=0){
	       equityPercentage = equityInvestmentAssetsSubTotal /(total)*100;
	       debtPercentage = debtInvestmentAssetsSubTotal/(total)*100;
        } 
        
        String partOne='http://chart.apis.google.com/chart?chs=290x110&chd=t:';
        String chartValues= equityPercentage.format()+ ',' + debtPercentage.format();
        String partTwo = '&chco=4B924B&cht=p3&chtt=Investments&chdl=Equity|Debt&chl=';
        String chartLabels = equityPercentage.round().format()+ '%' + '|' + debtPercentage.round().format() + '%';
        return  partOne + chartValues + partTwo + chartLabels;
    }
    
    public Planner_Details__c getPlannerDescription(){
         if(detail==null){
                List<Planner_Details__c> planDetail= [select Name,
                                                    
                                                     Email__c,
                                                     MobilePhone__c,
                                                     Description__c 
                                                     from Planner_Details__c  
                                                     where OwnerId = :getAccount().OwnerId LIMIT 1];
            if(planDetail != null && !planDetail.isEmpty() ){
                detail = planDetail[0];
            }
         } 
         return detail;
    }
        public class InvestmentAssetsWrapper{
                public String subType {get;set;}
                public String amount {get;set;}
                public InvestmentAssetsWrapper(String subType,String amount){
                        this.subType= subType;
                        this.amount= amount;
                }
        }
        
        public class InsuranceWrapper{
                public String policyHolder {get;set;}
                public String suggestedCover {get;set;}
                public String actualCover {get;set;}
                public String policyType {get;set;}
                public InsuranceWrapper(String policyHolder,String suggestedCover,String policyType,String actualCover){
                        this.policyHolder = policyHolder;
                        this.suggestedCover = suggestedCover;
                        this.actualCover = actualCover;
                        this.policyType = policyType;
                }
        }
        
        public class SuccessionPlanningWrapper{
	        public Boolean selected {get;set;}
	        public String label {get; set;}
	        public SuccessionPlanningWrapper(Boolean selected, String label){
	                    this.selected = selected;
	                    this.label = label;
	            }                       
        }
        
        public class AssetsWrapper{
                public String assetType {get; set;}
                public String amount {get;set;}
                public AssetsWrapper(String assetType ,String amount){
                        this.assetType= assetType;
                        this.amount= amount;
                } 
        }
        
        public class LoanWrapper{
                public String loanType {get; set;}
                public String EMI {get;set;}
                public LoanWrapper(String loanType ,String EMI){
                        this.loanType= loanType;
                        this.EMI= EMI;
                } 
        }
        
}