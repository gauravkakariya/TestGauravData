/*
    This class is controller for InvestmentAssetPage
*/
public class InvestmentAssetController 
{
    public List<Account> accountList {get; set;}
    public String entityId {get; set;}                
    public String objectName='Investment_Asset__c';
    public String selRecordTypeId {get; set;}    
    public Boolean displayPopUp {get; set;}    
    private String selectedIndexStr,selectedAMCName;
    public FamilyMemberInfoBean fmBean{get;set;}
    public FamilyMemberInfoService fmInfoService{get;set;}
    //Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
	private Map<String,String> mapTypeToProductNames;
	public Boolean isDisplayError{get;set;}
	
    public InvestmentAssetServices investmentAssetServicesInstance 
    {
        get 
        {           
            return investmentAssetServicesInstance ;
        } 
        set;
    }
    
    public InvestmentAssetBean investmentAssetBeanInstance 
    {
        get 
        {                                                                                        
            if(selectedIndexStr != null) 
            {
                InvestmentAssetBean.InvestmentWrapper wrapper = investmentAssetBeanInstance
                                                                    .investmentAssetWrapperList.get(Integer.valueOf(selectedIndexStr));                        
                wrapper.selectedAMCName = selectedAMCName;                
                /*if(selectedIndexStr != null) {
                    wrapper.schemeNameList =investmentAssetServicesInstance.getSchemeNameList(selectedAMCName);
                    wrapper.selectedSchemeName = wrapper.schemeNameList.get(0).getValue();
                }*/
                selectedIndexStr = null;
            }               
            return investmentAssetBeanInstance ;
        } 
        set;
    }                 
    public String recordType{get; set;}
    public final Investment_Asset__c investmentAsset {get; set;}
    public String selRecordTypeName{get; set;}
    public Integer listIndex{get; set;}
    public Investment_Asset__c  investmentInstance{get; set;}
    private List<SelectOption> amcNameList,schemeNameList;
    
    private ActionPlanUtility objActionPlanUtility;
    public String strProductSchemeName{get;set;}
    public Boolean includeHLV {get;set;} /* Prajakta - FP changes - 13-6-13 */
    
    public List<OuterClass> summaryTableList
    { 
    	get 
    	{
            if(summaryTableList == null) 
            {
                summaryTableList = investmentAssetServicesInstance.getSummaryTableList(entityId, accountList);      
            }
            return summaryTableList;
        }
        set;
    }
    
  	/*public List<SelectOption> getSchemeList(){
     		return this.schemeList;
    }*/
  	//Boolean isAddNew = true;
    
    public InvestmentAssetController(ApexPages.StandardController stdController)
    {
    	//Code Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   		isDisplaySaveButton = true;
   		isDisplayError =false;
        investmentAsset = (Investment_Asset__c)stdController.getRecord();
        investmentAssetServicesInstance = new InvestmentAssetServices();
        investmentAssetBeanInstance = new InvestmentAssetBean();        
        entityId = ApexPages.currentPage().getParameters().get('EntityId');
        accountList = investmentAssetServicesInstance.getFamilyDetails(entityId);        
        //amcNameList = investmentAssetServicesInstance.getAMCNameList();
        //schemeNameList = investmentAssetServicesInstance.getSchemeNameList(amcNameList.get(0).getValue());
        //system.debug('schemeNameList==###=='+schemeNameList); 
        fmBean = new FamilyMemberInfoBean();
        fmInfoService = new FamilyMemberInfoService();
        fmInfoService.isCostomerProfile(fmBean);
        recordType = 'null';   
        
        //Added Code on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
        User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
        if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
        {
        	isDisplaySaveButton = false;
        }
         /* Gaurav (12-6-2013) :  for Display autocomeple in scheme name*/
        objActionPlanUtility =  new ActionPlanUtility();
       	strProductSchemeName  = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Mutual Fund'));
       	mapTypeToProductNames = new Map<String,String>{'Mutual Fund' => strProductSchemeName };
       	/* End changes*/
    } 
    
        
    public void showPopUp() 
    {
        displayPopUp=true;
        if(selRecordTypeId == InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c)
        {
        	system.debug('==========Stocks===========');
            recordType = 'Stocks';
        }
        if(selRecordTypeId == InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c)
        {
            recordType = 'Mutual_Fund';
        }
        if(selRecordTypeId == InvestmentAsset__c.getInstance('Fixed Income').RecordTypeId__c)
        {
            recordType = 'Fixed_Income';
        }
        //Prajakta - FP changes - 25-02-2013
        if(selRecordTypeId == InvestmentAsset__c.getInstance('Gold and Silver').RecordTypeId__c)  /*Prajakta - 24-05-2013 */
        {
        	system.debug('==========Gold===========');
            recordType = Label.Gold_and_Silver;		/*Prajakta - 24-05-2013 */
        }
                     
        if((investmentAssetBeanInstance.investmentAssetWrapperList.isEmpty())) 
        {
            investmentAssetServicesInstance.getInvestmentList(investmentAssetBeanInstance,selRecordTypeId,entityId);
            if(investmentAssetBeanInstance.investmentAssetWrapperList.isEmpty())
            {
                for(Integer i=0;i < 10; i++)
                {        
                    investmentAssetServicesInstance.addRow(investmentAssetBeanInstance,selRecordTypeId, true);
                }
            }
        }                   
    }
    
