/* @Author: Sandip C
 * @Description:ApprovedPlanServices is class to prepare the data as per the business logic. 
 * This is act as service class for the ApprovedPlanController
 */
 /*
Revision History:

   Version     Version Author     Date          Comments
   1.0         Persistent         NA  		  	Initial Draft
   
   2.0		   Manasi Ranade     11/11/2011	  	Issue ID : FS0267 : Change in Class :ApprovedPlanServices :
   											    Commented original code. Displayed the Actual Current value
   												Change in function : getAssetAllocation
   2.0		   Manasi Ranade     21/12/2011	  	Issue ID : FS0290 : Change in Class :ApprovedPlanServices :
					  							Function name :upsertData: Added validation related to Amount and Action amount
   2.0		   Manasi Ranade     1/2/2012	  	Issue ID : 00001470 : Code to find out the Equity,Debt,Gold percentages
*/
public class ApprovedPlanServices{
    DatabaseSOQL dbSOQLObj {get; set;}
    DatabaseDML dbDMLObj {get; set;}
    String currentLump = Label.CurrentLumpSumRecordType;
    String currentSIP = Label.CurrentSIPRecordType;
    String suggestedLump = Label.SuggestedLumpSumRecordType;
    String suggestedSIP = Label.SuggestedSIPRecordType;
    Public ApprovedPlanServices(){
        dbSOQLObj = new DatabaseSOQL();
        dbDMLObj = new DatabaseDML();
    }
    
    /**
    * @Description: Get family details for parent entity
    * param: None 
    * return type: void
    */  
    public void getFamilyDetails(ApprovedPlanBean beanObj){
        beanObj.accList = dbSOQLObj.getFamilyDetails(beanObj.entityId);
    }
    
    /**
    * @Description: Get Asset Allocation Details
    * param: ApprovedPlanBean
    * return type: void
    */ 
    public void getAssetAllocation(ApprovedPlanBean beanObj)
    {
        List<GoalInvestmentAssetAssociation__c> giaList = dbSOQLObj.getGoalInvestmentAssociationList(beanObj.entityId);
        List<GoalAssetAssociation__c> gaaList = dbSOQLObj.getGoalAssetAllocationList(beanObj.entityId);
        List<GoalInsuranceAssociation__c> ginaList = dbSOQLObj.getGoalInsuranceAllocationList(beanObj.entityId);
        
        Set<Id> recIds = new Set<Id>();
        Map<String,Double> Assetperc = new Map<String,Double>();
        
        for(GoalAssetAssociation__c gaObj: gaaList){
            //recIds.add(gaObj.asset__r.RecordTypeId);
            if(Assetperc.get(gaObj.asset__c)!=null){
                Assetperc.put(gaObj.asset__c, Assetperc.get(gaObj.asset__c)+gaObj.allocated__c);
            }else{
                Assetperc.put(gaObj.asset__c, gaObj.allocated__c);
            }
        }
        
        for(GoalInvestmentAssetAssociation__c giObj: giaList){
            //recIds.add(giObj.Investment_asset__r.RecordTypeId);
            if(Assetperc.get(giObj.Investment_asset__c)!=null){
                Assetperc.put(giObj.Investment_asset__c, Assetperc.get(giObj.Investment_asset__c)+giObj.allocated__c);
            }else{
                Assetperc.put(giObj.Investment_asset__c, giObj.allocated__c);
            }
        }
        
        for(GoalInsuranceAssociation__c ginObj: ginaList){
           // recIds.add(ginObj.Insurance__r.RecordTypeId);
            if(Assetperc.get(ginObj.Insurance__c)!=null){
                Assetperc.put(ginObj.Insurance__c, Assetperc.get(ginObj.Insurance__c)+ginObj.allocated__c);
            }else{
                Assetperc.put(ginObj.Insurance__c, ginObj.allocated__c);
            }
        }
        
       /* List<RecordType> recList = dbSOQLObj.getRecordTypeNames(recIds);
        Map<Id,String> recMap = new Map<Id,String>();
        for(RecordType recObj: recList){
            recMap.put(recObj.Id, recObj.Name);
        }*/
        Set<String> processedId = new Set<String>();
        if(gaaList.size()>0){
            Map<String, double> golVal1 = new Map<String, double>();
           for(GoalAssetAssociation__c gaaObj: gaaList){
               golVal1.put(''+gaaObj.asset__c+gaaObj.goal__c, gaaObj.Allocated__c); 
           }
            for(GoalAssetAssociation__c gaaObj: gaaList){
                if(gaaObj.asset__r.Action__c != '---None----'){
                    if(!processedId.contains(gaaObj.asset__c)){
                        processedId.add(gaaObj.asset__c);
                        ApprovedPlanBean.SAssetAllocationBean tmpObj = new ApprovedPlanBean.SAssetAllocationBean();
                        tmpObj.entityName = gaaObj.asset__r.entity__r.FirstName +' '+gaaObj.asset__r.entity__r.LastName;
                        tmpObj.action = gaaObj.asset__r.action__c;
                        //tmpObj.Assets = gaaObj.asset__r.Asset_Types__c;
                        if(gaaObj.Asset__r.Asset_Types__c!=null && gaaObj.Asset__r.Asset_Types__c!=''){
                            tmpObj.Assets = gaaObj.Asset__r.Asset_Types__c;
                        }else{
                            tmpObj.Assets = gaaObj.Asset__r.Account_Type__c;
                        }
                        if(Assetperc.get(gaaObj.asset__c)!=null){
                            tmpObj.available = 100 - Assetperc.get(gaaObj.asset__c);
                            tmpObj.allocated = Assetperc.get(gaaObj.asset__c);
                        }else{
                            tmpObj.available = 100;
                            tmpObj.allocated = 0;
                        }
                        /** Eternus Solutions       **/
						/** Author  : Manasi Ranade **/
						/** Issue Id: FS0267      	**/
						/** Date    : 11/11/2011 	**/
						/** Purpose : Commented original code. Displayed the Actual Current value 
						/****************************************************/
                        //Original Code
                        //tmpObj.currentVal = gaaObj.asset__r.Monthly_Asset__c - gaaObj.asset__r.Allocated_Amount__c;
                        tmpObj.currentVal = gaaObj.asset__r.Monthly_Asset__c; //- gaaObj.asset__r.Allocated_Amount__c;
                        for(Goal__c golObj:beanObj.goalList){
                            if(golVal1.get(''+gaaObj.asset__c+golObj.Id)!=null){
                                tmpObj.golListVals.add(golVal1.get(''+gaaObj.asset__c+golObj.Id));
                            }else{
                                tmpObj.golListVals.add(0);
                            }
                        }
                        beanObj.aaBeanList.add(tmpObj);
                    }
                }
            }
        }
        
       if(ginaList.size()>0){
       	//Action Plan : Manasi
		/** Eternus Solutions       **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: FS0229      	**/
		/** Date    : 25/10/2011 	**/
		/** Purpose : Map required in calculation of current value of insurance
		/****************************************************/       	
       	Map<Id,Insurance__c> insuranceMap = new Map<Id,Insurance__c>();
       	insuranceMap = dbSOQLObj.getInsuranceDetails(beanObj.entityId);
           Map<String, double> golVal = new Map<String, double>();
           for(GoalInsuranceAssociation__c ginaObj: ginaList){
               golVal.put(''+ginaObj.Insurance__c+ginaObj.goal__c, ginaObj.Allocated__c); 
           }
               
            for(GoalInsuranceAssociation__c ginaObj: ginaList){
                if(ginaObj.Insurance__r.Action__c != '---None----'){
                    if(!processedId.contains(ginaObj.Insurance__c)){
                        processedId.add(ginaObj.Insurance__c);
                        ApprovedPlanBean.SAssetAllocationBean tmpObj = new ApprovedPlanBean.SAssetAllocationBean();
                        tmpObj.entityName = ginaObj.Insurance__r.entity__r.FirstName +' '+ginaObj.Insurance__r.entity__r.LastName;
                        tmpObj.action = ginaObj.Insurance__r.action__c;
                        tmpObj.Assets =ginaObj.Insurance__r.RecordType.Name;
                        
                        if(Assetperc.get(ginaObj.Insurance__c)!=null){
                            tmpObj.available = 100 - Assetperc.get(ginaObj.Insurance__c);
                            tmpObj.allocated = Assetperc.get(ginaObj.Insurance__c);
                        }else{
                            tmpObj.available = 100;
                            tmpObj.allocated = 0;
                        }
                        
                        //tmpObj.currentVal = ginaObj.Insurance__r.total_insurance__c - ginaObj.Insurance__r.Allocated_Amount__c;
                        //Previuos Code:
                        //tmpObj.currentVal = ginaObj.Insurance__r.Premium_Amount_Rs__c;
                        //Action Plan : Manasi
                        //FS0229
                        /** Eternus Solutions       **/
						/** Author  : Manasi Ranade **/
						/** Issue Id: FS0229      	**/
						/** Date    : 25/10/2011 	**/
						/** Purpose : Code to calculate current value of insurance
						/****************************************************/
                        if(insuranceMap.containsKey(ginaObj.Insurance__c))
                        {
                        	AssetAllocationService objAssetAllocationService = new AssetAllocationService();
	                		Insurance__c objInsurance =insuranceMap.get(ginaObj.Insurance__c);
	                		Double dblOneInstallmentPremiumAmount = 0;
	                		if(!objInsurance.Premium_Frequency__c.equals('One Time Premium'))
			 					dblOneInstallmentPremiumAmount = objInsurance.Premium_Amount_Rs__c;
			 				Integer iTenureOfInsurance = Integer.valueOf(objInsurance.Tenure_of_Insurance__c);
			 				Integer iMaturityYear = iTenureOfInsurance + objInsurance.Commencement_Date__c.year();
			 				Integer iCurrentYearForCalculation = 0;
			 				if(Date.today().year() > iMaturityYear)
			 					iCurrentYearForCalculation = iMaturityYear;
			 				else
			 					iCurrentYearForCalculation = Date.today().year();
			 				Integer totalPeriodInYears =  iCurrentYearForCalculation - objInsurance.Commencement_Date__c.year();//
			 				if(objInsurance.Surrender_Cash_Value__c == null)
						 		tmpObj.currentVal = objAssetAllocationService.GetInsuranceAmountForPeriod(objInsurance,totalPeriodInYears, dblOneInstallmentPremiumAmount);
						 	else
						 		tmpObj.currentVal = objInsurance.Surrender_Cash_Value__c;
						 	Double dblAllocated = tmpObj.allocated;
						 	/** Eternus Solutions       **/
							/** Author  : Manasi Ranade **/
							/** Issue Id: FS0267      	**/
							/** Date    : 11/11/2011 	**/
							/** Purpose : Commented original code.
							/****************************************************/
	                        //Original Code
						 	//tmpObj.currentVal = tmpObj.currentVal * ((100- Decimal.valueof(dblAllocated)) / 100 );
                        }
                        else
                        	tmpObj.currentVal = 0; 
                        
                        for(Goal__c golObj:beanObj.goalList){
                            if(golVal.get(''+ginaObj.Insurance__c+golObj.Id)!=null){
                                tmpObj.golListVals.add(golVal.get(''+ginaObj.Insurance__c+golObj.Id));
                            }else{
                                tmpObj.golListVals.add(0);
                            }
                        }
                        beanObj.aaBeanList.add(tmpObj);
                    }
                }
            }
        }
        
        if(giaList.size()>0){
           Map<String, double> golVal2 = new Map<String, double>();
           for(GoalInvestmentAssetAssociation__c giaObj: giaList){
               golVal2.put(''+giaObj.Investment_asset__c+giaObj.goal__c, giaObj.Allocated__c); 
           }
           
           Map<String, double> totCurrent = new Map<String, double>();
           for(GoalInvestmentAssetAssociation__c giaObj: giaList){
               if(totCurrent.get(''+giaObj.Investment_asset__r.RecordType.Name+giaObj.Investment_asset__r.Entity__c)!=null){
                   /** Eternus Solutions       **/
				   /** Author  : Manasi Ranade **/
				   /** Issue Id: FS0267      	**/
				   /** Date    : 11/11/2011 	**/
				   /** Purpose : Commented original code. Displayed the Actual Current value 
				   /****************************************************/
	               //Original Code
                   //double tmpVal1 = giaObj.Investment_asset__r.TotalAsset__c - giaObj.Investment_asset__r.Allocated_Amount__c;
                   double tmpVal1 = giaObj.Investment_asset__r.TotalAsset__c;// - giaObj.Investment_asset__r.Allocated_Amount__c;
                   tmpVal1 = tmpVal1 + totCurrent.get(''+giaObj.Investment_asset__r.RecordType.Name+giaObj.Investment_asset__r.Entity__c);
                   totCurrent.put(''+giaObj.Investment_asset__r.RecordType.Name+giaObj.Investment_asset__r.Entity__c, tmpVal1);
               }else{
                   /** Eternus Solutions       **/
				   /** Author  : Manasi Ranade **/
				   /** Issue Id: FS0267      	**/
				   /** Date    : 11/11/2011 	**/
				   /** Purpose : Commented original code. Displayed the Actual Current value 
				   /****************************************************/
	               //Original Code
                   //double tmpVal = giaObj.Investment_asset__r.TotalAsset__c - giaObj.Investment_asset__r.Allocated_Amount__c;
                   double tmpVal = giaObj.Investment_asset__r.TotalAsset__c;// - giaObj.Investment_asset__r.Allocated_Amount__c;
                   totCurrent.put(''+giaObj.Investment_asset__r.RecordType.Name+giaObj.Investment_asset__r.Entity__c, tmpVal);
               } 
           }
            
            for(GoalInvestmentAssetAssociation__c giaObj: giaList){
                if(giaObj.Investment_asset__r.Action__c != '---None----'){
                    if(!processedId.contains(''+giaObj.Investment_asset__r.RecordType.Name+giaObj.Investment_asset__r.Entity__c)){
                        processedId.add(''+giaObj.Investment_asset__r.RecordType.Name+giaObj.Investment_asset__r.Entity__c);
                        ApprovedPlanBean.SAssetAllocationBean tmpObj = new ApprovedPlanBean.SAssetAllocationBean();
                        tmpObj.entityName = giaObj.Investment_asset__r.entity__r.FirstName +' '+giaObj.Investment_asset__r.entity__r.LastName;
                        tmpObj.action = giaObj.Investment_asset__r.action__c;
                        
                        if(Assetperc.get(giaObj.Investment_asset__c)!=null){
                            tmpObj.available = 100 - Assetperc.get(giaObj.Investment_asset__c);
                            tmpObj.allocated = Assetperc.get(giaObj.Investment_asset__c);
                        }else{
                            tmpObj.available = 100;
                            tmpObj.allocated = 0;
                        }
                        tmpObj.Assets = giaObj.Investment_asset__r.RecordType.Name;
                        if(totCurrent.get(''+giaObj.Investment_asset__r.RecordType.Name +giaObj.Investment_asset__r.Entity__c)!=null){
                            tmpObj.currentVal = totCurrent.get(''+giaObj.Investment_asset__r.RecordType.Name+giaObj.Investment_asset__r.Entity__c);
                            
                        }else{
                            tmpObj.currentVal = 0;
                        }
                        
                        for(Goal__c golObj:beanObj.goalList){
                            if(golVal2.get(''+giaObj.Investment_asset__c+golObj.Id)!=null){
                                tmpObj.golListVals.add(golVal2.get(''+giaObj.Investment_asset__c+golObj.Id));
                            }else{
                                tmpObj.golListVals.add(0);
                            }
                        }
                        beanObj.aaBeanList.add(tmpObj);
                    }
                }
            }
        }
    }
    
