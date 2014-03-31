/**
  This class is an interface to VisualForce page to get/hold all dara for 
      landing page and output page.
      
Revision History:
  
    Version     Version Author     Date        Comments
    1.0         --                --        Initial Draft
    2.0      Niket Chandane     2/06/2011    Added the new property "GlobalAssumptionInflationRate" to set the 
                          Global assumption Inflaction rate when Inflaction rate is null on the goal.
    2.0      Manasi Ranade      25/08/2011    Issue Id : FS0124 :
                          Function Name : getPresentFutureValueList
                          Before fetching list values checked null condition and size of the list
    2.0      Manasi Ranade     31/10/2011   Issue ID: FS0230: 
                        Added properties to display SIP values on Generated PDF plan
  2.0      Manasi Ranade     7/12/2011    1)Issue Id:FS0340 : Clear goalSIPAmountList also before 'Liquidate Align to Goal' related calculations
                          And Initialse it after clearing it.
  2.0      Manasi Ranade     1/2/2012    issue id : 00001470 : Assigned default values to GoldCurrentYear__c,EquityCurrentYear__c,DebtCurrentYear__c.
  
  2.0      Mahesh Hirugade     9/5/2012    issue id : 00001614 : Added new parameter "newDescription" to populateGoalAseetMapping()
                                    Added new property "newDescription" to "GoalAssetMappingBean" inner class
  2.1      Gaurav         15/2/2013  Issue: To add new column in GoalCalculationOutputpage (Allocated Percent).                    
  
*/
public class GoalMappingBean {
    // Goal object reference
    public Goal__c goalObj { get;set;}
    public List<SelectOption> lstSipStartYear {get;set;}
    /*
      Modified By : Niket Chandane.
      Modified At : 2 June 2011.
      Change     : GlobalAssumptionInflationRate{get;set;}
    */
    /** Eternus Solutions      **/
  /** Author  : Manasi Ranade*/
  /** Issue Id: FS0230      **/
  /** Date    : 31/10/2011 **/
  /** Purpose : Added properties to display SIP values on Generated PDF plan **/
  /****************************************************/
  public Double retirmentFutureValue {get;set;}
    public Double dblEquitySIP {get;set;}
    public Double dblGoldSIP{get;set;}
    public Double dblDebtSIP {get;set;}
    public Double dblTotalSIP {get;set;}
    public List<String> lstAllocatedString{get;set;} //Aditi
    public String SipYear{get;set;}
    public Decimal GlobalAssumptionInflationRate{get;set;}
    // To keep data to be stored in db
    public List<GoalSIPAmount__c> goalSIPAmountList = new List<GoalSIPAmount__c>();
    // Header list for Target amount table
    public List<String> headerList 
    {
        get 
        {
            if(headerList == null) 
            {
                headerList = new List<String>();
                headerList.add('Goal Year');
            }
            return headerList;
        }
        set;
    }
    public Integer goalStartYear { get;set;}
    public Integer goalEndYear { get;set;}  
    public Map<Integer,Double> goalPVActualSumMap = new Map<Integer,Double>(); // For retirement
    //Manasi Joshi
    //public Map<Integer,Double> goalFVActualSumMap = new Map<Integer,Double>();// For retirement
    public List<SIPBean> goalPVSIPCalculationList = new List<SIPBean>();// Retirement
    private Double cashInflowSum = 0;
    public Integer retirementYear;
    public Integer sipStartYear{get;set;}
    public Boolean isRemainingYear{get;set;}
    public string chartData1{get;set;}
    private Integer remainingYear;
    
    
    public GoalMappingBean()
    {
      //Do nothing
    }
    
    
    public GoalMappingBean(Integer retirementYear) 
    {  
      this.retirementYear = retirementYear;
    }
    
    /*   Constructor is to populate/initialize default data for SIP calculation. */
    public GoalMappingBean(String goalId, Integer goalStartYear, Integer retirementYear, Integer goalEndYear, Integer sipStartYear) 
    {
      this.goalStartYear = goalStartYear;
        this.goalEndYear = goalEndYear;
        this.retirementYear = retirementYear;
        this.sipStartYear = sipStartYear;
        DataEntrySummaryBean summaryBeanObj;
        
        List<DataEntrySummaryBean> dataEntrySummaryBeanList;
        
        SIPBean sipBean,sipBeanForPV;
        
        GoalSIPAmount__c goalSIPAmountObj;
        /*Praj*/
        system.debug('------sipStartYear-----in GoalMappingBean()-----'+sipStartYear);
        for(Integer currentYear = sipStartYear;/* System.today().year(); /* /*Praj*/ currentYear < goalEndYear; currentYear++) 
        {        
            indexMap.put(currentYear,summaryBeanIndexList.size());
            dataEntrySummaryBeanList = new List<DataEntrySummaryBean>();            
            dataEntrySummaryBeanList.add((summaryBeanObj =new DataEntrySummaryBean()));                                                                                 
            summaryBeanIndexList.add(dataEntrySummaryBeanList);
            sipBeanList.add(((sipBean = new SIPBean())));
            
            // In this constructor goalSIPAmountList get fields which conatains the 
            // GoalSIPAmount__c object 
            /** Eternus Solutions       **/
          /** Author  : Manasi Ranade **/
          /** Issue Id: 00001470       **/
          /** Date    : 1/2/2012    **/
          /** Purpose : Assigned default values to GoldCurrentYear__c,EquityCurrentYear__c,DebtCurrentYear__c.
          /****************************************************/
            goalSIPAmountList.add(new GoalSIPAmount__c(Goal__c = goalId, goal_year__c = currentYear, SIP_Debt__c = 0, SIP_Equity__c = 0, SIP_Gold__c = 0, 
                                    SIP_Outflow__c = true, DebtCurrentYear__c = 0, EquityCurrentYear__c = 0, GoldCurrentYear__c = 0 ));
            goalPVActualSumMap.put(currentYear,0);
            //Manasi Joshi 
            //goalFVActualSumMap.put(currentYear,0);
            
            goalPVSIPCalculationList.add((sipBeanForPV = new SIPBean()));
            summaryBeanObj.linkField = sipBean.financialYear = sipBeanForPV.financialYear = currentYear;            
        }
    }
    
