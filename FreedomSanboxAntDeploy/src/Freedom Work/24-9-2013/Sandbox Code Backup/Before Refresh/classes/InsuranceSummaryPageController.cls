/*
  
  Revision History:
  
    Version     Version Author     Date        Comments
    1.0         --                --        Initial Draft
    2.0      Manasi         11/06/2011  1) Issue ID :F0040,F0048: Added code in showPopUp() fuction to 
                             calculate current value,maturity amount of insurance.
    2.0      Manasi         20/06/2011  2) Issue ID :F0052: If Life Insurance tab is selected then only calculate the current 
                             value of insurance.So added if condition for checking selected tab before 
                             calculating current value in showPopUp() function
  2.0      Manasi         15/12/2011  2) Issue ID :FS0345: As Tenure Of Insurance is not filled.It is throwing an exception.So check null condition before using it                  
  2.0      Aditi         29/06/2012  2) Issue ID :00001703 ,Change in function :showPopUp()  As Policy Type Of Life Insurance is not filled.It is throwing an exception.So check null condition before using it                  


*/

public class InsuranceSummaryPageController
{
    public InsuranceServices InsuranceServicesObj {get; set;}
    public InsuranceBean InsuranceBeanObj {get; set;} 
    public Insurance__c testInsurance;
    //Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
    public Boolean isDisplaySaveButton{get;set;}
    
    /*Prajakta*/
    DatabaseSOQL dbQuery{get;set;}
    public Account objAccount{get;set;}
    public String entityId {get;set;}
  
    /**
    @description constructor
   */
    public InsuranceSummaryPageController()
    {
        dbQuery = new DatabaseSOQL();
        //Code Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
        isDisplaySaveButton = true;
       
        //Create instances of Bean and Services class
        InsuranceServicesObj = new InsuranceServices();
        InsuranceBeanObj = new InsuranceBean();
     
        InsuranceBeanObj.EntityId = ApexPages.currentPage().getParameters().get('EntityId');
        InsuranceBeanObj.AccountList = InsuranceServicesObj.getRelatedEntities(InsuranceBeanObj.EntityId);
        InsuranceBeanObj.AggQueryResult = InsuranceServicesObj.getDBValues(InsuranceBeanObj.AccountList);
        
        //Get list of recordtypes for Insurance__c
        InsuranceBeanObj.RTList = InsuranceServicesObj.getInsuranceRecordTypes( InsuranceBeanObj.ObjectName );
        
        //Gets List of AccountNames
        InsuranceBeanObj.AccountNameList = InsuranceServicesObj.getAccountNames( InsuranceBeanObj.AccountList);
        InsuranceBeanObj.TotalInsurance=InsuranceServicesObj.getTotal(InsuranceBeanObj.EntityId,InsuranceBeanObj.AccountNameList);
        
        //Initialises the SummaryTableList to be displayed in the Summary table  
        InsuranceBeanObj.SummaryTableList = InsuranceServicesObj.initSummaryTableList( InsuranceBeanObj.RTList, InsuranceBeanObj.AccountNameList);
        
        //Populates the SummaryTableList to be displayed in the Summary table    
        InsuranceBeanObj.SummaryTableList = InsuranceServicesObj.populateSummaryTableList(InsuranceBeanObj.AggQueryResult,InsuranceBeanObj.SummaryTableList);
       
       //Added Code on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
        User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
        if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
        {
          isDisplaySaveButton = false;
        }
    }  
    