    /**
    * @Description: Get General Insurance records which are created during the Insurence planning
    * param: List<Account>
    * return type: List<Insurance__c>
    */ 
    public List<Insurance__c> getGenerelInsurance(List<Account> accList){
        return dbSOQLObj.getAnalysisInsurances(InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c, accList);
    }
    
     /**
    * @Description: Get Life Insurance records which are created during the Insurence planning
    * param: List<Account>
    * return type: List<Insurance__c>
    */ 
    public List<Insurance__c> getLifeInsurance(List<Account> accList){
        return dbSOQLObj.getAnalysisInsurances(InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c, accList);
    }
    
     /**
    * @Description: Get Approved Life insurance records which are created on Approved plan page
    * param: ApprovedPlanBean 
    * return type: void
    */ 
    public void getApprGenerelInsurance(ApprovedPlanBean beanObj){
        beanObj.giApprovedList = dbSOQLObj.getApprovedInsurances(InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c, beanObj.accList);
        if(beanObj.giApprovedList.size()<=0){
            for(Insurance__c insObj: beanObj.giList){
                Insurance__c insTmp = new Insurance__c();
                insTmp.Flag__c = 'Approved';
                insTmp.Suggested_Cover_General_Insurance__c = insObj.Suggested_Cover_General_Insurance__c;
                insTmp.Premium_Amount_Rs__c =insObj.Premium_Amount_Rs__c;
                insTmp.Policy_Type__c = insObj.Policy_Type__c;
                insTmp.Entity__c = insObj.Entity__c;
                insTmp.Entity_Name__c = insObj.Entity__r.FirstName + ' ' + insObj.Entity__r.LastName;
                insTmp.Insurance_Company__c = insObj.Insurance_Company__c;
                insTmp.RecordTypeId = InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c;
                beanObj.giApprovedList.add(insTmp);
                beanObj.isApprovedGeneralInsExist = true;
            }
        }else{
            beanObj.isApprovedGeneralInsExist = true;
        }
    }
    
    /**
    * @Description: Get Approved Life insurance records which are created on Approved plan page
    * param: ApprovedPlanBean 
    * return type: void
    */ 
    public void getApprLifeInsurance(ApprovedPlanBean beanObj){
        beanObj.liApprovedList = dbSOQLObj.getApprovedInsurances(InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c, beanObj.accList);
        system.debug('size***'+beanObj.liApprovedList.size());
        if(beanObj.liApprovedList.size()<=0){
            system.debug('size1***');
            for(Insurance__c insObj: beanObj.liList){
                Insurance__c insTmp = new Insurance__c();
                insTmp.Flag__c = 'Approved';
                insTmp.Suggested_Cover_General_Insurance__c = insObj.Suggested_Cover_General_Insurance__c;
                insTmp.Premium_Amount_Rs__c =insObj.Premium_Amount_Rs__c;
                insTmp.Policy_Type__c = insObj.Policy_Type__c;
                insTmp.Entity__c = insObj.Entity__c;
                insTmp.Entity_Name__c = insObj.Entity__r.FirstName + ' ' + insObj.Entity__r.LastName;
                insTmp.Insurance_Company__c = insObj.Insurance_Company__c;
                insTmp.RecordTypeId = InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c;
                beanObj.liApprovedList.add(insTmp);
                beanObj.isApprovedLifeInsExist = true;
                //system.debug('size2***');
            }
        }else{
            beanObj.isApprovedLifeInsExist = true;
        }
    }
    