    public void ClearSipBeanList(Integer goalEndYear,Id goalId,Integer sipStartYear)
    {
        SIPBean sipBean;
        this.sipStartYear = sipStartYear;
        sipBeanList.clear();
        //FS0340
        /** Eternus Solutions       **/
      /** Author  : Manasi Ranade **/
      /** Issue Id: FS0340        **/
      /** Date    : 7/12/2011   **/
       /** Purpose : Clear goalSIPAmountList also before 'Liquidate Align to Goal' related calculations
            And Initialse it after clearing it.
      /****************************************************/
      goalSIPAmountList.clear();
    
         for(Integer currentYear = sipStartYear;  /*Praj - Commented system.today().year()*/currentYear < goalEndYear; currentYear++)
         {
          sipBeanList.add(((sipBean = new SIPBean())));
           goalSIPAmountList.add(new GoalSIPAmount__c(Goal__c = goalId,goal_year__c = currentYear,SIP_Debt__c = 0,SIP_Equity__c = 0,SIP_Gold__c = 0,SIP_Outflow__c = true
                                   ,DebtCurrentYear__c = 0,EquityCurrentYear__c = 0,GoldCurrentYear__c = 0 ));
         }
         cashInflowSum = 0;
        // goalDetailBeanList = new List<GoalDetailBean>();
  }
    /*public void setSIPObjects(List<GoalSIPAmount__c> sipCalculatedInDbList) {
        GoalSIPAmount__c tempObj;       
        System.debug('setSIPObjects ' + goalSIPAmountList.size() );
        for(GoalSIPAmount__c sipObj : sipCalculatedInDbList) {
            if(indexMap.containsKey(sipObj.Goal_Year__c.intValue())) {
                goalSIPAmountList.set(indexMap.get(sipObj.Goal_Year__c.intValue()),sipObj);                             
            }                               
        }       
        System.debug('setSIPObjects After for loop ' + goalSIPAmountList.size());
    }*/
    /*
      This function is being used to calculate IRR value.
    */
    
    public Double getIRR() 
    {
        system.debug('-------------sipStartYear-------------'+sipStartYear);
        system.debug('-------------goalPVActualSumMap-------------'+goalPVActualSumMap.keySet());
        if(goalPVActualSumMap.containsKey(sipStartYear))
        {
          Double initialCashFlow = goalPVActualSumMap.get(sipStartYear); //(system.today().year());    /*Praj-PGD*/
          Double tempValue;
          Decimal result, rateGuess1, rateGuess2, pSum1 = 0, pSum2 = 0 , p;
          
          //error.debugLog('--------------initialCashFlow------------------'+initialCashFlow);
          //Added condtion:It was throwing divide by zero exception
          if(initialCashFlow != 0)
            rateGuess1 = Math.pow(cashInflowSum/initialCashFlow, (2.0d/(goalPVActualSumMap.size() +1)));
          else
            rateGuess1 = 0;
          if(rateGuess1 != 0)
            rateGuess1 = rateGuess1.setScale(4, System.Roundingmode.HALF_EVEN);
          
          System.debug('------------------goalDetailBeanList---------------'+ goalDetailBeanList);  
          if(goalDetailBeanList != null && !goalDetailBeanList.isEmpty()){
            for(GoalDetailBean detailBean : goalDetailBeanList) 
            {
              System.debug('-------------------rateGuess1.doubleValue()--------------------'+ rateGuess1.doubleValue());
              System.debug('-------------------detailBean.goalEndYear--------------------'+ detailBean.goalEndYear);
              System.debug('-------------------detailBean.goalStartYear--------------------'+ detailBean.goalStartYear);
              System.debug('-------------------detailBean.goalEndYear - detailBean.goalStartYear--------------------'+ (detailBean.goalEndYear - detailBean.goalStartYear));
              System.debug('-------------------Math--------------------'+ Math.pow(rateGuess1.doubleValue(), detailBean.goalEndYear - detailBean.goalStartYear));
              /* Added On :  23/7/13 : Aditi Satpute : Added Condition check as it Throws error if Retirement Year is less current year.*/
              if(Math.pow(rateGuess1.doubleValue(), detailBean.goalEndYear - detailBean.goalStartYear) > 0.0)  
                pSum1 += (detailBean.targetAmountActual / Math.pow(rateGuess1.doubleValue(), detailBean.goalEndYear - detailBean.goalStartYear));
               pSum1 = pSum1.setScale(4, System.Roundingmode.HALF_EVEN);
            }
            rateGuess2 = rateGuess1 * (1.0d + (1.0d - initialCashFlow/pSum1)*(2.0d/goalPVActualSumMap.size()));
            rateGuess2 = rateGuess2.setScale(4, System.Roundingmode.HALF_EVEN);
            rateGuess2 = (rateGuess2 < 0 ? rateGuess2 * (-1) : rateGuess2);
            
            for(GoalDetailBean detailBean : goalDetailBeanList) 
            {
                pSum2+=(detailBean.targetAmountActual/Math.pow(rateGuess2.doubleValue(),detailBean.goalEndYear- detailBean.goalStartYear));
                pSum2 = pSum2.setScale(4, System.Roundingmode.HALF_EVEN);
            }
            
            if(pSum2 != pSum1 && pSum2 > 0.0) 
            {
              p = Math.log(pSum2/initialCashFlow) /Math.log(pSum2/pSum1);
                p = p.setScale(6,System.Roundingmode.HALF_EVEN);
                tempValue = rateGuess1.doubleValue()/rateGuess2.doubleValue();
                tempValue = (tempValue < 0 ? tempValue * -1 : tempValue);
                result = (rateGuess2 * Math.pow(tempValue, p.doubleValue()) -1)* 100;
            } 
            else 
            {
              p = (Math.log(cashInflowSum/initialCashFlow)/Math.log(cashInflowSum/pSum1));
                result = ( Math.pow(rateGuess1.doubleValue(),p.doubleValue()) - 1) * 100 ;          
            }  
          }
          
          if(result == null) return 1;
          
          result = result.setScale(4, System.Roundingmode.HALF_EVEN);
          return result.doubleValue();       
        }
        return null;                        
    }
    
    /*
      To show goalProfiles on landing page
    */
    public List<SelectOption> goalProfileList {
        get {
            if(goalProfileList == null) {
                goalProfileList = new List<SelectOption>();             
            }
            return goalProfileList;
        }
        set;
    }
    
