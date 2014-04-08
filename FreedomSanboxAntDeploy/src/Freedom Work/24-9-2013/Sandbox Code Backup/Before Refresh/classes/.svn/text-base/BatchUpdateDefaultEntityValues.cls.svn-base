/* BatchUpdateDefaultEntityValues class is One time run script.
   It will update the existing records whose Current_Age__c is null
   Revision History:
	
   Version     Version Author     Date         Comments
   1.0		   Manasi			  21/06/2011	Issue ID : F0055 :BatchUpdateDefaultEntityValues class is One time run script.
   												It will update the existing records whose Current_Age__c is null.
   												For this script need to update the Current_Age__c (Account Object) 
   												field's Length to the value = 3.
    						 
*/


public with sharing class BatchUpdateDefaultEntityValues 
{
	public 	BatchUpdateDefaultEntityValues()
	{
		List<Account> accountWithNullCurrentAgeList = new List<Account>();
 		Integer iNoOfRecords = [SELECT count() FROM Account where Current_Age__c =: null];
		system.debug('*******iNoOfRecords:'+iNoOfRecords);
		
		for(Account objAccout :[SELECT Id,Current_Age__c FROM Account where Current_Age__c =: null])
		{
			accountWithNullCurrentAgeList.add(objAccout);
		}
		update accountWithNullCurrentAgeList;
	}
	
	public static testMethod void UpadteCurrentAgeToRequiredValue_Test()
	{
		Account objAccount = new Account(FirstName='Test_Fname1',LastName='Test_Lname',Entity_Status__c='Active');
		Insert objAccount;
		test.startTest();
		BatchUpdateDefaultEntityValues objBatchUpdateDefaultEntityValues = new BatchUpdateDefaultEntityValues();
		test.stopTest();
	}
}