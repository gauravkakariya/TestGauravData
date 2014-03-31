/**
 * @Author: Samruddhi P
 * @since : 18th Feb 2011
 * @Description: LifeInsurancePlanningServices is service class for LifeInsurancePlanningPage in Analysis Section
 */
 /*
	Revision History:
	
    Version     Version Author     Date         Comments
    1.0         Persistent         NA  		  	Initial Draft
   
	2.0			Manasi Ranade	   01/06/2011    Changes in save method:
												 1)Added message to the page if Suggested_Cover_General_Insurance__c is not greater than zero	
												 2)Added default values to the insurance.Which are required fields in Insurance page			
    
    2.0			Manasi Ranade	   02/06/2011	 if Suggested_Cover_General_Insurance__c  is not greater than zero,
							  					 then we should not allow user to save any other changes from that page.
							  					 eg: "Select Adjustment Factor(%) for Expenses" should be same as that of its previous value 
							  					 Hence instead of adding apex message on the page, added throw exception statement in the else part of save button.

	2.0			Manasi Ranade	   06/07/2011	 Issue Id : F0071 :
												 1. Change in function getDataForAllEntities(): Calculation part display total Lieabilites
												 		 of Parent entity and its spouce entity on Plan
												 2. Change in function getPresentValueTotal(): If adjustmentFactor is null then assign 
												 		 '-100' for further calculation
	2.0			Manasi Ranade	   16/11/2011	 Issue Id : FS0285 :
												 Change in function : getInsurances:
												 Need to remove 'Less:- Life Insurance Premium' from LI page
    2.0			Manasi Ranade	   29/12/2011	 Issue Id : FS0388 :
												 In Life Insurance page, when person is adequately insured, 
									             and when we say yes for LI table to be added to Financial plan, 
									             the premium amount is creating a problem because it is zero.
	2.0			Manasi Ranade	   16/04/2012	 Issue Id : 00001595 :
												 Change in save method : Now FP can Enter the required Tenure of Insurance value manually.
						  						 If it is blank then default value will be 20.
	2.0			Manasi Ranade	   16/04/2012	 Issue Id : 00001597 : Change in function getDataForAllEntities: Created Map of entity vs its remark.
	2.0			Manasi Ranade	   16/04/2012	 Issue Id : 00001605 : Change in function getGoalsToBeMet:Commemted previous code.Instaed of picking goals from 
												 Goal priority fetch it from flag 'Is_Include_In_HLV'
	2.0			Manasi Ranade	   16/04/2012	 Issue Id : 00001616 : Created New Function to find out spouse/Dependent entity
	2.0  		Manasi Ranade	   07/05/2012    Issue Id: 00001613 : Change in function : getDataForAllEntities
												 Commented original Code related to map and
												 changed Map from Map<Id,String> to Map<Id,Remarks__c> 
												 Fetched remark from map for respective entity
	2.0  		Manasi Ranade	   07/06/2012    Issue Id: 00001613 : Set the Insurances whose flag is 'Analysis' in fuction : getDataForAllEntities
	2.0  		Manasi Ranade	   09/07/2012    Issue Id: 00001710 : Added null check condition in fuction : getEntityDependentMap
*/
public class LifeInsurancePlanningServices{
    DatabaseSOQL dbSOQL {get; set;}
    DatabaseDML dbDML {get; set;}
    public String entityId {get; set;}
    public Account objAccount;
    public Integer dateYear; 
    /**
    * @Description: Constructor to initialise the service class
    * @param: None 
    */
    public LifeInsurancePlanningServices(){
        dbSOQL = new DatabaseSOQL();
        dbDML = new DatabaseDML();
    }
    
    /** 
    * @getRelatedEntities() gets related Entities 
    * @Param: entityId
    * @Return Type: List of Account
    */
    public List<Account> getRelatedEntities(String entityId){
        List<Account> accountList = dbSOQL.getFamilyDetails(entityId); 
        return accountList ;
    }
    
