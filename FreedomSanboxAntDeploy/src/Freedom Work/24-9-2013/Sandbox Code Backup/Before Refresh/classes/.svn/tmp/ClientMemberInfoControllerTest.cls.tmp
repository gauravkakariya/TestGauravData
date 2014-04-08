@isTest
private class ClientMemberInfoControllerTest {
    static ClientInfoContoller fmInfoCon;
 static ClientMemberDetailsController fmDetailCon;
 static  DatabaseDML dmlobj;
static Account acc;
 static Account child;
 static Account clientacc;
 static String childId;

 // static Client_Details__c Client_Details__c;

 public static void parentData()
 {
 	Clientacc =new Account(LastName='ABC',PersonMailingStreet='Street',PersonMailingCity='City',
                    PersonMailingState='state',PersonMailingCountry='country',
                    PersonMailingPostalCode='123456',FirstName='DEF',Retirement_Age__c='55',
                    Estimated_Life_Expectancy__c='85',PersonBirthdate=system.today(), RecordTypeId=RecTypes__c.getInstance ('AccountClient').Record_Type_Value__c); //'01220000000DnK3AAK');//Prajakta
    
  	insert Clientacc;
  	system.assertNotEquals(null, Clientacc.id);
 	Apexpages.currentPage().getParameters().put('entityId',Clientacc.id);
    child=new Account(LastName='PQR',FirstName='MNO',Parent_Entity__c=Clientacc.id,RecordTypeId=RecTypes__c.getInstance ('AccountFamily').Record_Type_Value__c);//Prajakta//'01220000000HZ0HAAW');
    insert child;
    system.assert(child!=null);
    Client_Details__c accs=new Client_Details__c(Entity__c=Clientacc.id);
    insert accs;
    system.assertNotEquals(null,accs);
    fmInfoCon=new ClientInfoContoller();
 }
 public static void testParent1()
 {
    Account acc1=new Account(LastName='ABC',PersonMailingStreet='Street',PersonMailingCity='City',
                    PersonMailingState='state',
                    PersonMailingPostalCode='123456',FirstName='DEF',
                    PersonBirthdate=system.today(), RecordTypeId=RecTypes__c.getInstance ('AccountClient').Record_Type_Value__c); //'01220000000DnK3AAK');//Prajakta
    insert acc1;
    system.assertNotEquals(null,acc1);
      Client_Details__c accs=new Client_Details__c(Entity__c=acc1.id);
    insert accs;
    system.assertNotEquals(null,accs);
    Apexpages.currentPage().getParameters().put('entityId',acc1.id);
    fmInfoCon=new ClientInfoContoller();
 }
 public static void testParent2()
 {
    Account acc1= new Account(LastName='ABC',PersonMailingCity='City',
                    PersonMailingState='state',PersonMailingCountry='country',
                    PersonMailingPostalCode='123456',FirstName='DEF',Retirement_Age__c='55',
                    Estimated_Life_Expectancy__c='85',PersonBirthdate=system.today(), RecordTypeId=RecTypes__c.getInstance ('AccountClient').Record_Type_Value__c); //Prajakta//'01220000000DnK3AAK');
    insert acc1;
    system.assertNotEquals(null,acc1);
  	Client_Details__c accs=new Client_Details__c(Entity__c=acc1.id);
    insert accs;
    system.assertNotEquals(null,accs);
 	Apexpages.currentPage().getParameters().put('entityId',acc1.id);
    fmInfoCon=new ClientInfoContoller();
 }
 public static void testParent3()
 {
    Account acc1=new Account(LastName='ABC',PersonMailingStreet='Street',
                    PersonMailingState='state',PersonMailingCountry='country',
                    PersonMailingPostalCode='123456',FirstName='DEF',PersonBirthdate=system.today(), RecordTypeId=RecTypes__c.getInstance ('AccountClient').Record_Type_Value__c); //Prajakta//'01220000000DnK3AAK');
    insert acc1;
    system.assertNotEquals(null,acc1);
  	Client_Details__c accs=new Client_Details__c(Entity__c=acc1.id);
    insert accs;
    system.assertNotEquals(null,accs);
 	Apexpages.currentPage().getParameters().put('entityId',acc1.id);
    fmInfoCon=new ClientInfoContoller();
 }
 public static void testParent4()
 {
    Account acc1=new Account(LastName='ABC',PersonMailingStreet='Street',PersonMailingCity='City',
                   PersonMailingCountry='country',PersonMailingPostalCode='123456',FirstName='DEF',
                    PersonBirthdate=system.today(), RecordTypeId=RecTypes__c.getInstance ('AccountClient').Record_Type_Value__c); //Prajakta//'01220000000DnK3AAK');
    insert acc1;
    system.assertNotEquals(null,acc1);
  	Client_Details__c accs=new Client_Details__c(Entity__c=acc1.id);
    insert accs;
    system.assertNotEquals(null,accs);
 	Apexpages.currentPage().getParameters().put('entityId',acc1.id);
    fmInfoCon=new ClientInfoContoller();
 }
 public static void childSetupData()
 {
    
 	Client_Details__c Clientchild=new Client_Details__c(Last_Name__c='PQR',First_Name__c='MNO',Parent_Entity__c =Clientacc.id);
    insert Clientchild;
    system.assert(Clientchild!=null);
    Apexpages.currentPage().getParameters().put('fentityId',Clientchild.id);
   
 }
     
