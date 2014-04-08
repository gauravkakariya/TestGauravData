/**
* @Description: Bean class to populate the data on generatepdf.page
*/

public class GeneratePDFBean{
    public Account client{get;set;}
    public Account spouse{get;set;}
    public string entityID{get;set;}
    public list<goal__c> goalList{get;set;}
    
     public LifeInsurancePlanningServices insuranceService{get;set;}
    public list<LifeInsurancePlanningBean> insuranceBeanList{get;set;}
    public GeneratePDFBean(){
      insuranceService=new LifeInsurancePlanningServices ();
      goalList=new list<goal__c>();
    }
}