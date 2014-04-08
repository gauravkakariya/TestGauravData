/*
	
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0			Manasi			   27/05/2011  Issue ID : F0061 :
    										   A.Created new class ScheduleUpdateCurrentAgeFormBirthdate
											   B.It Implements Schedulable Inteface
											   C.Selects Accounts those are active
*/					  							
global class ScheduleUpdateCurrentAgeFormBirthdate implements Schedulable
{
	global void execute(SchedulableContext SC) {
    UpdateCurrentAgeFormBirthdateOfEntity objUpdateCurrentAge = new UpdateCurrentAgeFormBirthdateOfEntity();
    //objUpdateCurrentAge.query = 'Select Id,PersonBirthdate,Current_Age__c from Account where PersonBirthdate != \'Null\')';
    //objUpdateCurrentAge.query = 'Select Id,PersonBirthdate,Current_Age__c,Entity_Status__c from Account where Account.Entity_Status__c !=\' \' and Account.Entity_Status__c !=\'Null\'';
    objUpdateCurrentAge.query = 'Select Id,PersonBirthdate,Current_Age__c,Entity_Status__c from Account';
    objUpdateCurrentAge.email= 'tech@ffreedom.in';
    database.executebatch(objUpdateCurrentAge);
	} 
}