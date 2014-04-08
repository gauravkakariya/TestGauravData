public virtual class FPsidebarDispalyLink 
{
     //Added on : 10/4/2013 : Gaurav : Hide Some field(link) of financial plan 
    public Boolean isPortfolioSummary{get;set;}
    public Boolean isNetworth{get;set;}
    public Boolean isCashFlow{get;set;}
    public Boolean isAssetAllocation{get;set;}
    public Boolean isEmergencyPlanning{get;set;}
    public Boolean isLifeInsurancePlanning{get;set;}
    public Boolean isGeneralInsurancePlanning{get;set;}
    public Boolean isSuccessionPlanning{get;set;}
    public Boolean isSummaryActionPlan{get;set;}
    public Boolean isGenerateActionPlan{get;set;}
    public Boolean isNewExecutionTracker{get;set;}
    public Boolean isGenerateFinancialPlan{get;set;}
    public Boolean isGlobalAssumption{get;set;}
    public Boolean isGoal{get;set;}
    private String entityId;
    public FPsidebarDispalyLink(String entityId)
    {
        this.entityId = entityId;
        fpSidebarDisplay();
    }
    public void fpSidebarDisplay()
    {
        try
        {   
            Entity_Global_Assumption__c objEntityGlobalAssumption = [Select Name, No_of_Goals__c, Data_Collection_Analysis_Control__c, Goals_Allowed_List__c, Financial_Planing_Output_Report__c, Account__r.Id, Account__c 
                                                                        From Entity_Global_Assumption__c 
                                                                        Where Account__c =:entityId];
                                                                        
            String strDataCollectionAnalysis = objEntityGlobalAssumption.Data_Collection_Analysis_Control__c;
            List<String> lstDataCollectionAnalysis = new List<String>();
            Set<String> setDataCollectionAnalysis = new Set<String>();
            if(strDataCollectionAnalysis <> NULL)
            {
	            lstDataCollectionAnalysis = strDataCollectionAnalysis.split(';');
	            
	            for(String strDataCollection : lstDataCollectionAnalysis)
	            {
	                setDataCollectionAnalysis.add(strDataCollection);
	            }
	            
	            isPortfolioSummary = setDataCollectionAnalysis.contains('Portfolio Summary') ;
	            isNetworth = setDataCollectionAnalysis.contains('Networth') ;
	            isCashFlow =  setDataCollectionAnalysis.contains('Cash Flow') ;
	            isAssetAllocation = setDataCollectionAnalysis.contains('Asset Allocation');
	            isEmergencyPlanning = setDataCollectionAnalysis.contains('Emergency Planning') ;
	            isLifeInsurancePlanning = setDataCollectionAnalysis.contains('Life Insurance Planning') ;
	            isGeneralInsurancePlanning = setDataCollectionAnalysis.contains('General Insurance Planning') ;
	            isSuccessionPlanning = setDataCollectionAnalysis.contains('Succession Planning') ;
	            isGlobalAssumption = setDataCollectionAnalysis.contains('Global Assumptions');
	            isGoal = (objEntityGlobalAssumption.No_of_Goals__c != 0);
            }      
        }
        catch(Exception e)
        {
            System.debug('-------------------'+e);
        }
      
    }
    
    @isTest
    private static void testFPSidebarrDisplayControl()
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
            
        Entity_Global_Assumption__c objEntityGlobalAssumption  = [Select Name, No_of_Goals__c, Data_Collection_Analysis_Control__c,Account__c 
                                                                        From Entity_Global_Assumption__c 
                                                                        Where Account__c =:objAccount.Id];
        objEntityGlobalAssumption.No_of_Goals__c =2;
        objEntityGlobalAssumption.Data_Collection_Analysis_Control__c = 'Introduction1;Disclosure Statement1';
        
        update objEntityGlobalAssumption;                                               
        PageReference pageRef = Page.ActionPlan;    
        ApexPages.currentPage().getParameters().put('EntityId', objAccount.Id);
        FPsidebarDispalyLink objFPReportControl = new FPsidebarDispalyLink(ApexPages.currentPage().getParameters().get('EntityId'));
        
        Test.stopTest();
    }
}