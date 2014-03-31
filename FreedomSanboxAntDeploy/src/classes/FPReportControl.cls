public virtual class FPReportControl 
{
     //Added on : 11/4/2013 : Gaurav : Hide Some field(link) of financial plan 
    public Boolean isIntroduction{get;set;}
    public Boolean isDisclosureStatement{get;set;}
    public Boolean isGoalSummary{get;set;}
    public Boolean isFinancialStatements{get;set;}
    public Boolean isEmergencyPlanning{get;set;}
    public Boolean isIndividualGoal{get;set;}
    public Boolean isLifeInsuranceAnalysis{get;set;}
    public Boolean isGeneralInsurance{get;set;}
    public Boolean isEstatePlanning{get;set;}
    public Boolean isSummaryActionPlan{get;set;}
    public Boolean isAnnexure1{get;set;}
    public Boolean isFinancialPlanReview{get;set;}
    public Boolean isInvestmentRisk{get;set;}
    public Boolean isDeliveryAcknowledgement{get;set;}
    
    public Entity_Global_Assumption__c objEntityGlobalAssumption{
    	get{
    		if(objEntityGlobalAssumption == null)
    			objEntityGlobalAssumption = new Entity_Global_Assumption__c();
    		return  objEntityGlobalAssumption;
    	}set;
    }
    
    private String entityId{get;set;}
    
    public FPReportControl()
    {
        this.entityId  = ApexPages.currentPage().getParameters().get('EntityId');
        if(this.entityId != null)
        	this.objEntityGlobalAssumption = getGlobalAssumptionByEntityId(this.entityId);
        fpSectionDisplay();
    }
    
    private Entity_Global_Assumption__c getGlobalAssumptionByEntityId(String entityId){
    	return [Select Name, No_of_Goals__c, Financial_Planing_Output_Report__c,Account__c 
                                                                       From Entity_Global_Assumption__c 
                                                                     Where Account__c =:entityId];
         //   return null;
    }
    
    //Constructor
    public FPReportControl(String entityId)
    {
        this.entityId = entityId;
        fpSectionDisplay();
    }
    
    public void fpSectionDisplay()
    {
        //try{
           /*Entity_Global_Assumption__c objEntityGlobalAssumption = [Select Name, No_of_Goals__c, Financial_Planing_Output_Report__c,Account__c 
                                                                        From Entity_Global_Assumption__c 
                                                                        Where Account__c =:entityId];*/
            String strFinancialPlanOutputReport = this.objEntityGlobalAssumption.Financial_Planing_Output_Report__c;
            List<String> lstFinancialPlanOutputReport = new List<String>();
            Set<String> setFinancialPlanOutputReport = new Set<String>();
            if(strFinancialPlanOutputReport != null){
            	lstFinancialPlanOutputReport = strFinancialPlanOutputReport.split(';');
            	
            	for(String strFinancialPlanOutput : lstFinancialPlanOutputReport)
	            {
	                setFinancialPlanOutputReport.add(strFinancialPlanOutput);
	            }
            }
            
            
            isIntroduction = setFinancialPlanOutputReport.contains('Introduction') ;
            isDisclosureStatement = setFinancialPlanOutputReport.contains('Disclosure Statement') ;
            isGoalSummary = setFinancialPlanOutputReport.contains('Goal Summary') ;
            isFinancialStatements =  setFinancialPlanOutputReport.contains('Financial Statements') ;
            isEmergencyPlanning = setFinancialPlanOutputReport.contains('Emergency Planning');
            isIndividualGoal = setFinancialPlanOutputReport.contains('Individual Goal') ;
            isLifeInsuranceAnalysis = setFinancialPlanOutputReport.contains('Life Insurance Analysis') ;
            isGeneralInsurance = setFinancialPlanOutputReport.contains('General Insurance') ;
            isSummaryActionPlan = setFinancialPlanOutputReport.contains('Summary Action Plan') ;
            isEstatePlanning = setFinancialPlanOutputReport.contains('Estate Planning') ;
            isAnnexure1 = setFinancialPlanOutputReport.contains('Annexure 1');
            isFinancialPlanReview = setFinancialPlanOutputReport.contains('Financial Plan Review');
            isInvestmentRisk = setFinancialPlanOutputReport.contains('Investment Risk');
            isDeliveryAcknowledgement = setFinancialPlanOutputReport.contains('Delivery Acknowledgement');
       // }
        //catch(Exception e)
        //{
          //  System.debug('-------------------'+e);
        //}
            
    }
    
    @isTest
    private static void testFPReportControl()
    {
    	//RecordType objRT = [Select Id from RecordType where Name = 'Client' and SobjectType = 'Account'];
		Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_INVESTMENT = Investment_Asset__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_INVESTMENTMAP = DESCRIBE_RESULT_INVESTMENT.getRecordTypeInfosByName();
    	
    	//Insert RecordType record
    	List<RecTypes__c> lstRecTypes = new List<RecTypes__c>();
    	RecTypes__c objRecType = new RecTypes__c(Name='General_Business', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	
    	RecTypes__c objRecType1 = new RecTypes__c(Name='AccountFamily', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('Family Member').getRecordTypeId());
    	RecTypes__c objRecType2 = new RecTypes__c(Name='AccountClient', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId());
    	
    	lstRecTypes.add(objRecType);										 
    	lstRecTypes.add(objRecType1);
    	lstRecTypes.add(objRecType2);	
    	insert lstRecTypes;
    	
    	
    	List<smagicbasic__SMS_Template__c> lstTemplate = new List<smagicbasic__SMS_Template__c>();
    	
    	smagicbasic__SMS_Template__c template= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Discontinuation Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	
    	smagicbasic__SMS_Template__c template1= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Renewal Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	lstTemplate.add(template);
    	lstTemplate.add(template1);
    	
    	insert lstTemplate;
    	
        //Insert Account record
    	Account objBPAccount = new Account(Name='Parner Account Test',
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	insert 	objBPAccount;
        Test.startTest();
        Account objAccount = new Account(LastName='Test Freedom', Adjustment_Factor__c='2',
                           PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
                           Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
                           PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                           Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
                           RecordTypeId = RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId(),Will__c = true);    
        insert objAccount;
            
        Entity_Global_Assumption__c objEntityGlobalAssumption  = [Select Name, No_of_Goals__c, Financial_Planing_Output_Report__c,Account__c 
                                                                        From Entity_Global_Assumption__c 
                                                                        Where Account__c =:objAccount.Id];
        objEntityGlobalAssumption.No_of_Goals__c =2;
        objEntityGlobalAssumption.Financial_Planing_Output_Report__c = 'Introduction1;Disclosure Statement1';
        
        update objEntityGlobalAssumption;                                               
        PageReference pageRef = Page.ExecutionTracker;  
        ApexPages.currentPage().getParameters().put('EntityId', String.valueOf(objAccount.Id));
        FPReportControl objFPReportControl = new FPReportControl();
        FPReportControl objFPReportControl1 = new FPReportControl(objAccount.Id);
        Test.stopTest();
        
    }
}