    /**
    showPopUp() shows InsuranceTable popup according to selected RecordType
    */
    public void showPopUp()
    {
        InsuranceBeanObj.displayPopUp = true;
        InsuranceBeanObj = InsuranceServicesObj.setRtypeFlags(InsuranceBeanObj); 
           
        //Populate DB records in InsuranceList using InsuranceServicesObj
        InsuranceBeanObj.InsuranceList = InsuranceServicesObj.getInsuranceRecords(InsuranceBeanObj.selRecordTypeId,InsuranceBeanObj.AccountList);
        
        /** Eternus Solutions       **/
        /** Author  : Manasi Ranade **/
        /** Issue Id: F0040,F0048   **/
        /** Date    : 11/06/2011   **/
        /** Purpose : Added code to calculate current value of Insurance.
        /****************************************************/
        /** Eternus Solutions      **/
        /** Author  : Manasi Ranade **/
        /** Issue Id: F0052       **/
        /** Date    : 20/06/2011   **/
        /** Purpose : If Life Insurance tab is selected then only calculate the current value of insurance.
                So added if condition for checking selected tab before calculating current value 
        /****************************************************/
        if(InsuranceBeanObj.displayLifeFields) //If Life Insurance tab is selected then only calculate the current value of insurance
        {
          CalculateMaturityAmount(InsuranceBeanObj.InsuranceList);
        } 
        
        if(InsuranceBeanObj.InsuranceList.isEmpty())
        {
            if(InsuranceBeanObj.selRecordTypeId == InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c) {
                for(Integer counter = 0; counter < 5; counter++)
                {
                    Insurance__c InsuranceTempObj = new Insurance__c();
                    InsuranceTempObj.RecordTypeId = InsuranceBeanObj.selRecordTypeId;    //Create new record of given RecordType
                    InsuranceBeanObj.InsuranceList.add(InsuranceTempObj);
                }
            }
            else if(InsuranceBeanObj.selRecordTypeId == InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c)
             {
                for(integer counter = 0; counter < 3; counter++)
                {
                    Insurance__c InsuranceTempObj = new Insurance__c();
                    InsuranceTempObj.RecordTypeId = InsuranceBeanObj.selRecordTypeId;    //Create new record of given RecordType
                    InsuranceBeanObj.InsuranceList.add(InsuranceTempObj);
                }
            }
        }   
    }
    
