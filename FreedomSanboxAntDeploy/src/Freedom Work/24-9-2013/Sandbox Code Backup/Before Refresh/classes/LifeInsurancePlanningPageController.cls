/**
 * @Author: Samruddhi P
 * @since : 18th Feb 2011
 * @Description: LifeInsurancePlanningController is controller class for LifeInsurancePlanningPage in Analysis Section
 */
 
/*
 	Revision History:
	Version     Version Author     Date       		 Comments
*    1.0        Samruddhi P		   18th Feb 2011	 LifeInsurancePlanningController is controller class for LifeInsurancePlanningPage
													 in Analysis Section

*	 2.0		Manasi Ranade	   23/05/2011		 Fetched current Adjustment_Factor__c from database for current entity and 
													 assigned it to the property 'selAdjustmentFactor' in a constructor
     
	 2.0 		Manasi Ranade	   01/06/2011 	 	 Added a method CheckIsEarningMember() in the constructor of the 
				  									 LifeInsurancePlanningPageController class which fetches Earning_Member__c from 
				  									 database to display it on the form
	 
	 2.0 		Manasi Ranade	   02/06/2011 	 1. Added following properties: 
							  							Parent:Holds Parent entity ,
														ChildSpouce:Holds Spouse ,
														ChildSpoucePrincipalAmount :holds Liabilities of child spouce ,
														ParentPrincipalAmount : holds Liabilities of parent entity
													 
													 2.	Assigned default values to Parent,ChildSpouce and 
													    liabilitiesTotal of Parent and its spouce entity is fetched in constructor.	
													    
													 3. Added liabilitiesTotal of parent entity and spouce entity and assigned it to bean.liabilitiesTotal
													    in calculate() function.		
	2.0			Manasi Ranade		06/07/2011		 Issue Id :F0071 :
													 Change in constructor LifeInsurancePlanningPageController and Calculate() function : 
													 1. Calculations related to F0005 are commented from  this page and placed them in 
													 	LifeInsurancePlanningServices class
						  							 2. LifeInsurancePlanningServices class is common for both Life Insurance planning page and for generate plan 												    									 
	2.0			Manasi Ranade		07/05/2012		 Issue Id :00001616 : Code to Find out the Dependent / Spouse entities												  
*/
/*

*/
public class LifeInsurancePlanningPageController
{
	/* Refactoring using HLVDetails object */
	public HLVDetails__c objHLVDetail {get;set;}
	public Remarks__c objRemark {get;set;}
    public String entityId {get; set;}
    
    public list<Account> allFamilyMembersTest;
    public List<HLVDetails__c> lstHLVDetails;
    //Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
	
    public String selectedEntityId 
    {
        get
        {
            if(selectedEntityId == null)
                selectedEntityId = ApexPages.currentPage().getParameters().get('EntityId');
            return selectedEntityId;   
        }
        set;
    }
    
    public String selAdjustmentFactor 
    {
        get
        {
            if(selAdjustmentFactor == null)
                selAdjustmentFactor = '-100';
            return selAdjustmentFactor;
        }
        set;
    } 
    public Account entity  
    {
        get
        {
            for(Account account : entities)
            {
                if(account.Id == selectedEntityId)
                    entity = account;
            }
            
            return entity;
        }
        set;
    }
   
    /** Eternus Solutions      **/
	/** Author  : Manasi Ranade*/
	/** Issue Id: F0005      **/
	/** Date    : 02/06/2011 **/
	/** Purpose : Added following properties: 
				  Parent:Holds Parent entity ,
				  ChildSpouce:Holds Spouse ,
				  ChildSpoucePrincipalAmount :holds Liabilities of child spouce ,
				  ParentPrincipalAmount : holds Liabilities of parent entity**/
	/****************************************************/
	public Account Parent {get;set;}
	public Account ChildSpouce {get;set;}
	
	public Double ChildSpoucePrincipalAmount {get;set;}
 	public Double ParentPrincipalAmount {get;set;}
    /*00001616 Code to select Spouce entity: 
    	1. If Relationship_to_Entity__pc is 'Wife or 'Husband' that will be a spouce Entity
    	2. Else take the value of Dependent__c from Parent Entity as a spouce Entity
    	3. Created Map that will contain Entity Vs Dependent Account
    */
    public Map<Id,Account> AccountVsDependentMap;
    
