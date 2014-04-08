/**
 * @Author: Sandip C
 * @since :08th Feb 2011
 * @Description:ClientInfoService is class for ClientInfoPage which used for 
 * customer portal to populate Client_Details__c custom object and the trigger on the custom object will
 * populate the data in account. 
 */
 public class ClientInfoService{
	    DatabaseDML databaseAccess=new DatabaseDML();
	    DatabaseSOQL databaseObj = new DatabaseSOQL();
	/**
	  * @Description: Constructor to initialise the bean class,service class and fetch existing data
	  * @param: None 
	  * @return type: 
	  */
	    public ClientInfoService(){
	    }
   /**
	 * @getEntity() function returns the details of Client_Details__c
	 * @params:id of particular Client_Details__c(Entity)
	 * @Return Type:Client_Details__c object instance for that particular entity
	 */  
	    public Client_Details__c getEntity(String clientId) {
		        Client_Details__c ct = new Client_Details__c();
		        List<Client_Details__c> ctList = databaseObj.getClient(clientId);
		        if(ctList ==null || ctList.size()==0) {
		        }
		        else{
		            ct = ctList[0];
		        }
		        Account acc = databaseObj.getEntity(clientId);
		        ct.First_Name__c = acc.FirstName;
		        ct.Last_Name__c = acc.LastName;
		        ct.Entity__c = acc.Id;
		        ct.Parent_Entity__c =  acc.Parent_Entity__c;
		        ct.Billing_City__c =  acc.BillingCity;
		        ct.Billing_Country__c =  acc.BillingCountry;
		        ct.Billing_State__c =  acc.BillingState;
		        ct.Billing_Street__c =  acc.BillingStreet;
		        ct.Billing_Zip_Postal_Code__c =  acc.BillingPostalCode;
		        ct.Date_Of_Birth__c =  acc.PersonBirthdate;
		        ct.Email__c =  acc.PersonEmail;
		        ct.Gender__c =  acc.Gender__pc;
		        ct.Health_History__c =  acc.Health_History_del__c;
		        ct.Home_Phone__c =  acc.PersonHomePhone;
		        ct.Mailing_City__c =  acc.PersonMailingCity;
		        ct.Mailing_Country__c =  acc.PersonMailingCountry;
		        ct.Mailing_State__c =  acc.PersonMailingState;
		        ct.Mailing_Street__c =  acc.PersonMailingStreet;
		        ct.Mailing_Zip_Postal_Code__c =  acc.PersonMailingPostalCode;
		        ct.Marital_Status__c =  acc.Marital_Status__pc;
		        ct.Middle_Name__c =  acc.Middle_Name__pc;
		        ct.Mobile__c =  acc.PersonMobilePhone;
		        ct.Office_City__c =  acc.PersonOtherCity;
		        ct.Office_Country__c =  acc.PersonOtherCountry;
		        ct.Office_State__c =  acc.PersonOtherState;
		        ct.Office_Street__c =  acc.PersonOtherStreet;
		        ct.Office_Zip_Postal_Code__c =  acc.PersonOtherPostalCode;
		        ct.Pan_Id__c =  acc.PAN_ID__pc;
		        ct.Passport_Number__c =  acc.Passport__pc;
		        ct.Relationship_to_Entity__c =  acc.Relationship_to_Entity__pc;
		        ct.Will__c =  acc.Will__c;
		        ct.Salutation__c =  acc.Salutation;
		        return ct;
		        
	    }
  /**
	* @save() Method is used to save the values enterd in the ClientInfoPage. 
	* @params:familyinfoBean class object instance and id of the account
	*/
	    public void save(ClientInfoBean ciBean){
	       	   for (integer index=0;index<ciBean.bankList.size();index++) {
	            	Financial_Account__c fAcc=ciBean.bankList.get(index);
	            	if (ciBean.isEmpty(fAcc,ciBean.bankRec.name)) {
	              		ciBean.bankList.remove(index);
	            	}
	        	}
	        
	        	for (integer index=0;index<ciBean.dematList.size();index++) {
		            Financial_Account__c fAcc=ciBean.dematList.get(index);
		            if (ciBean.isEmpty(fAcc,ciBean.dematRec.name)) {
		              ciBean.dematList.remove(index);
		            }
	        	}
	        
	        	try{
		            ciBean.validate(ciBean.acc);
		            databaseAccess.upsertObject(ciBean.acc);
		            if (ciBean.bankList.size()>0) {
		               databaseAccess.upsertObject(ciBean.bankList);
		            }
		            if (ciBean.dematList.size()>0) {
		                databaseAccess.upsertObject(ciBean.dematList);
		            }
	        	}
		        catch(ValidationException e) {
		            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
		        }
		        catch(Exception ex){
		           ApexPages.addMessages(ex);
		        }
		         return;
	    }
	    public List<Client_Details__c> getClientFamily(String clientId) {
	         	return databaseObj.getClientFamily(clientId);
	    }
   /**
	 * addNewMembers() method used insert/update the new/existing family members of particular entity
	 * params:List of family members
	 * Return Type:void
	 */   
	 
	   public void addNewMembers(List<Client_Details__c> entityLst){
	    	   databaseAccess.upsertObject(entityLst);
	   }
	  
   /**
	 * saveNext() method used to save the details of client/family members and move to next family member details
	 * params:id of client and particular family member
	 * Return Type:pageReference
	 */  
	 
	   public Pagereference saveNext(String parentId,String childId){
		     List<Account> accList=new List<account>();
		      Pagereference pageRef;
		      String newPageId;
		      integer i;
		      if (parentId!=null && parentId!='') {
		         accList=databaseObj.getFamilyDetails(parentId);
		         if (accList.size()>0) {
		          	if (childId!=null && childId!='') {
		            	for (i=0;i<accList.size();i++) {
		             		String accId=acclist.get(i).Id;
		              		if (accId.equalsIgnoreCase(childId)) {
		                		if ((i+1)!=accList.size()) {
		                 			newPageId=accList.get(i+1).Id;
		                  			pageRef =new pageReference('/apex/clientInfoPage?fentityId='+newPageId+'&entityId='+
		                                                        parentId+'&RecType=family&tabname=Financial Planning');
		                        }
		                        else{
		                            pageRef = new pageReference ('/apex/IncomeSummaryPage?entityId='+parentId+
		                                                         '&tabname=Financial Planning');
		                        }
		                       break;
		                    }  
		                }
		            }
		            else{
		            	if (accList.get(1)!=null) {
		              		newPageId=accList.get(1).id;
		              		pageRef = new pageReference ('/apex/clientInfoPage?fentityId='+newPageId+'&entityId='+
		              		                              parentId+'&RecType=family&tabname=Financial Planning');
		            	}
		            	else{
		              		pageRef = new pageReference ('/apex/IncomeSummaryPage?entityId='+parentId+
		              		                             '&tabname=Financial Planning');
		            	}
		            }
		         }
		      }
		      return pageRef;
	   }
	   
   /**
	 * addNewRow() method used to add new rows for entering aditional bank/demat account Details
	 * params:id familyMemberInfoBean object instance and account recordtype(bank/demat)
	 * Return Type:void
	 */  
	   public void addNewRow(ClientInfoBean ciBean,String financialRecType){
		      if (financialRecType.equalsIgnoreCase(Label.DematAccount)) {
		          Financial_Account__c tmp = new Financial_Account__c();
		          tmp.recordtypeId = ciBean.dematRec.RecordTypeId__c;
		          tmp.Account__c= ciBean.entId;
		          ciBean.dematList.add(tmp);
		      }
		      if (financialRecType.equalsIgnoreCase(Label.BankAccount)) {
		          Financial_Account__c tmp1 = new Financial_Account__c();
		          tmp1.recordtypeId = ciBean.bankRec.RecordTypeId__c;
		          tmp1.Account__c= ciBean.entId;
		          ciBean.bankList.add(tmp1);
		      }
	   }  
	      
   /**
	 * getFinancialRec() method used to get FinancialRecTypes__c object instance  for bank/demat account
	 * params:recordtype Name
	 * Return Type:FinancialRecTypes__c
	 */  
	  public  FinancialRecTypes__c getFinancialRec (String recordName){
	     	  return  databaseObj.getFinancialRec(recordName);
	   }
	   
   /**
	 * getBankDetails() method used to get bank/demat account details of particular client
	 * params:recordtype Name
	 * Return Type:FinancialRecTypes__c
	 */  
	 public List<Financial_Account__c> getBankDetails(String entityId,String recId) {
	        return databaseObj.getBankDetails(entityId, recId);
	  }
 }