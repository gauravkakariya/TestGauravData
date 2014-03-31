@isTest
private class TestCreateRegistrationTrigger {

    public static testMethod void testCreateRegistration(){
        List<CampaignMember> campList = new List<CampaignMember>();
        //Original Code
        //Campaign cmp = [select Id,EndDate from Campaign where Name='Ffreedom Day'];
        
        //Deployement : manasi
        Campaign cmp = new Campaign(Name = 'Test Campaign');
        upsert cmp;
        Campaign cmp1 = new Campaign(Name = 'Ffreedom Day');
        insert cmp1;
        List<Lead> ldList = new List<Lead>();
        List<Contact> contList = new List<Contact>();
        
        
        for(Integer i=0; i<10; i++){
            Lead newLead = new Lead(FirstName='TestLead', LastName='Testing');
            Contact con = new Contact(FirstName='Test', LastName='Contact');
            ldList.add(newLead);
            contList.add(con);
        }
        insert ldList;
        insert contList;
        
        for(Lead ld: ldList){
            CampaignMember campMem = new CampaignMember(CampaignId = cmp.Id, LeadId=ld.Id);
            campList.add(campMem);
        }
          
        for(Contact con: contList){
            CampaignMember campMem = new CampaignMember(CampaignId = cmp.Id, ContactId=con.Id);
            campList.add(campMem);
        }
        System.debug('***campList***'+campList);
        upsert campList;
       /* for(CampaignMember camp : campList)
        {
        		camp.CampaignId=camp.Id;
        }*/
        Registration__c[] regList = [select Id,Invitation_Sent__c from Registration__c where Campaign__c =:cmp.Id];
        System.debug('***regList***'+regList);
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(regList);
        ssc.setSelected(regList);
        PageReference pr = Page.Registration;
        Test.setCurrentPageReference(pr);
        RegistrationController r = new RegistrationController(ssc);
        r.sendInvite();
        delete campList;
        
    }
}