    public Account spouse
    {
        get
        {
            Account parentEntity;
            //00001616 Added Dependet Code to Find Dependent Entity If Spouce Entity is not present
            Id dependentId; 
            Boolean flag = false;
            if(entities != null)
            {
                for(Account account : entities)
                {
                    if((account.Relationship_to_Entity__pc == Label.Wife || account.Relationship_to_Entity__pc == Label.Husband) 
                       	 && account.Parent_Entity__c==entity.Id)
                    {
                    	spouse = account;
                    	flag = true;
                    }
                    /*if((account.Relationship_to_Entity__pc == 'Mother' || account.Relationship_to_Entity__pc == 'Father') 
                       	 )//&& account.Parent_Entity__c==entity.Id)
                    {
                    	system.debug('Father-mother=============='+account);
                    	spouse = account;
                    	flag = true;
                    }*/
                    if(account.Parent_Entity__c == null )
                    {
                        parentEntity = account;
                    }
                    /*if(account.Dependent__c != null)
                    	dependentId = account.Dependent__c;*/
                }
            }
            //Original
            /*if(flag==false)
                spouse = parentEntity;*/
			/*if(flag==false)
            {
             	if(dependentId != null)
             	{
                	for(Account account:entities)
                	{
                		if(dependentId == account.Id)
                		{
                			spouse = account;
							break;                			
                		}
                	}
             	}
            }*/
            return spouse;
        }
        set;
    }
    public List<Account> entities 
    {
        get
        {
            if(entities==null)
                entities=new List<Account>();
            return entities;
        }
        set;
    }
    public LifeInsurancePlanningServices service;
    public List<LifeInsurancePlanningBean> beanSummary 
    {
        get{
            if(beanSummary == null)
                beanSummary = new List<LifeInsurancePlanningBean>();
            return beanSummary;
        }
        set;
    }
    public LifeInsurancePlanningBean bean 
    {
         get
         {
            if(bean == null)
                bean = new LifeInsurancePlanningBean();
            return bean;
		 }
		 set;
    }
    public Insurance__c insurance 
    {
        get
        {
            if(insurance==null)
            {
                insurance = new Insurance__c();
                insurance.RecordTypeId = (InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c).substring(0,15);
                insurance.Policy_Type__c =Label.Term_Life; 
                //insurance.Policy_Type__c =Label.Term_Life; 
            }
            return insurance;
        }
        set;
    } 
    public Boolean includeInDoc
    {
        get
        {
            if(includeInDoc==null)
                includeInDoc=false;
            return includeInDoc;
        }
        set;
    }
    /** Eternus Solutions       **/
	/** Author  : Manasi Ranade **/
	/** Issue Id: 00001597     	**/
	/** Date    : 17/04/2012 	**/
	/** Purpose : Created Map of entity vs its remark record.
	/****************************************************/ 
    public Map<Id,Remarks__c> entityRemarkMap;

