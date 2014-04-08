/**
* @Author: Samruddhi P
* @since : 18th Feb 2011
* @Description: LifeInsurancePlanningServices is service class for LifeInsurancePlanningPage in Analysis Section
*/
/*
       Revision History:
       
    Version     Version Author     Date         Comments
    1.0         Persistent         NA                  Initial Draft
   
       2.0                  Manasi Ranade    06/07/2011   Change in function getInsurance: Instead of selecting earning members from parent ,
                                                                                  select all family members for that parent entity.                 
       2.0                  Manasi Ranade    18/11/2011   Issue Id : FS0281 :Change in function getInsurance: Select the Earning members only.
                                                                                  1. If we select checkbox for 'Do you want to include this in Financial Plan?' on Life Insurance Planning page,
                                                                                  then that selected entity's Earning member flag becomes true.                                                                                                      
*/
/**
* @Description: GeneratePDFServices is a class to prepare the data as per the business logic to display in pdf format
* This is act as service class for the GeneratePDFController
*/

public class GeneratePDFServices{
    DatabaseSOQL dbsoql{get;set;}
    public GeneratePDFServices(){ 
        dbsoql=new DatabaseSOQL ();
    }
    
   /**
    * @Description: function used to get client details
    * Return Type: void
    */
    public void getClientDetail(GeneratePDFBean bean){
       //00001556 Commented Original Code
        bean.client = dbsoql.getEntity(bean.entityID);
        /*StaticMethodClass.entityId = bean.entityID;
              bean.client = StaticMethodClass.getEntity;*/
              //00001556 Commented Original Code
        bean.spouse = dbsoql.getSpouseEntity(bean.entityID);
        /*StaticMethodClass.entityId = bean.entityID;
              bean.spouse = StaticMethodClass.getSpouseEntity;
              */
        list<Goal__c> allGoals = new list<goal__c>();
        allGoals = dbsoql.getEntityGoal(bean.entityID);
        
        for(goal__c goal :allGoals)
        {
            if(goal.Goal_Type__c!='Emergency Fund')
                bean.goalList.add(goal);
        }
    }
    
