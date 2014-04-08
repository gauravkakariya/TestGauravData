public without sharing class SFConvertLeadofPlatformUser
{
    public static void main(){
    
        Database.LeadConvert lc = new database.LeadConvert();
        Lead ld=new Lead(LastName='SF Test',Age__c=26,MobilePhone='01234567',Status='Converted');
        insert ld;
        lc.setLeadId(ld.id);
        lc.setOwnerId('005W0000000eitV'); // Should be a platform user ID
        lc.setConvertedStatus('Converted');
        List<Database.LeadConvert> l=new List<Database.LeadConvert>();
        l.add(lc);
        Database.convertLead(l);
        
    }

}