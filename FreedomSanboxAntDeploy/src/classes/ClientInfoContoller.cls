/**
 * @Author: Sandip C
 * @since :08th Feb 2011
 * @Description:ClientInfoContoller is controller class for ClientInfoPage which used for 
 * customer portal to populate Client_Details__c custom object and the trigger on the custom object will
 * populate the data in account. 
 */
 public class ClientInfoContoller{
        public ClientInfoBean ciBean{get;set;}
        public ClientInfoservice ciService{get;set;}
/**
  * @Description: Constructor to initialise the bean class,service class and fetch existing data
  * param: None 
  * return type: 
  */
         public ClientInfoContoller(){
                ciBean = new ClientInfoBean();
                ciService = new ClientInfoservice();
                ciBean.entityId = Apexpages.currentPage().getParameters().get('entityId');
                String fentityId=Apexpages.currentPage().getParameters().get('fentityId');
                ciBean.bankRec=ciService.getFinancialRec(Label.bankAccount); 
                ciBean.dematRec=ciService.getFinancialRec(Label.dematAccount);
                if (fentityId!=null && fentityId != '') {
                    ciBean.entId = fentityId;
                    ciBean.isFamily = true;
                }
                else{
                    ciBean.entId = ciBean.entityId;
                    ciBean.isFamily = false;
                }
        
               if(ciBean.entId  !=null && ciBean.entId !='') {
                    ciBean.acc = ciService.getEntity(ciBean.entId);       
                    ciBean.bankList=ciService.getBankDetails(ciBean.entId, ciBean.bankRec.RecordTypeId__c); 
                    if(ciBean.bankList.isEmpty()){
                        ciService.addNewRow(ciBean,Label.bankAccount);
                        ciService.addNewRow(ciBean,Label.bankAccount);
                        ciService.addNewRow(ciBean,Label.bankAccount);
                    }
                    ciBean.dematList=ciService.getBankDetails(ciBean.entId, ciBean.dematRec.RecordTypeId__c);
                    if(ciBean.dematList.isEmpty()) {
                        ciService.addNewRow(ciBean,Label.dematAccount);
                        ciService.addNewRow(ciBean,Label.dematAccount);
                   }
                
               }         
        }
         
/**
  * @Description: save the record in the Client_Details__c object
  * param: None 
  * return type: PageReference 
  */ 
        public PageReference save() {
               PageReference pageRef ;
               ciService.save(ciBean);
               if(ApexPages.hasMessages()){
                    pageRef=null;
               }else{
                    pageRef = new PageReference('/apex/ClientMemberDetails?entityId='+ciBean.entityId+
                                                '&tabname=Financial Planning');
                }
                return pageRef;
        }
        
        public PageReference cancell(){
               PageReference pageRef = new PageReference('/apex/ClientMemberDetails?entityId='+ciBean.entityId+
                                                      '&tabname=Financial Planning');
               return pageRef;
        }
        /**
            Saves family member detail and navigates to the detail page for next family member 
        */
        public PageReference saveNext() {
               PageReference pageRef;
               ciService.save(ciBean);
               if(ApexPages.hasMessages()) {
                    pageRef=null;
               }
               else{
                   String parentId=Apexpages.currentPage().getParameters().get('entityId');
                   String childId=Apexpages.currentPage().getParameters().get('fentityId');
                   pageRef=ciService.saveNext(parentId,childId);
                   pageRef.setRedirect(true);
               }
               return pageRef;
        }
        /**
        This function is used to add new row
        */
        public Pagereference addNewRow() {
                String financialRecType=Apexpages.currentPage().getParameters().get('financialRecordType');
                ciService.addNewRow(ciBean,financialRecType);
                return null;
        }
}