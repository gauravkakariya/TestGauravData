@isTest
private class TestEventRegistration {
    
    public static testMethod void testEventRegistration(){
        /* Create Test Data */
        List<CampaignMember> campMemList = new List<CampaignMember>();
        Lead ld = new Lead(FirstName='test', LastName='Lead');
        insert ld;
        Contact con = new Contact(FirstName='test', LastName='Lead');
        insert con;
        
       // Campaign cmp = [select Id from Campaign where Name='Ffreedom Day'];
        Campaign cmp = new Campaign(Name = 'Ffreedom Day');
		insert cmp;
        CampaignMember cm1 = new CampaignMember(CampaignId=cmp.Id, LeadId=ld.Id);
        campMemList.add(cm1);
        CampaignMember cm2 = new CampaignMember(CampaignId=cmp.Id, ContactId=con.Id);
        campMemList.add(cm2);
        insert campMemList;
        
        /* Initialize page reference and Controller class*/
        Pagereference pr = Page.EventRegistration;
        //Original Code
        //pr.getParameters().put('Id', [select Id from Registration__c where Campaign__c = :cmp.Id and Related_to_Contact__c = :con.Id].Id);
        //Deployment : Aditi Satpute
        Registration__c objReg = new Registration__c(Campaign__c=cmp.Id,Related_to_Contact__c=con.Id);
        insert objReg;
        pr.getParameters().put('Id',objReg.Id);
        Test.setCurrentPageReference(pr);
        EventRegistration eve = new EventRegistration();
        
        /* Scenario 1 - Registration for a Contact*/
        Registration__c regis = eve.getRegistration();
        System.assertEquals(regis.Related_to_Contact__c, con.Id);
        regis.Accompanied_by_Spouse__c = true;
        regis.City__c = 'Mumbai';
        eve.saveRegistration();
        System.assertEquals(regis.Registration_Complete__c, true);
        
        /* Scenario 2 - Registration for a Lead */
      	//Original Code
      	//  pr.getParameters().put('Id',  [select Id from Registration__c where Campaign__c = :cmp.Id and Related_to_Lead__c = :ld.Id].Id);
        //Deployment : Aditi Satpute
        Registration__c objReg1 = new Registration__c(Campaign__c=cmp.Id,Related_to_Lead__c=ld.Id);
        insert objReg1;
        pr.getParameters().put('Id', objReg1.Id);
        eve = new EventRegistration();
        Registration__c regis1 = eve.getRegistration();
        System.assertEquals(regis1.Related_to_Lead__c, ld.Id);
        regis1.Accompanied_by_Spouse__c = true;
        regis1.City__c = 'Mumbai';
        eve.saveRegistration();
        System.assertEquals(regis1.Registration_Complete__c, true);
        
        /* Scenario - Add interested person as Lead */
        pr.getParameters().put('Id', null);
        eve = new EventRegistration();
        Lead led = eve.getLead();
        led.LastName = 'Test';
        eve.saveContact();
        //System.assertEquals(led.Description,'Interested in attending Ffreedom Day');
        
        
    }

}