    /**
    * @getPlanningData() function populates bean with data
    * @params:List<Account> accountList,List<LifeInsurancePlanningBean> beanSummary
    * @Return Type:void
    */
    //00001556 Added allFamilyMembers parameter to the getPlanningData function
    private void getPlanningData(List<Account> accountList,List<LifeInsurancePlanningBean> beanSummary,List<Account> allFamilyMembers)
    {
        try{
            LifeInsuranceOuterClass summary = new LifeInsuranceOuterClass();
            List<AggregateResult> aggQueryResult; 
            //00001556
            Account parent;
            //FS0281
            //Only earning member will be in the list so
            //00001556
            for(Account account:allFamilyMembers){
                if(account.Parent_Entity__c==null)
                {
                 	parent = account;
                    entityId=account.Id;
                }
            }
            /*if(parentEntityId == null && accountList.size() > 0)
            {
            	Account parentEntity = [Select Parent_Entity__c from Account where Id =: accountList[0].Id];
            	parentEntityId = parentEntity.Parent_Entity__c;
            	parent = parentEntity;
            }*/
            
            entityId = ApexPages.currentPage().getParameters().get('EntityId');  //Prajakta
            /** Eternus Solutions  **/
			/** Author  : Manasi Ranade	**/
			/** Issue Id: 00001616      **/
			/** Date    : 07/05/2012 	**/
			/** Purpose : Added code to Decide Dependent entity**/
			/****************************************************/
            Map<Id,Account> AccountVsDependentMap = new Map<Id,Account>();
            AccountVsDependentMap = getEntityDependentMap(allFamilyMembers);
			/** Eternus Solutions      **/
			/** Author  : Manasi Ranade*/
			/** Issue Id: 00001673      **/
			/** Date    : 7/6/2012 **/
			/** Purpose : Set the Insurances whose flag is 'Analysis'**/
			/****************************************************/
			//05191120  Internal Problem Manasi
            List<Insurance__c> insurances = dbSOQL.getEntityLifeInsurance(accountList,InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,'Analysis');
	        Map<id, Insurance__c> insuranceAnalysisMap = new map<id, Insurance__c>();
	        for(Insurance__c objAnalysisInsurance : insurances)
			{
				if(insuranceAnalysisMap.get(objAnalysisInsurance.Entity__C) == Null)
				{
					insuranceAnalysisMap.put(objAnalysisInsurance.Entity__c,objAnalysisInsurance);
				}
			}
            for(Account account:accountList){
                LifeInsurancePlanningBean bean = new LifeInsurancePlanningBean();
                //00001673
                if(insuranceAnalysisMap.get(account.Id) != null)
				{
					bean.insuranceObj = insuranceAnalysisMap.get(account.Id);
				}
                bean.entityId=account.Id;
                bean.entity=account;
                Account spouse;
                ////////////////////////////////////////////////spouse
                //Code to find out the Spouse of the selected entity. 00001556
            	if(account.Parent_Entity__c == null)
            	{
            		for(Account objAcc : allFamilyMembers)
            		{
            			if(objAcc.Relationship_to_Entity__pc != null && 
            			(objAcc.Relationship_to_Entity__pc.equalsIgnoreCase('Wife') || objAcc.Relationship_to_Entity__pc==Label.Husband))
            			{
            				spouse = objAcc;
            				break;
            			}//Relationship_to_Entity__pc
            			/*for(Account account:entities)
            			{
		                    if((account.Relationship_to_Entity__pc==Label.Wife || account.Relationship_to_Entity__pc==Label.Husband) 
		                        && account.Parent_Entity__c==entity.Id){
		                        spouse=account;
		                        flag=true;
		                    }    
		                    if(account.Parent_Entity__c==null){
		                        parentEntity=account;
		                    }
		                }*/
            		}
            	}
        		if(spouse == null && AccountVsDependentMap != null && AccountVsDependentMap.get(account.id) != null)
        		{
        			spouse = AccountVsDependentMap.get(account.id);
        		}
        		system.debug('==========AccountVsDependentMap========='+AccountVsDependentMap);
            	if(spouse != null)
            		bean.spouse = spouse;
                beanSummary.add(bean);
            }
            System.Debug('============= service start planning data ========'+beanSummary);

            //Get Global Assumptions
            
            System.Debug('=============entityId%%%% ========'+entityId);
            
            Entity_Global_Assumption__c assumption = dbSOQL.getGlobalAssumptions(entityId);
            if(assumption!=null){
                LifeInsuranceOuterClass.validateAssumptions(assumption);
                for(LifeInsurancePlanningBean bean:beanSummary){
                    getGlobalAssumptions(assumption,bean.incomeAssumptions.detailList,bean.investAssumptions.detailList);
                }
            }
            else{
                throw new GeneralException(Label.GlobalAssumptionsValidation);
            }        
            //For Expenses           
            
            AggregateResult result = dbSOQL.getTotalExpenses(entityId);
            if(result.get('expenses')!=null){
                for(LifeInsurancePlanningBean bean:beanSummary){
                    summary = bean.expense;
                    summary.detailList=new List<InnerClass>();
                    Double yearlyExpense=(Double)result.get('expenses')*12;
                    bean.expense.detailList.add(new InnerClass(Label.HouseholdExpenses,yearlyExpense));
                    bean.expense.detailList.add(new InnerClass(Label.Adjustment_Factor,-100));
                    bean.expense=summary;
                }
                system.debug('beanSummary.size:'+beanSummary.size());
            }
            else{
                for(LifeInsurancePlanningBean bean:beanSummary){
                    summary = bean.expense;
                    summary.detailList=new List<InnerClass>();
                    bean.expense.detailList.add(new InnerClass(Label.HouseholdExpenses,0));
                    bean.expense.detailList.add(new InnerClass(Label.Adjustment_Factor,-100));
                    bean.expense=summary;
                }
            }
            
            //Get goals
            List<Goal__c> goalResult = dbSOQL.getAllGoals(entityId);
            // Hashing
            //List<Goal__c> goalResult = StaticMethodClass.getAllGoals(parentEntityId);
            for(LifeInsurancePlanningBean bean:beanSummary){
                getGoalsToBeMet(goalResult, bean.goal.detailList);
            }

            //Get Insurances
            aggQueryResult = dbSOQL.getTotalInsurance(accountList,Label.Data_Entry);
            system.debug('aggQueryResult:'+aggQueryResult);
            system.debug('beanSummary:'+beanSummary);
            getInsurances(aggQueryResult,beanSummary);
    
            //Get Incomes //00001556 //Get incomes from 
            aggQueryResult=dbSOQL.getDependentsIncomeValues(allFamilyMembers);
            getDependentIncomes(aggQueryResult,beanSummary);
            
            //Get Assets and Investment Assets
            getExistingAssets(entityId,beanSummary);
            System.Debug('============= service end planning data ========'+beanSummary);
        }
        catch(System.Exception e){
        	System.Debug('==******GetPlanningData');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
        }
    }
    
    /**
    * @getDataForAllEntities() function populates list of bean with data for all entitites
    * @params:List<Account> accountList
    * @Return Type:List<LifeInsurancePlanningBean>
    */ // Need to do
    