    public void CalculateMaturityAmount(List<Insurance__c> InsuranceList)
    {
        Double dblAnnualPremiumAmount = 0;
        /* Prajakta - FP changes - 04-03-2013 - Changed Date.Today() to Plan_Generation_Date__c*/
        entityId = System.currentPageReference().getParameters().get('EntityId');
        objAccount = dbQuery.getEntity(entityId);
        for(Insurance__c objInsurance : InsuranceList)
        {
            AssetAllocationService objAssetAllocationService = new AssetAllocationService();
         
         //dblAnnualPremiumAmount = objAssetAllocationService.GetAnnualPremiumAmount(objInsurance);
         //FS0240
         /*if(!objInsurance.Policy_Type__c.equals('Term Life') && !objInsurance.Policy_Type__c.equals('Pension Plan') &&
         !objInsurance.Policy_Type__c.equals('Children\'s') && !objInsurance.Policy_Type__c.equals('Other') )*/
         /** Eternus Solutions       **/
          /** Author  : Aditi Satpute **/
          /** Issue Id: 00001703   **/
          /** Date    : 29/06/2012   **/
          /** Purpose : Change in function :showPopUp()  As Policy Type Of Life Insurance is not filled.It is throwing an exception.So check null condition before using it in if condition.
          **/
            if(objInsurance.Policy_Type__c != null && !objInsurance.Policy_Type__c.equals('Term Life'))   
            {
                //Original Code
                //Integer totalPeriodInYears =  Date.today().year() - objInsurance.Commencement_Date__c.year();
                //Original code is replaced by following line
                //These changes are required for current value calculation : Manasi
                /** Eternus Solutions       **/
                /** Author  : Manasi Ranade **/
                /** Issue Id: FS0345        **/
                /** Date    : 15/12/2011   **/
                /** Purpose : As Tenure Of Insurance is not filled.It is throwing an exception.So check null condition before using it
                /****************************************************/
                Integer iTenureOfInsurance = 0;
                if(objInsurance.Tenure_of_Insurance__c != null)
                    iTenureOfInsurance = Integer.valueOf(objInsurance.Tenure_of_Insurance__c);
                else
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Check Tenure of Insurance of all Insurances.It should not be blank or zero.'));
             
                //B0002 To handle Null pointer Exception
                Integer iCommencementYear = 0;
                if(objInsurance.Commencement_Date__c != null)
                    iCommencementYear = objInsurance.Commencement_Date__c.year();
                else
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.FillInsuranceCommencementDate));
                system.debug('***********iCommencementYear****'+iCommencementYear);
                Integer iMaturityYear = iTenureOfInsurance + iCommencementYear;
                Integer iCurrentYearForCalculation = 0;
                system.debug('***********iMaturityYear****'+iMaturityYear);
                
                /* Prajakta - FP Changes - Added PGD value instead of Current Year - Checked for PGD not null otherwise system.today()*/
                Integer planYear = objAccount.Plan_Generation_Date__c != null ? objAccount.Plan_Generation_Date__c.year() : Date.today().year();
                if(planYear > iMaturityYear)
                    iCurrentYearForCalculation = iMaturityYear;
                else
                    iCurrentYearForCalculation = planYear;
                        
                Integer totalPeriodInYears =  iCurrentYearForCalculation - iCommencementYear;
                system.debug('***********totalPeriodInYears****'+totalPeriodInYears);
               /* Modified By  : Niket Chandane
                 Summary    : Change in the Insurance Current Amount Format
                         To hide the Decimala Places on the "InsuranceSummaryPage". 
               */
               //B0002 To handle Null pointer Exception
               //Original Code
               /*objInsurance.current_amount__C = Math.round(objAssetAllocationService.GetInsuranceAmountForPeriod(objInsurance
                                            ,totalPeriodInYears
                                        ,Double.valueOf(objInsurance.Premium_Amount_Rs__c)));*/
                Double dblPremiumAmount = 0;
                if(objInsurance.Premium_Amount_Rs__c != null)
                {
                    dblPremiumAmount = Double.valueOf(objInsurance.Premium_Amount_Rs__c);
                }
                else
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.FillInsurancePremiumAmount));
                //error.debugLog('------current_amount-------'+objInsurance+'-'+totalPeriodInYears+'-'+dblPremiumAmount);
                objInsurance.current_amount__C = Math.round(objAssetAllocationService.GetInsuranceAmountForPeriod(objInsurance, totalPeriodInYears, dblPremiumAmount));
                 system.debug('***********objInsurance.current_amount__C****'+objInsurance.current_amount__C);
                /** Eternus Solutions       **/
                /** Author  : Manasi Ranade **/
                /** Issue Id: FS0345        **/
                /** Date    : 15/12/2011   **/
                /** Purpose : As Tenure Of Insurance is not filled.It is throwing an exception.So check null condition before using it
                /****************************************************/
                iTenureOfInsurance = 0;
                if(objInsurance.Tenure_of_Insurance__c != null)
                    iTenureOfInsurance = Integer.valueOf(objInsurance.Tenure_of_Insurance__c);
                else
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Check Tenure of Insurance of all Insurances.It should not be blank or zero.'));
             
                //B0002 To handle Null pointer Exception
                //Original Code
                //Date dtEndDate = objInsurance.Commencement_Date__c;
                
                /* Prajakta - FP Changes - Added PGD value instead of Current Year */
                Date dtEndDate;
                if(objAccount.Plan_Generation_Date__c != null) 
                    dtEndDate = objAccount.Plan_Generation_Date__c;
                else
                    dtEndDate = Date.today();
                
                //Date dtEndDate = Date.today();    /*Praj*/
                if(objInsurance.Commencement_Date__c != null)
                    dtEndDate =  objInsurance.Commencement_Date__c;
                else 
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.FillInsuranceCommencementDate));
              
                dtEndDate = dtEndDate.addYears(iTenureOfInsurance);
                //Original Code
                //totalPeriodInYears =  dtEndDate.year() - objInsurance.Commencement_Date__c.year();
                totalPeriodInYears =  dtEndDate.year() - iCommencementYear;
                /*objInsurance.Maturity_Amount__c = 
                  objAssetAllocationService.GetInsuranceAmountForPeriod(objInsurance
                                                ,totalPeriodInYears
                                                ,Double.valueOf(objInsurance.Premium_Amount_Rs__c));*/
                objInsurance.Maturity_Amount__c = objAssetAllocationService.GetInsuranceAmountForPeriod(objInsurance, totalPeriodInYears, dblPremiumAmount);
                //system.debug('------objInsurance.Maturity_Amount__c------'+objInsurance.Maturity_Amount__c);
            }
            else
            {
               objInsurance.current_amount__C = 0;
               objInsurance.Maturity_Amount__c = 0;
            }
            //Insurance__c insurance,Integer totalPeriodInYears,Double dblOneInstallmentPremiumAmount)
        }
    }
    /**
    This function is called when user clicks on cancel button on popup page
    */  
    public void closePopUp()
    {
        InsuranceBeanObj.displayPopUp=false;
        InsuranceBeanObj.AggQueryResult = InsuranceServicesObj.getDBValues(InsuranceBeanObj.AccountList);
        InsuranceBeanObj.SummaryTableList = InsuranceServicesObj.initSummaryTableList( InsuranceBeanObj.RTList, InsuranceBeanObj.AccountNameList);
        InsuranceBeanObj.SummaryTableList= InsuranceServicesObj.populateSummaryTableList(InsuranceBeanObj.AggQueryResult,InsuranceBeanObj.SummaryTableList);
        InsuranceBeanObj.TotalInsurance=InsuranceServicesObj.getTotal(InsuranceBeanObj.EntityId,InsuranceBeanObj.AccountNameList);
        InsuranceBeanObj=InsuranceServicesObj.resetRtypeFlags(InsuranceBeanObj); 
    }

    /**
    addNewRow() adds a new row to the InsuranceTable 
    */
    public void addNewRow()
    {
        InsuranceBeanObj.InsuranceList = InsuranceServicesObj.addRow(InsuranceBeanObj.InsuranceList,InsuranceBeanObj.selRecordTypeId ); 
    }

    /**
    getOwnerItems() populates values of Owner picklist for InsuranceTable 
    */
    public List<SelectOption> getOwnerItems() 
    {
        List<SelectOption> options = InsuranceServicesObj.getOwnerItems(InsuranceBeanObj.AccountList);    
        System.Debug('====Owner Picklist Options===='+options);
        return options;
    }

    /**
     Save() saves records from InsuranceTable,refreshes the SummaryTable and closes the popup
   */
    public void Save() 
    {
        ApexPages.getMessages().clear();
        List<Insurance__c> insuranceobjlist = new List<Insurance__c>();
        system.debug('=======InsuranceBeanObj.InsuranceList============'+InsuranceBeanObj.InsuranceList);
        for(Insurance__c insurance : InsuranceBeanObj.InsuranceList)
        {
            system.debug('=======insurance 1============'+insurance);  
            if(!InsuranceBeanObj.isRowEmpty(insurance,InsuranceBeanObj.selrecordTypeName))
            {
                insuranceobjlist.add(insurance);
            }
        }  
         system.debug('=======insuranceobjlist 1============'+insuranceobjlist);  
        Integer flag = 0;   
        insuranceobjlist = checkOwnerChange(insuranceobjlist);
        //Added condition check on : 20/2/2013 : Aditi Satpute : General Insurance was storing Maturity Amount
                                                // and during selection of One Time Premium Error was shown for Maturity Amount.
        if(InsuranceBeanObj.selrecordTypeName != 'General Insurance')
        {
            system.debug('=======insuranceobjlist 2============'+insuranceobjlist); 
            CalculateMaturityAmount(insuranceobjlist);
            system.debug('=======insuranceobjlist==3=========='+insuranceobjlist);
        }
           
        List<Insurance__c>  lstInsurance  = new List<Insurance__c>();
        for(Insurance__c ins : insuranceobjlist)
        {
            try
            {
                InsuranceBeanObj.validate(ins);
                ins.removeCheckbox__c = false;
                ins.RecordTypeId = InsuranceBeanObj.selRecordTypeId;
                
                String strPolicyType = ins.Policy_Type__c;
                Double ROI = ins.Return_Of_Interest__c;
                if(strPolicyType != null && strPolicyType != '')
                {
                    system.debug('=======ins===if========'+ins.Policy_Type__c);
                    if(ROI == null)
                    {
                        system.debug('=======ins====ijn======='+ins.Return_Of_Interest__c);
                        if(ins.Policy_Type__c == 'Whole Life' || ins.Policy_Type__c == 'Pension Plan'
                               || ins.Policy_Type__c == 'Other' || ins.Policy_Type__c == 'Endowment')
                            ins.Return_Of_Interest__c = 6.0;
                        else if(ins.Policy_Type__c == 'Money-Back')
                            ins.Return_Of_Interest__c = 5.0;
                        else if(ins.Policy_Type__c == 'ULIP - Equity')
                            ins.Return_Of_Interest__c = 10.0;
                        else if(ins.Policy_Type__c == 'ULIP - Debt')
                            ins.Return_Of_Interest__c = 6.0;
                        else if(ins.Policy_Type__c == 'Children\'s')
                            ins.Return_Of_Interest__c = 6.0;
                        else
                            ins.Return_Of_Interest__c = 0.0;
                            
                       /* if(strPolicyType.equals(Label.Whole_Life) || strPolicyType.equals(Label.Pension_Plan)
                          || strPolicyType.equals(Label.Other) || strPolicyType.equals(Label.Children_s))
                            ROI = 6;
                        else if(strPolicyType.equals(Label.ULIP_Debt))
                            ROI = 6;
                        else if(strPolicyType.equals(Label.Money_Back))
                            ROI = 5;
                        else if(strPolicyType.equals(Label.Endowment))
                            ROI = 6;
                        else if(strPolicyType.equals(Label.ULIPEquity))
                            ROI = 10;
                        else 
                            ROI = 0;*/
                        system.debug('=======ins====ijn======='+ins.Return_Of_Interest__c);
                    }
                }
                system.debug('=======ins=====ROI======='+ins.Return_Of_Interest__c);
                system.debug('=======ins=====1======='+ins);
                //upsert ins;
                lstInsurance.add(ins);
                system.debug('=======ins======2======'+ins);
            }    
            catch(ValidationException e)
            {
                flag = 1;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
            }    
        }    
        system.debug('----------Limits.getCpuTime()-----upper---------'+Limits.getCpuTime());
        if(lstInsurance.size() > 0)
        	upsert lstInsurance;
        system.debug('----------Limits.getCpuTime()-----lower---------'+Limits.getCpuTime());	
        if(flag == 0)
        {
            InsuranceBeanObj.AggQueryResult = InsuranceServicesObj.getDBValues(InsuranceBeanObj.AccountList);
            InsuranceBeanObj.SummaryTableList = InsuranceServicesObj.initSummaryTableList( InsuranceBeanObj.RTList, InsuranceBeanObj.AccountNameList);
            InsuranceBeanObj.SummaryTableList = InsuranceServicesObj.populateSummaryTableList(InsuranceBeanObj.AggQueryResult, InsuranceBeanObj.SummaryTableList);
            InsuranceBeanObj = InsuranceServicesObj.resetRtypeFlags(InsuranceBeanObj);
            InsuranceBeanObj.TotalInsurance = InsuranceServicesObj.getTotal(InsuranceBeanObj.EntityId, InsuranceBeanObj.AccountNameList);
            InsuranceBeanObj.displayPopUp = false;      
        }
     }
     
     /**
         This function is used to check of owner of an entity is chnaged or not
         input parameters list of type insurance__c
         Returns list of type insurance__c
     */
      public list<insurance__c>checkOwnerChange(list<insurance__c> insurancePageList)
      {
         list<Insurance__c> dbRecords = InsuranceServicesObj.getInsuranceRecords(InsuranceBeanObj.selRecordTypeId,InsuranceBeanObj.AccountList);
         list<Insurance__c>ownerChangeList = new list<insurance__c>();
         list<Insurance__c> modifiedList = new list<insurance__c>();
       for(Insurance__c ins : insurancePageList)
       {
           if(ins.id != null)
           {
               for(insurance__c insdb : dbRecords)
               {
                   if(ins.id==insdb.id && ins.entity__c != insdb.entity__c)
                   {
                       insurance__c obj1 = new insurance__c();
                       obj1 = ins.clone(false);
                       modifiedList.add(obj1);
                       ownerChangeList.add(insdb);
                   }
                   else if(ins.id == insdb.id )
                      modifiedList.add(ins); 
               }
           }
           else
               modifiedList.add(ins);
         }
         
         insurancePageList = null;
         insurancePageList = modifiedList;
         InsuranceServicesObj.removeOwnerChangeList(ownerChangeList);
         return insurancePageList;
     }
     
     /**
     This function is called when user clicks on remove button
     */
     public void Remove()
     {
       InsuranceServicesObj.removeRecords(InsuranceBeanObj.InsuranceList);
     }
     
     public Insurance__c getTestInsurance()
     {
        if (testInsurance == null) testInsurance = new Insurance__c();
        return testInsurance;
     }

     public void setTestInsurance(Insurance__c value)
     {
        testInsurance = value;
     }
}