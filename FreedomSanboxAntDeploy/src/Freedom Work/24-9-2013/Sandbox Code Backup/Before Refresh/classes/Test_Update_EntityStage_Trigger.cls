@isTest
private class Test_Update_EntityStage_Trigger 
{
	 //Deployement Manasi
	  static testMethod void testTriggerDeleteParent()
	  {/*
	  	//system.debug('*******RecTypes__c.getInstanceRecord_Type_Value__c********'+RecTypes__c.getInstance('AccountClient').Record_Type_Value__c);
		    Id clientRecId=RecTypes__c.getInstance('AccountClient').Record_Type_Value__c;
		     Id familyRecId=RecTypes__c.getInstance('AccountFamily').Record_Type_Value__c;
		       
		     Account act = new Account(FirstName='ABC',LastName='XYZ',RecordTypeId=clientRecId);
		     insert act;
		     
		       Account son=new Account(FirstName='PQR',LastName='LMN',Parent_Entity__c=act.id,RecordTypeId=familyRecId);
		      insert son;
		      
		      Account Daughter =new Account(FirstName='EFG',LastName='HIJ',Parent_Entity__c=act.id,RecordTypeId=familyRecId);
		      insert Daughter;
		      
		  /*    Asset__c asset=new Asset__c(Expected_Growth_Rate__c=4,End_Year__c='2034',Start_Year__c='2001',
		                              Entity__c=act.id,action__c='yes',Asset_Types__c='Gold',RecordTypeId=AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c);//RecordTypeId='01220000000HYzWAAW' : mahesh
		        insert asset;
		        
		        /*Client_Details__c accs=new Client_Details__c(Entity__c = act.id);
		      insert accs;
		        
		        Expense__c exp=new Expense__c(Entity_Name__c=act.id,General_Expenses__c='Housing',Current_Expenses__c=12536,Frequency__c='Monthly');
		        upsert exp;
		        
		        Goal_Profile__c goalProfile=new Goal_Profile__c(Name='Moderately Aggressive',Account__c=act.id,Goal_Profile_Type__c='Customized',Debt_Allocation__c=23,Equity_Allocation__c=32,Gold_allocation__c=33);
		        insert goalProfile;
		        
		        Lead newLd = new Lead(LastName = 'Tesqqqqt', Status='Open');
		    insert newLd;
		    
		    Opportunity opp = new Opportunity(Name='Test', CloseDate= System.today(), StageName='Interested', Lead__c=newLd.Id,AccountId = act.Id);
		    insert opp;
		    */
		//   Delete son;
		//    Delete act;
	  }
		/*
static testMethod void testTrigger(){
		Test.startTest();
		List<Account> updateList= new List<Account>();
		List<Account> accounts =new List<Account>();
		Account act1 = new Account(FirstName='Test_Fname1',LastName='Test_Lname',Entity_Status__c='Active');
		accounts.add(act1);
		Account act2 = new Account(FirstName='Test_Fname2',LastName='Test_Lname',Entity_Status__c='Active');
		accounts.add(act2);
		Account act3 = new Account(FirstName='Test_Fname3',LastName='Test_Lname',Entity_Status__c='Active');
		accounts.add(act3);
		Account act4 = new Account(FirstName='Test_Fname4',LastName='Test_Lname',Entity_Status__c='Active');
		accounts.add(act4);
		/*Account act5 = new Account(FirstName='Test_Fname5',LastName='Test_Lname',Entity_Status__c='Active');
		accounts.add(act5);
		Account act6 = new Account(FirstName='Test_Fname6',LastName='Test_Lname',Entity_Status__c='Active');
		accounts.add(act6);
   //     insert accounts;
        
        /* Commented on 01Mar 2012 : because Cheque_Received_Date__c will be removed from Account object */
       //accounts= [select Id,Cheque_Received_Date__c from Account where LastName = 'Test_Lname'];
/*     accounts= [select Id from Account where LastName = 'Test_Lname'];
       
       for (Integer i=0;i<accounts.size();i++){
       	   Account acc=accounts.get(i);
       	   if(acc.Id==act1.Id){
       	   	  acc.Cheque_Received_Date__c=System.today();
       	   	  updateList.add(acc);
       	   }
       	   else
       	   if(acc.Id==act1.Id){
       	   	  acc.Data_Collection_Date__c=System.today();
       	   	  updateList.add(acc);	
       	   }
       	   else if(acc.Id==act2.Id){
       	   	  acc.Data_Collection_Date__c=System.today();
       	   	  acc.Plan_Writing_Date__c=System.today().addDays(1);
       	   	  updateList.add(acc);	
       	   }
       	   
       	//   ======Deleted Plan_Presented_Date__c field from Account object======
       	  else if(acc.Id==act4.Id){
       	   	  acc.Data_Collection_Date__c=System.today();
       	   	  acc.Plan_Writing_Date__c=System.today().addDays(1);
       	   	  //acc.Plan_Presented_Date__c=System.today().addDays(2);
       	   	  updateList.add(acc);	
       	   }
       	   
       	   else if(acc.Id==act3.Id){
       	   	  acc.Data_Collection_Date__c=System.today();
       	   	  acc.Plan_Writing_Date__c=System.today().addDays(1);
       	   	  //acc.Plan_Presented_Date__c=System.today().addDays(2);
       	   	  acc.Plan_Approved_Date__c=System.today().addDays(3);	
       	   	  updateList.add(acc);
       	   }
       	   else if(acc.Id==act4.Id){
       	   	  acc.Data_Collection_Date__c=System.today();
       	   	  acc.Plan_Writing_Date__c=System.today().addDays(1);
       	   	 // acc.Plan_Presented_Date__c=System.today().addDays(2);
       	   	  acc.Plan_Approved_Date__c=System.today().addDays(3);
       	   	  acc.Execution_Completion_Dates__c=System.today().addDays(4);	
       	   	  updateList.add(acc);
       	   }
		}
       
        update updateList; 
       
       Test.stopTest();
	}*/
}