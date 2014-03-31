public with sharing class RegistrationController {
	
	public Registration__c[] regList;
	
	public RegistrationController(ApexPages.StandardSetController controller ){
		regList = controller.getSelected();
	}

   public PageReference sendInvite(){
   	    for(Registration__c reg: regList){
   	    	reg.Invitation_Sent__c = true;
   	    	//regList.add(reg);
   	    }
   	    update regList;
   	    PageReference pr = new Pagereference('/'+System.currentPageReference().getParameters().get('campaignId'));
   	    return pr;
   }
}