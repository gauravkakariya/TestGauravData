public with sharing class ExportToExcelInsuranceMFStockController 
{
	private String entityId;
	public List<Insurance__c> lstGeneralInsurance {get;set;}
	public List<Insurance__c> lstLifeInsurance {get;set;}
	public List<Investment_Asset__c> lstMutualFund {get;set;}
	public List<Investment_Asset__c> lstStock {get;set;}
	private Map<String, Id> mapRecordTypeNameToId = new Map<String, Id>();
	private Set<Id> setId = new Set<Id>();
	public String entityName {get;set;}
 	public ExportToExcelInsuranceMFStockController()
	{
		String strInsuranceFields = 'select ';
		String strInvestmentAssetFields = 'select ';
		
		entityId = Apexpages.currentPage().getParameters().get('id');
		entityName = Apexpages.currentPage().getParameters().get('name');
		for(Account objAccount :[SELECT Id FROM Account WHERE (isPersonAccount =: true AND Parent_Entity__c =: entityId) OR (Id =: entityId) order by Id])
		{
			setId.add(objAccount.Id);
		}
		for(RecordType objRecordType : [Select Id, Name from RecordType where sObjectType = 'Insurance__c' or sObjectType = 'Investment_Asset__c'])
		{
			mapRecordTypeNameToId.put(objRecordType.Name, objRecordType.Id);
		}
		
		Map<String, Schema.SObjectField> mapInsuranceFieldNameToFieldDescribe = Insurance__c.sObjectType.getDescribe().fields.getMap();
		for(String strField : mapInsuranceFieldNameToFieldDescribe.keySet())
		{
			strInsuranceFields += strField +',';
		}
		//strInsuranceFields = strInsuranceFields.substring(0, strInsuranceFields.length() - 1);
		
		strInsuranceFields += 'Entity__r.Name from  Insurance__c where Entity__c IN: setId and RecordTypeId =';
		Map<String, Schema.SObjectField> mapInvestmentAssetFieldNameToFieldDescribe = Investment_Asset__c.sObjectType.getDescribe().fields.getMap();
		for(String strField : mapInvestmentAssetFieldNameToFieldDescribe.keySet())
		{
			strInvestmentAssetFields += strField +',';
		}
		//strInvestmentAssetFields = strInvestmentAssetFields.substring(0, strInvestmentAssetFields.length() - 1);
		
		strInvestmentAssetFields += 'Entity__r.Name  from  Investment_Asset__c where Entity__c IN: setId and RecordTypeId =';
		
		System.debug('------------error-----------'+ (strInsuranceFields + '\'' + mapRecordTypeNameToId.get('General Insurance') + '\''));
		try
		{
			lstGeneralInsurance = Database.query(strInsuranceFields + '\'' + mapRecordTypeNameToId.get('General Insurance') + '\'');
			lstLifeInsurance  = Database.query(strInsuranceFields + '\'' + mapRecordTypeNameToId.get('Life Insurance') + '\'');
			lstMutualFund  = Database.query(strInvestmentAssetFields + '\'' + mapRecordTypeNameToId.get('Mutual Fund') + '\'');
			lstStock  = Database.query(strInvestmentAssetFields + '\'' + mapRecordTypeNameToId.get('Stocks') + '\'');
		}
		catch(Exception e)
		{
			
		}
		
	}
	
	@isTest
	public static  void testExportToExcelInsuranceMFStockController()
	{
		Account objAccount = new Account(LastName = 'test', FirstName = 'test');
		Apexpages.currentPage().getParameters().put('id', objAccount.Id);
		ExportToExcelInsuranceMFStockController obj = new ExportToExcelInsuranceMFStockController();
	}
	
}