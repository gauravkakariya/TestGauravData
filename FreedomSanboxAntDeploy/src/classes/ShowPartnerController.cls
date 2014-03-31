public with sharing class ShowPartnerController 
{
	private final  Account acc;
	public Account objAccount {get;set;}
	public List<Account> lstAccount {get;set;}
	public string selectedBusinessUnit {get;set;}
	ApexPages.StandardSetController con;
	
	public ShowPartnerController (ApexPages.StandardSetController controller) 
	{
		this.con = controller;
		objAccount = new Account();
		this.acc = (Account) con.getRecord();
		system.debug('************this.acc**'+this.acc);
		lstAccount = [select id, Business_Unit__c,Virtual_Partner__c from Account where id=:acc.id and Business_Unit__c =: objAccount.Business_Unit__c];
		system.debug('************lstAccount11**'+lstAccount);
	}
	
	public void partnerPopulated() 
	{
		//List<Team_Member__c> lstTeamMember = [Select Department__c, Business_Unit__c from Team_Member__c Where
		//									  Department__r.Business_Unit__c =: selectedBusinessUnit ];
	 
		lstAccount = [select id, Business_Unit__c,Virtual_Partner__c from Account where id=:acc.id and Business_Unit__c =: objAccount.Business_Unit__c];
		system.debug('************lstAccount22**'+lstAccount);
		
	}	
			
}