/*Revision History:
	
    Version     Version Author     Date         Comments
    1.0         Aditi Satpute	   16/08/2012   Created class to split address of Partner Portal
*/
public with sharing class CoverComponentController
{
	public String newAddress{get;set;}
	public Account Family_Picture{get;set;}
	public String Familypic{get;set;}
	public Account acc;
	public Boolean isDisplayFamilyPic;
	
	public CoverComponentController()
	{
		Id entityId = ApexPages.currentPage().getParameters().get('EntityId');
		isDisplayFamilyPic = true;
		try
		{
			acc = [select Id, Family_Picture__c, Name
					from account 
					where id =: entityId];
			system.debug('=======acc======='+acc);
			Family_Picture = acc;
			system.debug('=======Familypic======='+Family_Picture);
			
	        if(acc.Family_Picture__c == null)
	        {
	        	system.debug('=======isDisplayFamilyPic======');
	            isDisplayFamilyPic = false;
	        }
		}
		catch(Exception e)
		{
			
		}
		
	}
	
	public List<String> lstAddwithComma 
	{
		get
		{
			if(newAddress != null && newAddress != '')
			{
				double counter=0;
				lstAddwithComma = new List<String>();
				List<String> lstAdd = new List<String>();
				system.debug('********newAddress*********'+newAddress);
				lstAdd = newAddress.split(',');
				system.debug('********lstAdd*********'+lstAdd);
				double lengthAdd=lstAdd.size();
				system.debug('********lengthAdd*********'+lengthAdd);
					
				for(String str:lstAdd)
				{
					if(counter<lengthAdd-1)
					{
						counter++;
						lstAddwithComma.add(str+',');
					}
					else
					{
						lstAddwithComma.add(str);
					}
				}
				return lstAddwithComma;
			}
			else
				return null;
			//return lstAdd;
		}
		set;
	}
	
	@isTest
	static void TestCoverComponentController()
	{
		Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	//Insert RecordType record
    	List<RecTypes__c> lstRecTypes = new List<RecTypes__c>();
    	RecTypes__c objRecType = new RecTypes__c(Name='General_Business', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	
    	RecTypes__c objRecType1 = new RecTypes__c(Name='AccountFamily', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('Family Member').getRecordTypeId());
    	RecTypes__c objRecType2 = new RecTypes__c(Name='AccountClient', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId());
    	
    	lstRecTypes.add(objRecType);										 
    	lstRecTypes.add(objRecType1);
    	lstRecTypes.add(objRecType2);	
    	insert lstRecTypes;
    	
    	//Insert smagicbasic SMS Template record 
    	List<smagicbasic__SMS_Template__c> lstTemplate = new List<smagicbasic__SMS_Template__c>();
    	
    	smagicbasic__SMS_Template__c template= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Discontinuation Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	
    	smagicbasic__SMS_Template__c template1= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Renewal Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	lstTemplate.add(template);
    	lstTemplate.add(template1);
    	
    	insert lstTemplate;
    	 
		//RecordType objRT = [Select Id from RecordType where Name = 'Client' and SobjectType = 'Account'];
		
		   //Insert Account record
    	Account objBPAccount = new Account(Name='Parner Account Test',
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	insert 	objBPAccount;
		CoverComponentController objCoverComp = new CoverComponentController();
		
		Account acc = new Account(FirstName='ABC',LastName='DEF',RecordTypeId=RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId());
		insert acc;
		
		objCoverComp.newAddress = 'aaa aaa, aaa aaa, aaa';
		objCoverComp.lstAddwithComma.add('aaa aaa,aaaa aa,aaa');
	}
}