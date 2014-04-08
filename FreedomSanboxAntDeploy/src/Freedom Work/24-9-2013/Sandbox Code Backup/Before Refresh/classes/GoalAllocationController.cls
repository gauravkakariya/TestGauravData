public with sharing class GoalAllocationController {
    Account acct;
    List<Goal__c> goals = new List<Goal__c>();
    List<Assets> assetsList = new List<Assets>();
    List<InvestmentAssets> investmentList = new List<InvestmentAssets>();
    List<InvestmentAssets> sipList = new List<InvestmentAssets>();
    List<Insurances> insuranceList = new List<Insurances>();
    List<Id> childEntitiesList = new List<Id>();
    
    Map<Id, Asset__c> assetIds = new Map<Id, Asset__c>();
    Map<Id, Portfolio_Report__c> portfolioIds = new Map<Id, Portfolio_Report__c>();
    Map<Id, Insurance__c> insuranceIds = new Map<Id, Insurance__c>();
    
    Map<Id, GoalAssetAssociation__c[]> goalAssetAssociationMap = new Map<Id, GoalAssetAssociation__c[]>();
    Map<Id, GoalIAULIPAssociation__c[]> goalInvestAssetAssociationMap = new Map<Id, GoalIAULIPAssociation__c[]>();
    Map<Id, GoalInsuranceAssociation__c[]> goalInsuranceAssociationMap = new Map<Id, GoalInsuranceAssociation__c[]>();
    
    Map<Id, Double> goalEquityMap = new Map<Id, Double>();
    Map<Id, Double> goalDebtMap = new Map<Id, Double>();
    Map<Id, Double> goalGoldMap = new Map<Id, Double>();
    Map<Id, Double> goalRealEstateMap = new Map<Id, Double>();
    Map<Id, Double> goalOthersMap = new Map<Id, Double>();
    
    private String goalValues = '';
    private Integer count= 0;
    public String id {get;set;}
    
    public GoalAllocationController(){
            
            initialize();
    }
    
    public void initialize(){
        try{
                goalValues = '';
                getAssets();
                getGoals();
                retrieveAssetGoalAss();
                getInvestmentAssets();
                retrieveInvestAssetGoalAss();
                getInsurances();
                retrieveInsuranceGoalAss();
        }
         catch(Exception e) {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage())); 
        }
                
    }
    
    public Integer getCount(){
        count++;
        return count;
    }
    public Account getEntity(){
        acct = [select Id, Name from Account where Id = :System.currentPageReference().getParameters().get('Id')] ;
        return acct;
    }
    
    public List<Id> getChildEntities(){
        if(childEntitiesList.isEmpty()){
            
            for(Account a: [select Id, 
                                   Name from Account 
                                   where Parent_Entity__c = :System.currentPageReference().getParameters().get('Id')]){
                childEntitiesList.add(a.Id);                    
           }
        }
        return childEntitiesList;
        
    }
    
    public List<Goal__c> getGoals(){
        if(goals.isEmpty() || goals == null){
                Integer counter = 1;
                for(Goal__c g:[select Id, 
                                      Goal_Type__c,
                                      Accumulated_Amount__c,
                                      Cost_of_Goal_Annual__c,
                                      Allocated_Equity__c,
                                      Allocated_Debt__c,
                                      Allocated_Real_Estate__c,
                                      Allocated_Others__c,
                                      Allocated_Gold__c,
                                      Description__c,
                                      Name
                                      from Goal__c 
                                      where Entity__c = :getEntity().Id
                                      ORDER BY Name ASC]){
                        goals.add(g);
                        goalValues += counter+'. '+g.Name +'/t';
                        counter ++;
                }               
        }
        return goals;
        
    }
    
    public String getGoalValues(){
        return goalvalues;
    }   
    
    public void getAssets(){
        for(Asset__c ass: [select Id, 
                                  Name,
                                  Asset_Types__c,
                                  Entity__r.Name,
                                  Account_Type__c, 
                                  Current_Value__c,
                                  Allocated_Amount__c,
                                  Categories__c 
                                  from Asset__c 
                                  where (Entity__c = :getEntity().Id
                                  OR Entity__c IN :getChildEntities())
                                  AND Current_Value__c != null]){
            assetIds.put(ass.Id, ass);
        }
       
        
    }
    
    public void getInvestmentAssets(){
        for(Portfolio_Report__c pR: [select Id, 
                                  Portfolio_Type__c,
                                  Entity__r.Name,
                                  Scheme_Scrip_Name__c,
                                  Allocated_Amount__c,
                                  Current_Value__c,
                                  Transaction_Type__c,
                                  Categories__c  
                                  from Portfolio_Report__c 
                                  where (Entity__c = :getEntity().Id
                                  OR Entity__c IN :getChildEntities())
                                  AND Current_Value__c != null]){
            portfolioIds.put(pR.Id, pR);
        }
       
        
    }
    
    public void getInsurances(){
        for(Insurance__c pR: [Select i.Id,
                                     Entity__r.Name,
                                     i.Sum_Assured_Rs__c, 
                                     i.Surrender_Value__c,
                                     i.Policy_Type__c, 
                                     i.Allocated_Amount__c,
                                     i.Insurance_Company__c,
                                     i.Categories__c 
                                     From Insurance__c i
                                     where (Entity__c = :getEntity().Id
                                     OR Entity__c IN :getChildEntities())
                                     AND Surrender_Value__c != null
                                     ]){
                insuranceIds.put(pR.Id, pR);
        }
       
        
    }
 
    public void retrieveAssetGoalAss(){
        for(GoalAssetAssociation__c g: [select Id, Goal__c, 
                                                   Asset__c,
                                                   Asset__r.Current_Value__c, 
                                                   Goal__r.Goal_Type__c,
                                                   Asset__r.Categories__c,
                                                   Allocation__c
                                                   from GoalAssetAssociation__c
                                                   where Asset__c IN :assetIds.keySet() ORDER BY Goal__r.Name ASC]){
           
                
                if(!goalAssetAssociationMap.isEmpty() && goalAssetAssociationMap.containsKey(g.Asset__c)) {
                        List<GoalAssetAssociation__c> existing = goalAssetAssociationMap.get(g.Asset__c);
                        
                        existing.add(g);
                        
                        goalAssetAssociationMap.put(g.Asset__c, existing);
                        
                }
                else{
                        List<GoalAssetAssociation__c> newList = new List<GoalAssetAssociation__c>();
                        Map<Id, Id> newGoals = new Map<Id, Id>();
                        newList.add(g);
                        
                        goalAssetAssociationMap.put(g.Asset__c, newList);
                        
                }
                
        }
        
    }
    
     public void retrieveInvestAssetGoalAss(){
        for(GoalIAULIPAssociation__c g: [select Id, 
                                               Portfolio_Report__c, 
                                               Goal__c, 
                                               Goal__r.Goal_Type__c,
                                               Portfolio_Report__r.Current_Value__c,
                                               Portfolio_Report__r.Categories__c,
                                               Portfolio_Report__r.Transaction_Type__c,
                                               Allocation__c 
                                               from GoalIAULIPAssociation__c
                                               where Portfolio_Report__c IN :portfolioIds.keySet() ORDER BY Goal__r.Name ASC]){
           
                
                if(!goalInvestAssetAssociationMap.isEmpty() && goalInvestAssetAssociationMap.containsKey(g.Portfolio_Report__c)) {
                        List<GoalIAULIPAssociation__c> existing = goalInvestAssetAssociationMap.get(g.Portfolio_Report__c);
                        
                        existing.add(g);
                        
                        goalInvestAssetAssociationMap.put(g.Portfolio_Report__c, existing);
                        
                }
                else{
                        List<GoalIAULIPAssociation__c> newList = new List<GoalIAULIPAssociation__c>();
                        
                        newList.add(g);
                        
                        goalInvestAssetAssociationMap.put(g.Portfolio_Report__c, newList);
                        
                }
                
        }
        
    }
    
    public void retrieveInsuranceGoalAss(){
            for(GoalInsuranceAssociation__c g: [select Id, 
                                                       Goal__c, 
                                                       Insurance__c, 
                                                       Insurance__r.Surrender_Value__c,
                                                       Goal__r.Goal_Type__c,
                                                       Insurance__r.Categories__c,
                                                       Allocation__c 
                                                       from GoalInsuranceAssociation__c
                                                       where Insurance__c IN :insuranceIds.keySet() ORDER BY Goal__r.Name ASC]){
               
                        
                        if(!goalInsuranceAssociationMap.isEmpty() && goalInsuranceAssociationMap.containsKey(g.Insurance__c)) {
                                List<GoalInsuranceAssociation__c> existing = goalInsuranceAssociationMap.get(g.Insurance__c);
                                
                                existing.add(g);
                                
                                goalInsuranceAssociationMap.put(g.Insurance__c, existing);
                                
                        }
                        else{
                                List<GoalInsuranceAssociation__c> newList = new List<GoalInsuranceAssociation__c>();
                                
                                newList.add(g);
                                
                                goalInsuranceAssociationMap.put(g.Insurance__c, newList);
                                
                        }
                        
                }
    }
    
    public List<Assets> getAllocateAssets(){
   
       if(assetsList.isEmpty()){
        
           for(Asset__c a: assetIds.values()){
                if(goalAssetAssociationMap.get(a.Id) != null && !goalAssetAssociationMap.get(a.Id).isEmpty()) {
                            if(a.Current_Value__c == null){
                                a.Current_Value__c = 0;
                            }
                        Double d = a.Current_Value__c - (a.Allocated_Amount__c/100 * a.Current_Value__c);
                        Assets ast = new Assets(a, goalAssetAssociationMap.get(a.Id), d);
                        System.debug('Asset Id'+a.Id +'goals '+goalAssetAssociationMap.get(a.Id));
                        assetsList.add( ast);
                }       
           }
       }
           return assetsList;
    }
    
     public void allocatePortfolio(){
     
       for(Portfolio_Report__c a: portfolioIds.values()){
            
            if(goalInvestAssetAssociationMap.get(a.Id) != null && !goalInvestAssetAssociationMap.get(a.Id).isEmpty()) {
                Double d = 0;
                InvestmentAssets ast = new InvestmentAssets(a, goalInvestAssetAssociationMap.get(a.Id), d);
                 if(a.Current_Value__c == null){
                        a.Current_Value__c = 0;
                 }
                 ast.unallocatedAmt = a.Current_Value__c-(a.Allocated_Amount__c/100 * a.Current_Value__c);
                 if(a.Transaction_Type__c == 'SIP'){
                           
                        sipList.add(ast);
                 }
                 else
                 {
                           //ast.unallocatedAmt = a.Current_Value__c - a.Allocated_Amount__c;
                        
                        investmentList.add(ast);
                 }
            }       
       }
       
    }
    
     public List<InvestmentAssets> getAllocateInvestmentAssets(){
          if(investmentList.isEmpty()){
            allocatePortfolio();
          }
        return investmentList;
     }
     
    public List<InvestmentAssets> getAllocateSIP(){
       return sipList;
    }
    
    public List<Insurances> getAllocateInsurance(){
      
       if(insuranceList.isEmpty()){
                     
           for(Insurance__c a: insuranceIds.values()){
                if(goalInsuranceAssociationMap.get(a.Id) != null && !goalInsuranceAssociationMap.get(a.Id).isEmpty()) {
                          if(a.Surrender_Value__c == null){
                                a.Surrender_Value__c  = 0;
                            }
                        Double d = a.Surrender_Value__c - (a.Allocated_Amount__c/100 * a.Surrender_Value__c);
                        Insurances ast = new Insurances(a, goalInsuranceAssociationMap.get(a.Id), d);
                        insuranceList.add(ast);
                }       
           }
       }
           return insuranceList;
    }
    
   public void updateUnallocatedAmount() {
        if(this.id != null & this.id != ''){
                for(Assets asst: assetsList){
                        if(String.valueOf(asst.assetType.Id).equals(id)){
                                Double d = 0;
                                for(GoalAssetAssociation__c g: asst.goalList){
                                        System.debug('Allocation '+g.Allocation__c);
                                         if(g.Allocation__c == null){
                                                g.Allocation__c = 0;
                                        }
                                        d += g.Allocation__c;
                                        System.debug('Total '+d);
                                }
                                asst.unallocatedAmt = asst.assetType.Current_Value__c - (d/100 * asst.assetType.Current_Value__c);
                        }
                }
                        
                        
                }
        
    }
    
     public void updateUnallocatedAmountForInsurance() {
        if(this.id != null & this.id != ''){
            for(Insurances ins: insuranceList){
                if(String.valueOf(ins.insurance.Id).equals(id)){
                        Double d = 0;
                        for(GoalInsuranceAssociation__c g: ins.goalList){
                                System.debug('Allocation '+g.Allocation__c);
                                 if(g.Allocation__c == null){
                                        g.Allocation__c = 0;
                                }
                                d += g.Allocation__c;
                                System.debug('Total '+d);
                        }
                        ins.unallocatedAmt = ins.insurance.Surrender_Value__c - (d/100 *ins.insurance.Surrender_Value__c);
                }
            }     
        }
    }
    
     public void updateUnallocatedAmountForInvAssets() {
        if(this.id != null & this.id != ''){
                for(InvestmentAssets ins: investmentList){
                        if(String.valueOf(ins.portfolio.Id).equals(id)){
                                Double d = 0;
                                for(GoalIAULIPAssociation__c g: ins.goalList){
                                        System.debug('Allocation '+g.Allocation__c);
                                         if(g.Allocation__c == null){
                                                g.Allocation__c = 0;
                                        }
                                        d += g.Allocation__c;
                                        System.debug('Total '+d);
                                }
                                ins.unallocatedAmt = ins.portfolio.Current_Value__c - (d/100*ins.portfolio.Current_Value__c);
                        }
                }       
                        
                }
    }
    
    public void updateUnallocatedAmountForSIP() {
        if(this.id != null & this.id != ''){
                for(InvestmentAssets ins: sipList){
                        if(String.valueOf(ins.portfolio.Id).equals(id)){
                                Double d = 0;
                                for(GoalIAULIPAssociation__c g: ins.goalList){
                                        System.debug('Allocation '+g.Allocation__c);
                                         if(g.Allocation__c == null){
                                                g.Allocation__c = 0;
                                        }
                                        d += g.Allocation__c;
                                        System.debug('Total '+d);
                                }
                                ins.unallocatedAmt = ins.portfolio.Current_Value__c - (d/100 * ins.portfolio.Current_Value__c);
                        }
                }       
                        
                }
    }
    
    public void updateAllocationAsCategories(Sobject obj, String str){
        Double d1 = 0.0;
        if(str.equals('Assets')){
                GoalAssetAssociation__c gA = (GoalAssetAssociation__c)obj;
                 d1 = gA.Allocation__c/100 * gA.Asset__r.Current_Value__c;
                System.debug('Asset Allocation'+d1);
                if(gA.Asset__r.Categories__c != null){
                        if(gA.Asset__r.Categories__c.equals('Debt')){
                                System.debug('Asset Debt');
                                if(goalDebtMap.containsKey(gA.Goal__c)){
                                d1 += goalDebtMap.get(gA.Goal__c) ;
                                }
                                goalDebtMap.put(gA.Goal__c, d1);
                    }
                    else if(gA.Asset__r.Categories__c.equals('Equity')){
                        
                                if(goalEquityMap.containsKey(gA.Goal__c)){
                                d1 += goalEquityMap.get(gA.Goal__c);
                                }
                        goalEquityMap.put(gA.Goal__c, d1);
                    }
                    else if(gA.Asset__r.Categories__c.equals('Others')){
                        
                                if(goalOthersMap.containsKey(gA.Goal__c)){
                                d1 += goalOthersMap.get(gA.Goal__c);
                                }
                        goalOthersMap.put(gA.Goal__c, d1);
                    }
                    else if(gA.Asset__r.Categories__c.equals('Gold')){
                        
                                if(goalGoldMap.containsKey(gA.Goal__c)){
                                d1 += goalGoldMap.get(gA.Goal__c);
                                }
                        goalGoldMap.put(gA.Goal__c, d1);
                    }
                    else if(gA.Asset__r.Categories__c.equals('Real Estate')){
                        
                                if(goalRealEstateMap.containsKey(gA.Goal__c)){
                                d1 += goalRealEstateMap.get(gA.Goal__c);
                                }
                        goalRealEstateMap.put(gA.Goal__c, d1);
                    }
                }
        }
        if(str.equals('Insurances')){
                GoalInsuranceAssociation__c gA = (GoalInsuranceAssociation__c)obj;
                System.debug('Insurance Allocation'+gA.Allocation__c);
                
                d1 = gA.Allocation__c/100 * gA.Insurance__r.Surrender_Value__c;
                System.debug('Insurance Allocation'+d1);
                if(gA.Insurance__r.Categories__c != null){
                        if(gA.Insurance__r.Categories__c.equals('Debt')){
                        
                                if(goalDebtMap.containsKey(gA.Goal__c)){
                                d1 += goalDebtMap.get(gA.Goal__c) ;
                                }
                                System.debug('Insurance Allocation'+d1);
                                goalDebtMap.put(gA.Goal__c, d1);
                    }
                    else if(gA.Insurance__r.Categories__c.equals('Equity')){
                        
                                if(goalEquityMap.containsKey(gA.Goal__c)){
                                d1 += goalEquityMap.get(gA.Goal__c);
                                }
                        goalEquityMap.put(gA.Goal__c, d1);
                    }
                    else if(gA.Insurance__r.Categories__c.equals('Others')){
                        
                                if(goalOthersMap.containsKey(gA.Goal__c)){
                                d1 += goalOthersMap.get(gA.Goal__c);
                                }
                        goalOthersMap.put(gA.Goal__c, d1);
                    }
                    else if(gA.Insurance__r.Categories__c.equals('Gold')){
                        
                                if(goalGoldMap.containsKey(gA.Goal__c)){
                                d1 += goalGoldMap.get(gA.Goal__c);
                                }
                        goalGoldMap.put(gA.Goal__c, d1);
                    }
                    else if(gA.Insurance__r.Categories__c.equals('Real Estate')){
                        
                                if(goalRealEstateMap.containsKey(gA.Goal__c)){
                                d1 += goalRealEstateMap.get(gA.Goal__c);
                                }
                        goalRealEstateMap.put(gA.Goal__c, d1);
                    }
                }
        }
        
        if(str.equals('InvestmentAssets')){
                GoalIAULIPAssociation__c gA = (GoalIAULIPAssociation__c)obj;
               // if(gA.Portfolio_Report__r.Transaction_Type__c.equals('SIP')){
                            //System.debug('Sip '+gA.Allocation__c);
                        //    System.debug('Sip '+gA.Current_Value__c);
                                d1 = gA.Allocation__c/100 * gA.Portfolio_Report__r.Current_Value__c;
                        //}
                        //else{
                        //        d1 = gA.Allocation__c;
                        //}
                        System.debug('Investment Allocation'+d1);
                    if(gA.Portfolio_Report__r.Categories__c != null){
                        if(gA.Portfolio_Report__r.Categories__c.equals('Debt')){
                                if(goalDebtMap.containsKey(gA.Goal__c)){
                                d1 += goalDebtMap.get(gA.Goal__c) ;
                                }
                                System.debug('Investment Allocation'+d1);
                                goalDebtMap.put(gA.Goal__c, d1);
                        }
                        else if(gA.Portfolio_Report__r.Categories__c.equals('Equity')){
                                    if(goalEquityMap.containsKey(gA.Goal__c)){
                                    d1 += goalEquityMap.get(gA.Goal__c);
                                    }
                            goalEquityMap.put(gA.Goal__c, d1);
                        }
                        else if(gA.Portfolio_Report__r.Categories__c.equals('Others')){
                            
                                    if(goalOthersMap.containsKey(gA.Goal__c)){
                                    d1 += goalOthersMap.get(gA.Goal__c);
                                    }
                            goalOthersMap.put(gA.Goal__c, d1);
                        }
                        else if(gA.Portfolio_Report__r.Categories__c.equals('Gold')){
                        
                                    if(goalGoldMap.containsKey(gA.Goal__c)){
                                    d1 += goalGoldMap.get(gA.Goal__c);
                                    }
                            goalGoldMap.put(gA.Goal__c, d1);
                        }
                        else if(gA.Portfolio_Report__r.Categories__c.equals('Real Estate')){
                            
                                    if(goalRealEstateMap.containsKey(gA.Goal__c)){
                                    d1 += goalRealEstateMap.get(gA.Goal__c);
                                    }
                            goalRealEstateMap.put(gA.Goal__c, d1);
                        }
                    }
            }
    }
    
    public PageReference updateGoals(){
        List<GoalAssetAssociation__c> updateAssets = new List<GoalAssetAssociation__c>();
        List<GoalInsuranceAssociation__c> updateInsurance = new List<GoalInsuranceAssociation__c>();
        List<GoalIAULIPAssociation__c> updateInvestmentAssets = new List<GoalIAULIPAssociation__c>();
       
        PageReference pr = null;
        Map<Id, Double> updateGoalsMap = new Map<Id, Double>();
        List<Goal__c> goals = new List<Goal__c>();
        
       try{
                for(Assets ast: assetsList){
                        for(GoalAssetAssociation__c gA: ast.goalList){
                                if(updateGoalsMap != null && !updateGoalsMap.isEmpty() && updateGoalsMap.containsKey(gA.Goal__c)){
                                    System.debug('Asset Association '+gA.Allocation__c);
                                    Double d = updateGoalsMap.get(gA.Goal__c) + (gA.Allocation__c/100 * ast.assetType.Current_Value__c);
                                    updateGoalsMap.put(gA.Goal__c, d);
                                    updateAllocationAsCategories(gA, 'Assets');
                                    
                                        
                                }
                                else{
                                        updateGoalsMap.put(gA.Goal__c, gA.Allocation__c/100 * ast.assetType.Current_Value__c);
                                         updateAllocationAsCategories(gA, 'Assets');
                                }
                        }
                        updateAssets.addAll(ast.goalList);
                }
                for(Insurances ast: insuranceList){
                        for(GoalInsuranceAssociation__c gA: ast.goalList){
                                if(updateGoalsMap != null && !updateGoalsMap.isEmpty() && updateGoalsMap.containsKey(gA.Goal__c)){
                                        Double d = updateGoalsMap.get(gA.Goal__c) + (gA.Allocation__c/100 * ast.insurance.Surrender_Value__c);
                                        
                                        updateGoalsMap.put(gA.Goal__c, d);
                                        updateAllocationAsCategories(gA, 'Insurances');
                                }
                                else{
                                        updateGoalsMap.put(gA.Goal__c, gA.Allocation__c/100 * ast.insurance.Surrender_Value__c);
                                        updateAllocationAsCategories(gA, 'Insurances');
                                }
                        }
                        updateInsurance.addAll(ast.goalList);
                }
                for(InvestmentAssets ast: investmentList){
                        for(GoalIAULIPAssociation__c gA: ast.goalList){
                                if(updateGoalsMap != null && !updateGoalsMap.isEmpty() && updateGoalsMap.containsKey(gA.Goal__c)){
                                         Double d = updateGoalsMap.get(gA.Goal__c) +(gA.Allocation__c/100 * ast.portfolio.Current_Value__c);
                                       
                                        updateGoalsMap.put(gA.Goal__c, d);
                                        updateAllocationAsCategories(gA, 'InvestmentAssets');
                                }
                                else{
                                        updateGoalsMap.put(gA.Goal__c, gA.Allocation__c/100 * ast.portfolio.Current_Value__c);
                                        updateAllocationAsCategories(gA, 'InvestmentAssets');
                                }
                        }
                        updateInvestmentAssets.addAll(ast.goalList);
                }
                for(InvestmentAssets ast: sipList){
                        for(GoalIAULIPAssociation__c gA: ast.goalList){
                                if(updateGoalsMap != null && !updateGoalsMap.isEmpty() && updateGoalsMap.containsKey(gA.Goal__c)){
                                       
                                        Double d = updateGoalsMap.get(gA.Goal__c) + (gA.Allocation__c/100 * ast.portfolio.Current_Value__c);
                                        System.debug('Double1'+d);
                                        updateGoalsMap.put(gA.Goal__c, d);
                                        updateAllocationAsCategories(gA, 'InvestmentAssets');
                                }
                                else{
                                        System.debug('Double2'+(gA.Allocation__c/100 * ast.portfolio.Current_Value__c));
                                        updateGoalsMap.put(gA.Goal__c, (gA.Allocation__c/100 * ast.portfolio.Current_Value__c));
                                        updateAllocationAsCategories(gA, 'InvestmentAssets');
                                        
                                }
                        }
                        updateInvestmentAssets.addAll(ast.goalList);
                }
                for(Goal__c g: [select Id, 
                                                           Accumulated_Amount__c,
                                                           Allocated_Equity__c,
                                                           Allocated_Debt__c,
                                                           Allocated_Real_Estate__c,
                                                           Allocated_Others__c,
                                                           Allocated_Gold__c 
                                                           from Goal__c where Id IN: updateGoalsMap.keySet()]){
                        
                        g.Accumulated_Amount__c = 0;
                        g.Allocated_Equity__c = 0;
                        g.Allocated_Debt__c = 0;
                        g.Allocated_Real_Estate__c = 0;
                        g.Allocated_Others__c = 0;
                        g.Allocated_Gold__c = 0;
                        g.Accumulated_Amount__c += updateGoalsMap.get(g.Id);
                        if(goalEquityMap.containsKey(g.Id)&& goalEquityMap.get(g.Id) != 0){
                                g.Allocated_Equity__c += (goalEquityMap.get(g.Id)/g.Accumulated_Amount__c)*100;
                        }
                        if(goalEquityMap.containsKey(g.Id)&& goalDebtMap.get(g.Id) != 0){
                                g.Allocated_Debt__c += (goalDebtMap.get(g.Id)/g.Accumulated_Amount__c)*100;
                        }
                        if(goalRealEstateMap.containsKey(g.Id) && goalRealEstateMap.get(g.Id) != 0){
                                g.Allocated_Real_Estate__c += (goalRealEstateMap.get(g.Id)/g.Accumulated_Amount__c)*100;
                        }
                        if(goalOthersMap.containsKey(g.Id) && goalOthersMap.get(g.Id) != 0){
                                g.Allocated_Others__c += (goalOthersMap.get(g.Id)/g.Accumulated_Amount__c)*100;
                        }
                        if(goalGoldMap.containsKey(g.Id) && goalGoldMap.get(g.Id) != 0){
                                g.Allocated_Gold__c +=( goalGoldMap.get(g.Id)/g.Accumulated_Amount__c)*100;
                        }
                        goals.add(g);
                }
                update updateAssets;
                update updateInsurance;
                update updateInvestmentAssets;
                update goals;
                resetAll();
             
                //pr = new PageReference('/'+getEntity().Id);
                //pr.setRedirect(true);
      }
      catch(Exception e) {
              Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage())); 
       }
       return pr; 
    }
    
   public void resetAll(){
           
           assetsList = new List<Assets>();
           investmentList = new List<InvestmentAssets>();
           sipList = new List<InvestmentAssets>();
           insuranceList = new List<Insurances>();
           goals = new List<Goal__c>();
           goalAssetAssociationMap = new Map<Id, GoalAssetAssociation__c[]>();
            goalInvestAssetAssociationMap = new Map<Id, GoalIAULIPAssociation__c[]>();
            goalInsuranceAssociationMap = new Map<Id, GoalInsuranceAssociation__c[]>();
            goalEquityMap = new Map<Id, Double>();
            goalDebtMap = new Map<Id, Double>();
            goalGoldMap = new Map<Id, Double>();
            goalRealEstateMap = new Map<Id, Double>();
            goalOthersMap = new Map<Id, Double>();
    
           initialize();
           
   }
   public PageReference cancel() {
        PageReference pr = new PageReference('/'+getEntity().Id);
        pr.setRedirect(true);
        return pr;
    }
    
    public class Assets{
        public Asset__c assetType{get;set;}
        public List<GoalAssetAssociation__c> goalList {get;set;}
        public Double unallocatedAmt {get;set;}
        
        public Assets(Asset__c assetType, List<GoalAssetAssociation__c> goalList, Double unallocatedAmt){
            this.assetType = assetType;
            this.goalList = goalList;
            this.unallocatedAmt = unallocatedAmt;
        }
    }
    
     public class InvestmentAssets{
        public Portfolio_Report__c portfolio{get;set;}
        public List<GoalIAULIPAssociation__c> goalList {get;set;}
        public Double unallocatedAmt {get;set;}
        
        public InvestmentAssets(Portfolio_Report__c portfolio, List<GoalIAULIPAssociation__c> goalList, Double unallocatedAmt){
            this.portfolio = portfolio;
            this.goalList = goalList;
            this.unallocatedAmt = unallocatedAmt;
        }
    }
    
    
     public class Insurances{
        public Insurance__c insurance{get;set;}
        public List<GoalInsuranceAssociation__c> goalList {get;set;}
        public Double unallocatedAmt {get;set;}
        
        public Insurances(Insurance__c insurance, List<GoalInsuranceAssociation__c> goalList, Double unallocatedAmt){
            this.insurance = insurance;
            this.goalList = goalList;
            this.unallocatedAmt = unallocatedAmt;
        }
    }
    
}