    /**
    * @Description: Constructor to initialise the bean class,service class and fetch existing data
    * @param: None 
    */
    public LifeInsurancePlanningPageController()
    {
        try
        {
        	entityRemarkMap = new Map<Id,Remarks__c>();
        	entityId = ApexPages.currentPage().getParameters().get('EntityId');
        	system.debug('**********entityId******'+entityId);
        	//Code Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   			isDisplaySaveButton = true;
   			
            if(entityId != null)
            {
            	//List<HLVDetails__c> lst = getHLVEntityDetails(entityId);
            	lstHLVDetails = getHLVEntityDetails(entityId);
            	system.debug('**********lstHLVDetails**in constructor****'+lstHLVDetails);
            	//Added Code on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
			    User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
			    if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
			    {
			    	isDisplaySaveButton = false;
			    }	
        		if(lstHLVDetails != null && lstHLVDetails.size() > 0)
        			objHLVDetail = lstHLVDetails[0];
        			
            	service = new LifeInsurancePlanningServices();
				//00001556 Copied selected list to the allAccounts list and added that to getRelatedEntities function 
                /*List<Account> allFamilyMembersTest = entities = service.getRelatedEntities(entityId);
                List<Account> allFamilyMembers = new List<Account>();
                
                for (Account account : allFamilyMembersTest) {
                	if((account.Relationship_to_Entity__pc == Label.Wife || account.Relationship_to_Entity__pc == Label.Husband) 
                       	 && account.Parent_Entity__c==entity.Id)
                    {
                    	spouse = account;
                    	allFamilyMembers.add(account);
                    	//flag = true;
                    }
                    if (account.id == entityId && selectedEntityId != spouse.id)
                        allFamilyMembers.add(account);
                }*/
                
                List<Account> allFamilyMembers = entities = service.getRelatedEntities(entityId); 
                
                allFamilyMembersTest = allFamilyMembers;  
            	/** Eternus Solutions  **/
			    /** Author  : Manasi Ranade	**/
			    /** Issue Id: 00001616      **/
			    /** Date    : 07/05/2012 	**/
			    /** Purpose : Code to find out the Dependent entity**/
			    /****************************************************/
	            AccountVsDependentMap = new Map<Id,Account>();
	            Map<Id,Account> idAccountMap = new Map<Id,Account>(); 
	            for(Account accObj: allFamilyMembers)
	            {
	            	if(idAccountMap.get(accObj.id) == null)
	            		idAccountMap.put(accObj.id,accObj);
	            }
	            //16 th Aug Manasi
	            String currentAdjustmentFactor;
	            if(idAccountMap != null && idAccountMap.containskey(entityId))
	            {
	            	Account currentAccount = idAccountMap.get(entityId);
	            	system.debug('currentAccount=============='+currentAccount);
	            	if(currentAccount != null)
	            		currentAdjustmentFactor = currentAccount.Adjustment_Factor__c;
	            }
	            system.debug('allFamilyMembers---->'+allFamilyMembers);
	            for(Account accObj: allFamilyMembers)
	            {
	            	if(AccountVsDependentMap.get(accObj.id) == null)
	            	{
	            		if(spouse != null && accObj.Parent_Entity__c == null)
	            		{
	            			system.debug('accObj.id=============='+accObj.id);
	            			AccountVsDependentMap.put(accObj.id,spouse);
	            		}
	            		else 
	            		{
	            			if(accObj.Dependent__c != null)
		            		{
		            			if(idAccountMap.get(accObj.Dependent__c) != null)
		            			{
		            				system.debug('idAccountMap=============='+idAccountMap);
									Account dependentAcc = idAccountMap.get(accObj.Dependent__c);
									system.debug('dependentAcc=============='+dependentAcc);
									if(dependentAcc != null)
										AccountVsDependentMap.put(accObj.id,dependentAcc);
		            			}            			
		            		}
		            		/*else 
		            		{
		            			if(idAccountMap.get(accObj.Dependent__c) != null)
		            			{
		            				system.debug('idAccountMap====else=========='+idAccountMap);
									Account dependentAcc = idAccountMap.get(accObj.Dependent__c);
									system.debug('dependentAcc=======else======='+dependentAcc);
									if(dependentAcc != null)
										AccountVsDependentMap.put(accObj.Dependent__c,dependentAcc);
		            			}    
		            		} */
	            		}
	            	}
	            }
	            system.debug('AccountVsDependentMap=============='+AccountVsDependentMap);
	            
	            if(AccountVsDependentMap != null && AccountVsDependentMap.get(entityId) != null)
	            {
		            spouse = AccountVsDependentMap.get(entityId);
		            system.debug('AccountVsDependentMap=====spouse========='+spouse);
	            }    
            	//Start :Manasi 
            	/** Eternus Solutions       **/
				/** Author  : Manasi Ranade **/
				/** Issue Id: F0004         **/
				/** Date    : 24/05/2011    **/
				/** Purpose : Fetched current Adjustment_Factor__c from database for current entity and 
							  assigned it to the property 'selAdjustmentFactor' **/
				/****************************************************/
            	//String currentAdjustmentFactor = [SELECT Adjustment_Factor__c FROM Account WHERE Id =: entityId][0].Adjustment_Factor__c;
            	/** Eternus Solutions       **/
				/** Author  : Manasi Ranade **/
				/** Issue Id: 00001597     	**/
				/** Date    : 17/04/2012 	**/
				/** Purpose : commented original code.Created Map of entity vs its remark record.
				/****************************************************/ 
            	/*list<Remarks__c> lstRemark = [select Remark__c from Remarks__c where entity__c =:entityId and recordtype.Name=:'LifeInsurancePlanning' limit 1];
            	if(lstRemark != null && lstRemark.size() > 0)
            		objRemark = lstRemark[0];
            	else
            		objRemark = new Remarks__c();
            	*/
            	DatabaseSOQL objSOQL = new DatabaseSOQL();
				List<Account> lstFamilyMembers = objSOQL.getFamilyDetails(entityId);
				Set<Id> familyMembersID = new Set<Id>();
				for(Account objAccount : lstFamilyMembers)
				{
					familyMembersID.add(objAccount.Id);
				}
				for(Remarks__c objRemark : [select Entity__c,Remark__c from Remarks__c where entity__c 
											IN : familyMembersID and recordtype.Name =: 'LifeInsurancePlanning'])
            	{
            		if(entityRemarkMap.get(objRemark.entity__c) == null)
            			entityRemarkMap.put(objRemark.entity__c,objRemark);
            	}
				if(entityRemarkMap.get(entityId) != null)
				{
					objRemark = entityRemarkMap.get(entityId);
				}
				else
					objRemark = new Remarks__c();
					
            	if(currentAdjustmentFactor != null && currentAdjustmentFactor != '')
            		selAdjustmentFactor = currentAdjustmentFactor;
            	else
            		selAdjustmentFactor = '-100';
            	
            	//End of Issue Id: F0004  
                
                /*Id: FS0281: Added last parameter to the function.
                That will be true if function is called from LI page else if it is called from generatePDF it will be false*/
                
                beanSummary = service.getDataForAllEntities(entities,allFamilyMembers);
                
               	// Bean is getting created and filled by following method 
                bean = service.calculateValue(entity,spouse,selAdjustmentFactor,beanSummary);
                system.debug('****bean***in calcualte value****'+bean);
                //Calculate Present value
               	bean.income.presentValue = FinancialUtil.CalculateContinuingIncomeSources(spouse.Id,entityId);
                system.debug('****bean***after calcualte value****'+bean);
                Insurance__c insuranceObj = service.getInsurance(entity.Id);
                if(insuranceObj!=null)
                    insurance=insuranceObj;
                
                /** Eternus Solutions      **/
				/** Author  : Manasi Ranade**/
				/** Issue Id: F0025        **/
				/** Date    : 01/06/2011     **/
				/** Purpose : Added a method CheckIsEarningMember() in the constructor of the 
							  LifeInsurancePlanningPageController class which fetches Earning_Member__c from 
							  database to display it on the form **/
				/****************************************************/
                Boolean blnEarningMember = CheckIsEarningMember(entityId);
                if(blnEarningMember)
                	includeInDoc = true;
                else
                	includeInDoc = false;
                //Manasi F0005
                /** Eternus Solutions      **/
				/** Author  : Manasi Ranade*/
				/** Issue Id: F0005      **/
				/** Date    : 02/06/2011 **/
				/** Purpose : Assigned default values to Parent,ChildSpouce **/
				/****************************************************/
                if(entity != null)
                	Parent = entity;
                if(spouse != null)
                	ChildSpouce = spouse;
                
                /** Eternus Solutions      **/
				/** Author  : Manasi Ranade*/
				/** Issue Id: F0005      **/
				/** Date    : 02/06/2011 **/
				/** Purpose : liabilitiesTotal of Parent and its spouce entity is fetched and assigned to ParentPrincipalAmount
				 and ChildSpoucePrincipalAmount respectively  **/
				/****************************************************/
                /** Eternus Solutions       **/
				/** Author  : Manasi Ranade **/
				/** Issue Id: F0071      	**/
				/** Date    : 06/07/2011 	**/
				/** Purpose : 1. Commented following code, as this calculation is placed in LifeInsurancePlanningServices class
							  2. LifeInsurancePlanningServices class is common for both Life Insurance planning page and for generate plan  
				/****************************************************/	
               /* if(Parent.Id != ChildSpouce.Id)
                {
	                LifeInsurancePlanningBean objChildSpouce = new LifeInsurancePlanningBean();
	                objChildSpouce = service.calculateValue(ChildSpouce,parent,selAdjustmentFactor,beanSummary);
	                ChildSpoucePrincipalAmount = objChildSpouce.liabilitiesTotal;
	                
	                LifeInsurancePlanningBean objParentSpouce = new LifeInsurancePlanningBean();
	                objParentSpouce = service.calculateValue(parent,ChildSpouce,selAdjustmentFactor,beanSummary);
	                ParentPrincipalAmount = objParentSpouce.liabilitiesTotal;
	                
	                if(entity.Id == Parent.id || entity.Id == ChildSpouce.Id)
	                {
	                	bean.liabilitiesTotal = ChildSpoucePrincipalAmount + ParentPrincipalAmount;
	                }
                }*/
            }
            //bean
            //Please REMOVe
            //FS0309
        }
        catch(system.exception e){
             System.debug('=====Controller Constructor Exception======'+e.getMessage());
        }
    }
    //FS0245 , FS0281
    //Moved this method from this clss to FinancialUtil 
    /*public Double CalculateContinuingIncomeSources(String strSpouceID)
    {
    	Double dblPresentValue = 0;
    	try
    	{
    		 List<Income__c> objIncomeListspouce = [select Income_Amount__c,Frequency__c,Income_Growth_Rate__c,End_Year__c from Income__c where RecordTypeId=:'01220000000HYzeAAG' 
                									and Entity__c=:strSpouceID];
                Double TotalIncomeOfSpouce = 0; //A
                Double SalGrowthRateOfSpouce = 0; //g
                Integer EndYearSpouce = 0 ; //n
                String strEndyear = '0';
                for(Income__c objIncome : objIncomeListspouce)
                {
                	if(objIncome.Frequency__c.equals('Annual'))
                	{
                		TotalIncomeOfSpouce = TotalIncomeOfSpouce + (objIncome.Income_Amount__c);
                	}
                	else if(objIncome.Frequency__c.equals('Quarterly'))
                		TotalIncomeOfSpouce = TotalIncomeOfSpouce + (objIncome.Income_Amount__c * 4);
                	else if(objIncome.Frequency__c.equals('Half-Yearly'))
                		TotalIncomeOfSpouce = TotalIncomeOfSpouce + (objIncome.Income_Amount__c * 2);
                	else if(objIncome.Frequency__c.equals('Monthly'))
                		TotalIncomeOfSpouce = TotalIncomeOfSpouce + (objIncome.Income_Amount__c * 12);
                	else if(objIncome.Frequency__c.equals('Quarterly, Monthly'))
                		TotalIncomeOfSpouce = TotalIncomeOfSpouce + (objIncome.Income_Amount__c * 12);
                	SalGrowthRateOfSpouce = objIncome.Income_Growth_Rate__c;
                	if(objIncome.End_Year__c != null)
                	{
                		strEndyear = objIncome.End_Year__c;
                	}
                }
                EndYearSpouce = Integer.valueOf(strEndyear);
                Integer iRetirementYear = 0;
                if(EndYearSpouce - Date.today().year() > 0)
                 iRetirementYear = EndYearSpouce - Date.today().year(); //n
                
                
                DatabaseSOQL objSOQL = new DatabaseSOQL();
                Entity_Global_Assumption__c objGlobalAssumption = objSOQL.getEntityGlobalAssumption(entityId);
                Double dblRateOnInvestment = 9;
                if(objGlobalAssumption.Expected_Return_on_Investment__c != null)
                	dblRateOnInvestment = objGlobalAssumption.Expected_Return_on_Investment__c;//i
                
                
                if(dblRateOnInvestment == SalGrowthRateOfSpouce)
                {
                	dblPresentValue = (TotalIncomeOfSpouce * EndYearSpouce)/(1 + dblRateOnInvestment);
                }
                else
                {
                	//Previous Formula
                	//dblPresentValue = (TotalIncomeOfSpouce/dblRateOnInvestment-SalGrowthRateOfSpouce)*(1-((1+SalGrowthRateOfSpouce)/(1+dblRateOnInvestment))*iRetirementYear);
                	Double dblBase = (1+SalGrowthRateOfSpouce)/(1+dblRateOnInvestment);
                	Double dblPower = iRetirementYear;
                	dblPresentValue = (TotalIncomeOfSpouce/(dblRateOnInvestment-SalGrowthRateOfSpouce))*(1-(Math.Exp(dblPower * Math.Log(dblBase))));
                }
                
                bean.income.presentValue = dblPresentValue;
                
    	}
    	catch(system.exception e){
             System.debug('=====CalculateContinuingIncomeSources##======'+e.getMessage());
        }
        return dblPresentValue;
    }*/
    
