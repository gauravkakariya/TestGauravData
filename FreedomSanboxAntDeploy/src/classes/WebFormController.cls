/**
* 
* Author:  Ffreedom 
*
* Revision History:
*   Version     Version Author     Date           Comments
*   1.0          Ffreedom       --           Initial Draft
*  2.0      Dipak         05/09/2011    Issue Id : FS0126 : 
                          Changes related to Attachment
  2.0      Manasi         05/09/2011    Issue Id : FS0139 : 
                          Removed Exception From its Testclass
*/        
public class WebFormController  {
        public Lead ld ;
        //public Attachment attachment;
         public PageReference pr = null;
        private List<checkboxes> checkboxesListforContact = new List<checkboxes>();
        private List<checkboxes> checkboxesListforCareers = new List<checkboxes>();
        public String reportTimeValue {get;set;}
        public Attachment attachment{set;get;}
        public String errorMessge;
        public Boolean displayError {get; set;}  
        
        public WebFormController(){
            if(ld == null){
                ld = new Lead();
            }
            if(attachment == null){
              attachment = new Attachment();
            }      
            
            errorMessge = ApexPages.currentPage().getParameters().get('error'); 
                  
        }  
        
        //Show Error on Wellness Thank you page
        public PageReference showError(){
        	
        	if(errorMessge == 'error'){
        		displayError = true;
            	system.debug('****errorMessge'+errorMessge);
            	ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'Sorry, You have already given Freedom Scale Test');
                ApexPages.addMessage(myMsg);
            }
            return NULL; 
        }
               
        public Lead getLead(){
                return ld;  
        }
                  
       public PageReference getPageReference(){     
            pr = Page.ThankYou;
            pr.setredirect(true);
            return pr;
       }  
        
        public PageReference insertContactUsInfo(){ 

            User userRecord=[select Id from User where Name = 'Ffreedom Team'];
            System.debug('****userRecord****'+userRecord);
            if(userRecord!=null){
                ld.OwnerId=userRecord.Id; 
            }
            System.debug('**************');
            ld.FirstName = 'FirstName';
            ld.LastName = 'LastName';
            ld.LeadSource = 'Web';
            addToDescription();
            insert ld;
            System.debug('**************leadinsert'+ld);
            
            List<Campaign> lstCamp = [select Id from Campaign where Name='Website - Contact Us Leads'];
            if(!lstCamp.IsEmpty())
            {
              CampaignMember cmp = new CampaignMember(CampaignId= lstCamp[0].Id, LeadId=ld.Id);
              insert cmp;
              System.debug('**************CampaignMember'+cmp);
            }
            return(getPageReference());
        }
        
        
         public List<SelectOption> getreportTime() {
                        String baseHour = '09:';
                        String baseMinutes = baseHour + '00';
                        List<SelectOption> options = new List<SelectOption>();
                        options.add(new SelectOption(baseMinutes,baseMinutes));
                        for (Integer i =10; i <19 ; i++) {
                            for (Integer j = 15; j <=60 ; j+=15) {
                                if(j == 60 && i!=24){
                                    /*if(i<=9){
                                    baseHour = '0' + i + ':';
                                    baseMinutes = baseHour + '00';
                                    options.add(new SelectOption(baseMinutes,baseMinutes));
                                    }else if (i>9){*/
                                    baseHour =  i + ':' ;
                                    baseMinutes = baseHour + '00';
                                    options.add(new SelectOption(baseMinutes,baseMinutes));
                                   // }
                                }
                                if(j!=60 && i<25){
                                baseMinutes = baseHour + String.valueof(j);
                                options.add(new SelectOption(baseMinutes,baseMinutes));
                                }     
                             }
                        }
                        return options;
                } 
        
        public void addToDescription(){
            String description='';
            for(checkboxes c: checkboxesListforContact){
                if(c.selected == true){
                        description += c.value + ',';
                }
            }
            ld.Description = description;
        }
           
        public void addToPreferredDepartment(){
            String departments='';
            for(checkboxes c: checkboxesListforCareers){                     
                    if(c.selected == true){
                            departments += c.value + ',';
                    }
            }
            ld.PreferredDepartment__c=departments;
        }                 
                           
        public List<checkboxes> getCheckboxesListforContact(){
            if(checkboxesListforContact.isEmpty()){
                    checkboxesListforContact.add(new checkboxes(false, Label.KnowFP, Label.KnowFP));
                   // checkboxesListforContact.add(new checkboxes(false, Label.KnowSF, Label.KnowSF));
                    //checkboxesListforContact.add(new checkboxes(false, Label.GetCFP, Label.GetCFP));
                    //checkboxesListforContact.add(new checkboxes(false, Label.Feed, Label.Feed));
                    //checkboxesListforContact.add(new checkboxes(false, Label.DysFun, Label.DysFun));
                    checkboxesListforContact.add(new checkboxes(false, Label.Partner, Label.Partner));
                    checkboxesListforContact.add(new checkboxes(false, Label.Organize, Label.Organize));
                    checkboxesListforContact.add(new checkboxes(false, Label.Others, Label.Others));
            }
            return checkboxesListforContact;
      } 
        public List<checkboxes> getCheckboxesListforCareers(){
                if(checkboxesListforCareers.isEmpty()){
                        checkboxesListforCareers.add(new checkboxes(false, Label.Financial_Planning, Label.Financial_Planning));
                        checkboxesListforCareers.add(new checkboxes(false, Label.Marketing, Label.Marketing));
                        checkboxesListforCareers.add(new checkboxes(false, Label.Technology, Label.Technology));
                        checkboxesListforCareers.add(new checkboxes(false, Label.Operations, Label.Operations));
                        checkboxesListforCareers.add(new checkboxes(false, Label.Compliance_and_Administration, Label.Compliance_and_Administration));
                        checkboxesListforCareers.add(new checkboxes(false, Label.Others, ''));
                }
                return checkboxesListforCareers;
         } 
              
      public PageReference insertComplConsInfo(){ 
            User userRecord=[select Id from User where Name = 'Ffreedom Team'];
            if(userRecord!=null){
                ld.OwnerId=userRecord.Id; 
            } 
            ld.LeadSource = 'Web';
            ld.Status='Meeting Fixed';
      
            String dateString = String.valueOf(ld.tempReportDate__c);
                     
            Datetime d = datetime.valueOf(dateString + ' '+reportTimeValue+':00');
            
            ld.Appointment_Time__c = d;
            
            Database.Saveresult saveresult = Database.insert(ld);
            
            CampaignMember cmp = new CampaignMember(CampaignId= [select Id from Campaign where Name='Website - Complimentary Consultation Leads' order by CreatedDate ][0].Id, LeadId=ld.Id);
            insert cmp;                         
            return(getPageReference());                     
      }     
          
       public PageReference insertCareersPageInfo() {
            
            User[] userRecord=[select Id from User where Name = 'Analytics Team'];
            error.debuglog('user.............88'+userRecord);
            System.debug('===>Record User===>'+userRecord);
            if(!userRecord.isEmpty()) {
                    ld.OwnerId=userRecord[0].Id;
                    System.debug('===>%$#%$#!@%$#%235===>'+ ld.OwnerId); 
            }
            ld.LeadSource = 'Web';
            ld.Latest_Campaign__c = 'Website - Careers Campaign';
            addToPreferredDepartment();
            Database.Saveresult saveresult = Database.insert(ld);
            System.debug('===>newlead inser$#%#%$#%435===>'+ld);
            if(saveresult.isSuccess()){
              System.debug('===>Attachment code===>');
            if(!Test.isRunningTest())
            {
              //attachment.Body = attachment.Body;
                attachment.ParentId = saveresult.getId();
                //attachment.Name = attachment.Name;
            }
            /** Eternus Solutions       **/
        /** Author  : Manasi Ranade **/
        /** Issue Id: FS0139        **/
        /** Date    : 05/09/2011   **/
        /** Purpose : Removed Exception From Testclass 
        /****************************************************/
            else
            {
              attachment.ParentId = saveresult.getId();
              attachment.Body = Blob.valueOf('Test');
              attachment.Name = 'Test';
            }
            Database.Saveresult sp = Database.insert(attachment);
            
            // When attachment inserted . need to sent a mail with an attachment
            /*<!-- Revision History:
                         *   Version     Version Author        Date           Comments
                         *   1.0          Ffreedom       --           Initial Draft
                         *  2.0          Trupti         22/09/2011    Issue Id : FS0160 : 

                                                   Changes related to Upload Resume 

                */
            if(sp.isSuccess())
            {
               SendEmailFunctionality.sendCVattachment(ld,attachment);
        }
            else
            {
              System.debug('===>Attachments failure===>');
            }
            }  
                     
            CampaignMember cmp = new CampaignMember(CampaignId= [select Id from Campaign where Name='Website - Careers Campaign' order by CreatedDate][0].Id, LeadId=ld.Id);
            insert cmp;
            return(getPageReference());
       }
          
       public class checkboxes{
            public Boolean selected {get;set;}
            public String label {get; set;}
            public String value {get;set;}
            
            public checkboxes(Boolean selected, String label, String value){
                    this.selected = selected;
                    this.label = label;
                    this.value = value;
            }
     
      
            
          
}                      
}