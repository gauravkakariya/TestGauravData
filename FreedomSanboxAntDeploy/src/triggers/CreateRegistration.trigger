trigger CreateRegistration on CampaignMember (after insert,after delete) {
    List<Registration__c> regList = new List<Registration__c>();
    
    List<Id> leadList = new List<Id>();
    List<Id> contactList = new List<Id>();
    List<Campaign> lstcamp = new List<Campaign>(); 
    Campaign camp = new Campaign();
     
     lstcamp = [select Id,EndDate from Campaign where Name='Ffreedom Day'];
     if(lstcamp.Isempty())
     return;
    
    camp = lstcamp[0];
    
    if(Trigger.isInsert){
        for(CampaignMember cmp: Trigger.new){
            if(cmp.CampaignId == cmp.Id){
                if(cmp.LeadId != null)
                {   
                    leadList.add(cmp.LeadId);
                    
                }
                else {
                    contactList.add(cmp.ContactId);
                    
                }
                
            }
        }
        for(Lead l:[Select 
                        l.Street, 
                        l.State, 
                        l.PostalCode, 
                        l.OwnerId, 
                        l.Occupation__c, 
                        l.Name, 
                        l.MobilePhone, 
                        l.Location__c, 
                        l.Email, 
                        l.Country, 
                        l.Company_Name__c, 
                        l.City,
                        l.Id
                        From Lead l where Id IN :leadList]){
            
            Registration__c reg = new Registration__c();
            reg.Name = l.Name;
            reg.Campaign__c = camp.Id;
            reg.Street_Name__c = l.Street;
            reg.State__c = l.State;
            reg.City__c = l.City;
            reg.Country__c = l.Country;
            reg.OwnerId = l.OwnerId;
            reg.Mobile__c = l.MobilePhone;
            reg.Occupation__c = l.Occupation__c;
            reg.Email__c = l.Email;
            reg.Zip__c = l.PostalCode;
            reg.Related_to_Lead__c = l.Id;
            reg.Event_Date__c = camp.EndDate;
            regList.add(reg);
                            
        }
        for(Contact con: [Select 
                            c.Name, 
                            c.MobilePhone, 
                            c.MailingStreet, 
                            c.MailingState, 
                            c.MailingPostalCode, 
                            c.MailingCountry, 
                            c.MailingCity, 
                            c.Id, 
                            c.Email,
                            c.OwnerId
                            From Contact c where Id IN :contactList]){
                Registration__c reg = new Registration__c();
                reg.Name =con.Name;
                reg.Campaign__c = camp.Id;
                reg.Street_Name__c = con.MailingStreet;
                reg.State__c = con.MailingState;
                reg.City__c = con.MailingCity;
                reg.Country__c = con.MailingCountry;
                reg.OwnerId = con.OwnerId;
                reg.Mobile__c = con.MobilePhone;
                reg.Email__c = con.Email;
                reg.Zip__c = con.MailingPostalCode;
                reg.Related_to_Contact__c = con.Id;
                reg.Event_Date__c = camp.EndDate;
                regList.add(reg);       
        }
        
        insert regList;
    }
    else if(Trigger.isDelete){
        for(CampaignMember cmp:Trigger.old){
            if(cmp.CampaignId == camp.Id){
                if(cmp.LeadId != null)
                {   
                    leadList.add(cmp.LeadId);
                    
                }
                else {
                    contactList.add(cmp.ContactId);
                    
                }
                
            }
        }
        List<Registration__c> delList = [select 
                                            Id, 
                                            Name, 
                                            Campaign__c, 
                                            Related_to_Lead__c, 
                                            Related_to_Contact__c 
                                            from Registration__c where Campaign__c = :camp.Id AND 
                                            (Related_to_Lead__c IN :leadList OR Related_to_Contact__c IN :contactList)];
      delete delList;
        
    }
    
}