public with sharing class PrintFinancialPlanController {
	public String entity {get; set;}
	public PrintFinancialPlanController(){
		entity = System.currentPageReference().getParameters().get('entityId');
	}
}