    /*00001556 Added allFamilyMembers parameter that will contain all family members related o selected entity.
    Reason : 1. getDataForAllEntities function is called under Analysis section and aslo while generating PDF.
    		 2. When it is call from PDF generaton code, accountList contains only earning members.
    		 3. Hence in PDF it shows wrong value of Liability Total. So added allFamilyMembers which is a List of all family members
    		 	And that is passed to the function : getTotalLiabilities
    */
    public List<LifeInsurancePlanningBean> getDataForAllEntities(List<Account> accountList, List<Account> allFamilyMembers)
    {
        List<LifeInsurancePlanningBean> beanList = new List<LifeInsurancePlanningBean>();
        try{
        	if(accountList != null && accountList.size() > 0)
        	{
	            LifeInsuranceOuterClass summary = new LifeInsuranceOuterClass();
	            List<AggregateResult> aggQueryResult;
	            //00001556 Added allFamilyMembers parameter to the getPlanningData function 
	            getPlanningData(accountList,beanList,allFamilyMembers);
	            //Get total Liabilities //00001556
	            system.debug('****accountList******'+accountList);
	            system.debug('****allFamilyMembers******'+allFamilyMembers);
	           	//Commented on : 26/3/13 : Aditi Satpute : Issue related to Liabilities appearing 0 in Life Insurance Planning page.
	           	//aggQueryResult = dbSOQL.getTotalLiabilities(allFamilyMembers);
	           	//Added on : 26/3/13 : Aditi Satpute
	            aggQueryResult = dbSOQL.getTotalLiabilities(accountList);
	            Map<Id,Account> mapIdToAccount = new  Map<Id,Account>();
	            for(Account acc : accountList)
	            {
	            	if(!mapIdToAccount.containsKey(acc.Id))
	            	{
	            		mapIdToAccount.put(acc.Id,acc);
	            	}
	            }
	            Account accSpouce = new Account();
	       /*     for(Account acc : accountList)
	            {
	            	if(acc.Parent_Entity__c != null )
	            	{
	            		if(acc.Relationship_to_Entity__pc == 'Wife' || acc.Relationship_to_Entity__pc == 'Husband')
		            	{
		            		accSpouce = acc;
		            		break;
		            	}
	            		
	            	}
	            }
	            */
	            system.debug('****aggQueryResult******'+aggQueryResult);
	            if(aggQueryResult != null)
	            {
	            	/** Eternus Solutions  **/
					/** Author  : Manasi Ranade	**/
					/** Issue Id: 00001616      **/
					/** Date    : 07/05/2012 	**/
					/** Purpose : Commented Original Code And Added New Logic as per the dependent**/
					/****************************************************/
	            	Map<Id,Double> entityLiabilityMap = new Map<Id,Double>();
	            	for(AggregateResult aggResult:aggQueryResult)
	            	{
	            		if(entityLiabilityMap.get((String)aggResult.get('entity')) == null)
	            		{
	            			entityLiabilityMap.put((String)aggResult.get('entity'),(Double)aggResult.get(Label.Liabilities));
	            		}
	            	}
	            	      system.debug('****entityLiabilityMap******'+entityLiabilityMap);
	            	Account acc = new Account();
	            	for(LifeInsurancePlanningBean beanObj : beanList)
	            	{
	            		Id entityId, DependentSpouseId;
	            		Double entityLiability = 0, DependentSpouseLiability = 0;
	            		entityId = beanObj.entity.Id;
	            		if(beanObj.spouse != null)
	            			DependentSpouseId = beanObj.spouse.Id;
	            			
	            		if(mapIdToAccount.containsKey(beanObj.entity.Id))
	            		{
	            			acc = mapIdToAccount.get(beanObj.entity.Id);
	            			if(acc.Parent_Entity__c != null && (acc.Relationship_to_Entity__pc == 'Wife' || acc.Relationship_to_Entity__pc == 'Husband'))
	            			{
            					DependentSpouseId = acc.Parent_Entity__c;
	            			}
	            		}	
	            			
	            		//if(accSpouce != null)
	            		//	DependentSpouseId = accSpouce.Id;
	            		system.debug('****DependentSpouseId****'+DependentSpouseId);
	            		if(entityLiabilityMap.get(entityId) != null)
	            			entityLiability = entityLiabilityMap.get(entityId);
	            		if(DependentSpouseId != null && entityLiabilityMap.get(DependentSpouseId) != null)
	            			DependentSpouseLiability = entityLiabilityMap.get(DependentSpouseId);
	            		beanObj.liabilitiesTotal = entityLiability + DependentSpouseLiability;
	            		system.debug('****beanObj.liabilitiesTotal*****'+beanObj.liabilitiesTotal);
	            	}
	            	
	            	            	
	            	/** Eternus Solutions : Manasi Ranade : F0071 : 06/07/2011 	**/
					/** Purpose : To display total Lieabilites of Parent entity and its spouce entity on Plan   
					/****************************************************/
					/** Eternus Solutions: Manasi Ranade : 00001616 : 07/05/2012 : Commented Original Code
					/****************************************************/
					//Original Code
	            	/*Id SpouseEntityWife,SpouseEntityHusband ,parentEntity ,DependentEntity;
	            	
	            	for(Account acc:allFamilyMembers)
	            	{
	            		if(acc.Relationship_to_Entity__pc == 'Wife')
	            			SpouseEntityWife = acc.id;
	            		if(acc.Relationship_to_Entity__pc == 'Husband')
	            			SpouseEntityHusband = acc.id;
						if(acc.RecordTypeId == '01220000000DnK3AAK') //Record type id of 'Client'
							parentEntity = acc.id;
	            	}
	            	double wifeLiabilities = 0,HusbandLiabilities =0,ParentLiabilies =0,totalSpouceLiabilies = 0;
	            	for(AggregateResult aggResult:aggQueryResult)
	            	{
	            		if(SpouseEntityWife != null && SpouseEntityWife == ((String)aggResult.get('entity'))) 
	            			wifeLiabilities = ((Double)aggResult.get(Label.Liabilities));
	            		if(SpouseEntityHusband != null && SpouseEntityHusband == ((String)aggResult.get('entity')))
	            			HusbandLiabilities = ((Double)aggResult.get(Label.Liabilities));
						if(parentEntity != null && parentEntity == ((String)aggResult.get('entity')))
							ParentLiabilies = ((Double)aggResult.get(Label.Liabilities));
						       			
	            	}
	            	totalSpouceLiabilies = wifeLiabilities + HusbandLiabilities + ParentLiabilies; 
	                for(AggregateResult aggResult:aggQueryResult)
	                {
	                    for(LifeInsurancePlanningBean beanObj:beanList){
	                    	//If condition to check the select entity is parent or its spouce or not
	                        if((SpouseEntityWife != null && SpouseEntityWife == beanObj.entityId)
	                        	|| (SpouseEntityHusband != null && SpouseEntityHusband == beanObj.entityId) 
	                        	|| (parentEntity != null && parentEntity == beanObj.entityId))  
	                        {
	                        	beanObj.liabilitiesTotal = totalSpouceLiabilies;
	                            System.debug('=====***************beanObj.liabilitiesTotal:'+beanObj.liabilitiesTotal ); 
	                        }
	                        else if(beanObj.entityId == ((String)aggResult.get('entity')))
	                        	beanObj.liabilitiesTotal=((Double)aggResult.get(Label.Liabilities));
	                    }
	                }*/
	            }
        	}
        	/** Eternus Solutions       **/
			/** Author  : Manasi Ranade **/
			/** Issue Id: 00001597     	**/
			/** Date    : 17/04/2012 	**/
			/** Purpose : Created Map of entity vs its remark .
			/****************************************************/ 
			/** Eternus Solutions       **/
			/** Author  : Manasi Ranade **/
			/** Issue Id: 00001613      **/
			/** Date    : 07/05/2012 	**/
			/** Purpose : Commented original Code.
						  Changed Map from Map<Id,String> to Map<Id,Remarks__c>
			/****************************************************/
    		/*Map<Id,String> entityRemarkMap = new Map<Id,String>();
        	for(Remarks__c objRemark : [select Entity__c,Remark__c from Remarks__c where entity__c 
											IN : accountList and recordtype.Name =: 'LifeInsurancePlanning'])
        	{
        		if(entityRemarkMap.get(objRemark.entity__c) == null)
        			entityRemarkMap.put(objRemark.entity__c,objRemark.Remark__c);
        	}*/
        	Map<Id,Remarks__c> entityRemarkMap = new Map<Id,Remarks__c>();
        	for(Remarks__c objRemark : [select Entity__c,Remark__c from Remarks__c where entity__c 
											IN : accountList and recordtype.Name =: 'LifeInsurancePlanning'])
        	{
        		if(entityRemarkMap.get(objRemark.entity__c) == null)
        			entityRemarkMap.put(objRemark.entity__c,objRemark);
        	}
			for(LifeInsurancePlanningBean beanObj:beanList)
			{
				if(entityRemarkMap.get(beanObj.entityId) != null)
				{
					/** Eternus Solutions       **/
					/** Author  : Manasi Ranade **/
					/** Issue Id: 00001613      **/
					/** Date    : 07/05/2012 	**/
					/** Purpose : Fetch remark from map for respective entity
					/****************************************************/
					beanObj.ObjRemark = entityRemarkMap.get(beanObj.entityId);
					beanObj.strRemark = beanObj.ObjRemark.Remark__c;
				}
			}
        }
        catch(System.Exception e){
             System.debug('=====service getDataForAllEntities Exception======'+e.getMessage());
        }
        return beanList;
    }
       
           
    /**
    * @getAdjustmentFactor() function returns values of Ajustment factor from account
    * @params:None
    * @Return Type:List<SelectOption>
    */    
    public List<SelectOption> getAdjustmentFactor(){
        List <SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult field = Schema.sObjectType.Account.fields.Adjustment_Factor__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        for(Schema.PicklistEntry picklistOption : picklist) {
            options.add(new SelectOption(picklistOption.getValue(),picklistOption.getLabel()));
        }
        return options; 
    }
    
