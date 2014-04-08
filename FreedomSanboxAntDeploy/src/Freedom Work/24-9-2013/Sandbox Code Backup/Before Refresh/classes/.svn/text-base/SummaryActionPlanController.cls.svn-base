/**
 * @Author: Sandip C
 * @Description:SummaryActionPlanController is controller class for SummaryActionPlan.page w
 */

public class SummaryActionPlanController //extends FPReportControl
{
	private SummaryActionPlanServices serviceObj;
    public SummaryActionPlanBean beanObj {get;set;}
    
    public List<SummaryDetail> lstSummaryDetail {get;set;}
    public SummaryDetail objSummaryDetail {get;set;}
    
    //Added on:23-May-2013 : Kiran : FP changes part2 - issue 10
    public Remarks__c remarks{get;set;}
    
    //Added on : 11/4/2013 : Gaurav : Hide Some field(link) of financial plan 
	/* FPReportControl Variables*/
    public Boolean isLifeInsuranceAnalysis{get;set;}
    public Boolean isGeneralInsurance{get;set;}
    
    public Entity_Global_Assumption__c objEntityGlobalAssumption{
    	get{
    		if(objEntityGlobalAssumption == null)
    			objEntityGlobalAssumption = new Entity_Global_Assumption__c();
    		return  objEntityGlobalAssumption;
    	}set;
    }
    /* End FPReportControl Variables*/
    
    public SummaryActionPlanController()
    {
    	//super(Apexpages.currentPage().getParameters().get('entityId'));
    	
    	System.debug('************** SummaryActionPlanController **********');
    	lstSummaryDetail = new List<SummaryDetail>();
        
    	serviceObj = new SummaryActionPlanServices();
        beanObj = new SummaryActionPlanBean();
        beanObj.entityId = Apexpages.currentPage().getParameters().get('entityId');
        fpDisplay();
        serviceObj.getFamilyDetails(beanObj);
        serviceObj.getGoals(beanObj);
        serviceObj.getAsset(beanObj);
        beanObj.giList = serviceObj.getGenerelInsurance(beanObj.accList);
      
        if(beanObj.giList != null && beanObj.giList.size()>0){
           beanObj.isGeneralInsExist = true;
        }
        beanObj.liList = serviceObj.getLifeInsurance(beanObj.accList);
        if(beanObj.liList != null && beanObj.liList.size()>0){
            beanObj.isLifeInsExist = true;
        }
        serviceObj.prepareData(beanObj);
        
        for(Integer i = 0 ; i < beanObj.goalList.size() ; i++)
        {
       		String strDescription = beanObj.goalList[i].Description__c;
       		Double sipDebt = beanObj.sipList[0].golListVals[i];
       		Double sipEquity = beanObj.sipList[1].golListVals[i];
       		Double sipGold = beanObj.sipList[2].golListVals[i];
       		
       		Double lumpsumDebt = beanObj.asetList[0].golListVals[i];
       		Double lumpsumEquity = beanObj.asetList[1].golListVals[i];
       		Double lumpsumGold = beanObj.asetList[2].golListVals[i];
       		
       		lstSummaryDetail.add(new SummaryDetail(strDescription, new List<Double>{sipDebt,sipEquity, sipGold}, new List<Double>{lumpsumDebt,lumpsumEquity, lumpsumGold}));
       	}
       	
       	
   		List<Double> lstTotalSip = new List<Double>();
   		List<Double> lstTotalLumpsum = new List<Double>();
   		for(Integer i = 0; i < 3 ; i++)
   		{
   			lstTotalSip.add(0);
   			lstTotalLumpsum.add(0);
   		}
   		
   		for(Integer i = 0; i < 3 ; i++)
   		{
   			for(Integer j = 0; j < lstSummaryDetail.size(); j++)
   			{
   				lstTotalSip.set(i, lstTotalSip.get(i) + Math.roundToLong(lstSummaryDetail[j].lstSipValue[i]));
   				lstTotalLumpsum.set(i, lstTotalLumpsum.get(i) + Math.roundToLong(lstSummaryDetail[j].lstLumpsumValue[i]));	
   			}
   		}
   		
   		objSummaryDetail = new SummaryDetail('Total', lstTotalSip, lstTotalLumpsum);
   		Error.debuglog('-----------------Limit SumAction--------'+Limits.getQueries());
   		
   		
   		Map<String, Schema.RecordTypeInfo> remarksRecordTypeInfo = Schema.SObjectType.Remarks__c.getRecordTypeInfosByName();
        String remarksRecordTypeId = remarksRecordTypeInfo.get('SummaryActionPlan').getRecordTypeId();
        
        list<Remarks__c> remarksList = [
                                 Select Remark__c
                                      , RecordTypeId
                                      , Name
                                      , Id
                                      , Entity__c
                                   From Remarks__c
                                  where Entity__c =: System.currentPageReference().getParameters().get('entityId')
                                    and RecordTypeId =: remarksRecordTypeId
        ];
        if (remarksList.isEmpty())
   			remarks = new Remarks__c(RecordTypeId = remarksRecordTypeId);
   		else
   			remarks = remarksList[0];
    }
    
