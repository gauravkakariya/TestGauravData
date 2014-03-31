/* @auther: Anju G
 * @Description: This class is used for creating and intializing the instance variables
 */

/*
	
Revision History:

   Version     Version Author     Date          Comments
   1.0         Persistent         NA  		  	Initial Draft
   
   2.0 		   Manasi Ranade	  11/06/2011	Issue id: F0041 : If selected entity is parent entity or earning spouce entity then display 
   												retirement Age field as Required field else it should not be required field 
			  									Change: 1) Added blnIsRetimentAgeRequired to check whether Selected entity is parent or earnig 
			  											   spouce entity or not.
				  	  									2) In validate() function added condition to check whether field is required or not	
   2.0 		   Manasi Ranade	  27/06/2011	Issue id: F0058 : If selected entity is parent entity or earning spouce entity then display 
   												Estimated Life Expectancy field as Required field, else it should not be required field 
			  									Change: 1) Added blnIsLifeExpectancyAgeRequired to check whether Selected entity is parent or earnig 
			  											   spouce entity or not.
				  	  									2) In validate() function added condition to check whether field is required or not					  	  									
   
 
*/
public class FamilyMemberInfoBean{
	  /** Eternus Solutions         **/
	  /** Author  : Manasi Ranade	**/
	  /** Issue Id: F0041      	    **/
	  /** Date    : 11/06/2011 	    **/
	  /** Purpose : Added blnIsRetimentAgeRequired to check Selected entity is parent or earnig spouce entity or not.**/
	  /****************************************************/
	  
	  public Boolean blnIsRetimentAgeRequired{get;set;}
	  //
	  /** Eternus Solutions         **/
	  /** Author  : Manasi Ranade	**/
	  /** Issue Id: F0058      	    **/
	  /** Date    : 27/06/2011 	    **/
	  /** Purpose : Added blnIsLifeExpectancyAgeRequired to check Selected entity is parent or earnig spouce entity or not.**/
	  /****************************************************/
	  public Boolean blnIsLifeExpectancyAgeRequired{get;set;}
      public Account acc{get;set;}
      public Contact con{get;set;}
      
      public List<Financial_Account__c> bankList{get;set;}
      public List<Financial_Account__c>dematList{get;set;}
      
      public FinancialRecTypes__c bankRec{get;set;}
      public FinancialRecTypes__c dematRec{get;set;}
      
      public Boolean isCustomer{get;set;}
      public Boolean isFamily{get;set;}
      
      public FamilyMemberInfoBean() {
          this.acc = new Account();
          this.con = new Contact();
          this.bankList = new List<Financial_Account__c>();
          this.dematList = new List<Financial_Account__c>();
          this.isCustomer = false;
          this.isFamily = false;
          
          //F0041
          this.blnIsRetimentAgeRequired = false;
          
          //F0058
          /** Eternus Solutions         **/
		  /** Author  : Manasi Ranade	**/
		  /** Issue Id: F0058      	    **/
		  /** Date    : 27/06/2011 	    **/
		  /** Purpose : set default value of blnIsLifeExpectancyAgeRequired to false**/
		  /****************************************************/
          this.blnIsLifeExpectancyAgeRequired = false;
     }
     
   /*
    * isEmpty() method is used to check whether  bank and demat account  details row is empty or not
    * param: financial_Account__c object  and String Recordtype associated with particular account
    * Return type is boolean
   */
    public boolean isEmpty(Financial_Account__c fAcc, String financialRecName) {
        Boolean empty = false;
        if (financialRecName.equalsIgnoreCase(Label.BankAccount)) {
            if (fAcc.Account_Number__c == null && fAcc.Account_type__c == null && fAcc.Bank_Name__c == null &&
                fAcc.Branch_detail__c == null && fAcc.MICR_No__c == null && fAcc.IFSC_No__c == null  ) {
                    empty = true;
            }
        }
        if (financialRecName.equalsIgnoreCase(Label.DematAccount)) {
            if (fAcc.Account_Number__c == null && fAcc.DP_Name__c == null && fAcc.DP_Id__c == null && 
               fAcc.Branch_detail__c == null) {
                  empty = true;
           }
        }
        return empty;
     }
     
    /*
    * validate() method is used for the validations for the personal Details
    * param: Account object
    * Return type void
   */
   public void validate(Account accs) {
          
         if(!(this.isFamily)){
               if (accs.PersonMailingStreet == null || accs.PersonMailingStreet == '') {
                     throw new ValidationException(Label.MailingAddressValidation); 
               }
               if (accs.PersonMailingCity == null || accs.PersonMailingCity == '') {
                     throw new ValidationException(Label.MailingAddressValidation); 
               }
               if (accs.PersonMailingState == null ||accs.PersonMailingState == '' ) {
                     throw new ValidationException(Label.MailingAddressValidation); 
               }
               if (accs.PersonMailingCountry == null || accs.PersonMailingCountry == '') {
                     throw new ValidationException(Label.MailingAddressValidation); 
               }
               if (accs.PersonMailingPostalCode == null || accs.PersonMailingPostalCode == '') {
                     throw new ValidationException(Label.MailingAddressValidation); 
               }
        }
     	if(accs.FirstName == null || accs.FirstName == ''){
            throw new ValidationException(Label.firstNameRequired); 
      	}
      	if(accs.LastName == null || accs.LastName == null ){ 
            throw new ValidationException(Label.lastNameRequired); 
      	}
          
       /** Eternus Solutions  **/
	   /** Author  : Manasi Ranade	**/
	   /** Issue Id: F0041      	**/
	   /** Date    : 11/06/2011 	**/
	   /** Purpose : If selected entity is parent entity or earning spouce entity then display Retirement Age
					  field as Required field and throw exception else it should not be required field .
					  Hence added condition of blnIsRetimentAgeRequired in following **/
	   /****************************************************/
       if((accs.Retirement_Age__c == null || accs.Retirement_Age__c == '' ) && this.blnIsRetimentAgeRequired  ){
            throw new ValidationException(Label.retirementAgeRequired); 
       }
       
       /** Eternus Solutions  **/
	   /** Author  : Manasi Ranade	**/
	   /** Issue Id: F0058      	**/
	   /** Date    : 27/06/2011 	**/
	   /** Purpose : If selected entity is parent entity or earning spouce entity then display Estimated Life Expectancy
	  				as Required field and throw exception, else it should not be required field .
					  Hence added '&&' condition of blnIsLifeExpectancyAgeRequired in following if statement**/
	   /****************************************************/
       if((accs.Estimated_Life_Expectancy__c == null || accs.Estimated_Life_Expectancy__c == '') && this.blnIsLifeExpectancyAgeRequired ){
            throw new ValidationException(Label.estimatedLifeExpectancyRequired); 
      }
    }
}