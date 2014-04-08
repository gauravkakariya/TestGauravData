/**
 * @Author: Samruddhi P
 * @since : 18th Feb 2011
 * @Description: GeneralInsurancePlanningService is service class for GeneralInsurancePlanningPage in Analysis Section
 */
/*

	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         --           	   --	  		Initial Draft
    2.0			Manasi			   19/11/2011	Change in function :getdbRecords:
    											Added Critical Illness, Disability or Personal Accident to the medical section 
    											and changed label from 'Others' to 'Other'
    2.0  		Manasi 			   16/01/2012   Issue Id: 00001449 : Added 'Others' related 'or' condition for Policy Type
    
    2.0  		Mahesh 			   27/04/2012   Case No : 00001611 : 1. Added the picklist : getMedicalPolicyTypeItems() : To show Policy Type picklist in under 
    																 	Suggested Medical Insurancne section on General Insurance Planning Page 
    																 2. Commented below line to allow users to save changed Suggested Policy Type under 
    																 	Medical Insurancne section on General Insurance Planning Page
*/

public class GeneralInsurancePlanningService{
    DatabaseSOQL dbSOQL {get; set;}
    DatabaseDML dbDML {get; set;}

    /**
    * @Description: Constructor to initialise the service class
    * @Parameters: None
    */
    public GeneralInsurancePlanningService(){
        dbSOQL =new DatabaseSOQL();
        dbDML =new DatabaseDML();
    }

    /**
    * @getFamilyDetails() function gets entities related to particular entity
    * @Parameters:id of particular Account (Entity)
    * @Return Type:List<Account>
    */
    public List<Account> getFamilyDetails(String entityId){
    	//00001556 Commented Original Code
		//return dbSOQL.getFamilyDetails(entityId);
		StaticMethodClass.entityId = entityId;
		List<Account> acc = StaticMethodClass.getFamilyDetails;
		Return acc;
    }

    /**
    * @getInsuredItems() function gets picklist values for Insured (Entity__c) on page
    * @Parameters:List<Account>
    * @Return Type:List<SelectOption>
    */
    public List<SelectOption> getInsuredItems(List<Account> accountList){
        List<SelectOption> options = new List<SelectOption>();
        for(Account account : accountList){
            options.add(new SelectOption(account.Id,account.Name));        
        }
        return options;
    }
    