  public static testMethod void saveTest1()
  {
   	 Test.startTest();
	 testParent1();
     fmInfoCon.save();
     test.stopTest();
  }
  public static testMethod void saveTest2()
  {
    	Test.startTest();
    	testParent2();
     	fmInfoCon.save();
     	test.stopTest();
  }
    public static testMethod void saveTest3()
    {
    Test.startTest();
    testParent3();
     fmInfoCon.save();
     test.stopTest();
   }
    public static testMethod void saveTest4()
    {
    Test.startTest();
    testParent4();
     fmInfoCon.save();
     test.stopTest();
   }
  public static testMethod  void clientTest()
  {
        Test.startTest();
        parentData();
        fmInfoCon.save();
        fmInfoCon.saveNext();
        fmInfoCon.cancell();
        test.stopTest();
        
  }
 
   public static testMethod  void chlidSaveNextTest()
   {
        Test.startTest();
         parentData();
        Apexpages.currentPage().getParameters().put('fentityId',child.id);
        fmInfoCon.saveNext();
        test.stopTest();
  }
    public static testMethod  void clientSaveNextTest()
    {
        Test.startTest();
      
        parentData();
        fmInfoCon.saveNext();
        test.stopTest();
  }
  public static testMethod void setDetailSave()
  {
  	Test.startTest();
    parentData();
  
    fmDetailCon=new ClientMemberDetailsController();
    fmDetailCon.save();
    fmDetailCon.cancel();  
 	fmDetailCon.Next();
   	fmDetailCon.AddNewMember();
    Test.stopTest();
  }
  public static testMethod void setDetailSave1(){
    Test.startTest();
    Account accClient= new Account(LastName='ABC',RecordTypeId=RecTypes__c.getInstance ('AccountClient').Record_Type_Value__c); //Prajakta//'01220000000DnK3AAK');
  insert accClient;
   Client_Details__c accs=new Client_Details__c(Entity__c=accClient.id);
    insert accs;
  Apexpages.currentPage().getParameters().put('entityId',accClient.id);
    fmDetailCon=new ClientMemberDetailsController();
    fmDetailCon.existingAcc.add(new Client_Details__c(First_Name__c='First')); 
    fmDetailCon.save();
    Test.stopTest();
  }
   public static testMethod void setDetailSave2(){
    Test.startTest();
    Account accClient= new Account(LastName='ABC',RecordTypeId=RecTypes__c.getInstance ('AccountClient').Record_Type_Value__c); //Prajakta//'01220000000DnK3AAK');
  insert accClient;
   Client_Details__c accs=new Client_Details__c(Entity__c=accClient.id);
    insert accs;
  Apexpages.currentPage().getParameters().put('entityId',accClient.id);
    fmDetailCon=new ClientMemberDetailsController();
    fmDetailCon.existingAcc.add(new Client_Details__c(Last_Name__c='last'));
    fmDetailCon.save();
    Test.stopTest();
  }
   public static testMethod  void AddDetailsTest(){
    Test.startTest();
     parentData(); 
     childSetupData();
     fmDetailCon=new ClientMemberDetailsController();
    fmDetailCon.existingAcc.add(new Client_Details__c(First_Name__c='First',Last_Name__c='last')); 
     Apexpages.currentPage().getParameters().put('accid',child.id);
     Apexpages.currentPage().getParameters().put('parentAcc',Clientacc.id);
     fmDetailCon.AddDetails();
      test.stopTest();
  }
   public static testMethod  void addNewRowBankTest(){
        Test.startTest();
        parentData();
        Apexpages.currentPage().getParameters().put('financialRecordType',Label.bankAccount);  
        fmInfoCon.addNewRow();
        test.stopTest();
  }
   public static testMethod  void addNewRowDematTest(){
        Test.startTest();
        parentData();    
        Apexpages.currentPage().getParameters().put('financialRecordType',Label.dematAccount);
        fmInfoCon.addNewRow();
        test.stopTest();
  }
    
}