    /**
     * @Description: function to get insurance details to show in pdf
     */
     public List<HLVDetails__c> getHLVDetails(GeneratePDFBean bean,List<Account> dummyAccountList)
     {
     	
     	//Previous code
     	//00001556 commented and created list as below to optimize the code
     	//List<Account> accountList = dbsoql.getEarningMember(bean.entityID);
     	/** Eternus Solutions       **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: F0071      	**/
		/** Date    : 06/07/2011 	**/
		/** Purpose : Instead of selecting earning members from parent ,
					  select all family members for that parent entity.   
		/****************************************************/   
		/** Eternus Solutions       **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: FS0281      	**/
		/** Date    : 06/07/2011 	**/
		/** Purpose : Select the Earning members from the selected parent.
						So comment the following. And use the query 'getEarningMember' to select the entities
		/****************************************************/   
     	//List<Account> accountList = dbsoql.getFamilyDetails(bean.entityID);
     	//FS0281
     	//00001556 Commented Original Code
     	List<HLVDetails__c> lstHLVDetails = new List<HLVDetails__c>(); 
     	//List<Account> dummyAccountList = dbsoql.getFamilyDetails(bean.entityID);
     	List<Account> allAccounts = dummyAccountList;
     	List<Account> accountList = new List<Account>();
		/*StaticMethodClass.entityId = bean.entityID;
		List<Account> dummyAccountList = StaticMethodClass.getFamilyDetails;*/
     	List<Account> allFamilyMembers = new List<Account> ();
     	allFamilyMembers = dummyAccountList;
     	
     	//Calculate the ToalLiabilities for the All family members.
     	//Please uncomment 
     	//List<LifeInsurancePlanningBean> lstInsuranceBean = bean.insuranceService.getDataForAllEntities(dummyAccountList);
     	for(Account accObj : dummyAccountList)
     	{
     		if(accObj.Earning_Member__c != null && accObj.Earning_Member__c == true)
     			accountList.add(accObj);
     	}
     	if(accountList != null && accountList.size() > 0)
     	{
     		set<ID> accIdSet = new set<ID>();
     		for(Account objAcc : accountList)
     		{
     			accIdSet.add(objAcc.id);
     		}
     		lstHLVDetails = [select id,Present_Age_in_case_of_Death_A__c,Normal_Age_of_Retirement_B__c,
        									Working_Life_B_A__c,Present_Age_in_case_of_Death_A_Dependent__c,
        									Normal_Life_Expectancy_B__c,Living_Years_B_A__c,
        									Expected_Return_on_Investments__c,Expected_Inflation__c,
        									Expected_Inflation_Adjusted_Return__c,
        									Selected_Entity_Name__c,Dependent_Entity_Name__c,
        									Liabilities__c,ONE_TIME_FINAL_COSTS_Present_Value__c,
        									Yearly_Household_Inevitable_Expenses__c,Adjustment_Factor_Increase_or_Decreas__c,
        									Total_Living_Expenses_Of_Dependant__c,DEPENDENT_NEEDS_Present_Values__c,GoalDetails__c,
        									GROSS_LIFE_INSURANCE_REQUIRED__c,GOALS_TO_BE_MET_Total__c,Existing_Life_Insurance_Present_Value__c,
        									Continuing_Income_Sources_Details__c,Continuing_Income_Sources_Present_Value__c,
        									Existing_Investments_Details__c,Existing_Investments_Total__c,
        									Additional_Life_Insurance_Required__c,Round_Off__c,entity__c,Remark__c,
        									Premium_Amount_Rs__c,Term_of_Insurance__c,Policy_Type__c
            								from HLVDetails__c where entity__c in: accIdSet];
     	}
     	system.debug('******lstHLVDetails*********'+lstHLVDetails);
     	  System.debug('=============in HLV====>'+Limits.getQueries());
     	return lstHLVDetails;
     	
     }
     public void getInsurance(GeneratePDFBean bean)
     {
       //Previous code
       //00001556 commented and created list as below to optimize the code
       //List<Account> accountList = dbsoql.getEarningMember(bean.entityID);
       /** Eternus Solutions       **/
              /** Author  : Manasi Ranade **/
              /** Issue Id: F0071        **/
              /** Date    : 06/07/2011   **/
              /** Purpose : Instead of selecting earning members from parent ,
                                    select all family members for that parent entity.   
              /****************************************************/   
              /** Eternus Solutions       **/
              /** Author  : Manasi Ranade **/
              /** Issue Id: FS0281      **/
              /** Date    : 06/07/2011   **/
              /** Purpose : Select the Earning members from the selected parent.
                                         So comment the following. And use the query 'getEarningMember' to select the entities
              /****************************************************/   
       //List<Account> accountList = dbsoql.getFamilyDetails(bean.entityID);
       //FS0281
       //00001556 Commented Original Code
       List<Account> dummyAccountList = dbsoql.getFamilyDetails(bean.entityID);
       List<Account> allAccounts = dummyAccountList;
       List<Account> accountList = new List<Account>();
              /*StaticMethodClass.entityId = bean.entityID;
              List<Account> dummyAccountList = StaticMethodClass.getFamilyDetails;*/
       List<Account> allFamilyMembers = new List<Account> ();
       allFamilyMembers = dummyAccountList;
       
       //Calculate the ToalLiabilities for the All family members.
       //Please uncomment 
       //List<LifeInsurancePlanningBean> lstInsuranceBean = bean.insuranceService.getDataForAllEntities(dummyAccountList);
       for(Account accObj : dummyAccountList)
       {
              if(accObj.Earning_Member__c != null && accObj.Earning_Member__c == true)
                     accountList.add(accObj);
       }
       if(accountList != null && accountList.size() > 0)
       {
              /*Id: FS0281: Added last parameter to the function.
                That will be true if function is called from LI page else if it is called from generatePDF it will be false*/
                  
               bean.insuranceBeanList = bean.insuranceService.getDataForAllEntities(accountList,allFamilyMembers);
               
               //Overwrite the Total Liabilities and amountValue of accountList from lstInsuranceBean
               //Commented the following code : Issue Id : 00001556
               /*for(LifeInsurancePlanningBean objBeanOuter : bean.insuranceBeanList)
               {
                     for(LifeInsurancePlanningBean objBeanInner : lstInsuranceBean)
                     {
                            if(objBeanOuter.entityId == objBeanInner.entityId)
                            {
                                  objBeanOuter.liabilitiesTotal = objBeanInner.liabilitiesTotal;
                                  objBeanOuter.income.detailList.clear();
                                  for(InnerClass objInnerClass : objBeanInner.income.detailList)
                                  {
                                         objBeanOuter.income.detailList.add(new innerclass(objInnerClass.accountName,double.valueOf(objInnerClass.amountValue)));
                                  }
                                  break;
                            }
                     }
               }
               */
               //Added AccountList Parameter //00001556
               bean.insuranceService.calculateSummaryBeanValues(bean.insuranceBeanList,accountList,allFamilyMembers);
               system.debug('********************8 bean.insuranceBeanList:'+bean.insuranceBeanList);
       }
       
    }
}