    /*
      property to store Present and Future value of a given Goal
    */
    public List<List<DataEntrySummaryBean>> getPresentFutureValueList 
    {
        get {
            //Previous code: 
            //Integer listSize = summaryBeanIndexList.get(0).get(0).fieldList.size(), indexStart;
            /** Eternus Solutions       **/
          /** Author  : Manasi Ranade **/
          /** Issue Id: FS0124        **/
          /** Date    : 25/08/2011   **/
          /** Purpose : Before fetching list values checked null condition and size of the list
          /****************************************************/
            Integer listSize =0, indexStart;
            if(summaryBeanIndexList != null &&  summaryBeanIndexList.size() > 0 &&  summaryBeanIndexList.get(0) != null &&
              summaryBeanIndexList.get(0).size() > 0 && summaryBeanIndexList.get(0).get(0) != null && summaryBeanIndexList.get(0).get(0).fieldList != null)
            {
              listSize = summaryBeanIndexList.get(0).get(0).fieldList.size();
            }
          for(List<DataEntrySummaryBean> summaryBeanList : summaryBeanIndexList) 
            {
                for(DataEntrySummaryBean summaryBean : summaryBeanList) 
                {
                    indexStart = summaryBean.fieldList.size();
                    if(indexStart < listSize && indexStart != 0) {           
                        for(Integer index = indexStart; index < listSize;index+=2) 
                        {
                          if(summaryBean != null)
                          {
                              summaryBean.fieldList.add(0,0);
                          summaryBean.fieldList.add(0,0);
                          }
                        }
                }
            }
        }
      system.debug('*********summaryBeanIndexList*********'+summaryBeanIndexList);
      return summaryBeanIndexList;
    }   
} 
     
    /*
      keep SIP details.
    */ 
    public List<SIPBean> getSIPDetails 
    {
        get 
        {
            return sipBeanList;
        }
    }
    // helper Map to maintain index of each object based on year
    Map<Integer,Integer> indexMap = new Map<Integer,Integer>();  
    List<List<DataEntrySummaryBean>> summaryBeanIndexList = new List<List<DataEntrySummaryBean>>();
    List<SIPBean> sipBeanList = new List<SIPBean>();        
                   
    /*
      This method is being called from Service class to populate SIP,FV and PV values in the respective properties.
    */               
    public void populatePresentFutureValueAndSIP(Integer goalStartYear, Integer goalEndYear, GoalFinancialDataBean financialDataBean, Boolean flag) 
    {
        DataEntrySummaryBean summaryBeanObj;
        SIPBean sipBean,sipBeanForPV;  
        
        System.debug('-----------financialDataBean----------'+financialDataBean);
        System.debug('-----------indexMap--------------'+indexMap);
              
        if(flag)
        {
            summaryBeanObj = summaryBeanIndexList.get(indexMap.get(financialDataBean.financialYear)).get(0); 
            summaryBeanObj.fieldList.add(financialDataBean.goalPV);
            summaryBeanObj.fieldList.add(financialDataBean.futureValue);
            
            if((retirementYear == null) || ( financialDataBean.financialYear < retirementYear ))
            {
              sipBean = sipBeanList.get(indexMap.get(financialDataBean.financialYear));
              //error.debugLog('------------------------financialDataBean.financialYear------------------'+financialDataBean.financialYear);
              //error.debugLog('------------------------sipBean------------------'+sipBean);
              
            sipBean.equityAmount = sipBean.equityAmount + (financialDataBean.pmt * (financialDataBean.goalProfile.Equity_Allocation__c /100));
              goalSIPAmountList.get(indexMap.get(financialDataBean.financialYear)).SIP_Equity__c = sipBean.equityAmount;
              
              
              //error.debugLog('****sipBean.equityAmount*down**'+sipBean.equityAmount);
              sipBean.debt = sipBean.debt + (financialDataBean.pmt * (financialDataBean.goalProfile.Debt_Allocation__c /100));
              goalSIPAmountList.get(indexMap.get(financialDataBean.financialYear)).SIP_Debt__c = sipBean.debt;
              
              //error.debugLog('****sipBean.debt*down**'+sipBean.debt);
              
              
              sipBean.gold = sipBean.gold + (financialDataBean.pmt * (financialDataBean.goalProfile.Gold_Allocation__c /100));
              goalSIPAmountList.get(indexMap.get(financialDataBean.financialYear)).SIP_gold__c = sipBean.gold;
              
              //error.debugLog('****sipBean.gold*down**'+sipBean.gold);
              //
              /*goalSIPAmountList.get(indexMap.get(financialDataBean.financialYear)).SIP_Equity__c = sipBean.equityAmount =199;
              goalSIPAmountList.get(indexMap.get(financialDataBean.financialYear)).SIP_Debt__c = sipBean.debt = 199;
              goalSIPAmountList.get(indexMap.get(financialDataBean.financialYear)).SIP_gold__c = sipBean.gold = 199;
              */
              //error.debugLog('****financialDataBean.pmt*'+financialDataBean.pmt);
              //error.debugLog('****sipBean.totalValue*up**'+sipBean.totalValue);
              sipBean.totalValue = sipBean.totalValue + financialDataBean.pmt;
              //error.debugLog('****sipBean.totalValue*down**'+sipBean.totalValue);
          }
        }
        //error.debugLog('---------------goalPVActualSumMap before----------------'+goalPVActualSumMap);
        goalPVActualSumMap.put(financialDataBean.financialYear, goalPVActualSumMap.get(financialDataBean.financialYear) + financialDataBean.goalPVActual);    
        //error.debugLog('---------------goalPVActualSumMap after----------------'+goalPVActualSumMap);
        //if((retirementYear == null) || ( financialDataBean.financialYear < retirementYear )) {
        sipBeanForPV =  goalPVSIPCalculationList.get(indexMap.get(financialDataBean.financialYear));
        sipBeanForPV.equityAmount = sipBeanForPV.equityAmount + (financialDataBean.futureValueActual * (financialDataBean.goalProfile.Equity_Allocation__c /100));
        sipBeanForPV.debt = sipBeanForPV.debt + (financialDataBean.futureValueActual * (financialDataBean.goalProfile.Debt_Allocation__c /100));
        sipBeanForPV.gold = sipBeanForPV.gold + (financialDataBean.futureValueActual * (financialDataBean.goalProfile.Gold_Allocation__c /100));
        sipBeanForPV.totalValue = sipBeanForPV.totalValue + financialDataBean.futureValueActual;
    }
    
