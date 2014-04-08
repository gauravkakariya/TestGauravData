public with sharing class WellnessThankYouController {
    
    
    public string leadId_String{get;set;}
    public string leadScore_String{get;set;}
    public string leadFName_String{get;set;}
    public string leadEmail_String{get;set;}
    public string leadLName_String{get;set;}
    //Constructor
    public WellnessThankYouController(){
        
        Cookie LeadId = ApexPages.currentPage().getCookies().get('LeadId');
        Cookie LeadScore = ApexPages.currentPage().getCookies().get('LeadScore');
        system.debug('****LeadId'+LeadId);
        system.debug('****LeadScore'+LeadScore);
        Cookie leadFName= ApexPages.currentPage().getCookies().get('leadFName');
                
                Cookie leadLName= ApexPages.currentPage().getCookies().get('leadLName');
               
                Cookie leadEmail= ApexPages.currentPage().getCookies().get('leadEmail'); 
                
        LeadId = LeadId == null ? 
            new Cookie('LeadId',null,null,-1,false) : 
            new Cookie('LeadId',LeadId.getValue(),null,-1,false);
            
        LeadScore = new Cookie('LeadScore',LeadScore.getValue(), null, 1440 , false);
        ApexPages.currentPage().setCookies(new Cookie[]{LeadScore});
        leadId_String=LeadId.getValue();
        leadScore_String=LeadScore.getValue();
        leadFName_String=leadFName.getValue();
        leadLName_String=leadLName.getValue();
        leadEmail_String=leadEmail.getValue();
        system.debug('****LeadScore'+LeadScore);
        
                
                
    }
    
    public PageReference sendReport()
    {
                Pagereference pageRef;  
                Blob pageAttachment;
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                string strEntityId=leadId_String;
                string dblFreedomScore=  leadScore_String;
                
                //Set the File Name of generated PDF    
                pageRef = Page.FinancialWellnessReport;
                pageRef.setRedirect(true);
                pageRef.getParameters().put('id',strEntityId);
                pageRef.getParameters().put('value',dblFreedomScore);
                pageRef.getParameters().put('leadFName',leadFName_String);
                pageRef.getParameters().put('leadLName',leadLName_String);
                pageRef.getParameters().put('leadEmail',leadEmail_String);
                
                pageAttachment = pageRef.getContent();
                efa.setFileName('Attachment.pdf');
                efa.setBody(pageAttachment);
                
               
                 
                // Create the email attachment 
                List<String> toAddresses = new List<String>();
                system.debug('****strEntityId'+strEntityId);
               
               
             
                 
                 
                //If Record Id  is Lead
                if(strEntityId!= NULL && strEntityId.substring(0,3).compareTo('00Q') == 0 && strEntityId != ''){
                    
                    // Sets the paramaters of the email
                    if(leadEmail_String != null)
                        toAddresses.add(leadEmail_String);
                        
                        //String[] toBccAddresses = new String[] {'aditi.satpute@eternussolutions.com'};
                        email.setSubject( 'Wellness Test Report of ' + leadFName_String+' '+leadLName_String);     
                        email.setToAddresses( toAddresses );
                        
                   
                        email.setHtmlBody('Dear '+leadFName_String+' '+leadLName_String +Label.Send_Mail_Set_Html_Body_Message);
                        email.setSenderDisplayName(leadFName_String+' '+leadLName_String);
                   
                      
                }   
                else if(strEntityId == NULL || strEntityId == ''){ 
                    
                    // Sets the paramaters of the email
                     if(leadEmail_String != null)
                        toAddresses.add(leadEmail_String);
                        
                        //String[] toBccAddresses = new String[] {'aditi.satpute@eternussolutions.com'};
                        email.setSubject( 'Wellness Test Report of  ' + leadFName_String+' '+leadLName_String);        
                        email.setToAddresses( toAddresses );
                        
                    
                        email.setHtmlBody('Dear '+leadFName_String+' '+leadLName_String +Label.Send_Mail_Set_Html_Body_Message);
                        email.setSenderDisplayName(leadFName_String+' '+leadLName_String);
                   
                }
               
                email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});    
                 
                // Sends the email to Lead or Entity acccording to RecordId
                Messaging.SendEmailResult [] arrResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                system.debug('*****arrResult'+arrResult);
        
        return null;        
    }
    
    public class LeadTest
    {
        public Lead testQuery(string id)
        {
            return [Select Id, Name,Email, FirstName,LastName, MobilePhone, Age__c,
                    Income_Source__c,Occupation__c From Lead Where 
                    Id =:id];
        }
    }
    
    
    
}