    //To Add default rows
    public void addNewRow() 
    {
    	/* Prajakta - FP changes - 13-6-13 */
        investmentAssetServicesInstance.addRow(investmentAssetBeanInstance,selRecordTypeId, true);//amcNameList,schemeNameList
        investmentAssetServicesInstance.addRow(investmentAssetBeanInstance,selRecordTypeId, true);
        investmentAssetServicesInstance.addRow(investmentAssetBeanInstance,selRecordTypeId, true); 
    }

    public void closePopUp()
    {
        displayPopUp = false;
        summaryTableList = null;
        investmentAssetBeanInstance.investmentAssetWrapperList = null;
        accountList = investmentAssetServicesInstance.getFamilyDetails(entityId);  
        system.debug('==========accountList========1==='+accountList);      
    }
    
    //To save/update investment asset in db.
    public void save() 
    {
        try 
        {   
        	for(InvestmentAssetBean.InvestmentWrapper objWrapper:  investmentAssetBeanInstance.investmentAssetWrapperList)
        	{
        	/* Gaurav (15-5-2013) : To validate entered product name of Mutual fund is available in Mutual fund  product name list   */ 
              if(objWrapper.investmentAsset.Scheme_Name_Text__c != null && objWrapper.investmentAsset.Scheme_Name_Text__c.trim() != '' &&
              			(recordType=='Mutual_Fund') && !(mapTypeToProductNames.get('Mutual Fund').contains('"'+objWrapper.investmentAsset.Scheme_Name_Text__c+'"')))
              {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, '"'+objWrapper.investmentAsset.Scheme_Name_Text__c+'"'+ ' is not valid Scheme name. '+ Label.EditET_Scheme_Name  ));
                return;
              }  
             /* Enf Changes  */
        		
        	}
        	 
        	investmentAssetServicesInstance.save(investmentAssetBeanInstance,recordType,selRecordTypeId,entityId);                   
            summaryTableList = null;
            investmentAssetBeanInstance.investmentAssetWrapperList = null;
            displayPopUp = false;
            accountList = investmentAssetServicesInstance.getFamilyDetails(entityId);
            system.debug('==========accountList=====save======'+accountList);
        }
        catch(ValidationException e) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,e.getMessage()));
        }             
    }
    
    public List<SelectOption> getOwnerItems() 
    {
        investmentAssetBeanInstance.options = investmentAssetServicesInstance.getOwnerItems(entityId,accountList);    
        return investmentAssetBeanInstance.options;
    }  
    
    //This function is called when user clicks remove button
	public void remove()
	{
	    investmentAssetServicesInstance.removeRecords(investmentAssetBeanInstance);                   
 	}  
       
    //Place holder method to update Picklist on edit page.
    public PageReference dummy()
    {
        selectedIndexStr = ApexPages.currentPage().getParameters().get('Index');            
        selectedAMCName = ApexPages.currentPage().getParameters().get('selectedAMCName');               
        return null;
    }
}