    public void populatePresentFutureValueAndSIPForLiquidate(Integer goalStartYear,Integer goalEndYear, GoalFinancialDataBean financialDataBean,Boolean flag) 
    {
        DataEntrySummaryBean summaryBeanObj;
        SIPBean sipBean,sipBeanForPV;
        
        if(flag)
        {
            summaryBeanObj = summaryBeanIndexList.get(indexMap.get(financialDataBean.financialYear)).get(0); 
            //Commented for Liquidate
            summaryBeanObj.fieldList.add(financialDataBean.goalPV);
            summaryBeanObj.fieldList.add(financialDataBean.futureValue);                                        
            if((retirementYear == null) || ( financialDataBean.financialYear < retirementYear )) 
            {
              //error.debugLog('-------financialDataBean.financialYear---------->'+financialDataBean.financialYear);
              sipBean = sipBeanList.get(indexMap.get(financialDataBean.financialYear));       
              goalSIPAmountList.get(indexMap.get(financialDataBean.financialYear)).SIP_Equity__c = sipBean.equityAmount = sipBean.equityAmount + (financialDataBean.pmt * (financialDataBean.goalProfile.Equity_Allocation__c /100));
              goalSIPAmountList.get(indexMap.get(financialDataBean.financialYear)).SIP_Debt__c = sipBean.debt = sipBean.debt + (financialDataBean.pmt * (financialDataBean.goalProfile.Debt_Allocation__c /100));
              goalSIPAmountList.get(indexMap.get(financialDataBean.financialYear)).SIP_gold__c = sipBean.gold = sipBean.gold + (financialDataBean.pmt * (financialDataBean.goalProfile.Gold_Allocation__c /100));                                        
              sipBean.totalValue = sipBean.totalValue + financialDataBean.pmt;
              //error.debugLog('-------sipBean.totalValue---------->'+sipBean.totalValue);
            }
        }
        
        //Previous code
        //goalPVActualSumMap.put(financialDataBean.financialYear,goalPVActualSumMap.get(financialDataBean.financialYear)+ financialDataBean.goalPVActual);
        //Commented financialDataBean.goalPVActual from addition section.As it was showing the double value. 
        goalPVActualSumMap.put(financialDataBean.financialYear,goalPVActualSumMap.get(financialDataBean.financialYear));//+ financialDataBean.goalPVActual);
        //if((retirementYear == null) || ( financialDataBean.financialYear < retirementYear )) {
      sipBeanForPV =  goalPVSIPCalculationList.get(indexMap.get(financialDataBean.financialYear));
      sipBeanForPV.equityAmount = sipBeanForPV.equityAmount + (financialDataBean.futureValueActual * (financialDataBean.goalProfile.Equity_Allocation__c /100));
      sipBeanForPV.debt = sipBeanForPV.debt + (financialDataBean.futureValueActual * (financialDataBean.goalProfile.Debt_Allocation__c /100));
      sipBeanForPV.gold = sipBeanForPV.gold + (financialDataBean.futureValueActual * (financialDataBean.goalProfile.Gold_Allocation__c /100));                                                                                                                            
        sipBeanForPV.totalValue = sipBeanForPV.totalValue + financialDataBean.futureValueActual;
      //}
    }
    
    
    /*
      This is to show associated assets on Output page
    */
    public List<GoalAssetMappingBean> goalAssetMappingBeanList 
    {
        get 
        {
            if(goalAssetMappingBeanList == null) 
            {
                goalAssetMappingBeanList = new List<GoalAssetMappingBean>();
          }   
            return goalAssetMappingBeanList;
        }
        set;                    
    } 
    
    /** Eternus Solutions         **/
  /** Author  : Mahesh Hirugade  **/
  /** Issue Id: 00001614        **/
  /** Date    : 09/05/2012     **/
  /** Purpose : Added new parameter "newDescription" to populateGoalAseetMapping()
  /****************************************************/
    // To populate associated assets in the Bean
    public GoalAssetMappingBean populateGoalAseetMapping(Object obj,String id,String description,String name , 
                                                            Double allocatedAmount, Double growthRate ,Integer startYear,
                                                            Integer endYear,String action,String assetAssociationType,
                                                            Double goalYearValue,Double growthRateInAnnualContribution,
                                                            Double annualContribution, Double maturityAmount, String newDescription, 
                                                            Double allocatedPercent, Double maturityValue, /* Prajakta - FP changes - 14-03-2013 */
                                                            Decimal allocationOrder)/*Anupam -FP changes  Add new parameter AllocationOrder */
    {
      GoalAssetMappingBean mappingBean = new GoalAssetMappingBean();
        mappingBean.id = id;
        mappingBean.description = description;
        mappingBean.entityName = name;
        mappingBean.allocatedAmount = allocatedAmount;
        mappingBean.growthRate = growthRate;
        mappingBean.endYear = endYear;
        mappingBean.startYear = startYear;
        mappingBean.action = action;
        mappingBean.assetAssociationType = assetAssociationType;
        mappingBean.assetObj = obj;
        mappingBean.goalYearValue = goalYearValue;
        mappingBean.growthRateInAnnualContribution = growthRateInAnnualContribution;
        mappingBean.annualContribution = annualContribution;
        mappingBean.maturityAmount = maturityAmount;
        mappingBean.newDescription = newDescription;
        mappingBean.allocatedPercent = allocatedPercent;
        mappingBean.maturityValue = maturityValue;   /* Prajakta - FP changes - 14-03-2013 */
        //error.debugLog('-------mappingBean.maturityValue---------'+mappingBean.maturityValue);
        mappingBean.allocationOrder = Integer.valueOf(allocationOrder);
        
        if(goalAssetMappingBeanList.isEmpty()) 
        {
            goalAssetMappingBeanList.add(mappingBean);
        }
        else
        {
          Integer i;
          for(i = 0 ; i < goalAssetMappingBeanList.size() ; i++)
          {
            Integer currentOrderOfTopRecord = goalAssetMappingBeanList[i].allocationOrder;
            if(mappingBean.allocationOrder < currentOrderOfTopRecord)
            {
              break;
            }
          }
          if(i < goalAssetMappingBeanList.size())
          {
            goalAssetMappingBeanList.add(i, mappingBean);
          }
          else
            goalAssetMappingBeanList.add(mappingBean);
        }
        /*else 
        {
            if(Allocation_Action__c.getInstance('Action1').Action__c.equalsIgnoreCase(action)){ // To be grown till maturity and continue saving
                goalAssetMappingBeanList.add(0,mappingBean);                
            } else if (Allocation_Action__c.getInstance('Action2').Action__c.equalsIgnoreCase(action)) { // To be grown till maturity and stop saving
                goalAssetMappingBeanList.add(0,mappingBean);
            } else if (Allocation_Action__c.getInstance('Action3').Action__c.equalsIgnoreCase(action)) { // Liquidate Align to Goal
                goalAssetMappingBeanList.add(mappingBean);
            } else { // Liquidate (Sell) , Hold and Sell
                goalAssetMappingBeanList.add(mappingBean);
            }
        }   */
         
    System.debug('--------------------goalAssetMappingBeanList----'+goalAssetMappingBeanList.size());      
        return mappingBean;
    }  
    
      
    /*
      Goal can be spanned to multiple years.
      Goal detail bean is keeping information about all possible target goal years from current year.
    */ 
    public GoalDetailBean populateGoalDetailBeanList(Integer goalStartYear,Integer goalEndYear,Double targetAmount,Double targetAmountActual,Boolean flag) 
    {   //Commented on : 20/3/13 : View State problem
        //GoalDetailBean detailBean = new GoalDetailBean(this);
        GoalDetailBean detailBean = new GoalDetailBean();
        
        detailBean.goalStartYear = goalStartYear;
        detailBean.goalEndYear = goalEndYear;       
        detailBean.targetAmount = targetAmount;
        detailBean.targetAmountActual = targetAmountActual;
        cashInflowSum = cashInflowSum + targetAmountActual;
        
        if(flag)
        {
            headerList.add(detailBean.goalEndYear + 'PV');
            headerList.add(detailBean.goalEndYear + 'FV');
        }
        
        goalDetailBeanList.add(detailBean);
        //error.debugLog('---------------------goalDetailBeanList.size()---------------'+goalDetailBeanList.size());
        //error.debugLog('---------------------goalDetailBeanList--------------'+goalDetailBeanList);
        return detailBean;
    }
    
