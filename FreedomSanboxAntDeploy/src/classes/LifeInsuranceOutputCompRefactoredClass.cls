public with sharing class LifeInsuranceOutputCompRefactoredClass
{
	public LifeInsurancePlanningBean bean {get; set;}
	public Account entity {get; set;}
	public HLVDetails__c HLVDetails {get; set;}
    public Account spouse {get; set;}
    public Insurance__c objInsurance  {get; set;} 
    public String selAdjustmentFactor {get; set;} 
	public List<Remarks__c> lstRemark {get;set;}
    /**
    * @Description: Constructor to initialise the bean class,service class and fetch existing data
    * @param: None 
    */
    public LifeInsuranceOutputCompRefactoredClass()
    {
    	//Do nothing
    }
	static testMethod void LifeInsuranceOutputCompRefactoredClassTest()
	{
		Test.startTest();
		LifeInsuranceOutputCompRefactoredClass objLifeInsuranceOutputCompRefactoredClass = new LifeInsuranceOutputCompRefactoredClass();
		Test.stopTest();
	}
}