   /* public void saveInsurence(ApprovedPlanBean beanObj){
        dbDMLObj.upsertObject(beanObj.giList);
        dbDMLObj.upsertObject(beanObj.liList);
    }*/
    
    /**
    * @Description: Get goals for the parent entity
    * param: void
    * return type: void
    */ 
    public void getGoals(ApprovedPlanBean beanObj){
         beanObj.goalList = dbSOQLObj.getAllGoals(beanObj.entityId);
    }
    
     /**
    * @Description: Prepare current Lumpsum approved data
    * param: ApprovedPlanBean 
    * return type: void
    */ 
    public void getCurMFLumpSumApprovedPlans(ApprovedPlanBean beanObj){
         Map<Id, List<ApprovedPlanBean.Goals>> mapcurrMFLump = new Map<Id, List<ApprovedPlanBean.Goals>>();
         mapcurrMFLump = getGoalsAllocated(currentLump ,beanObj);         
         set<id> investId = new set<id>();
         for(Approved_Action_Plan__c apObj: beanObj.approvedPlanList){
             if(apObj.RecordType.Name == currentLump ){
                if(mapcurrMFLump.get(apObj.Investment_Asset__c) != null){
                    investId.add(apObj.Investment_Asset__c);
                    ApprovedPlanBean.CurrentMFLumpSum tmpObj = new ApprovedPlanBean.CurrentMFLumpSum(); 
                    
                    tmpObj.entityId = apObj.Investment_Asset__r.Entity__c;
                    tmpObj.recordId = apObj;
                    tmpObj.assetId = apObj.Investment_Asset__c;
                    tmpObj.schemeName = apObj.Investment_Asset__r.Fund__r.Scheme_Name__c; //FS0235
                    tmpObj.schemeName = apObj.Investment_Asset__r.Scheme_Name_Text__c;//FS0235
                    tmpObj.assetsClass = apObj.Investment_Asset__r.Asset_Type__c;
                    tmpObj.assetAmount = apObj.Investment_Asset__r.TotalAsset__c;
                    tmpObj.entityName = apObj.Investment_Asset__r.Entity__r.FirstName +' '+apObj.Investment_Asset__r.Entity__r.LastName;
                    tmpObj.action = apObj.Lumpsum_Action__c;
                    tmpObj.actionAmount = apObj.Amount__c;
                    //tmpObj.allocatedAmount = apObj.Allocated_Amount__c;
                    tmpObj.golCurrMFLumpSum = mapcurrMFLump.get(apObj.Investment_Asset__c);
                    mapcurrMFLump.remove(apObj.Investment_Asset__c);
                    beanObj.currentMFLumpSumList.add(tmpObj);
                }
             }
         }
         
         //if(beanObj.currentMFLumpSumList.size()<=0){
             for(Investment_Asset__c investObj: beanObj.investment){
                 if(!investId.contains(investObj.Id)){
                     ApprovedPlanBean.CurrentMFLumpSum tmpObj = new ApprovedPlanBean.CurrentMFLumpSum();
                     tmpObj.entityId = investObj.Entity__c;
                     tmpObj.assetId = investObj.Id;
                     //tmpObj.schemeName = investObj.Fund__r.Scheme_Name__c;//FS0235
                     tmpObj.schemeName = investObj.Scheme_Name_Text__c;//FS0235
                     tmpObj.assetsClass = investObj.Asset_Type__c;
                     tmpObj.assetAmount = investObj.TotalAsset__c;
                     tmpObj.entityName = investObj.Entity__r.FirstName +' '+investObj.Entity__r.LastName;
                     
                     for(Goal__c golObj:beanObj.goalList){
                         ApprovedPlanBean.Goals tmpInObj = new ApprovedPlanBean.Goals();
                         tmpInObj.goalId = golObj.Id;
                         tmpInObj.allocated = 0;
                         tmpObj.golCurrMFLumpSum.add(tmpInObj);
                     }
                     beanObj.currentMFLumpSumList.add(tmpObj);
                 }
             }
         //}
     }   
     
      /**
    * @Description: Prepare current SIP approved data
    * param: ApprovedPlanBean 
    * return type: void
    */ 
     public void getCurMFSIPApprovedPlans(ApprovedPlanBean beanObj)
     {
         Map<Id, List<ApprovedPlanBean.Goals>> mapcurrMFSIP = new Map<Id, List<ApprovedPlanBean.Goals>>();
         mapcurrMFSIP = getGoalsAllocated(currentSIP ,beanObj);         
         set<id> investId = new set<id>();       
         for(Approved_Action_Plan__c apObj: beanObj.approvedPlanList)
         {
             if(apObj.RecordType.Name == currentSIP )
             {
                if(mapcurrMFSIP.get(apObj.Investment_Asset__c) != null)
                {
                    if(apObj.Investment_Asset__r.Monthly_SIP_Amount__c!= null && apObj.Investment_Asset__r.Monthly_SIP_Amount__c!=0)
                    {
                        ApprovedPlanBean.CurrentMFSIP tmpObj = new ApprovedPlanBean.CurrentMFSIP(); 
                        investId.add(apObj.Investment_Asset__c);
                        tmpObj.entityId = apObj.Investment_Asset__r.Entity__c;
                        tmpObj.recordId = apObj;
                        tmpObj.assetId = apObj.Investment_Asset__c;
                        //tmpObj.schemeName = apObj.Investment_Asset__r.Fund__r.Scheme_Name__c;//FS0235
                        tmpObj.schemeName = apObj.Investment_Asset__r.Scheme_Name_Text__c;//FS0235
                        tmpObj.assetsClass = apObj.Investment_Asset__r.Asset_Type__c;
                        tmpObj.currentSIP = apObj.Investment_Asset__r.Monthly_SIP_Amount__c;
                        tmpObj.entityName = apObj.Investment_Asset__r.Entity__r.FirstName +' '+apObj.Investment_Asset__r.Entity__r.LastName;
                        tmpObj.SIPAction = apObj.SIP_Action__c;
                        tmpObj.SIPChange = apObj.Amount__c;
                        //tmpObj.allocatedAmount = apObj.Allocated_Amount__c;
                        tmpObj.golCurrMFSIP = mapcurrMFSIP.get(apObj.Investment_Asset__c);
                        mapcurrMFSIP.remove(apObj.Investment_Asset__c);
                        beanObj.currentMFSIPList.add(tmpObj);
                    }
                }
             }
         }
         
         //if(beanObj.currentMFSIPList.size()<=0){
             for(Investment_Asset__c investObj: beanObj.investment){
                 if(!investId.contains(investObj.Id)){
                     if(investObj.Monthly_SIP_Amount__c!=null && investObj.Monthly_SIP_Amount__c != 0){
                         ApprovedPlanBean.CurrentMFSIP tmpObj = new ApprovedPlanBean.CurrentMFSIP();
                         tmpObj.entityId = investObj.Entity__c;
                         tmpObj.assetId = investObj.Id;
                         //tmpObj.schemeName = investObj.Fund__r.Scheme_Name__c;//FS0235
                         tmpObj.schemeName = investObj.Scheme_Name_Text__c;//FS0235
                         tmpObj.assetsClass = investObj.Asset_Type__c;
                         tmpObj.currentSIP = investObj.Monthly_SIP_Amount__c;
                         tmpObj.entityName = investObj.Entity__r.FirstName +' '+investObj.Entity__r.LastName;
                         
                         for(Goal__c golObj:beanObj.goalList){
                             ApprovedPlanBean.Goals tmpInObj = new ApprovedPlanBean.Goals();
                             tmpInObj.goalId = golObj.Id;
                             tmpInObj.allocated = 0;
                             tmpObj.golCurrMFSIP.add(tmpInObj);
                         }
                         beanObj.currentMFSIPList.add(tmpObj);
                     }
                 }
             }
         //}
     }
     