    /**
    * @getGlobalAssumptions() function populates the values from Global Assumptions
    * @params:Entity_Global_Assumption__c assumption, List<InnerClass> incomeList,List<InnerClass> investList
    * @Return Type:void
    */ 
    private void getGlobalAssumptions(Entity_Global_Assumption__c assumption, List<InnerClass> incomeList,List<InnerClass> investList){
        try{
            if(assumption!=null){
                Double adjRate;
                investList.add(new InnerClass(Label.ExpectedReturnOnInvestment,(Double)assumption.Expected_Return_on_Investment__c/100));
                investList.add(new InnerClass(Label.ExpectedInflation,(Double)assumption.Inflation_Rate__c/100));
                adjRate=LifeInsuranceOuterClass.calculateAdjustedRate(investList[0].amountValue,investList[1].amountValue);
                investList.add(new InnerClass(Label.Expected_Inflation_Adjusted_Return,adjRate));
                
                incomeList.add(new InnerClass(Label.ExpectedIncreaseInIncome,(Double)assumption.Income_Growth_Rate__c/100));
                incomeList.add(new InnerClass(Label.ExpectedInflation,(Double)assumption.Inflation_Rate__c/100));
                adjRate=LifeInsuranceOuterClass.calculateAdjustedRate(incomeList[0].amountValue,incomeList[1].amountValue);
                incomeList.add(new InnerClass(Label.Expected_Inflation_Adjusted_Income,adjRate));
                system.debug('******IncomeList :'+incomeList);
            }
        }
        catch(System.Exception e){
             System.debug('=====service getGlobalAssumptions Exception======'+e.getMessage());
        }
    }
    /**
    * @calculateValue() calculates pv values for a bean
    * @params:Account entity,Account spouse,String adjustmentFactor,List<LifeInsurancePlanningBean> beanSummary
    * @Return Type:LifeInsurancePlanningBean 
    */ 
    public LifeInsurancePlanningBean calculateValue(Account entity,Account spouse,String adjustmentFactor,List<LifeInsurancePlanningBean> beanSummary){
    	
        LifeInsurancePlanningBean bean = new LifeInsurancePlanningBean();
        try{
        	// LifeInsuranceOuterClass holding the [Continuing Income Sources value as PresentValue]
            LifeInsuranceOuterClass summary = new LifeInsuranceOuterClass();
            for(LifeInsurancePlanningBean beanObj:beanSummary)
            {
                if(beanObj.entityId == entity.Id)
                    bean = beanObj;
            }
            
            /* Prajakta - FP changes - 11-04-2013 */
	        entityId = System.currentPageReference().getParameters().get('entityId');
	        objAccount = dbSOQL.getEntity(entityId); 
	        if(objAccount.Plan_Generation_Date__c != null)
	        	dateYear = objAccount.Plan_Generation_Date__c.year();
	        else
	        	dateYear = system.today().year();
	        system.debug('=========dateYear============='+dateYear); 
            String currentYear = String.valueOf(dateYear);
            system.debug('=========currentYear============='+currentYear); 
            //String currentYear = System.now().format('yyyy');	/*Praj - commented*/
            System.debug('---------------spouse----------'+spouse);
            Integer ageDiff;
            
            /* Prajakta - FP changes - 18-03-2013 */
            if((entity != null && spouse == null))
            {
            	
                summary = bean.entityAssumptions;
                summary.detailList = new List<InnerClass>();
                ageDiff = Integer.valueOf(currentYear)-Integer.valueOf(entity.PersonBirthdate.year());
                summary.detailList.add(new InnerClass(Label.Present_Age,(Double)ageDiff));
                summary.detailList.add(new InnerClass(Label.Normal_Age_of_Retirement,(Double)Integer.valueOf(entity.Retirement_Age__c)));
                summary.detailList.add(new InnerClass(Label.Working_Life,(Double)summary.detailList[1].amountValue-summary.detailList[0].amountValue));
                bean.entityAssumptions = summary;
            }
            //===============================================
            LifeInsuranceOuterClass.validateAccount(entity,spouse);
            
            if(entity != null)
            {
                summary = bean.entityAssumptions;
                summary.detailList = new List<InnerClass>();
                ageDiff = Integer.valueOf(currentYear)-Integer.valueOf(entity.PersonBirthdate.year());
                summary.detailList.add(new InnerClass(Label.Present_Age,(Double)ageDiff));
                summary.detailList.add(new InnerClass(Label.Normal_Age_of_Retirement,(Double)Integer.valueOf(entity.Retirement_Age__c)));
                summary.detailList.add(new InnerClass(Label.Working_Life,(Double)summary.detailList[1].amountValue-summary.detailList[0].amountValue));
                bean.entityAssumptions = summary;
            }
             system.debug('======**********Inside calculateValue==== after entity!=null');
            if(spouse!=null)// && (entity.Id != spouse.Id))   /* Prajakta - FP changes - 18-03-2013 - Commeneted the condition*/
            {
                summary = bean.spouseAssumptions;
                summary.detailList = new List<InnerClass>();
                ageDiff=Integer.valueOf(currentYear)-Integer.valueOf(spouse.PersonBirthdate.year());
                summary.detailList.add(new InnerClass(Label.Present_Age,(Double)ageDiff));
                summary.detailList.add(new InnerClass(Label.Normal_Life_Expectancy,(Double)Integer.valueOf(spouse.Estimated_Life_Expectancy__c)));
                summary.detailList.add(new InnerClass(Label.Living_Years,(Double)summary.detailList[1].amountValue-summary.detailList[0].amountValue));
                bean.spouseAssumptions=summary;
            }
            
            for(LifeInsurancePlanningBean beanObj:beanSummary)
            {
                if(beanObj.entityId == entity.Id)
                    beanObj = getPresentValueTotal(beanObj,adjustmentFactor);
                   // error.debugLog('*****beanObj********'+beanObj);
            }
        }
        catch(System.Exception e){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
        }
        return bean;
    }
    /** Eternus Solutions  **/
	/** Author  : Manasi Ranade	**/
	/** Issue Id: 00001616      **/
	/** Date    : 07/05/2012 	**/
	/** Purpose : Created New Function to find out spouse/Dependent entity **/
	/****************************************************/
    private Map<Id,Account> getEntityDependentMap(List<Account> allFamilyMembers)
    {
    	Map<Id,Account> AccountVsDependentMap = new Map<Id,Account>();
    	Map<Id,Account> idAccountMap = new Map<Id,Account>();
    	for(Account accObj: allFamilyMembers)
        {
        	if(idAccountMap.get(accObj.id) == null)
        		idAccountMap.put(accObj.id,accObj);
        }
        for(Account accObj: allFamilyMembers)
        {
        	if(AccountVsDependentMap.get(accObj.id) == null)
        	{
        		if(accObj.Dependent__c != null)
        		{
        			/** Eternus Solutions  **/
					/** Author  : Manasi Ranade	**/
					/** Issue Id: 00001710      **/
					/** Date    : 09/07/2012 	**/
					/** Purpose : Added null check condition**/
					/****************************************************/
        			if(accObj.Dependent__c != null && idAccountMap != null && idAccountMap.get(accObj.Dependent__c) != null)
        			{
						Account dependentAcc = idAccountMap.get(accObj.Dependent__c);
						if(dependentAcc != null)
							AccountVsDependentMap.put(accObj.id,dependentAcc);
        			}            			
        		}
        	}
        }
        return AccountVsDependentMap;
    }
    /**
    * @calculateValue() calculates pv values for list of bean
    * @params:List<LifeInsurancePlanningBean> beanSummary
    * @Return Type:void
    */
    //Added AccountList,spouse Parameters //00001556
    public void calculateSummaryBeanValues(List<LifeInsurancePlanningBean> beanSummary,List<Account> accountList,List<Account> allFamilyMembers){
        try{
            system.debug('======IN calculateValue beanSummary==== '+beanSummary);
            //00001556 Used the previously selected select statement
            //List<Account> accountList=dbSOQL.getFamilyDetails(ApexPages.currentPage().getParameters().get('EntityId'));
            /** Eternus Solutions  **/
			/** Author  : Manasi Ranade	**/
			/** Issue Id: 00001616      **/
			/** Date    : 07/05/2012 	**/
			/** Purpose : Code to find out spouse/Dependent entity **/
			/****************************************************/
            Map<Id,Account> AccountVsDependentMap = new Map<Id,Account>();
            AccountVsDependentMap = getEntityDependentMap(allFamilyMembers);
            for(LifeInsurancePlanningBean bean:beanSummary){
        		Account parentEntity,spouse;
        		String entity=bean.entityID;
                LifeInsuranceOuterClass summary=new LifeInsuranceOuterClass();
                if(bean.entity.Parent_Entity__c == null)
                for(Account account:allFamilyMembers)
                {
                    if((account.Relationship_to_Entity__pc==Label.Wife || account.Relationship_to_Entity__pc==Label.Husband) 
                        && account.Parent_Entity__c==entity){
                        spouse=account;
                    }    
                }
                if(spouse == null)
                {
                	if(AccountVsDependentMap != null && AccountVsDependentMap.get(bean.entity.id) != null)
                		spouse = AccountVsDependentMap.get(bean.entity.id);
                }
                ////Original Code
               	/*for(Account account:allFamilyMembers){
                    if((account.Relationship_to_Entity__pc==Label.Wife || account.Relationship_to_Entity__pc==Label.Husband) 
                        && account.Parent_Entity__c==entity){
                        spouse=account;
                        flag=true;
                    }    
                    if(account.Parent_Entity__c==null){
                        parentEntity=account;
                    }
                }
                if(flag==false)
                    spouse=parentEntity;*/
                ////
                If(spouse != null)
                	bean = calculateValue(bean.entity,spouse,bean.entity.Adjustment_Factor__c,beanSummary);
            }    
            system.debug('======after calculate beanSummary==== '+beanSummary);
        }
        catch(System.Exception e){
             System.debug('=====service calculateSummaryBeanValues Exception======'+e.getMessage());
        }
    }
    /**
    * @getGoalsToBeMet() function populates the goals except retirement for a particular entity
    * @params:List<Goal__c> goalResult, List<InnerClass> detailList
    * @Return Type:void 
    */ 
    private void getGoalsToBeMet(List<Goal__c> goalResult, List<InnerClass> detailList){
        for(Goal__c goal : goalResult){
            system.debug('==========services getGoals==='+goal);
            /** Eternus Solutions       **/
			/** Author  : Manasi Ranade **/
			/** Issue Id: 00001605      **/
			/** Date    : 25/04/2012 	**/
			/** Purpose : Commemted previous code.Instaed of picking goals from Goal priority fetch it from flag 'Is_Include_In_HLV'
			/****************************************************/
            //00001605 Original Code
            //if(goal.Cost_of_Goal_Annual__c!=null && goal.Cost_of_Goal_Annual__c>0 
              //     && goal.Goal_Type__c!=Label.Retirement&& goal.Priority__c!=Label.Low && goal.Priority__c!=null){
              if(goal.Cost_of_Goal_Annual__c!=null && goal.Cost_of_Goal_Annual__c>0 
                    && goal.Goal_Type__c!=Label.Retirement && goal.Is_Include_In_HLV__c){
                 Decimal factor = 1;
                 if(goal.Goal_Start_Year__c!=null && goal.Goal_End_Year__c!=null){
                     factor = (Decimal)(Integer.valueOf(goal.Goal_End_Year__c)-Integer.valueOf(goal.Goal_Start_Year__c));
                     if(goal.Goal_Frequency__c!=null && goal.Goal_Frequency__c>1){
                         factor=(Decimal)(factor/goal.Goal_Frequency__c);
                     }
                     factor= factor+1;
                 }        
                detailList.add(new InnerClass(goal.Description__c,(Double)(goal.Cost_of_Goal_Annual__c*factor)));
            }
        }
        if(detailList.isEmpty())
            detailList.add(new InnerClass(Label.NoGoals,0));
    }
    
