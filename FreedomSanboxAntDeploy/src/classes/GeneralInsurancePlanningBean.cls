/**
 * @Author: Samruddhi P
 * @since : 18th Feb 2011
 * @Description: GeneralInsurancePlanningBean is bean class for GeneralInsurancePlanningPage in Analysis Section
 */
public class GeneralInsurancePlanningBean{
    public List<Insurance__c> currentMedInsurance{
        get{
            if(currentMedInsurance == null)
                currentMedInsurance = new List<Insurance__c>();
            return currentMedInsurance;
        }
        set;
    }
    public List<Insurance__c> currentAssetInsurance{
        get{
            if(currentAssetInsurance == null)
                currentAssetInsurance = new List<Insurance__c>();
            return currentAssetInsurance;
        }
        set;
    }
    public List<Insurance__c> suggestedMedInsurance{
        get{
            if(suggestedMedInsurance == null)
                suggestedMedInsurance = new List<Insurance__c>();
            return suggestedMedInsurance;
        }
        set;
    }
    public List<Insurance__c> suggestedAssetInsurance{
        get{
            if(suggestedAssetInsurance == null)
                suggestedAssetInsurance = new List<Insurance__c>();
            return suggestedAssetInsurance;
        }
        set;
    }
    public Boolean currentAssetEmptyFlag {get; set;}
    public Boolean currentMedicalEmptyFlag {get; set;}
    public Boolean suggestedAssetEmptyFlag {get; set;}
    public Boolean suggestedMedicalEmptyFlag {get; set;}
    public List<Insurance__c> suggMedList{
        get{
            if(suggMedList==null){
                suggMedList = new List<Insurance__c>();
                for(Insurance__c insurance : suggestedMedInsurance ){
                    if(!GeneralInsurancePlanningBean.isRowEmpty(insurance))
                        suggMedList.add(insurance);
                }
            }
            return suggMedList;
        }
        set;
    }
    public List<Insurance__c> suggAssetList {
        get{
            if(suggAssetList == null){
                suggAssetList = new List<Insurance__c>();
                for(Insurance__c insurance : suggestedAssetInsurance ){
                    if(!GeneralInsurancePlanningBean.isRowEmpty(insurance))
                        suggAssetList.add(insurance);
                }
            }
            return suggAssetList;
        }
        set;
    }
    
    public List<Account> accountList {get; set;}
  
    /**
    * @isRowEmpty() function checks whether row is empty
    * @params:Insurance__c 
    * @Return Type:Boolean
    */
    public static Boolean isRowEmpty(Insurance__c insurance){
        if(insurance.Policy_Type__c==null || insurance.Policy_Type__c=='None')
            if(insurance.Policy_Name__c==null || insurance.Policy_Name__c.trim().equals(''))
                if(insurance.Premium_Amount_Rs__c==null || insurance.Premium_Amount_Rs__c == 0.0)
                    if(insurance.Premium_Frequency__c==null)
                        if(insurance.Sum_Assured_Rs__c==null  || insurance.Premium_Amount_Rs__c == 0.0)
                            return true;
        return false;
    }
    
    
    /**
    * @validate() function validates each row 
    * @params:Insurance__c 
    * @Return Type:None
    */
    public static void validate(Insurance__c insurance) {                                       
        if(insurance.Entity__c== null){
            throw new ValidationException(Label.EntityValidation);                                         
        }
        if(insurance.Policy_Type__c=='None'){
            throw new ValidationException(Label.InsurancePolicyTypeValidation);                                         
        }
        if(insurance.Premium_Amount_Rs__c==null){
            throw new ValidationException(Label.InsurancePremiumAmountValidation);                                         
        }
    }
}