       /**
    * @Description: Prepare Suggested Lumpsum approved data
    * param: ApprovedPlanBean 
    * return type: void
    */ 
     public void getSuggMFLumpApprovedPlans(ApprovedPlanBean beanObj)
     {
         Map<String, List<ApprovedPlanBean.Goals>> mapSuggMFLump = new Map<String, List<ApprovedPlanBean.Goals>>();
         mapSuggMFLump = getSuggGoalsAllocated(suggestedLump,beanObj);
            
         for(Approved_Action_Plan__c apObj: beanObj.approvedPlanList)
         {
         	if(apObj.RecordType.Name == suggestedLump)
             {
                if(mapSuggMFLump.get(apObj.entity__c+apObj.Scheme_Name_Text__c) != null)
                {
                    ApprovedPlanBean.SuggestedMFLumpSum tmpObj = new ApprovedPlanBean.SuggestedMFLumpSum(); 
                    tmpObj.entityId = apObj.Entity__c;
                    tmpObj.recordId = apObj;
                    tmpObj.assetId = apObj.Investment_Asset__c;
                    //tmpObj.schemeName = apObj.Scheme_Name__c;//FS0235
                    tmpObj.schemeName = apObj.Scheme_Name_Text__c;//FS0235
                    tmpObj.assetsClass = apObj.Asset_Class__c;
                    tmpObj.entityName = apObj.Entity__r.FirstName +' '+apObj.Entity__r.LastName;
                    tmpObj.action = apObj.Suggested_LumpSum_Action__c;
                    tmpObj.amount = apObj.Amount__c;
                    tmpObj.notes = apObj.Notes__c;
                    //tmpObj.allocatedAmount = apObj.Allocated_Amount__c;
                    tmpObj.golsuggMFLump = mapSuggMFLump.get(apObj.entity__c+apObj.Scheme_Name_Text__c);
                    mapSuggMFLump.remove(apObj.entity__c+apObj.Scheme_Name_Text__c);
                    beanObj.suggestedMFLumpSumList.add(tmpObj);
                }
             }
         }
         
         if(beanObj.suggestedMFLumpSumList.size()<=0)
         {
             ApprovedPlanBean.SuggestedMFLumpSum tmpObj = AddNewSuggMFLump(beanObj);
             beanObj.SuggestedMFLumpSumList.add(tmpObj);
             //ApprovedPlanBean.SuggestedMFLumpSum tmpObj1 = AddNewSuggMFLump(beanObj);
             //beanObj.SuggestedMFLumpSumList.add(tmpObj1);
             //ApprovedPlanBean.SuggestedMFLumpSum tmpObj2 = AddNewSuggMFLump(beanObj);
             //beanObj.SuggestedMFLumpSumList.add(tmpObj2);
         }
     }
     
       /**
    * @Description: Prepare Suggested SIP approved data
    * param: ApprovedPlanBean 
    * return type: void
    */
    
 	/** Eternus Solutions       **/
	/** Author  : Dipak Nikam **/
	/** Case Number 00001521      	**/
	/** Date    : 24/02/2012 	**/
	/** Purpose :Modified  the code Replace Scheme_Name__c to Scheme_Name_Text__c
	/****************************************************/
     public void getSuggMFSIPApprovedPlans(ApprovedPlanBean beanObj)
     {
         Map<String, List<ApprovedPlanBean.Goals>> mapSuggMFSIP = new Map<String, List<ApprovedPlanBean.Goals>>();
         mapSuggMFSIP = getSuggGoalsAllocated(suggestedSIP,beanObj);
       	for(Approved_Action_Plan__c apObj: beanObj.approvedPlanList)
	    {
		     if(apObj.RecordType.Name == suggestedSIP)
	         {
	            if(mapSuggMFSIP.get(apObj.entity__c+apObj.Scheme_Name_Text__c) != null)
	            {
	                ApprovedPlanBean.SuggestedMFSIP tmpObj = new ApprovedPlanBean.SuggestedMFSIP(); 
	                tmpObj.entityId = apObj.Entity__c;
	                /** Eternus Solutions       **/
					/** Author  : Manasi Ranade **/
					/** Issue Id: FS0290      	**/
					/** Date    : 7/12/2011 	**/
					/** Purpose : Added property in SuggestedMFSIP class.It will be usefull in Action Plan PDF generation at the time of ET
					/****************************************************/
					tmpObj.entityName = apObj.Entity__r.FirstName +' ' +apObj.Entity__r.LastName;
	                                    
	                tmpObj.recordId = apObj;
	                tmpObj.assetId = apObj.Investment_Asset__c;
	                //tmpObj.schemeName = apObj.Scheme_Name__c;//FS0235
	                tmpObj.schemeName = apObj.Scheme_Name_Text__c;//FS0235
	                tmpObj.assetsClass = apObj.Asset_Class__c;
	                tmpObj.SIPAmount= apObj.Amount__c;
	                //tmpObj.allocatedAmount = apObj.Allocated_Amount__c;
	                tmpObj.golSuggMFSIP = mapSuggMFSIP.get(apObj.entity__c+apObj.Scheme_Name_Text__c);
	                mapSuggMFSIP.remove(apObj.entity__c+apObj.Scheme_Name_Text__c);
	                beanObj.suggestedMFSIPList.add(tmpObj);
	            }
         	}
	     }
         if(beanObj.suggestedMFSIPList.size()<=0){
             ApprovedPlanBean.SuggestedMFSIP tmpObj = AddNewSuggMFSIP(beanObj);
             beanObj.SuggestedMFSIPList.add(tmpObj);
            // ApprovedPlanBean.SuggestedMFSIP tmpObj1 = AddNewSuggMFSIP(beanObj);
            // beanObj.SuggestedMFSIPList.add(tmpObj1);
           //  ApprovedPlanBean.SuggestedMFSIP tmpObj2 = AddNewSuggMFSIP(beanObj);
           //  beanObj.SuggestedMFSIPList.add(tmpObj2);
         }
     }
     
      /**
    * @Description: Add new record for the suggested Lumpsum
    * param: ApprovedPlanBean
    * return type: ApprovedPlanBean.SuggestedMFLumpSum
    */ 
    public ApprovedPlanBean.SuggestedMFLumpSum AddNewSuggMFLump(ApprovedPlanBean beanObj){
        ApprovedPlanBean.SuggestedMFLumpSum tmpObj = new ApprovedPlanBean.SuggestedMFLumpSum();
        tmpObj.entityId = beanObj.entityId;
        for(Goal__c golObj:beanObj.goalList){
                     ApprovedPlanBean.Goals tmpInObj = new ApprovedPlanBean.Goals();
                     tmpInObj.goalId = golObj.Id;
                     tmpInObj.allocated = 0;
                     tmpInObj.allocatedAmount = 0;
                     tmpObj.golsuggMFLump.add(tmpInObj);
        }
        return tmpObj;
    } 
    
    /**
    * @Description: Add new record for the suggested SIP
    * param: ApprovedPlanBean
    * return type: ApprovedPlanBean.SuggestedMFSIP
    */ 
    public ApprovedPlanBean.SuggestedMFSIP AddNewSuggMFSIP(ApprovedPlanBean beanObj){
        ApprovedPlanBean.SuggestedMFSIP tmpObj = new ApprovedPlanBean.SuggestedMFSIP();
        tmpObj.entityId = beanObj.entityId; 
        for(Goal__c golObj:beanObj.goalList){
                     ApprovedPlanBean.Goals tmpInObj = new ApprovedPlanBean.Goals();
                     tmpInObj.goalId = golObj.Id;
                     tmpInObj.allocated = 0;
                     tmpInObj.allocatedAmount = 0;
                     tmpObj.golSuggMFSIP.add(tmpInObj);
        }
        return tmpObj;
    }                             
    
    /**
    * @Description: get allocated goals for the current approved data
    * param: Recordtype.Name, ApprovedPlanBean 
    * return type: Map<Id, List<ApprovedPlanBean.Goals>>
    */ 
    public Map<Id, List<ApprovedPlanBean.Goals>> getGoalsAllocated(String recType,ApprovedPlanBean beanObj)
    {
         Map<Id, List<ApprovedPlanBean.Goals>> mapAllocatedVal = new Map<Id, List<ApprovedPlanBean.Goals>>();
         Map<String, double> goalAllocatedMap = new Map<String, double>();
         Map<String, double> goalAmountMap = new Map<String, double>();
         set<string> proceesRec = new set<string>();
         for(Approved_Action_Plan__c apObj: beanObj.approvedPlanList)
         {
             if(apObj.RecordType.Name == recType)
             {
                goalAllocatedMap.put(''+apObj.goal__c+apObj.Investment_Asset__c,apObj.Allocated__c);
                if(apObj.Allocated__c!=null && apObj.Allocated__c != 0 && apObj.Amount__c != null && apObj.Amount__c != 0)
                {
                    goalAmountMap.put (''+apObj.goal__c+apObj.Investment_Asset__c, (apObj.Amount__c * apObj.Allocated__c) / 100) ;
                }
                else
                {
                    goalAmountMap.put (''+apObj.goal__c+apObj.Investment_Asset__c, 0) ;
                }
             }
         }
         
         for(Approved_Action_Plan__c apObj: beanObj.approvedPlanList){
             if(!proceesRec.contains(apObj.Investment_Asset__c)){
                 if(apObj.RecordType.Name == recType){
                     proceesRec.add(apObj.Investment_Asset__c);
                     for(Goal__c golObj:beanObj.goalList){
                       if(mapAllocatedVal.get(apObj.Investment_Asset__c)!=null){
                            List<ApprovedPlanBean.Goals> tmpList = mapAllocatedVal.get(apObj.Investment_Asset__c);
                            ApprovedPlanBean.Goals tmpGol = new ApprovedPlanBean.Goals();
                            tmpGol.goalId = golObj.Id;
                            if(goalAllocatedMap.get(''+golObj.Id+apObj.Investment_Asset__c)!=null){
                                tmpGol.allocated= goalAllocatedMap.get(''+golObj.Id+apObj.Investment_Asset__c);
                            }else{
                                tmpGol.allocated= 0;
                            }
                            
                            if(goalAmountMap.get(''+golObj.Id+apObj.Investment_Asset__c)!=null){
                                tmpGol.allocatedAmount = goalAmountMap.get(''+golObj.Id+apObj.Investment_Asset__c);
                            }else{
                                tmpGol.allocatedAmount = 0;
                            }
                            tmpList.add(tmpGol);
                            mapAllocatedVal.put(apObj.Investment_Asset__c, tmpList);
                       }else{
                            List<ApprovedPlanBean.Goals> tmpList1 = new List<ApprovedPlanBean.Goals>();
                            ApprovedPlanBean.Goals tmpGol1 = new ApprovedPlanBean.Goals();
                            tmpGol1.goalId = golObj.Id;
                            if(goalAllocatedMap.get(''+golObj.Id+apObj.Investment_Asset__c)!=null){
                                tmpGol1.allocated= goalAllocatedMap.get(''+golObj.Id+apObj.Investment_Asset__c);
                            }else{
                                tmpGol1.allocated= 0;
                            }
                            
                            if(goalAmountMap.get(''+golObj.Id+apObj.Investment_Asset__c)!=null){
                                tmpGol1.allocatedAmount = goalAmountMap.get(''+golObj.Id+apObj.Investment_Asset__c);
                            }else{
                                tmpGol1.allocatedAmount = 0;
                            }
                            tmpList1.add(tmpGol1);
                            mapAllocatedVal.put(apObj.Investment_Asset__c, tmpList1);
                           
                       }                      
                     }
                 }
             }
         }
         return mapAllocatedVal; 
     }
     
