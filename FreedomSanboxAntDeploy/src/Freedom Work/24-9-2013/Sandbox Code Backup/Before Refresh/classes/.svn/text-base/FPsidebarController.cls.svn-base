/**
@description FPsidebarController is controller class for FinincialPlanningSidebarPage
*/
/*
   
   Revision History:
   
Version     Version Author     Date        		Comments
1.0         --                   --             Initial Draft
2.0			Manasi Ranade	   9/08/2012    	Added Code to display Partner Name if selected entity is a Partner Entity	
*/
public with sharing class FPsidebarController extends FPsidebarDispalyLink
{
	//Added this Code to display Partner Name if selected entity is a Partner Entity
	//Partner Portal Manasi
	public Boolean IsPartnerEntity{get;set;}
	//need to comment below
	public String EntityRelatedTo{get;set;}
	public String strBusinessPartner{get;set;}
	public String strVirtualPartner{get;set;}
    private Account acct;
    public String entityId {get;set;}
    public String fpLabel{get;set;}
    public String lblWidth{get;set;}
    public FamilyMemberInfoBean fmBean{get;set;}
    public FamilyMemberInfoService fmInfoService{get;set;}
  	Id  EntityVirtualPartnerId;
  	public Boolean isVirtualPartner{get;set;}
  	//Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
  	
    public FPsidebarController(ApexPages.StandardController stdController) 
    {
    	//Changes by gaurav - to hide link in sidebar 
    	super(Apexpages.currentPage().getParameters().get('entityId'));
    	//Code Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   		isDisplaySaveButton = true;
        fmBean=new FamilyMemberInfoBean();
        fmInfoService=new FamilyMemberInfoService();
        fmInfoService.isCostomerProfile(fmBean);
        this.acct = (Account)stdController.getRecord();
        String accountId;
        if(this.acct.Id == null)
        {
            accountId= Apexpages.currentPage().getParameters().get('entityId');
        }
        else
        {
            accountId = this.acct.Id;
        }
        system.debug('*********accountId:'+accountId);
        Account accInstance=fmInfoService.getEntity(accountId);
        system.debug('*******accInstance*******'+accInstance);
        IsPartnerEntity = false;
     	//Account VirtualEntity = new Account();
        //Partner Portal Manasi
        //Added this Code to display Partner Name if selected entity is a Partner Entity
        if(accInstance != null)
        {
    		IsPartnerEntity  = accInstance.IsCreatedByPartner__c;
    		////need to comment below
    		EntityRelatedTo = accInstance.Related_To__c;
        }	
        if(IsPartnerEntity && accInstance != null && EntityRelatedTo == 'Business Partner')
        {
        	strBusinessPartner = 'Business Partner : ' + accInstance.owner.Name;
        }
        else if(EntityRelatedTo == 'Virtual Partner')
        {
        	isVirtualPartner = true;
        	Account VirtualEntity = [select Id,Name from Account where id =:accInstance.Virtual_Partner__c];
        	strVirtualPartner = 'Virtual Partner : ' + VirtualEntity.Name;
        }
        //IsPartnerEntity
      	if(accInstance != null)
      	{
          	if(accInstance.Parent_Entity__c==null)
          	{
            	this.entityId=accInstance.id;
  			}
         	else
         	{
            	this.entityId=accInstance.Parent_Entity__c;
          	}
      	}
        if(fmBean.isCustomer==false)
        {
            fpLabel = 'Financial Planning';
            lblWidth = '210px';
        }
        else
        {
            fpLabel = '';
            lblWidth = '1130px';
        }    
        
        //Added Code on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	    User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
	    if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
	    {
	    	isDisplaySaveButton = false;
	    }	
    }
    /**
    This function is used to get goals of an entity from database to display it on sidebar under goals section
    */
    public List<Goal__c> getGoals()
    {
        List<Goal__c> gols = new List<Goal__c>();
        if(entityId!=null && entityId != '')
        {
            //gols = [Select Id, Name, Goal_Type__c,Description__c from Goal__c where entity__c =:entityId AND Goal_Type__c != NULL AND Description__c != NULL AND GOAL_START_YEAR__C != NULL AND GOAL_END_YEAR__C != NULL AND Description__c != 'Emergency Fund'];
            gols = [Select Id, Name, Goal_Type__c,Description__c from Goal__c where entity__c =:entityId AND Goal_Type__c != NULL AND Description__c != NULL AND GOAL_START_YEAR__C != NULL AND GOAL_END_YEAR__C != NULL AND Goal_Type__c != 'Emergency Fund'];
        }
        
        /*
		  Updated By : Kiran Patil
		  Updated At : 29-May-2013
		  Summary    : FP changes-part2 - issue 6 
		*/
        if(!gols.isEmpty()) {
	        list<Goal__c> tempaddNewListView = new list<Goal__c>();
        	list<Goal__c> tempaddNewListViewRetirement = new list<Goal__c>();
        	for (Goal__c goal : gols) {
        		if (goal.Goal_Type__c.equalsIgnoreCase('Retirement'))
        		    tempaddNewListViewRetirement.add(goal);
        		else     
        		    tempaddNewListView.add(goal);
        	}
        	gols = new list<Goal__c>();
        	gols.addall(tempaddNewListView);
        	gols.addall(tempaddNewListViewRetirement);
        }
        return gols;        
    }  
}