    /** Eternus Solutions      **/
	/** Author  : Manasi Ranade**/
	/** Issue Id: F0025        **/
	/** Date    : 01/06/2011     **/
	/** Purpose : Added a method CheckIsEarningMember() in the constructor of the 
				  LifeInsurancePlanningPageController class which fetches Earning_Member__c from 
				  database to display it on the form**/
	/****************************************************/
    private Boolean CheckIsEarningMember(string entityId)
    {
    	Boolean blnEarningMember = [SELECT Earning_Member__c FROM Account WHERE Id =: entityId][0].Earning_Member__c;
    	return blnEarningMember;
    }
    /**
    * @getEntityPicklist() function returns picklist for selection of entity
    * @params:None
    * @Return Type:List<SelectOption>
    */   
    public List<SelectOption> getEntityPicklist(){
        List<SelectOption> options = new List<SelectOption>();
        for(Account account: entities){
            options.add(new SelectOption(account.Id,account.Name));
        }    
        return options;
    }

    /**
    * @getAdjustmentFactor() function returns values of Ajustment factor from account
    * @params:None
    * @Return Type:List<SelectOption>
    */    
    public List<SelectOption> getAdjustmentFactor(){
        return service.getAdjustmentFactor();
    }
    
    /**
    * @Calculate() function is used to perform calculations for selected entity using selected adjustment factor
    * @params:None
    * @Return Type:void
    */
    public void Calculate(){
    		/** Eternus Solutions       **/
			/** Author  : Manasi Ranade **/
			/** Issue Id: 00001597     	**/
			/** Date    : 17/04/2012 	**/
			/** Purpose : Fetch the Insurance of the selected entity.
			/****************************************************/ 
			system.debug('****selectedEntityId********'+selectedEntityId);
	        Insurance__c insuranceObj = service.getInsurance(selectedEntityId);
            if(insuranceObj!=null)
                insurance = insuranceObj;
            else
            	insurance = new Insurance__c();
	        //FS0281
	        includeInDoc = CheckIsEarningMember(selectedEntityId);
	        
	        if(insuranceObj!=null)
	            insurance=insuranceObj;
            system.debug('****insurance*****in calculate***'+insurance);
            /** Eternus Solutions      **/
			/** Author  : Manasi Ranade*/
			/** Issue Id: F0005      **/
			/** Date    : 02/06/2011 **/
			/** Purpose : 1. Added liabilitiesTotal of parent entity and spouce entity and assigned it to bean.liabilitiesTotal
						  Meaning of conditions :
						  entity.Id == ChildSpouce.Id : If selected entity from dropdown is Child spouse
						  Parent.Id != ChildSpouce.Id : If Parent entity does not contains any child entity Parent.Id 
						  				and ChildSpouce.Id contains same entity
						  entity.Id == Parent.Id : If selected entity from dropdown is Parent entity
						  
						  2. Meaning of following If Condition is : If Selected entity is Child spouce or Parent entity 
						  	 having atleast one child entity **/
						  
			/****************************************************/
		    /** Eternus Solutions       **/
			/** Author  : Manasi Ranade **/
			/** Issue Id: F0071      	**/
			/** Date    : 06/07/2011 	**/
			/** Purpose : 1. Commented following code, as this calculation is placed in LifeInsurancePlanningServices class
						  2. LifeInsurancePlanningServices class is common for both Life Insurance planning page and for generate plan  
			/****************************************************/	
	      /*  if((entity.Id == ChildSpouce.Id && Parent.Id != ChildSpouce.Id) || (entity.Id == Parent.Id && Parent.Id != ChildSpouce.Id)) //check if it is child spouce entity
	        {
	            //ChildSpoucePrincipalAmount
	            //ParentPrincipalAmount
	            bean=service.calculateValue(entity,spouse,selAdjustmentFactor,beanSummary); //Exceprtion is from here
	            bean.liabilitiesTotal = ChildSpoucePrincipalAmount + ParentPrincipalAmount;
	            
	        }
	        else*/
	        /** Eternus Solutions  **/
			  /** Author  : Manasi Ranade	**/
			  /** Issue Id: 00001616      **/
			  /** Date    : 07/05/2012 	**/
			  /** Purpose : Choose Dependent of selected Entity**/
			  /****************************************************/
	        if(AccountVsDependentMap != null)
	        {
	        	if(AccountVsDependentMap.get(entity.id) != null)
	        	{
					spouse = AccountVsDependentMap.get(entity.id);
	        	}
	        	else
	        	{
	        		spouse = null;
	        	}
	        }
	        //Original code
	        //bean=service.calculateValue(entity,spouse,selAdjustmentFactor,beanSummary); //Exceprtion is from here
	        system.debug('spouse----->'+spouse);
	        
	        /*  FP Changes - 16-3-2013 */
	        List<Account> allFamilyMembersA = new List<Account>();
	        
	        if(AccountVsDependentMap.get(entity.id) != null)
	        {
                for (Account account : allFamilyMembersTest) 
                {
                    if (spouse != null && spouse.id == account.id)   	 
                    {
                    	allFamilyMembersA.add(account);
                    } 
                    else if (account.id == entityId && spouse != null
                    		 &&(account.Relationship_to_Entity__pc == Label.Wife || account.Relationship_to_Entity__pc == Label.Husband) )
                    {
                        allFamilyMembersA.add(account);
                    }
                    if(account.Dependent__c == null && account.id != entityId)
                    {
                    	system.debug('######################->'+allFamilyMembersA);
                    }
                    
                }
                //List<LifeInsurancePlanningBean> beanSummaryTest = service.getDataForAllEntities(entities,allFamilyMembersA);
                
                List<LifeInsurancePlanningBean> beanSummaryTest = service.getDataForAllEntities(entities,allFamilyMembersA);
		        bean = service.calculateValue(entity, spouse, selAdjustmentFactor, beanSummaryTest);
		        system.debug('********bean in if*******'+bean);
		        system.debug('********beanSummaryTest****'+beanSummaryTest);
		        
		        //bean = service.calculateValue(entity, spouse, selAdjustmentFactor, beanSummary); //Exceprtion is from here
		        //FS0245
	              /*  List<Income__c> objIncomeListspouce = [select Income_Amount__c,Frequency__c,Income_Growth_Rate__c,End_Year__c from Income__c where RecordTypeId=:'01220000000HYzeAAG' 
	                									and Entity__c=:spouse.Id];
	                Double TotalIncomeOfSpouce = 0; //A
	                Double SalGrowthRateOfSpouce = 0; //g
	                Integer EndYearSpouce = 0 ; //n
	                String strEndyear = '0';
	                for(Income__c objIncome : objIncomeListspouce)
	                {
	                	if(objIncome.Frequency__c.equals('Annual'))
	                	{
	                		TotalIncomeOfSpouce = TotalIncomeOfSpouce + (objIncome.Income_Amount__c);
	                	}
	                	else if(objIncome.Frequency__c.equals('Quarterly'))
	                		TotalIncomeOfSpouce = TotalIncomeOfSpouce + (objIncome.Income_Amount__c * 4);
	                	else if(objIncome.Frequency__c.equals('Half-Yearly'))
	                		TotalIncomeOfSpouce = TotalIncomeOfSpouce + (objIncome.Income_Amount__c * 2);
	                	else if(objIncome.Frequency__c.equals('Monthly'))
	                		TotalIncomeOfSpouce = TotalIncomeOfSpouce + (objIncome.Income_Amount__c * 12);
	                	else if(objIncome.Frequency__c.equals('Quarterly, Monthly'))
	                		TotalIncomeOfSpouce = TotalIncomeOfSpouce + (objIncome.Income_Amount__c * 12);
	                	SalGrowthRateOfSpouce = objIncome.Income_Growth_Rate__c;
	                	if(objIncome.End_Year__c != null)
	                	{
	                		strEndyear = objIncome.End_Year__c;
	                	}
	                }
	                EndYearSpouce = Integer.valueOf(strEndyear);
	                Integer iRetirementYear = 0;
	                if(EndYearSpouce - Date.today().year() > 0)
	                 iRetirementYear = EndYearSpouce - Date.today().year(); //n
	                
	                
	                DatabaseSOQL objSOQL = new DatabaseSOQL();
	                Entity_Global_Assumption__c objGlobalAssumption = objSOQL.getEntityGlobalAssumption(entity.Id);
	                Double dblRateOnInvestment = 9;
	                //if
	               
	                if(objGlobalAssumption != null)
	                	if(objGlobalAssumption.Expected_Return_on_Investment__c != null)
	                		dblRateOnInvestment = objGlobalAssumption.Expected_Return_on_Investment__c;//i
	                else
	                {
	                	objGlobalAssumption = objSOQL.getEntityGlobalAssumption(spouse.Id);
	                	if(objGlobalAssumption != null && objGlobalAssumption.Expected_Return_on_Investment__c != null)
	                	{
	                		dblRateOnInvestment = objGlobalAssumption.Expected_Return_on_Investment__c;//i
	                	}
	                }
	                Double dblPresentValue = 0;
	               if(dblRateOnInvestment == SalGrowthRateOfSpouce)
	                {
	                	dblPresentValue = (TotalIncomeOfSpouce * EndYearSpouce)/(1 + dblRateOnInvestment);
	                }
	                else
	                {
	                	double dblDiff = 0;
	                	if((dblRateOnInvestment-SalGrowthRateOfSpouce) > 0)
	                	{
	                		dblDiff = dblRateOnInvestment-SalGrowthRateOfSpouce;
	                	}
	                	else
	                		dblDiff = SalGrowthRateOfSpouce - dblRateOnInvestment;
	                		double temp = (1+SalGrowthRateOfSpouce)/(1+dblRateOnInvestment);
	                	dblPresentValue = (TotalIncomeOfSpouce/dblDiff)*(1-(((1+SalGrowthRateOfSpouce)/(1+dblRateOnInvestment))*iRetirementYear));
	                }
	                
	                bean.income.presentValue = dblPresentValue;*/
	               //FS0281
	              /** Eternus Solutions  **/
				  /** Author  : Manasi Ranade	**/
				  /** Issue Id: 00001616      **/
				  /** Date    : 07/05/2012 	**/
				  /** Purpose : Commented Original Code**/
				  /****************************************************/
	               //bean.income.presentValue = FinancialUtil.CalculateContinuingIncomeSources(spouse.Id,entityId);
	               bean.income.presentValue = FinancialUtil.CalculateContinuingIncomeSources(spouse.Id,entityId);
	               if(entityRemarkMap.get(selectedEntityId) != null)
	               	objRemark = entityRemarkMap.get(selectedEntityId);
	               else
	               	objRemark = new Remarks__c();
	               	
		        ///Manasi LifeInsurancePlanningBean bean
		        //REMOVe Please
		        //includeInDoc = true;
	        }
	        /* Prajakta - FP changes - 18-03-2013 */
	        else
	        {
	        	  system.debug('********bean in else*******'+bean);
	        	allFamilyMembersA = new List<Account>();
	        	List<LifeInsurancePlanningBean> beanSummaryTest = service.getDataForAllEntities(entities,allFamilyMembersA);
		        bean = service.calculateValue(entity, spouse, selAdjustmentFactor, beanSummaryTest);
	            
	        	LifeInsuranceOuterClass spouseAssumptions = bean.spouseAssumptions;
	        	bean.spouseAssumptions = null;
	        	bean.income = null;
	        }
    }
    