    /**
    * @Description: get allocated goals for the suggested approved data
    * param: Recordtype.Name, ApprovedPlanBean 
    * return type: Map<Id, List<ApprovedPlanBean.Goals>>
    */
    /** Eternus Solutions       **/
	/** Author  : Dipak Nikam **/
	/** Case Number 00001521      	**/
	/** Date    : 24/02/2012 	**/
	/** Purpose :Modified  the code :To Replace Scheme_Name__c to Scheme_Name_Text__c
	/****************************************************/
     public Map<String, List<ApprovedPlanBean.Goals>> getSuggGoalsAllocated(String recType,ApprovedPlanBean beanObj)
     {
         Map<String, List<ApprovedPlanBean.Goals>> mapAllocatedVal = new Map<String, List<ApprovedPlanBean.Goals>>();
         Map<String, double> goalAllocatedMap = new Map<String, double>();
         Map<String, double> goalAmountMap = new Map<String, double>();
         set<string> proceesRec = new set<string>();
         
         for(Approved_Action_Plan__c apObj: beanObj.approvedPlanList)
         {
             if(apObj.RecordType.Name == recType)
             {
                goalAllocatedMap.put(''+apObj.goal__c+apObj.entity__c+apObj.Scheme_Name_Text__c,apObj.Allocated__c);
                if(apObj.Allocated__c!=null && apObj.Allocated__c != 0 && apObj.Amount__c != null && apObj.Amount__c != 0)
                {
                    goalAmountMap.put (''+apObj.Goal__c+apObj.entity__c+apObj.Scheme_Name_Text__c, (apObj.Amount__c * apObj.Allocated__c) / 100) ;
                }
                else
                {
                    goalAmountMap.put (''+apObj.Goal__c+apObj.entity__c+apObj.Scheme_Name_Text__c, 0) ;
                }
             }
         }
        
         for(Approved_Action_Plan__c apObj: beanObj.approvedPlanList)
         {
         	if(!proceesRec.contains(apObj.entity__c+apObj.Scheme_Name_Text__c))
             {
                 if(apObj.RecordType.Name == recType)
                 {
                     proceesRec.add(apObj.entity__c+apObj.Scheme_Name_Text__c);
                     for(Goal__c golObj:beanObj.goalList)
                     {
                       if(mapAllocatedVal.get(apObj.entity__c+apObj.Scheme_Name_Text__c)!=null)
                       {
                            List<ApprovedPlanBean.Goals> tmpList = mapAllocatedVal.get(apObj.entity__c+apObj.Scheme_Name_Text__c);
                            ApprovedPlanBean.Goals tmpGol = new ApprovedPlanBean.Goals();
                            tmpGol.goalId = golObj.Id;
                            if(goalAllocatedMap.get(''+golObj.Id+apObj.entity__c+apObj.Scheme_Name_Text__c)!=null)
                            {
                                tmpGol.allocated= goalAllocatedMap.get(''+golObj.Id+apObj.entity__c+apObj.Scheme_Name_Text__c);
                            }
                            else
                            {
                                tmpGol.allocated= 0;
                            }
                            
                            if(goalAmountMap.get(''+golObj.Id+apObj.entity__c+apObj.Scheme_Name_Text__c)!=null)
                            {
                                tmpGol.allocatedAmount = goalAmountMap.get(''+golObj.Id+apObj.entity__c+apObj.Scheme_Name_Text__c);
                            }
                            else
                            {
                                tmpGol.allocatedAmount = 0;
                            }
                            tmpList.add(tmpGol);
                            mapAllocatedVal.put(apObj.entity__c+apObj.Scheme_Name_Text__c, tmpList);
                        }
                        else
                        {
                            List<ApprovedPlanBean.Goals> tmpList1 = new List<ApprovedPlanBean.Goals>();
                            ApprovedPlanBean.Goals tmpGol1 = new ApprovedPlanBean.Goals();
                            tmpGol1.goalId = golObj.Id;
                            if(goalAllocatedMap.get(''+golObj.Id+apObj.entity__c+apObj.Scheme_Name_Text__c)!=null)
                            {
                                tmpGol1.allocated= goalAllocatedMap.get(''+golObj.Id+apObj.entity__c+apObj.Scheme_Name_Text__c);
                            }else
                            {
                                tmpGol1.allocated= 0;
                            }
                            
                            if(goalAmountMap.get(''+golObj.Id+apObj.entity__c+apObj.Scheme_Name_Text__c)!=null)
                            {
                                tmpGol1.allocatedAmount = goalAmountMap.get(''+golObj.Id+apObj.entity__c+apObj.Scheme_Name_Text__c);
                            }else
                            {
                                tmpGol1.allocatedAmount = 0;
                            }
                            tmpList1.add(tmpGol1);
                            mapAllocatedVal.put(apObj.entity__c+apObj.Scheme_Name_Text__c, tmpList1); 
                        }                   
                     }
                 }
             }
         }
         return mapAllocatedVal; 
     }
    
