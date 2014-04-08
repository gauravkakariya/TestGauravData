public class EventRegistration {

    public String registrationconfirm { get; set; }

    public String contactus { get; set; }
        
        public Lead ld;
        public Registration__c registration;
        public Pagereference pr = Page.EventThankYou;

        public EventRegistration(){
                String id = System.currentPageReference().getParameters().get('Id');
                if(id == null && ld == null){
                        ld = new Lead();
                }
                else if(Id != null && Id != '' && registration == null){
                        registration = [select 
                                            Id,
                                            Name,
                                            Occupation__c,
                                            Street_Name__c,
                                            City__c,
                                            Zip__c,
                                            State__c,
                                            Mobile__c,
                                            Email__c,
                                            Related_to_Contact__c,
                                            Related_to_Lead__c,
                                            Accompanied_by_Spouse__c,
                                            Not_Interested__c,
                                            Registration_Complete__c From Registration__c
                                            where Id =:id];
                }
        }
        
        public Lead getLead(){
                return ld;
        }
        
        public Registration__c getRegistration(){
                return registration;
        }

        public PageReference saveContact(){
        
        User[] userRecord=[select Id from User where Name = 'Ffreedom Marketing Team'];
        if(!userRecord.isEmpty()) {
            ld.OwnerId=userRecord[0].Id; 
        }
        ld.LeadSource = 'Web';
        System.debug('Desc'+ld.Description);
        ld.Description  +=  ', '+'Interested in attending Ffreedom Day';
        insert ld;
        pr.getParameters().put('from', 'contactus');
        pr.getParameters().put('Id', System.currentPageReference().getParameters().get('Id'));
        pr.setRedirect(true);
        registration=null;
        return pr;
        }
        
        public PageReference saveRegistration(){
        	if(registration.Not_Interested__c != null && registration.Not_Interested__c){
        		registration.Not_Interested__c = false;
        	}
	        registration.Registration_Complete__c = true;
	        update registration;
	        pr.getParameters().put('from', 'registrationconfirm');
	        pr.getParameters().put('Id', System.currentPageReference().getParameters().get('Id'));
	        pr.setRedirect(true);
	        registration=null;
	        return pr;
        }
}