    //FS0309
    private void saveRemark()
	{
		ID RecTypeId = [select id from RecordType where Name= 'LifeInsurancePlanning'][0].id;
    	objRemark.RecordTypeId = RecTypeId;
    	objRemark.Entity__c = entity.Id;
		objRemark.Remark__c = objRemark.Remark__c;
    	Database.Upsertresult Sr = Database.upsert(objRemark);
	}
    /**
    * @output() function is used to redirect to LifeInsuranceOutputPage
    * @params:None
    * @Return Type:pageReference 
    */
    public pageReference output(){
        pageReference pageRef=new pageReference('/apex/LifeInsuranceOutputPage?entityId='+entityId+'&tabname=Financial Planning');
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
    /**
    * @analysis() function is used to redirect to LifeInsurancePlanningPage
    * @params:None
    * @Return Type:pageReference 
    */
    public pageReference analysis(){
        pageReference pageRef=new pageReference('/apex/LifeInsurancePlanningPage?entityId='+entityId+'&tabname=Financial Planning');
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
    /**
    * @save() function saves the suggested insurance for a particular entity
    * @params:None
    * @Return Type:void
    */ 
    public void save()
    {
	     try
	     {
	     	system.debug('*****in controller save *insurance.Entity__c***'+insurance.Entity__c);
             if(insurance.Entity__c!=null)
             {
                 insurance.Suggested_Cover_General_Insurance__c=bean.roundTotalLifeInsRequired;
                 insurance.Death_Benefit_Rs__c = insurance.Suggested_Cover_General_Insurance__c;
             }
             else
             {
            	 /** Eternus Solutions       **/
				 /** Author  : Manasi Ranade **/
				 /** Issue Id: 00001597     	**/
				 /** Date    : 17/04/2012 	**/
				 /** Purpose : Create the Insurance of selected entity.Commented the original code
				 /****************************************************/ 
                 //insurance.Entity__c = entity.Id;
                 insurance.Entity__c = selectedEntityId;
                 insurance.Flag__c = Label.Analysis;
                 insurance.Suggested_Cover_General_Insurance__c=bean.roundTotalLifeInsRequired;
                 insurance.Death_Benefit_Rs__c = insurance.Suggested_Cover_General_Insurance__c;
             }
             entity.Adjustment_Factor__c = selAdjustmentFactor;
             entity.Earning_Member__c = includeInDoc;
             service.save(entity,insurance);
            
	          // System.debug('Parent::'+Parent.Name);
	          // System.debug('ChildSpouce::'+ChildSpouce.Name);
	          //FS0309
		      saveRemark();
		      ////////////////////////////Refactoring
	          HLVDetails__c objSelectedHLVDetails;
	          //List<HLVDetails__c> lstHLVDetails = getHLVEntityDetails(selectedEntityId);
	          
              system.debug('******selectedEntityId******'+selectedEntityId);
              lstHLVDetails = getHLVEntityDetails(selectedEntityId);
	          if(lstHLVDetails != null && lstHLVDetails.size() > 0)
	          {
	              objSelectedHLVDetails = lstHLVDetails[0];
	              delete objSelectedHLVDetails;
	              
	          }
	          objSelectedHLVDetails = new HLVDetails__c();
	          objSelectedHLVDetails.Present_Age_in_case_of_Death_A__c = bean.entityAssumptions.detailList[0].amountValue;
	          objSelectedHLVDetails.Normal_Age_of_Retirement_B__c = bean.entityAssumptions.detailList[1].amountValue;
	          double dblWorkingLife = bean.entityAssumptions.detailList[1].amountValue 
	            											- bean.entityAssumptions.detailList[0].amountValue;
			  objSelectedHLVDetails.Working_Life_B_A__c = dblWorkingLife;
			  objSelectedHLVDetails.Present_Age_in_case_of_Death_A_Dependent__c = bean.spouseAssumptions.detailList[0].amountvalue;
	          objSelectedHLVDetails.Normal_Life_Expectancy_B__c = bean.spouseAssumptions.detailList[1].amountvalue;
	          objSelectedHLVDetails.Living_Years_B_A__c = bean.spouseAssumptions.detailList[1].amountvalue - bean.spouseAssumptions.detailList[0].amountvalue;
	          objSelectedHLVDetails.Expected_Return_on_Investments__c = bean.investAssumptions.detailList[0].amountvalue;
	          objSelectedHLVDetails.Expected_Inflation__c = bean.investAssumptions.detailList[1].amountvalue;
	          objSelectedHLVDetails.Expected_Inflation_Adjusted_Return__c = bean.investAssumptions.detailList[2].amountvalue;
	          objSelectedHLVDetails.Selected_Entity_Name__c = entity.Name;
	          objSelectedHLVDetails.Dependent_Entity_Name__c = spouse.Name;
	          objSelectedHLVDetails.Liabilities__c = bean.LiabilitiesTotal;
	          objSelectedHLVDetails.ONE_TIME_FINAL_COSTS_Present_Value__c = bean.LiabilitiesTotal;
	          objSelectedHLVDetails.Yearly_Household_Inevitable_Expenses__c = bean.expense.detailList[0].amountvalue;
	          objSelectedHLVDetails.Adjustment_Factor_Increase_or_Decreas__c = bean.expense.detailList[1].amountvalue;
	          objSelectedHLVDetails.Total_Living_Expenses_Of_Dependant__c = bean.expense.Total;
	          objSelectedHLVDetails.DEPENDENT_NEEDS_Present_Values__c = bean.expense.presentValue;
	          String strGoalDetails = '';
	          //objSelectedHLVDetails.GoalDetails__c = bean.goal.detailList
	          for(Integer iIndex = 0; iIndex < bean.goal.detailList.size(); iIndex++)
	          {
	         	   strGoalDetails += bean.goal.detailList[iIndex].accountName + '::' + bean.goal.detailList[iIndex].amountvalue+ ';;';
	          }
	          //strGoalDetails += bean.goal.detailList.size();
	          objSelectedHLVDetails.GoalDetails__c = strGoalDetails;
	          objSelectedHLVDetails.GOALS_TO_BE_MET_Total__c = bean.goal.total;
	          objSelectedHLVDetails.GROSS_LIFE_INSURANCE_REQUIRED__c = bean.grossLifeInsRequired;
	          objSelectedHLVDetails.entity__c = selectedEntityId;
	          objSelectedHLVDetails.Existing_Life_Insurance_Present_Value__c = bean.existingInsuranceTotal;
	          objSelectedHLVDetails.Continuing_Income_Sources_Present_Value__c = bean.income.PresentValue;
	          String strIncomeDetails = '';
	          for(Integer iIndex = 0; iIndex < bean.income.detailList.size(); iIndex++)
	          {
	              strIncomeDetails += bean.income.detailList[iIndex].accountName + '::' + bean.income.detailList[iIndex].amountvalue+ ';;';
	          }
	          objSelectedHLVDetails.Continuing_Income_Sources_Details__c = strIncomeDetails;
	          String strAssetDetail = ''; 
	          for(Integer iIndex = 0; iIndex < bean.asset.detailList.size(); iIndex++)
	          {
	          	  if((bean.asset.detailList[iIndex].accountName) != 'Mutual Funds')			/*Prajakta - 9-7-2013 - Added condition to avoid null records of Mutual Funds*/
	          	  		strAssetDetail += bean.asset.detailList[iIndex].accountName + '::' + bean.asset.detailList[iIndex].amountvalue+ ';;';
	          }
	          /*String strExistingInvestments ; 
	          for(Integer iIndex = 0; iIndex < bean.asset.detailList.size(); iIndex++)
	          {
           		  strExistingInvestments += bean.asset.detailList[iIndex].accountName + '::' + bean.asset.detailList[iIndex].amountvalue+ ';;';
	          }*/
	          objSelectedHLVDetails.Existing_Investments_Details__c = strAssetDetail;
	          objSelectedHLVDetails.Existing_Investments_Total__c = bean.asset.Total;
	          objSelectedHLVDetails.Additional_Life_Insurance_Required__c = bean.addLifeInsRequired;
	          objSelectedHLVDetails.Round_Off__c = bean.roundTotalLifeInsRequired;
	          objSelectedHLVDetails.Remark__c = objRemark.Remark__c;
	          objSelectedHLVDetails.Premium_Amount_Rs__c = insurance.Premium_Amount_Rs__c;
	          objSelectedHLVDetails.Term_of_Insurance__c = insurance.Tenure_of_Insurance__c;
	          objSelectedHLVDetails.Policy_Type__c = insurance.Policy_Type__c;
	          upsert objSelectedHLVDetails;
	     }
	     catch(System.Exception e)
	     {
	          system.debug('*****in save : error**'+e.getMessage());
	          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
	     }
    }
    ///////////////////////Refactoring
    private List<HLVDetails__c> getHLVEntityDetails(Id entityId)
    {
    	List<HLVDetails__c> lstHLVDetails = [select id,Present_Age_in_case_of_Death_A__c,Normal_Age_of_Retirement_B__c,
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
        									Existing_Investments_Details__c,Existing_Investments_Total__c,Additional_Life_Insurance_Required__c,Round_Off__c
            								from HLVDetails__c where entity__c =: entityId];
        system.debug('******lstHLVDetails in query********'+lstHLVDetails);    								
        return lstHLVDetails;
    }
}