    /**
    * @getDependentIncomes() function populates the Incomes of family members of particular entity
    * @params:List<AggregateResult>,List<LifeInsurancePlanningBean>
    * @Return Type:void 
    */ 
    private void getDependentIncomes(List<AggregateResult> aggQueryResult, List<LifeInsurancePlanningBean> summaryBean){
        for(LifeInsurancePlanningBean bean:summaryBean){
            LifeInsuranceOuterClass summary=bean.income;
            for(AggregateResult aggResult: aggQueryResult){
                if( aggResult.get('amount')!=null && (Double)aggResult.get('amount')!=0 && bean.entityId!=(String)aggResult.get('entity') ){
                        summary.detailList.add(new InnerClass((String)aggResult.get('name'),(Double)aggResult.get('amount')*12));
                }    
            }
            if(summary.detailList.isEmpty())
                summary.detailList.add(new InnerClass(Label.NoIncome,0));
            bean.income=summary;
        }    
    }
    
    /**
    * @getInsurances() function populates insurance value
    * @params:List<AggregateResult>,List<LifeInsurancePlanningBean>
    * @Return Type:void
    */ 
    public void getInsurances(List<AggregateResult> aggQueryResult, List<LifeInsurancePlanningBean> summaryBean){
       
        for(LifeInsurancePlanningBean bean:summaryBean){
            for(AggregateResult aggResult: aggQueryResult){
                if(aggResult.get('deathbenefit')!=null && (Double)aggResult.get('annualpremium')!=null && bean.entityId==(String)aggResult.get('entity') ){
                	    
                        bean.existingInsuranceTotal=(Double)aggResult.get('deathbenefit');
                        /** Eternus Solutions       **/
						/** Author  : Manasi Ranade **/
						/** Issue Id: FS0285      	**/
						/** Date    : 16/11/2011 	**/
						/** Purpose : Need to remove 'Less:- Life Insurance Premium' from LI page 
						/****************************************************/ 
                        //bean.expense.detailList.add(new InnerClass(Label.Life_Insurance_Premium,(Double)aggResult.get('annualpremium')));
                }
            }
        } 
    }