    public GoalDetailBean populateGoalDetailBeanList(Integer goalStartYear,Integer goalEndYear,Double targetAmount,Double targetAmountActual,Boolean flag,GoalDetailBean detailBean1) 
    {
        //GoalDetailBean detailBean1 = new GoalDetailBean(this);
        detailBean1.goalStartYear = goalStartYear;
        detailBean1.goalEndYear = goalEndYear;
        detailBean1.targetAmount = targetAmount;
        detailBean1.targetAmountActual = targetAmountActual;
        cashInflowSum = cashInflowSum + targetAmountActual;
        
        if(flag) 
        {
            headerList.add(detailBean1.goalEndYear + 'PV');
            headerList.add(detailBean1.goalEndYear + 'FV');
        }
        
        //goalDetailBeanList.add(detailBean1);
        return detailBean1;
    }
    
    public List<GoalDetailBean> goalDetailBeanList 
    {
        get 
        {
            if(goalDetailBeanList == null) {
                goalDetailBeanList = new List<GoalDetailBean>();
            }
            return goalDetailBeanList;
        }
        set;
    }
    
    // This is overloaded property to have proper GUI display on Output page
    public List<List<GoalDetailBean>> goalDetailBeanListForOutput 
    {
        get 
        {
            List<GoalDetailBean> tempGoalDetailBeanList = new List<GoalDetailBean>();               
            
            if( goalDetailBeanListForOutput == null ){
                goalDetailBeanListForOutput = new List<List<GoalDetailBean>>();
            }
            if(goalDetailBeanList.size() <= 8) {
                goalDetailBeanListForOutput.add(goalDetailBeanList);
                
            } else {
                for(GoalDetailBean detailBean : goalDetailBeanList) {
                    if( Math.mod(tempGoalDetailBeanList.size(),8)==0 ) {
                        tempGoalDetailBeanList = new List<GoalDetailBean>();
                        goalDetailBeanListForOutput.add(tempGoalDetailBeanList);
                    }
                    tempGoalDetailBeanList.add(detailBean);
                }   
            }
            return goalDetailBeanListForOutput;
        }
        set;
    }
    
    //To get  SIP amount for Current year
     public GoalSIPAmount__c currentSIP
     {
        get
        {
            if(currentSIP == null)
            {
              if(goalSIPAmountList != null && goalSIPAmountList.size() > 0)
                 currentSIP = goalSIPAmountList.get(0);
            }
            return currentSIP;
        }
        set;
    }
    
    
    /*
      Goal Detail bean is holding current year and Target goal year, amount and original amount.
    */
    public class GoalDetailBean 
    {
      //Commented on : 20/3/13 : View State problem
       //public GoalMappingBean parent;
        public Integer goalStartYear { get;set;}
        public Integer goalEndYear { get; set;}
        public Double targetAmount { get;set;}
        public Double targetAmountActual { get;set;}
        
