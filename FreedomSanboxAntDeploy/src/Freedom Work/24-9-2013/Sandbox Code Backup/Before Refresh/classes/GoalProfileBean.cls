public class GoalProfileBean {
	
	public  String index{get;set;}
	public Goal_Profile__c goalProfile{get;set;}
	public GoalProfileBean(){
		goalProfile = new Goal_Profile__c();
	}
}