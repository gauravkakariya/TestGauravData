@isTest
private class Test_TransactionController
{     
    static testMethod void testTransaction(){
    
    List<Transaction__c> Summary_Transaction_List = new List<Transaction__c>();
    List<Account> ChildEntitiesList = new List<Account>();
    List<TransactionController.summaryReportWrapper> parentSummaryDataList = new List<TransactionController.summaryReportWrapper>();
    List<TransactionController.childSummaryReportWrapper> childSummaryReportWrapperList = new List<TransactionController.childSummaryReportWrapper>();
    Map<String, Transaction__c[]> map_Summary = new    Map<String, Transaction__c[]>();
    Map<String, Transaction__c> map_transaction = new    Map<String, Transaction__c>();
    Map<Account, Transaction__c[]> map_Entity_Transaction = new    Map<Account, Transaction__c[]>();
    Map<String, Transaction__c[]> child_map_Summary = new    Map<String, Transaction__c[]>();
    List<User> lstUser = new List<User>();
    String accountid =  UserInfo.getUserId();
    Account account;
    
    /*Contact objContact = new Contact();
    objContact.AccountId = objAccount.Id;
    objContact.FirstName = 'TestContact'; 
    objContact.LastName = 'TestLast';
    insert objContact;
    */
    Account child = [select Id, Parent_Entity__c from Account where Parent_Entity__c != null and RecordTypeId !=:RecTypes__c.getInstance('General_Business').Record_Type_Value__c LIMIT 1];
    Account act = [select Id, OwnerId, PersonContactId from Account where Id =:child.Parent_Entity__c and RecordTypeId !=:RecTypes__c.getInstance('General_Business').Record_Type_Value__c];
    Profile objProfile = [select Id from Profile where name = 'Customer Portal Standard - Custom' limit 1]; 
    
    ID ProfileID = [ Select id from Profile where name = 'Customer Portal Standard - Custom'].id;
        
    List<User> u1 = [select Id from User where contactid = :act.PersonContactId];
    User user;
    if(u1 == null || u1.isEmpty()){
            user = new User( email='test-user@fakeemail.com', contactid = act.PersonContactId, profileid = ProfileID, UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname' );
            insert user; 
    }
    else{
        user= u1[0];
    }
    //User user = new User(email='test-user@fakeemail.com',ProfileId=objProfile.Id, contactid = objContact.Id, UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname');
    //lstUser.add(user);
        
    Account objAccount = new Account();
    objAccount.RecordTypeId = RecTypes__c.getInstance ('AccountClient').Record_Type_Value__c; //'01220000000DnK3'; Gaurav
    objAccount.FirstName = 'TestFirst';
    objAccount.LastName = 'TestLast';
    objAccount.Entity_Status__c = 'Active';
    objAccount.Agreement_Received__c = 'Yes';
    
    /* Commented on 01Mar 2012 : because Cheque_Received_Date__c will be removed from Account object */
    //objAccount.Cheque_Received_Date__c = Date.valueOf('2011-10-12 09:15:30');
    
    objAccount.Client_Category__c = 'Neutral';
    objAccount.Description = 'Test entity description';
    objAccount.Age__c = 25;
    insert objAccount;
    system.debug('objAccount1Parent:'+objAccount.id);
    
    Account objAccount1 = new Account();
    objAccount1.RecordTypeId = RecTypes__c.getInstance ('AccountFamily').Record_Type_Value__c; //'01220000000HZ0H'; Gaurav
    objAccount1.Parent_Entity__c = objAccount.Id;
    objAccount1.FirstName = 'TestChildFirst';
    objAccount1.LastName = 'TestChildLast';
    objAccount1.Entity_Status__c = 'Active';
    objAccount1.Agreement_Received__c = 'Yes';
    
    /* Commented on 01Mar 2012 : because Cheque_Received_Date__c will be removed from Account object */
    //objAccount1.Cheque_Received_Date__c = Date.valueOf('2011-10-12 09:15:30');
    
    objAccount1.Client_Category__c = 'Neutral';
    objAccount1.Description = 'Test entity description';
    objAccount1.Age__c = 25;
    insert objAccount1;
    system.debug('objAccount1Child:'+objAccount1.id);
    //Database.Saveresult accountSaveResult = Database.insert(objAccount);
    
    //Transaction for parent entity 
    Transaction__c objTransaction = new Transaction__c();
    objTransaction.Owner__c = objAccount.Id;
    //objTransaction.tr'001P000000VKH4M';
    objTransaction.Transaction_Type__c = 'TestType';
    objTransaction.Scheme_Scrip__c = 'TestScheme/Scrip';
    objTransaction.Asset_Class__c = 'Debt: Short Term';
    objTransaction.Folio_Number__c = '1223456';
    Database.Saveresult transactionSaveResult = Database.insert(objTransaction);
    
    //Transaction for child entity
    Transaction__c objTransactionChild = new Transaction__c();
    objTransactionChild.Owner__c = objAccount1.id;
    //objTransactionChild.tr'001P000000VKH4M';
    objTransactionChild.Transaction_Type__c = 'TestType';
    objTransactionChild.Scheme_Scrip__c = 'TestScheme/Scrip';
    objTransactionChild.Asset_Class__c = 'Debt: Short Term';
    objTransactionChild.Folio_Number__c = '12234567';
    Database.Saveresult transactionSaveResultChild = Database.insert(objTransactionChild);
    
    if(transactionSaveResult.isSuccess() && transactionSaveResultChild.isSuccess())
    {
        Summary_Transaction_List.add(objTransaction);
        Summary_Transaction_List.add(objTransactionChild);
    }
    //System.runAs(user){
    test.startTest();
    system.debug('Test Class Id :'+objAccount.id);
    ApexPages.currentPage().getParameters().put('Id',objAccount.id);
    TransactionController objTransactionController = new TransactionController();
    User user2 = objTransactionController.getCurrentUserDetails();
    parentSummaryDataList = objTransactionController.getSummaryDataList();
    childSummaryReportWrapperList = objTransactionController.getAllChildSummaryRecords();
    TransactionController.summaryReportWrapper objSummaryReport = new TransactionController.summaryReportWrapper('Debt: Short Term',Summary_Transaction_List);
    test.stopTest();    
    //}
    //Test.setCurrentPage(Page.Portal_Family);
    
    //TransactionController.childSummaryReportWrapper objChildSummaryReport = new TransactionController.childSummaryReportWrapper();
    }   
    
    
}