    /**
    * @getPresentValueTotal() function calculates present values for expense and income
    * @params:LifeInsurancePlanningBean ,String 
    * @Return Type:LifeInsurancePlanningBean
    */ 
    private LifeInsurancePlanningBean getPresentValueTotal(LifeInsurancePlanningBean bean,String adjustmentFactor){
        LifeInsuranceOuterClass summary = bean.expense;
        /** Eternus Solutions       **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: F0071      	**/
		/** Date    : 06/07/2011 	**/
		/** Purpose : If adjustmentFactor is null then assign '-100' for further calculation
		/****************************************************/   
        if(adjustmentFactor == null )
        {
        	adjustmentFactor = '-100';
        }
        
        summary.detailList[1].amountValue = (Double)Integer.valueOf(adjustmentFactor);
        summary.getExpenseTotal(summary); //Exception is coming from this function: LifeInsuranceOuterClass.getExpensetotal
        
        if(bean.spouseAssumptions == null && bean.entityAssumptions != null)
        {
        	//error.debugLog('****if 1**bean.entityAssumptions*'+bean.entityAssumptions);
        	summary.presentValue = LifeInsuranceOuterClass.calculatePresentValue(bean.investAssumptions.detailList[2].amountValue,bean.entityAssumptions.detailList[2].amountValue.intValue(),summary.Total);
        }
        
        if(bean.spouseAssumptions != null)
        {
        	//error.debugLog('*******if 2:bean.spouseAssumptions'+bean.spouseAssumptions);
            summary.presentValue=LifeInsuranceOuterClass.calculatePresentValue(bean.investAssumptions.detailList[2].amountValue,bean.spouseAssumptions.detailList[2].amountValue.intValue(),summary.Total);
        //error.debugLog('*****summary.presentValue 2*****'+summary.presentValue);
        }
        bean.expense = summary;
        summary = bean.income;
        
        if(bean.entityAssumptions!=null){
        	//error.debugLog('****if 3**bean.incomeAssumptions*'+bean.incomeAssumptions.detailList[2].amountValue);
        	//error.debugLog('****if 3**bean.incomeAssumptions*'+bean.entityAssumptions.detailList[2].amountValue.intValue());
        	//error.debugLog('****if 3**bean.incomeAssumptions*'+summary.Total);
        	summary.presentValue=LifeInsuranceOuterClass.calculatePresentValue(bean.incomeAssumptions.detailList[2].amountValue,bean.entityAssumptions.detailList[2].amountValue.intValue(),summary.Total);
        	//error.debugLog('*****summary.presentValue 3*****'+summary.presentValue);
        }
        return bean;
    }