    /*
	  Updated By : Kiran Patil
	  Updated At : 23-May-2013
	  Summary    : FP changes-part2 - issue 10 
	*/
    public void saveUnallocatedAssetsRemark()
    {
        try {
        	if (remarks.Entity__c == null)
        		remarks.Entity__c = Apexpages.currentPage().getParameters().get('entityId');
        	upsert remarks;
        }
        catch(System.Exception ex)
        {
            error.DebugLog('--- Error --->' + ex.getMessage());
        }
    }
    
  	/*  public pageReference saveInsurence(){
        serviceObj.saveInsurence(beanObj);
        return null;
    }
    */
    
    
    /* FPReportControl Variables initializations*/
    public void fpDisplay()
    {
        try{
           Entity_Global_Assumption__c objEntityGlobalAssumption = [Select Name, No_of_Goals__c, Financial_Planing_Output_Report__c,Account__c 
                                                                        From Entity_Global_Assumption__c 
                                                                        Where Account__c =:beanObj.entityId];
            String strFinancialPlanOutputReport = objEntityGlobalAssumption.Financial_Planing_Output_Report__c;
            List<String> lstFinancialPlanOutputReport = new List<String>();
            Set<String> setFinancialPlanOutputReport = new Set<String>();
            if(strFinancialPlanOutputReport != null){
            	lstFinancialPlanOutputReport = strFinancialPlanOutputReport.split(';');
            	
            	for(String strFinancialPlanOutput : lstFinancialPlanOutputReport)
	            {
	                setFinancialPlanOutputReport.add(strFinancialPlanOutput);
	            }
            }
            
            isLifeInsuranceAnalysis = setFinancialPlanOutputReport.contains('Life Insurance Analysis') ;
            isGeneralInsurance = setFinancialPlanOutputReport.contains('General Insurance') ;
        }
        catch(Exception e)
        {
            System.debug('---------Exception----------'+e);
        }
            
    }
    
    /**
 	*
 	* @Description:approvedPlan()is function used for navigating to ApprovedPlan page
 	* ReturnType:pageReference 
 	*/
    public pageReference approvedPlan()
    {
        pageReference pageRef = new pageReference('/apex/ApprovedPlan?entityId='+beanObj.entityId+'&tabname=Financial Planning');
        return pageRef ;
    }
    
    public class SummaryDetail
    {
    	public String description {get;set;}
    	public List<Double> lstSipValue {get;set;}
    	public List<Double> lstLumpsumValue {get;set;}
    	
    	public SummaryDetail(String description, List<Double> lstSipValue, List<Double> lstLumpsumValue)
    	{
    		this.description = description;
    		this.lstSipValue = lstSipValue;
    		this.lstLumpsumValue = lstLumpsumValue;
    	}
    	
    }
}