        public List<GoalFinancialDataBean> goalFinancialDataBeanList 
        {
            get 
            {
                if(goalFinancialDataBeanList == null)
                {
                    goalFinancialDataBeanList = new List<GoalFinancialDataBean>();
                }
                return goalFinancialDataBeanList;
            }
            set;
        }
        //Commented on : 20/3/13 : View State problem
       /* public GoalDetailBean(GoalMappingBean parent) 
        {
            this.parent = parent;
        }
        */
        public GoalDetailBean() 
        {
           
        }
        public GoalFinancialDataBean populate( Double presentValue , Double futureValue , Double goalPV , Double pmt , 
                                    Integer financialYear , Goal_Profile__c goalProfile,Double futureValueActual,
                                    Double presentValueActual,Double pmtAmountActual)
        {
            GoalFinancialDataBean dataBean = new GoalFinancialDataBean();
            dataBean.presentValue = presentValue;
            dataBean.futureValue = futureValue;
            dataBean.goalPV = goalPV;
            dataBean.pmt = pmt;
            dataBean.financialYear = financialYear;
            dataBean.goalProfile = goalProfile;
            dataBean.futureValueActual  = futureValueActual;
            dataBean.presentValueActual = presentValueActual;
            dataBean.pmtActual = pmtAmountActual;                                                                                                                                                                                                                                                                                                                                                                                                   
            goalFinancialDataBeanList.add(dataBean);
            //parent.populatePresentFutureValueAndSIP(this.goalStartYear,this.goalEndYear,dataBean);
            return dataBean;
        }
    }
    
    
    /* To store SIP equity, debt and gold amount.
    */
    public class SIPBean 
    {
        public Integer financialYear { get;set;}
        public Double equityAmount 
        {
            get 
            {
                return (equityAmount == (Double)null ? 0: equityAmount);
            } 
            set;
        }
        public Double debt 
        {
            get 
            {
                return (debt == (Double)null ? 0: debt);                            
            }
            set;
        }
        public Double gold 
        { 
          get 
          {
                return (gold == (Double)null ? 0: gold);
          }                                
            set;
        }
        public Double totalValue 
        {
          get 
          {
                return (totalValue == (Double)null ? 0: totalValue);
          }
            set;
        }           
    }
    
    
    /*  
      Helper class which is being used for Goal amount Calculation 
    */
    public class GoalFinancialDataBean 
    {
        public Double presentValue {get; set;}
        public Double futureValue {get; set;}
        public Double goalPV {get; set;}
        
        public Double pmt { get;set;}
        public Integer financialYear;
        public Goal_Profile__c goalProfile { get; set;}
        
        public Double presentValueActual {  get; set;}
        public Double futureValueActual {  get; set;}
        public Double goalPVActual {  get; set;}        
        public Double pmtActual { get;set;}
        
    }
    
    /** Eternus Solutions         **/
  /** Author  : Mahesh Hirugade  **/
  /** Issue Id: 00001614        **/
  /** Date    : 09/05/2012     **/
  /** Purpose : Added new property "newDescription" to GoalAssetMappingBean inner class
  /****************************************************/
    /*
      To store Goal Asset association and other related data.
  */     
    public class GoalAssetMappingBean 
    {
        public Object assetObj {get; set;}
        public String description 
        { 
            get {
                if(description == null) {
                    description = '';   
                }
                return description;
            }               
            set;
        }
        public String id { get;set;}
        public String entityName {get;set;}
        public Double allocatedAmount { get;set;}
        public String assetAssociationType { get;set;} // This field is to differentiate Asset, Investment Asset and Insurance
        public Double growthRate { get;set;}
        public Double goalYearValue {get;set;}
        public String action {get;set;}
        public Integer startYear {get;set;}
        public Integer endYear {get;set;}
        public Double remainingAmount { get;set;}
        public Double growthRateInAnnualContribution {get;set;}
        public Double annualContribution {get;set;}
        public Double  maturityAmount{get;set;}
        public String newDescription{get;set;}/** Issue Id: 00001614 **/
        //Below : Created by Gaurav
        public Double allocatedPercent{get;set;}
        public Double maturityValue{get;set;}    /* Prajakta - FP changes - 14-03-2013 */
        public Integer allocationOrder {get;set;}
    }
    
    /**
    For chart generation
    */
    
    public String chartData
    {
    get
    {
       system.debug('******sipStartYear****ff*****'+goalObj.SIP_Start_Year__c);
       //error.debugLog('******sipStartYear****ff*****'+goalObj.SIP_Start_Year__c);
       
       /* Prajakta - 10-09-2013 - To resolve list index out of bound error */
       
       Integer currentYear = system.today().year();
       
       if(goalObj.SIP_Start_Year__c != null)
       {
         if(Integer.valueOf(goalObj.SIP_Start_Year__c) != date.today().year())
           currentYear = Integer.valueOf(goalObj.SIP_Start_Year__c);
       }
           
         Integer yearDifference = 0; 
         remainingYear = 0;
         Integer chartEndYear = 0;
         String tableWidht = '';
         chartData1 = '';
      /*if(!goalObj.goal_type__c.equals('Retirement') ) 
      {
        system.debug('******in if*********');
        tableWidht = '700x200';
        if((retirementYear!=NULL) && retirementYear < goalEndYear)
        {
          system.debug('******in if*** if******');
          yearDifference  = retirementYear - currentYear;
          chartEndYear = retirementYear ;
        }
        else
        {
          system.debug('******in if***else******');
          yearDifference  = goalEndYear - currentYear;
          chartEndYear = goalEndYear ;
                }
      }
      else 
      {
        system.debug('******in else*********');
        tableWidht = '500x200';
        yearDifference  = goalEndYear - currentYear;
        chartEndYear = goalEndYear ;
      }*/
      /*
        Updated By : Aditi Satpute
        Updated At : 04-June-2013
        Summary    : Issue related to SIP chart not displaying properly for Retirement Goal
      */
      system.debug('******retirementYear********'+retirementYear);
      system.debug('******goalEndYear********'+goalEndYear);
      
      if(goalObj.goal_type__c.equals('Retirement') ) 
      {
        system.debug('******in rretirement if*********');
        tableWidht = '700x200';
        if((retirementYear!=NULL) && retirementYear < goalEndYear)
        {
          system.debug('******in retirement if*** if******');
          yearDifference  = retirementYear - currentYear;
          chartEndYear = retirementYear ;
        }
        
      }
      else 
      {
        system.debug('******in else*********');
        tableWidht = '500x200';
        if((retirementYear!=NULL) && retirementYear < goalEndYear)
        {
          system.debug('******in else*** if******');
          yearDifference  = retirementYear - currentYear;
          chartEndYear = retirementYear ;
        }
        else
        {
          system.debug('******in else*** else******');
          yearDifference  = goalEndYear - currentYear;
          chartEndYear = goalEndYear ;
        }
      }
      
      
      system.debug('******goalEndYear********'+goalEndYear);
        system.debug('******currentYear********'+currentYear);
      
      system.debug('******yearDifference********'+yearDifference);
      system.debug('******chartEndYear********'+chartEndYear);
      
      
             /* Integer chartWidth = 0;
              
              if(yearDifference >= 6){
                  chartWidth = yearDifference * 15  + 100;
              }if(yearDifference == 1 || yearDifference == 0){
                  chartWidth = 500;
              }else{
                  chartWidth = yearDifference * 20  + 200;                  
              }
              
              if(chartWidth >= 750){
                  chartWidth = 720;
              } 
              if(chartWidth <= 300){
                  chartWidth = 500;
              }
              System.debug('---------------chartWidth ----------' + chartWidth);*/
              String chartPath = 'http://chart.apis.google.com/chart?cht=bvs&chs='+tableWidht+'&chco=458B00,6495ED,CD9B1D';
              system.debug('********minValue**********'+minValue);
              system.debug('********maxValue**********'+maxValue);
             
              double incrementFactor = getIncrementFactor();
              system.debug('********incrementFactor**********'+incrementFactor);
              Integer firstChartYears = 0;
              /** Added on 26/7/2013 : Aditi/Gaurav -  If difference between Current year and Retirement
                  Start year or any Goals Start Year is greater than 25 yreas, then SIP chart was not visible **/
              if(yearDifference > Integer.ValueOF(Label.No_of_Years_for_SIP_Chart))
              {
                   firstChartYears = yearDifference/2;
                  isRemainingYear = true;
                 remainingYear = yearDifference - Integer.ValueOF(firstChartYears);
                 
                 chartPath = chartPath + '&chxt=x,y&chf=bg,s,F0F0F0&chxr=1,'+minValue+','+maxValue+','+incrementFactor +'&chds='+minValue+','+maxValue;  
                 //chartData = chartPath +  getChartInfo(580,Integer.ValueOF(firstChartYears),chartEndYear-remainingYear);
                 chartData = chartPath +  getChartInfo(580,yearDifference,chartEndYear-remainingYear);
                 system.debug('********chartData**********'+chartData);
                 chartData1 = chartPath +  getChartInfo(580,yearDifference,chartEndYear);
                 system.debug('********chartData1**********'+chartData1);
                 system.debug('*****in if*****isRemainingYear**'+isRemainingYear);
              }
              else{
                
                isRemainingYear = false;
                system.debug('*****in else*****isRemainingYear**'+isRemainingYear);
                chartPath = chartPath + '&chxt=x,y&chf=bg,s,F0F0F0&chxr=1,'+minValue+','+maxValue+','+incrementFactor +'&chds='+minValue+','+maxValue;  
                chartData = chartPath +  getChartInfo(580,yearDifference,chartEndYear);
              }
               system.debug('********isRemainingYear**********'+isRemainingYear);
              return ChartData;
        } 
        set;
    }
  
    
    