    /**
    * @getPolicyTypeItems() function gets picklist values for Policy Type on page
    * @Parameters:None
    * @Return Type:List<SelectOption>
    */
    public List<SelectOption> getPolicyTypeItems(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.None,Label.NoneOption));        
        options.add(new SelectOption(Label.Vehicle,Label.Vehicle));        
        options.add(new SelectOption(Label.Householder,Label.Householder));    
        options.add(new SelectOption(Label.Others,Label.Others));    
        return options;
    }
    
    /** Eternus Solutions       	**/
	/** Author  : Mahesh Hirugade	**/
	/** Case No : 00001611			**/
	/** Date    : 27/4/2012 		**/
	/** Purpose : Added the picklist : getMedicalPolicyTypeItems() : To show Policy Type picklist in under Suggested Medical Insurancne section on General Insurance Planning Page 
	/****************************************************/
    public List<SelectOption> getMedicalPolicyTypeItems(){
    	List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.None,Label.NoneOption));        
        options.add(new SelectOption(Label.Medical,Label.Medical));        
        //options.add(new SelectOption(Label.Disability,Label.Disability));    	//Commented by - Prajakta - FP Changes - 22-02-2013
        options.add(new SelectOption(Label.Critical_Illness,Label.Critical_Illness));
        options.add(new SelectOption(Label.Personal_Accident,Label.Personal_Accident));
        options.add(new SelectOption(Label.Top_Up,Label.Top_Up));  				//Added by - Prajakta - FP Changes - 22-02-2013
        options.add(new SelectOption(Label.Other,Label.Other));
        return options;
    }

    /**
    * @getdbRecords() function gets the medical and asset insurances records entered in Data Entry wizard
    * @Parameters:id of particular Account (Entity),medicalInsuranceList,assetInsuranceList
    * @Return Type:GeneralInsurancePlanningBean 
    */ 
    public GeneralInsurancePlanningBean getdbRecords(String entityId, GeneralInsurancePlanningBean bean){
        try{
            List<Insurance__c> insuranceResult = dbSOQL.getGenInsuranceValues(entityId,InsuranceRecTypes__c.getInstance(Label.General_Insurance).RecordTypeId__c,Label.Data_Entry);
            if(insuranceResult!=null){
            	//FS0292
                /** Eternus Solutions       **/
				/** Author  : Manasi Ranade **/
				/** Issue Id: FS0292      	**/
				/** Date    : 19/11/2011 	**/
				/** Purpose : Add Critical Illness, Disability or Personal Accident to the medical section and changed label from 'Others' to 'Other'
				/****************************************************/
                /** Eternus Solutions  **/
				/** Author  : Manasi Ranade	**/
				/** Issue Id: 00001449      **/
				/** Date    : 16/01/2012 	**/
				/** Purpose : Added 'Others' related 'or' condition for Policy Type**/
				/****************************************************/
                for(Insurance__c insurance : insuranceResult){
                    if(insurance.Policy_Type__c==Label.Medical || insurance.Policy_Type__c==Label.Disability || insurance.Policy_Type__c==Label.Top_Up //Prajakta - FP Changes - 22-02-2013
                    	|| insurance.Policy_Type__c==Label.Critical_Illness || insurance.Policy_Type__c==Label.Personal_Accident)
                        bean.currentMedInsurance.add(insurance);
                    else if(insurance.Policy_Type__c==Label.Householder || insurance.Policy_Type__c==Label.Vehicle || insurance.Policy_Type__c==Label.Other)
                        bean.currentAssetInsurance.add(insurance);
                }   
            }
            if(bean.currentMedInsurance.isEmpty()){
                Insurance__c insuranceObj=new Insurance__c();
                insuranceObj.Policy_Name__c=Label.NoInsurance;
                bean.currentMedInsurance.add(insuranceObj);
                bean.currentMedicalEmptyFlag = true;
            }
           if(bean.currentAssetInsurance.isEmpty()){
                Insurance__c insuranceObj=new Insurance__c();
                insuranceObj.Policy_Name__c=Label.NoInsurance;
                bean.currentAssetInsurance.add(insuranceObj);
                bean.currentAssetEmptyFlag = true;
            }
            insuranceResult=dbSOQL.getGenInsuranceValues(entityId,InsuranceRecTypes__c.getInstance(Label.General_Insurance).RecordTypeId__c,Label.Analysis);
            if(insuranceResult!=null){
                for(Insurance__c insurance : insuranceResult){
                /** Eternus Solutions       **/
				/** Author  : Manasi Ranade **/
				/** Issue Id: FS0292      	**/
				/** Date    : 19/11/2011 	**/
				/** Purpose : Add Critical Illness, Disability or Personal Accident to the medical section and changed label from 'Others' to 'Other'
				/****************************************************/
                    if(insurance.Policy_Type__c==Label.Medical || insurance.Policy_Type__c==Label.Disability 
                    	|| insurance.Policy_Type__c==Label.Top_Up //Prajakta - FP Changes - 22-02-2013
                    	|| insurance.Policy_Type__c==Label.Critical_Illness || insurance.Policy_Type__c==Label.Personal_Accident)
                        bean.suggestedMedInsurance.add(insurance);
                    else if(insurance.Policy_Type__c==Label.Householder || insurance.Policy_Type__c==Label.Vehicle || insurance.Policy_Type__c==Label.Other || insurance.Policy_Type__c.equalsIgnoreCase('others'))
                        bean.suggestedAssetInsurance.add(insurance);
                }   
            }
            if(bean.suggestedMedInsurance.isEmpty())
                bean.suggestedMedicalEmptyFlag = true;
            if(bean.suggestedAssetInsurance.isEmpty())
                bean.suggestedAssetEmptyFlag = true;
        }
        catch(system.exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
        }        
        return bean;
    }
    
    /**
    * @saveRecords() function saves the medical and asset insurances records
    * @Parameters:id of particular Account (Entity),medicalInsuranceList,assetInsuranceList
    * @Return Type:Boolean
    */ 
    public Boolean saveRecords(String entityId,List<Insurance__c> medicalInsList, List<Insurance__c> assetInsList){
        Boolean isSuccess=true;
        InsuranceBean insuranceBeanObj=new InsuranceBean();
        if(medicalInsList!=null){
            try{
            	System.debug('#### medicalInsList : ' + medicalInsList);
                for(Insurance__c insurance : medicalInsList){
                    /** Eternus Solutions       	**/
					/** Author  : Mahesh Hirugade	**/
					/** Case No : 00001611			**/
					/** Date    : 27/4/2012 		**/
					/** Purpose : Commented below line to allow users to save changed Suggested Policy Type under Medical Insurancne section on General Insurance Planning Page 
					/****************************************************/
                    //insurance.Policy_Type__c= Label.Medical;
                    insurance.Flag__c = Label.Analysis;
                    insurance.Suggested_Cover_General_Insurance__c = insurance.Sum_Assured_Rs__c;
                    insurance.RecordTypeId = InsuranceRecTypes__c.getInstance(Label.General_Insurance).RecordTypeId__c;
                    GeneralInsurancePlanningBean.validate(insurance);
                }
                system.debug('=======Services save======'+medicalInsList);
                dbDML.upsertObject(medicalInsList);
            }
            catch(System.Exception e){
                isSuccess=false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
            }   
        }
        if(assetInsList!=null && entityId!=null){
            try{
                for(Insurance__c insurance : assetInsList){
                    insurance.Flag__c=Label.Analysis;
                    insurance.Suggested_Cover_General_Insurance__c=insurance.Sum_Assured_Rs__c;
                    insurance.RecordTypeId=InsuranceRecTypes__c.getInstance(Label.General_Insurance).RecordTypeId__c;
                    GeneralInsurancePlanningBean.validate(insurance);
                }
                system.debug('=======Services save======'+medicalInsList);
                Error.DebugLog('=======Services save======'+medicalInsList);
                dbDML.upsertObject(assetInsList);
            }
            catch(System.Exception e){
                isSuccess=false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
            }   
        }
        return isSuccess;
    }
}