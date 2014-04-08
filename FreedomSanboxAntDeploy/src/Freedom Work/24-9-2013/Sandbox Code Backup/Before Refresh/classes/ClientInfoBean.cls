/**
 * @Author: Sandip C
 * @since :08th Feb 2011
 * @Description:ClientInfoBean is bean class for ClientInfoPage which used for 
 * customer portal to populate Client_Details__c custom object and the trigger on the 
 * custom object will populate the data in account. 
 */
 
 public class ClientInfoBean{
        public string entityId {get;set;}
        public string entId {get;set;}
        public boolean isFamily{get;set;}
        public Client_Details__c acc{get;set;}
        public List<Financial_Account__c> bankList{get;set;}
        public List<Financial_Account__c> dematList{get;set;}
        public FinancialRecTypes__c bankRec{get;set;}
        public FinancialRecTypes__c dematRec{get;set;}
   /**
     * @Description: Constructor to initialise the bean properties
     * param: None 
     * return type: none
     */
       public ClientInfoBean(){
            acc = new Client_Details__c();
            isFamily = false;
            this.bankList=new List<Financial_Account__c>();
            this.dematList=new List<Financial_Account__c>();
      }
    
   /**
     * isEmpty() method is used to check whether  bank and demat account  details row is empty or not
     * param: financial_Account__c object  and String Recordtype associated with particular account
     * Return type is boolean
     */
      public boolean isEmpty(Financial_Account__c fAcc,String financialRecName) {
            Boolean empty=false;
            if (financialRecName.equalsIgnoreCase(Label.DematAccount)) {
                if (fAcc.Account_Number__c==null && fAcc.Account_type__c==null && fAcc.Bank_Name__c==null &&
                    fAcc.Branch_detail__c==null && fAcc.MICR_No__c==null && fAcc.IFSC_No__c==null  ) {
                       empty=true;
                 }
            }
            if (financialRecName.equalsIgnoreCase(Label.BankAccount)) {
                if (fAcc.Account_Number__c==null && fAcc.DP_Name__c==null && fAcc.DP_Id__c==null && 
                   fAcc.Branch_detail__c==null) {
                      empty=true;
               }
            }
            return empty;
     }
     /*
    * validate() method is used for the validations for the personal Details
    * param: Client_Details__c object
    * Return type void
   */
     public void validate(Client_Details__c accs) {
          
        if(!(this.isFamily)){
           if (accs.Mailing_Street__c==null || accs.Mailing_Street__c=='') {
                 throw new ValidationException(Label.MailingAddressValidation); 
           }
           if (accs.Mailing_City__c==null || accs.Mailing_City__c=='') {
                 throw new ValidationException(Label.MailingAddressValidation); 
           }
           if (accs.Mailing_State__c==null ||accs.Mailing_State__c=='' ) {
                 throw new ValidationException(Label.MailingAddressValidation); 
           }
           if (accs.Mailing_Country__c==null || accs.Mailing_Country__c=='') {
                 throw new ValidationException(Label.MailingAddressValidation); 
           }
           if (accs.Mailing_Zip_Postal_Code__c==null || accs.Mailing_Zip_Postal_Code__c=='') {
                 throw new ValidationException(Label.MailingAddressValidation); 
           }
        }
       if(accs.First_Name__c==null || accs.First_Name__c==''){
           throw new ValidationException(Label.firstNameRequired); 
       }
       if(accs.Last_Name__c==null || accs.Last_Name__c==null ){
           throw new ValidationException(Label.lastNameRequired); 
       }
    }
}