    /**
    * @getExistingAssets() function gets the all Assets and Investment Assets for a particular entity
    * @params:String ,List<LifeInsurancePlanningBean>
    * @Return Type:void
    */ 
    private void getExistingAssets(String entityId, List<LifeInsurancePlanningBean> beanSummary)
    {
        List<AggregateResult> aggAssetResult=new List<AggregateResult>();
        AggregateResult aggQueryResult;
        try
        {
            // Fetch Assets except Personal Assets and Real Estate Assets
            aggAssetResult = dbSOQL.getExistingAssets(entityId);
            system.debug('========= getExistingAssets =========='+aggAssetResult);
            for(LifeInsurancePlanningBean bean:beanSummary){
                for(AggregateResult aggResult: aggAssetResult){
                	if(aggResult.get('includeHLV') == true)			/*Prajakta - FP changes II - 27-05-2013 - To include only checked assets in HLV*/
                        bean.asset.detailList.add(new InnerClass((String)aggResult.get('recordtype'),(Double)aggResult.get('totalasset')));
                }    
            }
            // Fetch Personal Assets (Gold) and Real Estate Assets (except 'Primary' AssetType 
            aggAssetResult=dbSOQL.getExistingRealEstatePersonalAssets(entityId);
            for(LifeInsurancePlanningBean bean:beanSummary)
            {
                for(AggregateResult aggResult: aggAssetResult){
                	if(aggResult.get('includeHLV') == true)		/*Prajakta - FP changes II - 27-05-2013 - To include only checked assets in HLV*/
                	{
                		/*Prajakta - FP changes II - 27-05-2013 - Commented as Gold is removed from pick list of Personal Assets*/
	                    if((String)aggResult.get('recordtype')==Label.Personal_Assets){
	                        if((String)aggResult.get('assettype')==Label.Gold)
	                            bean.asset.detailList.add(new InnerClass(Label.Gold,(Double)aggResult.get('totalasset')));
	                    } 
	                    else 
	                    if((String)aggResult.get('recordtype')==Label.RealEstateAssets){
	                        if((String)aggResult.get('assettype')!=Label.Primary)
	                            bean.asset.detailList.add(new InnerClass(Label.RealEstate,(Double)aggResult.get('totalasset')));
	                    }
                	}
                }
            }
            
            /*Prajakta - FP changes II - 27-05-2013 - To include only checked assets in HLV*/
            List<Investment_Asset__c> lstInvestmentAsset = new List<Investment_Asset__c>();
 			Boolean mutualFundFlag=false;
            lstInvestmentAsset = dbSOQL.getInvestmentAsset(entityId, true);
            if(lstInvestmentAsset != null)
            {
            	for(LifeInsurancePlanningBean bean:beanSummary)
            	{
                	Double totalStock = 0, totalGold = 0, totalFI = 0;
                	Double totalEquity = 0, totalDebt = 0,totalHybrid = 0;
                	
					for(Investment_Asset__c result : lstInvestmentAsset)
					{
						//result.Is_Include_In_HLV_Inv_Asset__c = true;
						if(result.RecordTypeId == InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c)
            			{
							if(result.Is_Include_In_HLV_Inv_Asset__c == true)
								totalStock += result.TotalAsset__c;
            			}
            			else if(result.RecordTypeId == InvestmentAsset__c.getInstance('Gold and Silver').RecordTypeId__c)
            			{
							if(result.Is_Include_In_HLV_Inv_Asset__c == true)
								totalGold += result.TotalAsset__c;
								
            			}
            			else if(result.RecordTypeId == InvestmentAsset__c.getInstance(Label.FixedIncome).RecordTypeId__c)
            			{
							if(result.Is_Include_In_HLV_Inv_Asset__c == true)
								totalFI += result.TotalAsset__c;
            			}
            			//Combined Code on : 3/10/13 - Aditi Satpute : Removed Multiple queries on one Obj and Merged the code
            			else if(result.Asset_Type__c.contains(Label.Equity) && result.Is_Include_In_HLV_Inv_Asset__c == true)
						{
							system.debug('-------result-Equity-result.TotalAsset__c-'+result.TotalAsset__c);
							totalEquity += result.TotalAsset__c;
						}
						else if(result.Asset_Type__c.contains(Label.Debt) && result.Is_Include_In_HLV_Inv_Asset__c == true)
						{
							totalDebt += result.TotalAsset__c;
						}
						else if(result.Asset_Type__c.contains(Label.Hybrid) && result.Is_Include_In_HLV_Inv_Asset__c == true)
						{
							totalHybrid += result.TotalAsset__c;
						}
					}
					bean.asset.detailList.add(new InnerClass(Label.StocksShares,totalStock));
					bean.asset.detailList.add(new InnerClass(Label.Gold_and_Silver,totalGold));
					bean.asset.detailList.add(new InnerClass(Label.FixedIncome,totalFI)); 
					 
					bean.asset.detailList.add(new InnerClass(Label.Mutual_Funds,null));
					mutualFundFlag = true;
					bean.asset.detailList.add(new InnerClass(Label.Equity_Funds,totalEquity)); 
					bean.asset.detailList.add(new InnerClass(Label.Debt_Funds,totalDebt)); 
					bean.asset.detailList.add(new InnerClass(Label.Hybrid_Funds,totalHybrid));
					         	
                }
            }
            
            //Commented Code on : 3/10/13 - Aditi Satpute : Removed Multiple queries on one Obj and Merged the code above
           /* lstInvestmentAsset = dbSOQL.getInvestmentAsset(InvestmentAsset__c.getInstance(Label.Gold_and_Silver).RecordTypeId__c, entityId);
            if(lstInvestmentAsset != null){
            	for(LifeInsurancePlanningBean bean:beanSummary){
                	Double total = 0;
					for(Investment_Asset__c result : lstInvestmentAsset){
						total += result.TotalAsset__c;
						if(result.Is_Include_In_HLV_Inv_Asset__c == true)
							bean.asset.detailList.add(new InnerClass(Label.Gold_and_Silver,total));
					}            	
                }
            }*/
            
            /*Prajakta - FP changes II - 27-05-2013 - To include only checked assets in HLV*/
            
         	 /* Boolean mutualFundFlag=false;
            lstInvestmentAsset = dbSOQL.getInvestmentAsset(InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c, entityId);
            if(lstInvestmentAsset != null)
            {
            	for(LifeInsurancePlanningBean bean:beanSummary)
            	{
                	Double totalEquity = 0;
                	Double totalDebt = 0;
                	Double totalHybrid = 0;
					for(Investment_Asset__c result : lstInvestmentAsset)
					{
						if(result.Asset_Type__c.contains(Label.Equity) && result.Is_Include_In_HLV_Inv_Asset__c == true)
						{
							system.debug('-------result-Equity-result.TotalAsset__c-'+result.TotalAsset__c);
							totalEquity += result.TotalAsset__c;
						}
						else if(result.Asset_Type__c.contains(Label.Debt) && result.Is_Include_In_HLV_Inv_Asset__c == true)
						{
							totalDebt += result.TotalAsset__c;
						}
						else if(result.Asset_Type__c.contains(Label.Hybrid) && result.Is_Include_In_HLV_Inv_Asset__c == true)
						{
							totalHybrid += result.TotalAsset__c;
						}
						
					}  
					bean.asset.detailList.add(new InnerClass(Label.Mutual_Funds,null));
					mutualFundFlag = true;
					bean.asset.detailList.add(new InnerClass(Label.Equity_Funds,totalEquity)); 
					bean.asset.detailList.add(new InnerClass(Label.Debt_Funds,totalDebt)); 
					bean.asset.detailList.add(new InnerClass(Label.Hybrid_Funds,totalHybrid));          	
                }
                
            	//for(LifeInsurancePlanningBean bean:beanSummary){
                //	Double total = 0;
				//	for(Investment_Asset__c result : lstInvestmentAsset){
				//		system.debug('-------result---'+result);
				//		if(result.Asset_Type__c.contains(Label.Debt) && result.Is_Include_In_HLV_Inv_Asset__c == true){
				//			total += result.TotalAsset__c;
				//		}
				//	}  
				//	if(mutualFundFlag!= true)
				//		bean.asset.detailList.add(new InnerClass(Label.Mutual_Funds,null));
				//	mutualFundFlag = true;
				//	bean.asset.detailList.add(new InnerClass(Label.Debt_Funds,total));          	
                //}
                
            }*///End -- Commented Code on : 3/10/13 - Aditi Satpute : Removed Multiple queries on one Obj and Merged the code above
            
            /*
            lstInvestmentAsset = dbSOQL.getInvestmentAsset(InvestmentAsset__c.getInstance(Label.FixedIncome).RecordTypeId__c, entityId);
            if(lstInvestmentAsset != null){
            	for(LifeInsurancePlanningBean bean:beanSummary){
                	Double total = 0;
					for(Investment_Asset__c result : lstInvestmentAsset){
						total += result.TotalAsset__c;
						if(result.Is_Include_In_HLV_Inv_Asset__c == true)
							bean.asset.detailList.add(new InnerClass(Label.FixedIncome,total));
					}            	
                }
            }
            */
             /*Prajakta - FP changes II - 27-05-2013 - Commented original code - To include only checked assets in HLV*/
            // Fetch Stock Investment Asset 
            /*aggQueryResult = dbSOQL.getInvestmentAssetByClass(entityId,InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c);
            if(aggQueryResult!= null) {
                for(LifeInsurancePlanningBean bean:beanSummary)
                {
                	error.debugLog('*******(Double)aggQueryResult.get(assetValue)*****1**'+(Double)aggQueryResult.get('assetValue'));	
                	bean.asset.detailList.add(new InnerClass(Label.StocksShares,(Double)aggQueryResult.get('assetValue')));
                }    
            }*/
            
            /* Prajakta - FP changes - 26-02-2013 
            // Fetch Gold Investment Asset 
            aggQueryResult= dbSOQL.getInvestmentAssetByClass(entityId,InvestmentAsset__c.getInstance(Label.Gold_and_Silver).RecordTypeId__c);
            if(aggQueryResult!= null) {
                for(LifeInsurancePlanningBean bean:beanSummary){
                   	bean.asset.detailList.add(new InnerClass(Label.Gold_and_Silver,(Double)aggQueryResult.get('assetValue'))); //Label.Gold
                }    
            }
            
            // Fetch Equity and Debt Mutual Fund Investment Asset 
            aggQueryResult= dbSOQL.getMutualFundTotal(entityId,Label.Equity,InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c);
            if((aggQueryResult!= null)) {
                for(LifeInsurancePlanningBean bean:beanSummary){
                    bean.asset.detailList.add(new InnerClass(Label.Mutual_Funds,null));
                    mutualFundFlag=true;
                    bean.asset.detailList.add(new InnerClass(Label.Equity_Funds,(Double)aggQueryResult.get('assetValue')));
                }
            }
            
            aggQueryResult= dbSOQL.getMutualFundTotal(entityId,Label.Debt,InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c);
            if(aggQueryResult!= null) {
                if(mutualFundFlag!= true) {
                    for(LifeInsurancePlanningBean bean:beanSummary){
                        bean.asset.detailList.add(new InnerClass(Label.Mutual_Funds,null));
                        mutualFundFlag= true;
                    }    
                }
                for(LifeInsurancePlanningBean bean:beanSummary){
	                bean.asset.detailList.add(new InnerClass(Label.Debt_Funds,(Double)aggQueryResult.get('assetValue')));
                }
            }  
            
             */           
                     
            // Fetch Fixed Income Investment Asset 
            /*aggQueryResult= dbSOQL.getInvestmentAssetByClass(entityId,InvestmentAsset__c.getInstance('Fixed Income').RecordTypeId__c);
            if(aggQueryResult!= null) {
                for(LifeInsurancePlanningBean bean:beanSummary){
                    bean.asset.detailList.add(new InnerClass(Label.FixedIncome,(Double)aggQueryResult.get('assetValue')));
                } 
            }*/
            
            for(LifeInsurancePlanningBean bean:beanSummary){
                if(bean.asset.detailList.isEmpty()){
                    bean.asset.detailList.add(new InnerClass(Label.NoAssets,0));
                }
            } 
        }           
        catch(System.Exception e){
             System.debug('=====service getExistingAssets Exception====='+e.getMessage());
        }
    }
    /**
    * @getInsurance() function gets analysis insurance
    * @params:String entityId
    * @Return Type:Insurance__c 
    */    
    public Insurance__c getInsurance(String entityId){
        Insurance__c insurance;
        try{
            insurance = dbSOQL.getEntityLifeInsurance(entityId,InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,'Analysis');
        }
        catch(System.Exception e){
            System.Debug('=============service getInsurance Exception========'+e.getMessage());
        }
        return insurance; 
    }
    /**
    * @getInsuranceValues() function populates insurances for beanSumamry 
    * @params:List<Account> accountList,List<LifeInsurancePlanningBean> beanSummary
    * @Return Type:void
    */    
    public void getInsuranceValues(List<Account> accountList,List<LifeInsurancePlanningBean> beanSummary){
        try{
            List<Insurance__c> insurances = dbSOQL.getEntityLifeInsurance(accountList,InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c,'Analysis');
            for(LifeInsurancePlanningBean beanobj:beanSummary){
                for(Insurance__c insurance:insurances){
                    if(beanobj.entityId==insurance.entity__c)
                        beanobj.insurance=insurance;
                }
            }
            System.Debug('============= Service getInsuranceValues========'+beanSummary);
        }
        catch(System.Exception e){
            System.Debug('=============service getInsuranceValues Exception========'+e.getMessage());
        }
    }
    /**
    * @save() function saves the suggested insurance for a particular entity
    * @params:Account ,calculatedInsurance
    * @Return Type:void
    */ 
    public void save(Account entity,Insurance__c insurance){
        try{
        	system.debug('*****in service save *entity.Id***'+entity.Id);
        	
        	if(insurance.Premium_Amount_Rs__c != null && insurance.Premium_Amount_Rs__c > 0)
        	{
        		system.debug('*******in if****');
	            if(insurance.Policy_Type__c==null)
	                insurance.Policy_Type__c = Label.Term_Life;
	            if(insurance.Premium_Amount_Rs__c==null)
	                insurance.Premium_Amount_Rs__c = 0;
	            insurance.Flag__c = Label.Analysis;
	            
	            /** Eternus Solutions      **/
				/** Author  : Manasi Ranade*/
				/** Issue Id: F0025      **/
				/** Date    : 01/06/2011 **/
				/** Purpose : Added default values to the insurance.Which are required fields in Insurance page**/
				/****************************************************/
	            insurance.Premium_Frequency__c = 'Annually';
	            insurance.commencement_date__c = Date.today();	/*Praj*/
	            /** Eternus Solutions      **/
				/** Author  : Manasi Ranad e*/
				/** Issue Id: 00001595     **/
				/** Date    : 16/04/2012   **/
				/** Purpose : Now FP can Enter the required Tenure of Insurance value manually.
							  If it is blank then default value will be 20**/
				/****************************************************/
	            if(insurance.Tenure_of_Insurance__c == null || insurance.Tenure_of_Insurance__c == 0) 
	            	insurance.Tenure_of_Insurance__c = 20;
	            /** Eternus Solutions      **/
				/** Author  : Manasi Ranade*/
				/** Issue Id: FS0388      **/
				/** Date    : 29/12/2011 **/
				/** Purpose : In Life Insurance page, when person is adequately insured, 
				            and when we say yes for LI table to be added to Financial plan, 
				            the premium amount is creating a problem because it is zero.
				/****************************************************/
	            //if(insurance.Suggested_Cover_General_Insurance__c>0)
                dbDML.upsertObject(insurance);
        	}
        	else
        	{
        		try
        		{
        			insurance.Tenure_of_Insurance__c = null;
        			system.debug('********insurance********'+insurance);
        			delete insurance; //If ID is not present then it will thow exception
        		}
        		catch(Exception e)
        		{}
        		
        	}
            //Original Code
            /** Eternus Solutions      **/
			/** Author  : Manasi Ranade*/
			/** Issue Id: F0025      **/
			/** Date    : 01/06/2011 **/
			/** Purpose : Added message to the page if Suggested_Cover_General_Insurance__c is not greater than zero  **/
			/****************************************************/
            /*else
            {
				System.debug('*************** Label.GeneralInsuranceSuggestedValueMessage'+ Label.GeneralInsuranceSuggestedValueMessage);    
				/** Eternus Solutions      **/
				/** Author  : Manasi Ranade*/
				/** Issue Id: F0025      **/
				/** Date    : 02/06/2011 **/
				/** Purpose : if Suggested_Cover_General_Insurance__c  is not greater than zero,
							  then we should not allow user to save any other changes from that page.
							  eg: "Select Adjustment Factor(%) for Expenses" should be same as that of its previous value 
							  Hence instead of adding apex message on the page, added throw exception statement.**/
				/****************************************************/        
            	/*throw new GeneralException(Label.GeneralInsuranceSuggestedValueMessage); 
            	//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, System.Label.GeneralInsuranceSuggestedValueMessage));
            }*/	
            dbDML.upsertObject(entity);
       }
        catch(System.Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
        }
    }
}