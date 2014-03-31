/*
 *@Author: Sandip 
 *@since :09th Feb 2011
 *@Description:ClientMemberDetailsContoller is controller class for Personal Details Landing Page
 */
public class ClientMemberDetailsController{
        public String entityId{get;set;}
        public List<Account> acc {get;set;}
        public List<Client_Details__c> existingAcc {get;set;}
        public List<Client_Details__c> newAcc {get;set;}
        public boolean isNew {get;set;}
        public ClientInfoService ctservice;
        public FamilyMemberInfoService fmservice;
        public ClientInfoBean ctBean;
        public ClientMemberDetailsController(){
           fmservice = new FamilyMemberInfoService();
           ctBean =new ClientInfoBean();
           newAcc = new List<Client_Details__c>();
           existingAcc = new List<Client_Details__c>();
           ctservice = new ClientInfoService();
           acc = new List<Account>();
           isNew = false;
           entityId=Apexpages.currentPage().getParameters().get('entityId');
           List<Client_Details__c> ctListTmp = new List<Client_Details__c>();
           if (entityId!=null && entityId!='') {
                acc = fmservice.getFamilyDetails(entityId);
                ctListTmp = ctservice.getClientFamily(entityId);  
           }
           Map<Id, Client_Details__c>ctmap = new Map<Id, Client_Details__c>();
           for (Client_Details__c ctObj: ctListTmp) {
               ctmap.put(ctObj.Entity__c,ctObj);
           }
           if (acc.size()>0) {
               for (Integer i=0; i<acc.size();i++) {
                    if (ctmap.get(acc[i].Id)!=null) {
                        Client_Details__c tmp = ctmap.get(acc[i].Id);
                        tmp.First_Name__c = acc[i].FirstName;
                        tmp.Last_Name__c = acc[i].LastName;
                        tmp.Entity__c = acc[i].Id;
                        tmp.Parent_Entity__c = acc[i].Parent_Entity__c;
                        existingAcc.add(tmp);
                     }
                     else{
                         Client_Details__c tmp1 = new Client_Details__c();
                         tmp1.First_Name__c = acc[i].FirstName;
                         tmp1.Last_Name__c = acc[i].LastName;
                         tmp1.Entity__c = acc[i].Id;
                         tmp1.Parent_Entity__c = acc[i].Parent_Entity__c;
                         existingAcc.add(tmp1);
                     }   
               }
           }
        }
        /**
            This function is used to save the record from portal
        */
        public pageReference save(){
            pageReference pageRef=null;
            for (Client_Details__c ac1:existingAcc) {
                if(ac1.Id==null){
                    newAcc.add(ac1);
                }
            }
            
            try{
                for (Client_Details__c ac:newAcc) {
                     if (ac.First_Name__c==null || ac.First_Name__c=='') {
                          throw new ValidationException(Label.firstNameRequired); 
                     }
                     else if (ac.Last_Name__c==null || ac.Last_Name__c=='' ) {
                           throw new ValidationException(Label.lastNameRequired); 
                     }
                    if(newAcc.size()>0){
                           ctservice.addNewMembers(newAcc); 
                    }
                    newAcc = new List<Client_Details__c>();
                    pageRef = new pageReference ('/apex/ClientMemberDetails?entityId='+entityId+
                                                     '&tabname=Financial Planning');
                    pageRef.setRedirect(true); 
                    
              }
            }catch(ValidationException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
            }catch(Exception ex){
                 ApexPages.addMessages(ex);
            }
         return pageRef;
        }
        /**
        This function is called when user clicks on cancel button
        */
        public Pagereference cancel(){
            pageReference pageRef = new pageReference ('/apex/ClientMemberDetails?entityId='+entityId+
                                                       '&tabname=Financial Planning');
            pageRef.setRedirect(true); 
            return pageRef;
        }
        /**
        It navigates user to income page
        */
        public pageReference Next(){
            pageReference pageRef = new pageReference ('/apex/IncomeSummaryPage?entityId='+entityId+
                                                       '&tabname=Financial Planning');
            return pageRef;
        }
        /**
        It adds new member
        */
        public pageReference AddNewMember(){
            Client_Details__c acctemp = new Client_Details__c();
            acctemp.Parent_Entity__c = entityId;
            newAcc.add(acctemp);
            isNew = true;
            return null;
        }
        /**
           This function is used to navigate to detail page
        */
        public pageReference AddDetails(){
            String accId=Apexpages.currentPage().getParameters().get('accid');
            String parentId=Apexpages.currentPage().getParameters().get('parentAcc');
            if (accId!=null && accId!= '') {
                pageReference pageRef;
                if (parentId== null || parentId =='') {
                   pageRef = new pageReference ('/apex/ClientInfoPage?entityId='+accid+
                                                '&RecType=client&tabname=Financial Planning');
                }
                else{
                    pageRef = new pageReference ('/apex/ClientInfoPage?fentityId='+accid+'&entityId='+parentId+
                                                 '&RecType=family&tabname=Financial Planning');
                }
                return pageRef;
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,Label.addDetailsValidation);
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
}