    public double getIncrementFactor()
    {
       if(minValue<0)
       {
           minValue=minValue*(-1);
       }
        
       if(minValue == MaxValue) 
       {
            minValue = 0;
       }
       
       double value=0;
       value=(maxValue-minValue)/10;
       
       return Math.roundToLong(value);
      
   }
   
   /*
       Function which returns chartPath for the ChartData
   
   */
   Integer yearCount = 0;
   private String getChartInfo(Integer chartWidth,Integer yearDifference, Integer chartEndYear)
   {
         list<ChartDataItem> items=new list<ChartDataItem>();
         String chd = ''; 
         String chl = '';
         String result = '';
         
         if(goalSIPAmountList != null && goalSIPAmountList.size() > 0)
         {
           List<GoalSIPAmount__c> sipDetails = goalSIPAmountList;
           
           system.debug('***sipDetails.size()**************'+sipDetails.size());
           system.debug('******sipStartYear*********'+sipStartYear);
            system.debug('***yearDifference*******'+yearDifference);
          // for(GoalSIPAmount__c obj:sipDetails)
           for(;yearCount < yearDifference;yearCount++ )
           {
               system.debug('****yearCount*****************'+yearCount);
               GoalSIPAmount__c obj = sipDetails[yearCount];
               system.debug('*****obj*****************'+obj);
               if(obj.goal_year__c > chartEndYear)
                   break;
               //error.debugLog('******obj.SIP_Equity__c*****'+obj.SIP_Equity__c);
              // error.debugLog('******obj.SIP_Equity__c.doubleValue()*****'+obj.SIP_Equity__c.doubleValue());    
              /* items.add(new ChartDataItem(obj.Goal_Year__c.intValue()
                              ,Math.roundToLong(obj.SIP_Equity__c.doubleValue()) 
                                             ,Math.roundToLong(obj.SIP_Gold__c.doubleValue())
                                             ,Math.roundToLong(obj.SIP_Debt__c.doubleValue())));*/
                /**
                  Updated by : Aditi Satpute
                  Date : 19/6/13
                  Purpose : Removed Round as SIP chart was not displaying proper Year wise SIP total.
                **/
                 system.debug('********obj.Goal_Year__c.intValue()********'+obj.Goal_Year__c.intValue());
                 items.add(new ChartDataItem(obj.Goal_Year__c.intValue()
                              ,obj.SIP_Equity__c.doubleValue() 
                                             ,obj.SIP_Gold__c.doubleValue()
                                             ,obj.SIP_Debt__c.doubleValue()));
           }
         } 
         
        Integer temp = 0,labelSeparator ;
       Integer barWidth;
         system.debug('********yearDifference********'+yearDifference);
        yearDifference = (yearDifference*2)+1;
        system.debug('********yearDifference********'+yearDifference);
    /*if(isRemainingYear)  
      barWidth = 500/remainingYear;
    else*/
          barWidth = 500/yearDifference;
        //barWidth= yearDifference/4;
        system.debug('********barWidth********'+barWidth);
        labelSeparator = (barWidth > 15 ? 2  :3); //: barWidth > 20 ? 5 : 3);
         if(items != null && items.size() > 0)
         {
           for(ChartDataItem citem : items) 
           {
               chd += citem.equity + ',';//+citem.gold+','+citem.debt+'|';
               if(Math.mod(temp,labelSeparator)==0)
               {
                   chl += citem.Name+ '|'; 
                    system.debug('********chl********'+chl);
               }
               else
               {
                   chl += '|'; 
               }
               temp++;
           } 
           chd = chd.substring(0, chd.length() -1)+'|'; 
           
           for(ChartDataItem citem : items) 
           {
               chd += citem.gold+',';
           }
           
           chd = chd.substring(0, chd.length() -1)+'|'; 
           
           for(ChartDataItem citem : items) 
           {
               chd += citem.debt+',';
           }
           //remove the last comma or pipe 
           chd = chd.substring(0, chd.length() -1); 
           chl = chl.substring(0, chl.length() -1); 
           
           system.debug('***Barwidth'+barWidth);
           system.debug('***chd'+chd);
           system.debug('***chl'+chl);
           //String total = N+N+N;
           if(yearDifference!=1)
           //result = '&chbh=a,'+barWidth + ','+barWidth+'&chdl=Equity|Gold|Debt&chd=t:' + chd + '&chl=' + chl+'&chtt='+'SIP Outflow and Portfolio Allocation'+'&chf'+ 'b0,lg,0,FFE7C6,0,76A4FB,1' + '&chdlp=' + 't';
           //result = '&chbh=a,'+barWidth + ','+barWidth+'&chdl=Equity|Gold|Debt&chd=t:' + chd +'&chm=N,FF0000,0,0:7,8,,c|N,FF0000,1,0:7,8,,c|N,FF0000,2,0:7,8,,c'+ '&chl=' + chl+'&chtt='+'SIP Outflow and Portfolio Allocation'+'&chf'+ 'b0,lg,0,FFE7C6,0,76A4FB,1' + '&chdlp=' + 't';
         
      /*
        Updated By : Kiran Patil
        Updated At : 28-May-2013
        Summary    : FP changes-part2 - issue 23 
      */
      /*
            Updated by : Aditi Satpute
           Date : 19/6/13
           Purpose : Added Round (N*0*) as SIP chart was not displaying proper Year wise SIP total.
            */
          result = '&chbh=a,'+barWidth + ','+barWidth+'&chdl=Equity|Gold|Debt&chd=t:' + chd +'&chm=N*0*,000000,-1,0:'+yearDifference+',8'+ '&chl=' + chl+'&chtt='+'SIP Outflow and Portfolio Allocation'+'&chf'+ 'b0,lg,0,FFE7C6,0,76A4FB,1' + '&chdlp=' + 't';
            //result = '&chbh=a,'+barWidth + ','+barWidth+'&chdl=Equity|Gold|Debt&chd=t:' + chd +'&chls=1|1&chem=y;s=bubble_text_small_shadow;d=bb,&chm,FF8,000;ds=0;dp=1;py=1&chm=N,000000,-1,0:7,12'+ '&chl=' + chl+'&chtt='+'SIP Outflow and Portfolio Allocation'+'&chf'+ 'b0,lg,0,FFE7C6,0,76A4FB,1' + '&chdlp=' + 't';
        } 
        //Error.debuglog('=='+result);
        //else
            // result = '&chbh=a,500,250&chdl=Equity|Gold|Debt&chd=t:' + chd + '&chl=' + chl+'&chtt='+'SIP Outflow and Portfolio Allocation'+'&chf'+ 'b0,lg,0,FFE7C6,0,76A4FB,1' + '&chdlp=' + 't'; 
         /*if(chartWidth == 500 && yearDifference <= 5){  
             result = '&chbh=15,5,10&chdl=Equity|Gold|Debt&chd=t:' + chd + '&chl=' + chl+'&chtt='+'\'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ SIP Outflow and Portfolio Allocation'+'&chf'+ 'b0,lg,0,FFE7C6,0,76A4FB,1' + '&chdlp=' + 't'; 
         }
         if(chartWidth == 500 && yearDifference >= 5){  
             result = '&chbh=15,5,10&chdl=Equity|Gold|Debt&chd=t:' + chd + '&chl=' + chl+'&chtt='+'\'++++++++++++++++++++++++++++++++++++++++++++++SIP Outflow and Portfolio Allocation'+'&chf'+ 'b0,lg,0,FFE7C6,0,76A4FB,1' + '&chdlp=' + 't'; 
         }
         if(chartWidth == 500 || yearDifference == 1){
             result = '&chbh=15,5,10&chdl=Equity|Gold|Debt&chd=t:' + chd + '&chl=' + chl+'&chtt='+'\'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++SIP Outflow and Portfolio Allocation'+'&chf'+ 'b0,lg,0,FFE7C6,0,76A4FB,1' + '&chdlp=' + 't'; 
         }
         if(chartWidth == 720){
             result = '&chbh=10,5,10&chdl=Equity|Gold|Debt&chd=t:' + chd + '&chl=' + chl+'&chtt='+'SIP Outflow and Portfolio Allocation'+'&chf'+ 'b0,lg,0,FFE7C6,0,76A4FB,1' + '&chdlp=' + 't'; 
         }else{
             result = '&chbh=10,5,10&chdl=Equity|Gold|Debt&chd=t:' + chd + '&chl=' + chl+'&chtt='+'\'+++++++++++++++++++++++++++++++++++++++SIP Outflow and Portfolio Allocation'+'&chf'+ 'b0,lg,0,FFE7C6,0,76A4FB,1' + '&chdlp=' + 't'; 
         }
         */
         
         return result;
   }
   
