/*
	Revision History:
	
    Version     Version Author     Date           Comments
    1.0         Prajakta Sanap     27/09/2012     New Action Plan Creation
    2.0			Gaurav			   15/04/2013	  To hide succesion palnning and Insurance disply on Action plan
*/

public with sharing class SumActionPlanController extends FPsidebarDispalyLink
{
    private SumActionPlanServices serviceObj;
    public SummaryActionPlanBean beanObj {get;set;}
    
    //Added on:06/02/2013 : Aditi Satpute : AP changes
    public String isShowActionPlan{get;set;}
    
    public List<SummaryDetail> lstSummaryDetail {get;set;}
    public SummaryDetail objSummaryDetail {get;set;}
    
    //Added on:23-May-2013 : Kiran : FP changes part2 - issue 10
    public Remarks__c remarks{get;set;}
    
    public SumActionPlanController()
    {
    	super(System.currentPageReference().getParameters().get('entityId')); //Changes by Gaurav (15-4-2013): To hide succesion palnning and Insurance disply on Action plan
    	lstSummaryDetail = new List<SummaryDetail>();
        serviceObj = new SumActionPlanServices();
        beanObj = new  SummaryActionPlanBean();
        remarks = new Remarks__c();
        beanObj.entityId = Apexpages.currentPage().getParameters().get('entityId');
        isShowActionPlan = Apexpages.currentPage().getParameters().get('isShowActionPlan');
       
        serviceObj.getFamilyDetails(beanObj);
        serviceObj.getGoals(beanObj);
        
        /*
		  Updated By : Kiran Patil
		  Updated At : 5-Jun-2013
		  Summary    : FP changes-part2 - issue 6 
		*/
		if(!(beanObj.goalList).isEmpty()) {
	        list<Goal__c> tempaddNewListView = new list<Goal__c>();
        	list<Goal__c> tempaddNewListViewRetirement = new list<Goal__c>();
        	for (Goal__c goal : beanObj.goalList) {
        		if (goal.Goal_Type__c.equalsIgnoreCase('Retirement'))
        		    tempaddNewListViewRetirement.add(goal);
        		else     
        		    tempaddNewListView.add(goal);
        	}
        	beanObj.goalList = new list<Goal__c>();
        	beanObj.goalList.addall(tempaddNewListView);
        	beanObj.goalList.addall(tempaddNewListViewRetirement);
        }
        
        serviceObj.getAsset(beanObj);
        beanObj.giList = serviceObj.getGenerelInsurance(beanObj.accList);
        if(beanObj.giList != null && beanObj.giList.size()>0)
        {
           beanObj.isGeneralInsExist = true;
        }
        beanObj.liList = serviceObj.getLifeInsurance(beanObj.accList);
        if(beanObj.liList != null && beanObj.liList.size()>0)
        {
           beanObj.isLifeInsExist = true;
        }
        serviceObj.prepareData(beanObj);
       
        System.debug('--------------------------------beanObj.goalList------------'+beanObj.goalList);
        System.debug('--------------------------------beanObj.sipList------------'+beanObj.sipList);
        System.debug('--------------------------------beanObj.asetList------------'+beanObj.asetList);
        
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
    
 /**
 * @Description : actionPlan()is function used for navigating to ActionPlan page
 * ReturnType : pageReference 
 */
    public pageReference actionPlan()
    {
        pageReference pageRef = new pageReference('/apex/ActionPlan?entityId='+beanObj.entityId+'&tabname=Financial Planning');
        pageRef.setRedirect(true);
        return pageRef ;
    }
    
/**
 * @Description : actionPlanPDF()is function used for navigating to ActionPlanPDF page
 * ReturnType : pageReference 
 */
    public pageReference actionPlanPDF()
    {
        pageReference pageRef = new pageReference('/apex/ActionPlanPDF?entityId='+beanObj.entityId+'&tabname=Financial Planning');
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