    /**
    * @Description: Prepare summary table for original allocated assets 
    * param: ApprovedPlanBean 
    * return type: void
    */
    public void PrpeareSummary(ApprovedPlanBean beanObj){
        beanObj.doneLumpSum = new List<ApprovedPlanBean.DoneClass>();
        beanObj.doneSIP  = new List<ApprovedPlanBean.DoneClass>();
         Map<String, double> mapLumpDoneVals = new Map<String, double>();
         Map<String, double> mapSIPDoneVals = new Map<String, double>();
         //Following variables are only for internal calculations, please dont change the values. 
         //Its risk to save this in custom labels
         String debt = 'DEBT';
         String equity = 'EQUITY';
         String gold = 'GOLD';
         
         //System.debug('****beanObj.currentMFLumpSumList'+beanObj.currentMFLumpSumList) ; 
         
         for(ApprovedPlanBean.CurrentMFLumpSum tmpObj: beanObj.currentMFLumpSumList){
             for(ApprovedPlanBean.Goals golObj: tmpObj.golCurrMFLumpSum){
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(debt)){
                     mapLumpDoneVals = calculateTotal(mapLumpDoneVals,debt,golObj.goalId,golObj.allocatedAmount);
                  }  
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(equity)){
                     mapLumpDoneVals = calculateTotal(mapLumpDoneVals,equity ,golObj.goalId,golObj.allocatedAmount);
                 }
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(gold)){
                     mapLumpDoneVals = calculateTotal(mapLumpDoneVals,gold ,golObj.goalId,golObj.allocatedAmount);
                 }
             }
         }
         for(ApprovedPlanBean.SuggestedMFLumpSum tmpObj: beanObj.suggestedMFLumpSumList){
             for(ApprovedPlanBean.Goals golObj: tmpObj.golsuggMFLump){
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(debt)){
                     mapLumpDoneVals = calculateTotal(mapLumpDoneVals,debt,golObj.goalId,golObj.allocatedAmount);
                  }  
                 
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(equity)){
                     mapLumpDoneVals = calculateTotal(mapLumpDoneVals,equity ,golObj.goalId,golObj.allocatedAmount);
                 }
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(gold)){
                     mapLumpDoneVals = calculateTotal(mapLumpDoneVals,gold,golObj.goalId,golObj.allocatedAmount);
                 }
             }
         }
         for(ApprovedPlanBean.CurrentMFSIP tmpObj: beanObj.currentMFSIPList){
             for(ApprovedPlanBean.Goals golObj: tmpObj.golCurrMFSIP){
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(debt)){
                     mapSIPDoneVals = calculateTotal(mapSIPDoneVals ,debt,golObj.goalId,golObj.allocatedAmount);
                  }  
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(equity)){
                     mapSIPDoneVals = calculateTotal(mapSIPDoneVals ,equity ,golObj.goalId,golObj.allocatedAmount);
                 }
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(gold)){
                     mapSIPDoneVals = calculateTotal(mapSIPDoneVals ,gold ,golObj.goalId,golObj.allocatedAmount);
                 }
             }
         }
         
         if(beanObj.suggestedMFSIPList != null && beanObj.suggestedMFSIPList.size() > 0)
         {
	         for(ApprovedPlanBean.SuggestedMFSIP tmpObj: beanObj.suggestedMFSIPList)
	         {
	         	  if(tmpObj.golSuggMFSIP != null &&  tmpObj.golSuggMFSIP.size() > 0)
         		   {
		             for(ApprovedPlanBean.Goals golObj: tmpObj.golSuggMFSIP){
		                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(debt)){
		                     mapSIPDoneVals = calculateTotal(mapSIPDoneVals ,debt,golObj.goalId,golObj.allocatedAmount);
		                  }  
		                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(equity)){
		                     mapSIPDoneVals = calculateTotal(mapSIPDoneVals ,equity ,golObj.goalId,golObj.allocatedAmount);
		                 }
		                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(gold)){
		                     mapSIPDoneVals = calculateTotal(mapSIPDoneVals ,gold ,golObj.goalId,golObj.allocatedAmount);
		                 }
		             }
         		   }
	         }
         }
         //System.debug('****mapLumpDoneVals '+mapLumpDoneVals ) ; 
         //System.debug('****mapSIPDoneVals '+mapSIPDoneVals ) ;
                 
         List<double> debtLumpList = new List<double>();
         List<double> equityLumpList = new List<double>();
         List<double> goldLumpList = new List<double>();
         List<double> debtSIPList = new List<double>();
         List<double> equitySIPList = new List<double>();
         List<double> goldSIPList = new List<double>();
         for(Goal__c golObj:beanObj.goalList){
             if(mapLumpDoneVals.get(debt+golObj.Id)!=null){
                 debtLumpList.add(mapLumpDoneVals.get(debt+golObj.Id));
             }else{
                 debtLumpList.add(0);
             }
             if(mapLumpDoneVals.get(equity+golObj.Id)!=null){
                 equityLumpList.add(mapLumpDoneVals.get(equity+golObj.Id));
             }else{
                 equityLumpList.add(0);
             }
             if(mapLumpDoneVals.get(gold+golObj.Id)!=null){
                 goldLumpList.add(mapLumpDoneVals.get(gold+golObj.Id));
             }else{
                 goldLumpList.add(0);
             }
             
             if(mapSIPDoneVals.get(debt+golObj.Id)!=null){
                 debtSIPList.add(mapSIPDoneVals.get(debt+golObj.Id));
             }else{
                 debtSIPList.add(0);
             }
             if(mapSIPDoneVals.get(equity+golObj.Id)!=null){
                 equitySIPList.add(mapSIPDoneVals.get(equity+golObj.Id));
             }else{
                 equitySIPList.add(0);
             }
             if(mapSIPDoneVals.get(gold+golObj.Id)!=null){
                 goldSIPList.add(mapSIPDoneVals.get(gold+golObj.Id));
             }else{
                 goldSIPList.add(0);
             }
         }
         
        ApprovedPlanBean.DoneClass tmp1 = new ApprovedPlanBean.DoneClass('Debt',debtLumpList);
        ApprovedPlanBean.DoneClass tmp2 = new ApprovedPlanBean.DoneClass('Equity',equityLumpList);
        ApprovedPlanBean.DoneClass tmp3 = new ApprovedPlanBean.DoneClass('Gold',goldLumpList);
        ApprovedPlanBean.DoneClass tmp4 = new ApprovedPlanBean.DoneClass('Debt', debtSIPList);
        ApprovedPlanBean.DoneClass tmp5 = new ApprovedPlanBean.DoneClass('Equity', equitySIPList);
        ApprovedPlanBean.DoneClass tmp6 = new ApprovedPlanBean.DoneClass('Gold',goldSIPList);
        
        beanObj.doneLumpSum.add(tmp1);
        beanObj.doneLumpSum.add(tmp2);
        beanObj.doneLumpSum.add(tmp3);
        
        beanObj.doneSIP.add(tmp4);
        beanObj.doneSIP.add(tmp5);
        beanObj.doneSIP.add(tmp6);
    } 
    
    /**
    * @Description: calculate total amount as per asset type per each goal 
    * param: Map, String, Id , double
    * return type: Map<String, double>
    */
    public Map<String, double> calculateTotal(Map<String, double> tmpMap, String cType, Id goalId, double amt){
        if(amt==null){
            amt = 0;
        }
        if(tmpMap.get(cType+goalId)!=null){
             double val = tmpMap.get(cType+goalId);
             val = val + amt;
             tmpMap.put(cType+goalId, val);
         }else{
             double val = 0;
             val = val + amt;
             tmpMap.put(cType+goalId, val);
        }
        return tmpMap;
    }
    /*//FS0290
    private Boolean AmountValidation(double dblTotalAmount, Double dblAllocatedAmount)
    {
    	Boolean blnIsValid = true;
    	if(dblTotalAmount < dblAllocatedAmount)
    	{
    		blnIsValid = false
    	}
    	return blnIsValid;
    }*/
    /**
    * @Description: save data in approved plan object and insurence object 
    * param: ApprovedPlanBean 
    * return type: void
    */
    public Pagereference upsertData(ApprovedPlanBean beanObj)
    {
        List<Approved_Action_Plan__c> insList = new List<Approved_Action_Plan__c>();
        for(ApprovedPlanBean.CurrentMFLumpSum tmpObj: beanObj.currentMFLumpSumList)
        {
            for(ApprovedPlanBean.Goals golObj: tmpObj.golCurrMFLumpSum)
            {    
                Approved_Action_Plan__c tmpInsObj = new Approved_Action_Plan__c();
                tmpInsObj.RecordTypeId = beanObj.recTypeMap.get(currentLump);
                tmpInsObj.Entity__c = tmpObj.entityId;
                tmpInsObj.Amount__c = tmpObj.actionAmount;
                tmpInsObj.Asset_Class__c = tmpObj.assetsClass;
                tmpInsObj.Investment_Asset__c = tmpObj.assetId;
                tmpInsObj.Lumpsum_Action__c = tmpObj.action;
                //tmpInsObj.Scheme_Name__c = tmpObj.schemeName;//FS0235
                tmpInsObj.Scheme_Name_Text__c = tmpObj.schemeName;//FS0235
                tmpInsObj.Goal__c = golObj.goalId;
                tmpInsObj.Allocated__c = golObj.allocated;
                if(tmpInsObj.Lumpsum_Action__c == 'Hold - Change of broker' 
                    || tmpInsObj.Lumpsum_Action__c == 'Hold - No Change of broker'){
                    if(tmpInsObj.Allocated__c!=null && tmpInsObj.Allocated__c != 0
                        && tmpInsObj.Amount__c != null && tmpInsObj.Amount__c != 0){
                        tmpInsObj.Allocated_Amount__c = (tmpInsObj.Amount__c * tmpInsObj.Allocated__c) / 100 ;
                    }else{
                        tmpInsObj.Allocated_Amount__c = 0;
                    }
                }else{
                    tmpInsObj.Allocated_Amount__c = 0;
                }   
                insList.add(tmpInsObj); 
            }
        }
       	for(ApprovedPlanBean.CurrentMFSIP tmpObj: beanObj.currentMFSIPList)
        {
            for(ApprovedPlanBean.Goals golObj: tmpObj.golCurrMFSIP)
            {    
                Approved_Action_Plan__c tmpInsObj = new Approved_Action_Plan__c();
                tmpInsObj.RecordTypeId = beanObj.recTypeMap.get(currentSIP);
                tmpInsObj.Entity__c = tmpObj.entityId;
                tmpInsObj.Amount__c = tmpObj.SIPChange;
                tmpInsObj.Asset_Class__c = tmpObj.assetsClass;
                tmpInsObj.Investment_Asset__c = tmpObj.assetId;
                tmpInsObj.SIP_Action__c = tmpObj.SIPAction;
                //tmpInsObj.Scheme_Name__c = tmpObj.schemeName;//FS0235
                tmpInsObj.Scheme_Name_Text__c = tmpObj.schemeName;//FS0235
                tmpInsObj.Goal__c = golObj.goalId;
                tmpInsObj.Allocated__c = golObj.allocated;
                
                if(tmpInsObj.SIP_Action__c == 'Stop')
                {
                    tmpInsObj.Allocated_Amount__c = 0;
                }
                else if (tmpInsObj.SIP_Action__c == 'Continue')
                {
                	tmpInsObj.Amount__c = tmpObj.currentSIP; 
                }
                if(tmpInsObj.Allocated__c!=null && tmpInsObj.Allocated__c != 0&& tmpInsObj.Amount__c != null && tmpInsObj.Amount__c != 0)
                {
                    tmpInsObj.Allocated_Amount__c = (tmpInsObj.Amount__c * tmpInsObj.Allocated__c) / 100 ;
                }
                else
                {
                    tmpInsObj.Allocated_Amount__c = 0;
                }
            	insList.add(tmpInsObj); 
            }
        }
        Set<String> chkDuplicate = new  Set<String>();
        boolean isError = false;
        for(ApprovedPlanBean.SuggestedMFLumpSum tmpObj: beanObj.suggestedMFLumpSumList){
            for(ApprovedPlanBean.Goals golObj: tmpObj.golsuggMFLump){
                if(! chkDuplicate.contains(tmpObj.entityId+tmpObj.schemeName+golObj.goalId)){
                    Approved_Action_Plan__c tmpInsObj = new Approved_Action_Plan__c();
                    tmpInsObj.RecordTypeId = beanObj.recTypeMap.get(suggestedLump);
                    tmpInsObj.Entity__c = tmpObj.entityId;
                    tmpInsObj.Amount__c = tmpObj.amount;
                    tmpInsObj.Asset_Class__c = tmpObj.assetsClass;
                    tmpInsObj.Investment_Asset__c = tmpObj.assetId;
                    tmpInsObj.Suggested_LumpSum_Action__c  = tmpObj.Action;
                    //tmpInsObj.Scheme_Name__c = tmpObj.schemeName;//FS0235
                    tmpInsObj.Scheme_Name_Text__c = tmpObj.schemeName;//FS0235
                     tmpInsObj.Notes__c=tmpObj.notes;
                    tmpInsObj.Goal__c = golObj.goalId;
                    tmpInsObj.Allocated__c = golObj.allocated;
                    if(tmpInsObj.Allocated__c!=null && tmpInsObj.Allocated__c != 0
                        && tmpInsObj.Amount__c != null && tmpInsObj.Amount__c != 0){
                        tmpInsObj.Allocated_Amount__c = ( tmpInsObj.Amount__c * tmpInsObj.Allocated__c) / 100;
                    }else{
                        tmpInsObj.Allocated_Amount__c = 0;
                    }
                    insList.add(tmpInsObj); 
                    chkDuplicate.add(tmpObj.entityId+tmpObj.schemeName+golObj.goalId);
                }else{
                    isError = true;
                }
            }
        }
        
        Set<String> chkDuplicate1 = new  Set<String>();
        boolean isError1 = false;
        for(ApprovedPlanBean.SuggestedMFSIP tmpObj: beanObj.suggestedMFSIPList)
        {
        	for(ApprovedPlanBean.Goals golObj: tmpObj.golSuggMFSIP)
            {  
            	if(!chkDuplicate1.contains(tmpObj.entityId+tmpObj.schemeName+golObj.goalId))
                {
                    Approved_Action_Plan__c tmpInsObj = new Approved_Action_Plan__c();
                    tmpInsObj.RecordTypeId = beanObj.recTypeMap.get(suggestedSIP);
                    tmpInsObj.Entity__c = tmpObj.entityId;
                    tmpInsObj.Amount__c = tmpObj.SIPAmount;
                    tmpInsObj.Asset_Class__c = tmpObj.assetsClass;
                    tmpInsObj.Investment_Asset__c = tmpObj.assetId;
                    //tmpInsObj.Scheme_Name__c = tmpObj.schemeName;//FS0235
                    tmpInsObj.Scheme_Name_Text__c = tmpObj.schemeName;//FS0235
                    tmpInsObj.Goal__c = golObj.goalId;
                    tmpInsObj.Allocated__c = golObj.allocated;
                    if(tmpInsObj.Allocated__c!=null && tmpInsObj.Allocated__c != 0 && tmpInsObj.Amount__c != null && tmpInsObj.Amount__c != 0)
                    {
                        tmpInsObj.Allocated_Amount__c = ( tmpInsObj.Amount__c * tmpInsObj.Allocated__c) / 100;
                    }
                    else
                    {
                        tmpInsObj.Allocated_Amount__c = 0;
                    }
                    insList.add(tmpInsObj); 
                    chkDuplicate1.add(tmpObj.entityId+tmpObj.schemeName+golObj.goalId);
                }
                else
                {
                	isError1 = true;
                }    
            }
        }
        if(isError || isError1)
        {
            if(isError)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ApprovedPlanLumpSumMessage));
            }
            if(isError1)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ApprovedPlanSIPMessage));
            }
            return null;
        }
        
        if(beanObj.approvedPlanList.size()>0)
        {
            dbDMLObj.deleteRecords(beanObj.approvedPlanList);
        }
       	if(insList.size() >0)
        {
            dbDMLObj.upsertObject(insList);
        }
        if(beanObj.giApprovedList.size()>0){
            dbDMLObj.upsertObject(beanObj.giApprovedList);
        }
        if(beanObj.liApprovedList.size()>0){
            dbDMLObj.upsertObject(beanObj.liApprovedList);
        }
        
        //beanObj.approvedPlanList = getdbApprovedPlans(beanObj.accList);
        return null;
    }
    
     /**
    * @Description: remove record from list and approved plan object for suggested lumpsum
    * param: ApprovedPlanBean 
    * return type: void
    */
    public void RemoveRecordLump(ApprovedPlanBean beanObj){
        List<Approved_Action_Plan__c> delList = new List<Approved_Action_Plan__c>();
        List<Integer> removeList = new List<Integer>();
        Integer cnt = 0;
        
        for(ApprovedPlanBean.SuggestedMFLumpSum tmpObj: beanObj.suggestedMFLumpSumList){
            if(tmpObj.isRemove){
                removeList.add(cnt);
            }
            cnt++;
        }
        for(integer i=removeList.size();i>0;i--){
            //system.debug('removeList11' + removeList[i]);
            beanObj.suggestedMFLumpSumList.remove(removeList.get(i-1));
        }
       
    }
    
     /**
    * @Description: remove record from list and approved plan object for suggested SIP
    * param: ApprovedPlanBean 
    * return type: void
    */
    public void RemoveRecordSIP(ApprovedPlanBean beanObj){
        List<Approved_Action_Plan__c> delList = new List<Approved_Action_Plan__c>();
        List<Integer> removeList = new List<Integer>();
        Integer cnt = 0;
        for(ApprovedPlanBean.SuggestedMFSIP tmpObj: beanObj.suggestedMFSIPList){
            if(tmpObj.isRemove){
                removeList.add(cnt);
            }
            cnt++;
        }
        for(integer i=removeList.size();i>0;i--){
            beanObj.suggestedMFSIPList.remove(removeList.get(i-1));
        }
     }
   
    /**
    * @Description: get record types for the approved plan object
    * param: ApprovedPlanBean 
    * return type: void
    */
    public void getRecType(ApprovedPlanBean beanObj){
        List<RecordType> recTypeList = dbSOQLObj.getObjectRecordTypes('Approved_Action_Plan__c'); 
        for(RecordType recObj: recTypeList ){
            beanObj.recTypeMap.put(recObj.Name, recObj.Id);
        }
       
    }
    
    /**
    * @Description: get all approved plans for the entity
    * param: ApprovedPlanBean 
    * return type: void
    */
    
    public List<Approved_Action_Plan__c> getdbApprovedPlans(List<Account> accList){
         List<Approved_Action_Plan__c> approvedPlanList = dbSOQLObj.getdbApprovedPlans(accList);
         return approvedPlanList;
    }
    
    /**
    * @Description: get mutual fund record for the entity and familiy
    * param: ApprovedPlanBean 
    * return type: void
    */
    public List<Investment_Asset__c> getMFInvestmentAsset(List<Account> accList)
    {
        List<Investment_Asset__c> investment= dbSOQLObj.getMFInvestmentAsset(accList);    
        return investment; 
    } 
    
   /* public void DeleteRecords(List<Approved_Action_Plan__c> lst){
        Set<Id> entityId = new set<Id>();
        Set<String> schemeNames = new  Set<String>();
        for(Approved_Action_Plan__c apObj: lst){
            entityId.add(apObj.Entity__c);
            schemeNames.add(apObj.Scheme_Name__c);
        }
        if(entityId.size()>0 && schemeNames.size()>0){
            List<Approved_Action_Plan__c> delList = [select Id from Approved_Action_Plan__c where entity__c in: entityId
                                                and Scheme_Name__c in: schemeNames and (RecordType.Name=:suggestedLump OR RecordType.Name=:suggestedSIP)];
        }                                        
    }*/
    
    /**
    * @Description: Prpeare Lumpsum total and SIP Total
    * param: ApprovedPlanBean 
    * return type: void
    */
    public void PrpeareSuggested(ApprovedPlanBean beanObj){
        List<AggregateResult> goalInassetList = dbSOQLObj.getInvestAssociationSum(beanObj.accList);
        List<AggregateResult> goalAssetList = dbSOQLObj.getInsuranceAssociationSum(beanObj.accList);
        List<AggregateResult> goalInsurList = dbSOQLObj.getAssetAssociationSum(beanObj.accList);
        
        Set<Id> profileSet = new set<id>();
        Map<Id,Id> golProfileMap = new Map<Id,Id>();
        Map<Id,double> golAmountMap = new Map<Id,double>();
        for(AggregateResult agObj: goalInassetList){
             if((Double)agObj.get('expr0')!=null){  
                 golAmountMap.put((Id)agObj.get('Goal__c'),(Double)agObj.get('expr0'));  
             }
        }
        for(AggregateResult agObj: goalAssetList){
             if((Double)agObj.get('expr0')!=null){      
                 if(golAmountMap.get((Id)agObj.get('Goal__c'))!=null){
                     golAmountMap.put((Id)agObj.get('Goal__c'),golAmountMap.get((Id)agObj.get('Goal__c'))+(Double)agObj.get('expr0'));  
                 }else{
                     golAmountMap.put((Id)agObj.get('Goal__c'),(Double)agObj.get('expr0'));  
                 }
             }
        }
        for(AggregateResult agObj: goalInsurList){
             if((Double)agObj.get('expr0')!=null){  
                 if(golAmountMap.get((Id)agObj.get('Goal__c'))!=null){
                     golAmountMap.put((Id)agObj.get('Goal__c'),golAmountMap.get((Id)agObj.get('Goal__c'))+(Double)agObj.get('expr0'));  
                 }else{
                     golAmountMap.put((Id)agObj.get('Goal__c'),(Double)agObj.get('expr0'));  
                 }
             }
        }
        for(Goal__c golObj: beanObj.goalList){
            profileSet.add(golObj.SelectedGoalProfile__c);
            golProfileMap.put(golObj.Id,golObj.SelectedGoalProfile__c); 
        }
        
        List<goal_Profile__c> lstProfile = dbSOQLObj.getProfileList(profileSet);
                                                 
        
        //beanObj.asetList 'expr0'
        Map<Id,Double> golProfileDebtMap = new Map<Id,Double>();
        Map<Id,Double> golProfileGoldMap = new Map<Id,Double>();
        Map<Id,Double> golProfileEquityMap = new Map<Id,Double>();
        
        for(goal_Profile__c prObj: lstProfile){
            golProfileDebtMap.put(prObj.Id, prObj.debt_Allocation__c);
            golProfileGoldMap.put(prObj.Id, prObj.Gold_allocation__c);
            golProfileEquityMap.put(prObj.Id, prObj.Equity_Allocation__c);
            
        }
        /** Eternus Solutions       **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: 00001470     	**/
		/** Date    : 1/2/2012  	**/
		/** Purpose : Code to find out the Equity,Debt,Gold percentages
		/****************************************************/
        Datetime cDT = System.now();
        Integer currentYear = Integer.valueOf(cDT.format('yyyy'));
       
        List<Id> golIds = new List<Id>();
        for(Goal__c golObj: beanObj.goalList){
            golIds.add(golObj.Id);
        }
        /** Eternus Solutions       **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: 00001470     	**/
		/** Date    : 1/2/2012  	**/
		/** Purpose : Code to find out the Equity,Debt,Gold percentages
		/****************************************************/
        Map<Id, double> debtValMap = new  Map<Id, double>();
        Map<Id, double> equityValMap = new  Map<Id, double>();
        Map<Id, double> goldValMap = new  Map<Id, double>();
        Map<Id, double> totValMap = new  Map<Id, double>();
        double dblTotalPerc = 0,dblDebtPerc = 0,dblEquityPerc = 0,dblGoldPerc = 0;
        List<GoalSIPAmount__c> goalSips = dbSOQLObj.getGoalSIP(currentYear, golIds);
        Double dblTotalSIP = 0; 
        /*if(goalSips != null && goalSips.size() > 0)
        {
        	GoalSIPAmount__c objSIPAmt = goalSips[0];
        	dblTotalSIP = objSIPAmt.EquityCurrentYear__c + objSIPAmt.DebtCurrentYear__c + objSIPAmt.GoldCurrentYear__c;
        }*/
        double tempDebt = 0,tempEquity = 0,tempGold = 0;
        for(GoalSIPAmount__c sipObj: goalSips){
        	tempEquity = (sipObj.EquityCurrentYear__c == null ? 0 : sipObj.EquityCurrentYear__c);
        	tempDebt = (sipObj.DebtCurrentYear__c == null ? 0 : sipObj.DebtCurrentYear__c);
        	tempGold = (sipObj.GoldCurrentYear__c == null ? 0 : sipObj.GoldCurrentYear__c);
        	dblTotalSIP = tempEquity + tempDebt + tempGold;
        	if(dblTotalSIP > 0)
        	{
	        	//dblTotalPerc =  sipObj.SIP_Total__c;
				dblDebtPerc = sipObj.DebtCurrentYear__c / dblTotalSIP * 100;
				dblEquityPerc = sipObj.EquityCurrentYear__c / dblTotalSIP * 100;
				dblGoldPerc = sipObj.GoldCurrentYear__c / dblTotalSIP * 100;
        	}
        	else
			{
				dblDebtPerc = 0;
				dblEquityPerc = 0;
				dblGoldPerc = 0;
			}
            debtValMap.put(sipObj.Goal__c, dblDebtPerc);
            equityValMap.put(sipObj.Goal__c, dblEquityPerc); 
            goldValMap.put(sipObj.Goal__c, dblGoldPerc);
            //totValMap.put(sipObj.Goal__c, sipObj.SIP_Total__c);
        }
        
        List<double> debtVals = prepareProfileWiseData(beanObj.goalList,golProfileMap,golProfileDebtMap, golAmountMap,debtValMap);
        List<double> equityVals = prepareProfileWiseData(beanObj.goalList,golProfileMap,golProfileEquityMap, golAmountMap,equityValMap);
        List<double> goldVals = prepareProfileWiseData(beanObj.goalList,golProfileMap,golProfileGoldMap, golAmountMap,goldValMap);
        
        ApprovedPlanBean.DoneClass asetDebt = new ApprovedPlanBean.DoneClass('Debt', debtVals);
        ApprovedPlanBean.DoneClass asetEquity = new ApprovedPlanBean.DoneClass('Equity', equityVals);
        ApprovedPlanBean.DoneClass asetGold = new ApprovedPlanBean.DoneClass('Gold', goldVals);
        
        beanObj.suggestedLumpSum.add(asetDebt);
        beanObj.suggestedLumpSum.add(asetEquity);
        beanObj.suggestedLumpSum.add(asetGold);   
        prepareSIPData(beanObj);
    }
    
     /** Eternus Solutions       **/
	 /** Author  : Manasi Ranade **/
	 /** Issue Id: 00001470     	**/
	 /** Date    : 1/2/2012  	**/
	 /** Purpose : Code to find out the Equity,Debt,Gold percentages
	 /****************************************************/
     private List<double> prepareProfileWiseData(List<Goal__c> goalListP, Map<Id, Id>golProfileMapP, Map<Id, double>golProfileClassMapP
     												, Map<Id, double>golAmountMapP, Map<Id, double> percentageAllocationMap){
        //Original Code
        /*List<double> classVals = new List<double>();
        for(Goal__c golObj: goalListP){
            Id goalId = golObj.Id;
            double sumMF = golAmountMapP.get(goalId);
            
            double Perc = 0;
            double amount = 0;
            
            if(golProfileMapP.get(goalId)!=null && golProfileClassMapP.get(golProfileMapP.get(goalId))!=null){
                Perc = golProfileClassMapP.get(golProfileMapP.get(goalId));
                if(sumMF !=null && sumMF!=0){
                    amount = (sumMF * Perc)/100;
                }
            }
            classVals.add(amount);
            
         }
         return classVals;*/
         List<double> classVals = new List<double>();
        for(Goal__c golObj: goalListP){
            Id goalId = golObj.Id;
            double sumMF = golAmountMapP.get(goalId);
            
            double Perc = 0;
            double amount = 0;
            
            if(percentageAllocationMap != null & percentageAllocationMap.get(goalId) != null){
                Perc = percentageAllocationMap.get(goalId);
                if(sumMF !=null && sumMF!=0){
                    amount = (sumMF * Perc)/100;
                }
            }
            classVals.add(amount);
            
         }
         return classVals;
         
    }
    
    public void prepareSIPData(ApprovedPlanBean beanObj){
        Datetime cDT = System.now();
        Integer currentYear = Integer.valueOf(cDT.format('yyyy'));
       
        List<Id> golIds = new List<Id>();
        for(Goal__c golObj: beanObj.goalList){
            golIds.add(golObj.Id);
        }
        Map<Id, double> debtValMap = new  Map<Id, double>();
        Map<Id, double> equityValMap = new  Map<Id, double>();
        Map<Id, double> goldValMap = new  Map<Id, double>();
      //  Map<Id, double> totValMap = new  Map<Id, double>();
        
        List<GoalSIPAmount__c> goalSips = dbSOQLObj.getGoalSIP(currentYear, golIds);
        for(GoalSIPAmount__c sipObj: goalSips){
            debtValMap.put(sipObj.Goal__c, sipObj.SIP_Debt__c);
            equityValMap.put(sipObj.Goal__c, sipObj.SIP_Equity__c); 
            goldValMap.put(sipObj.Goal__c, sipObj.SIP_Gold__c);
           // totValMap.put(sipObj.Goal__c, sipObj.SIP_Total__c);
        }
        
        List<double> debtVal = new List<double>();
        List<double> equityVal = new List<double>();
        List<double> goldVal = new List<double>();
        
        for(Goal__c golObj: beanObj.goalList){
            if(debtValMap.get(golObj.Id)!=null){
                debtVal.add(debtValMap.get(golObj.Id));
            }else{
                debtVal.add(0);
            }
            if(equityValMap.get(golObj.Id)!=null){
                equityVal.add(equityValMap.get(golObj.Id));
            }else{
                equityVal.add(0);
            }
            if(goldValMap.get(golObj.Id)!=null){
                goldVal.add(goldValMap.get(golObj.Id));
            }else{
                goldVal.add(0);
            }
          /*  if(totValMap.get(golObj.Id)!=null){
                beanObj.totSIPList.add(totValMap.get(golObj.Id));
            }else{
                beanObj.totSIPList.add(0);
            }*/
        } 
        
        ApprovedPlanBean.DoneClass debtObj = new  ApprovedPlanBean.DoneClass('Debt', debtVal);
        beanObj.SuggestedSIP.add(debtObj);
        ApprovedPlanBean.DoneClass equityObj = new  ApprovedPlanBean.DoneClass('Equity', equityVal);
        beanObj.SuggestedSIP.add(equityObj);
        ApprovedPlanBean.DoneClass goldObj = new  ApprovedPlanBean.DoneClass('Gold', goldVal);
        beanObj.SuggestedSIP.add(goldObj);
    }
    
}