   public double minValue 
   {
       set;
       get 
       {
           if(goalSIPAmountList != null && goalSIPAmountList.size() > 0)
           {
              List<GoalSIPAmount__c> sipDetails = goalSIPAmountList;
              Double value = 0;
              minValue = Math.round(sipDetails.get(0).SIP_Total__c);            
              for(GoalSIPAmount__c bean:sipDetails) 
              {
                  minValue = (minValue > bean.SIP_Total__c ? Math.round(bean.SIP_Total__c) : minValue);
              }
           }
           return 0;
       }
   }
   
   public double maxValue 
   {
       set;
       get
       {
           if(goalSIPAmountList != null && goalSIPAmountList.size() > 0)
           { 
             List<GoalSIPAmount__c> sipDetails= goalSIPAmountList;
              Double value=0;
              maxValue=sipDetails.get(0).SIP_Total__c;
              for(GoalSIPAmount__c bean:sipDetails)
              {
                  maxValue = (maxValue < bean.SIP_Total__c ? Math.round(bean.SIP_Total__c) : maxValue);
              }
              return Math.roundToLong(maxValue);
           }
           return Math.roundToLong(0);
       }
   }           
   public class ChartDataItem
   { 
        public integer Name {get;set;}
        public Double equity {get;set;}
        public Double gold {get;set;}
        public Double debt {get;set;}
        
        public ChartDataItem(integer Name, double equity,double gold,double debt) 
        {
            this.Name = Name;    
            this.equity = equity; 
            this.gold= gold; 
            this.debt= debt; 
        }
   }       
}