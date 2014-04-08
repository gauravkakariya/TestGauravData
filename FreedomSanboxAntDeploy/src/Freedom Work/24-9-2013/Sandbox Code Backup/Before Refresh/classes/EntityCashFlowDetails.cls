/**
	Created by : Aditi Satpute
	Date : 2/9/2013
	Purpose : To create a report of all Entities with its CashFlow details
**/
public with sharing class EntityCashFlowDetails 
{
	public transient List<CashFlowDetails> lstCashFlowDetails {get;set;}
	public EntityCashFlowDetails()
	{
		Map<Id,Account> mapIdToClientAccount = new Map<Id,Account>([Select Id,Plan_Generation_Date__c, Name,RecordTypeId from Account 
						where (RecordType.Name = 'Client') order by Name]);
		Map<Id,List<Income__c>> mapIdToListIncome = new Map<Id,List<Income__c>>();
		Map<Id,List<Expense__c>> mapIdToListExpense = new Map<Id,List<Expense__c>>();
		Map<Id,List<Loan__c>> mapIdToListLoan = new Map<Id,List<Loan__c>>();
		Map<Id,List<Insurance__c>> mapIdToListInsurance = new Map<Id,List<Insurance__c>>();
		Map<Id,List<Asset__c>> mapIdToListAsset = new Map<Id,List<Asset__c>>();
		Map<Id,List<Investment_Asset__c>> mapIdToListInvAsset = new Map<Id,List<Investment_Asset__c>>();
		lstCashFlowDetails = new List<CashFlowDetails>();
		
		List<Account> lstClientAccount = mapIdToClientAccount.values();
		lstClientAccount.sort();
 		List<Income__c> lstIncome = [Select i.Start_Year__c,end_year__c,i.Entity__c,i.Entity__r.Parent_Entity__c,i.Monthly_Income__c, i.Income_Amount__c,Frequency__c From Income__c i];
		
		List<Expense__c> lstExpense =[SELECT  General_Expenses__c,Entity_Name__c,Entity_Name__r.Parent_Entity__c,start_year__c,end_year__c,MonthlyExpense__c FROM expense__c];
	
		List<Loan__c> lstLoan = [Select l.EMI__c,Balance_No_of_Years__c,Entity__c,Entity__r.Parent_Entity__c From Loan__c l];
	
		List<Insurance__c> lstInsurance = [Select i.Annual_Premium_amount__c,Commencement_Date__c,Entity__c,Entity__r.Parent_Entity__c, 
												Premium_Paying_Term__c,Tenure_of_Insurance__c From Insurance__c i  
												where  annual_premium_amount__c > 0 and Flag__c = 'Data Entry'];
	   	List<Asset__c> lstAsset = [SELECT RecordType.Name,Annual_Contribution__c, Expected_Growth_Rate__c,Start_year__c,end_year__c,Entity__c,Entity__r.Parent_Entity__c
                                        FROM  Asset__c WHERE  Annual_Contribution__c != null AND (recordTypeId =: AssetRecTypes__c.getInstance('Deposits With Bank').RecordTypeId__c   
											OR recordTypeId =: AssetRecTypes__c.getInstance('Govt. Saving Schemes').RecordTypeId__c)
                                        AND  Annual_Contribution__c >0];	
		List<Investment_Asset__c> lstInvAsset = [SELECT RecordType.Name, Monthly_SIP_Amount__c,Entity__c,Entity__r.Parent_Entity__c FROM  Investment_Asset__c  
                                            WHERE Monthly_SIP_Amount__c != null AND 
											(recordTypeId = :InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c OR 
											RecordTypeId = :InvestmentAsset__c.getInstance('Gold and Silver').RecordTypeId__c)];
											
		for(Income__c objIncome : lstIncome)
		{
			
			if((!mapIdToListIncome.containsKey(objIncome.Entity__c) && objIncome.Entity__r.Parent_Entity__c == null) || 
				(objIncome.Entity__r.Parent_Entity__c != null && !mapIdToListIncome.containsKey(objIncome.Entity__r.Parent_Entity__c)) )
			{
				
				List<Income__c> lst = new List<Income__c>();
				lst.add(objIncome);
				if(objIncome.Entity__r.Parent_Entity__c == null)
					mapIdToListIncome.put(objIncome.Entity__c,lst);
				else
					mapIdToListIncome.put(objIncome.Entity__r.Parent_Entity__c,lst);
			}
			else
			{
				if(objIncome.Entity__r.Parent_Entity__c == null)
					mapIdToListIncome.get(objIncome.Entity__c).add(objIncome);
				else 
				 	mapIdToListIncome.get(objIncome.Entity__r.Parent_Entity__c).add(objIncome);
			}
		}
		for(Expense__c objExpense : lstExpense)
		{
			
			if((!mapIdToListExpense.containsKey(objExpense.Entity_Name__c) && objExpense.Entity_Name__r.Parent_Entity__c == null) || 
				(objExpense.Entity_Name__r.Parent_Entity__c != null && !mapIdToListExpense.containsKey(objExpense.Entity_Name__r.Parent_Entity__c)) )
			{
				
				List<Expense__c> lst = new List<Expense__c>();
				lst.add(objExpense);
				if(objExpense.Entity_Name__r.Parent_Entity__c == null)
					mapIdToListExpense.put(objExpense.Entity_Name__c,lst);
				else
					mapIdToListExpense.put(objExpense.Entity_Name__r.Parent_Entity__c,lst);
			}
			else
			{
				if(objExpense.Entity_Name__r.Parent_Entity__c == null)
					mapIdToListExpense.get(objExpense.Entity_Name__c).add(objExpense);
				else 
				 	mapIdToListExpense.get(objExpense.Entity_Name__r.Parent_Entity__c).add(objExpense);
			}
		}
		for(Loan__c objLoan : lstLoan)
		{
			
			if((!mapIdToListLoan.containsKey(objLoan.Entity__c) && objLoan.Entity__r.Parent_Entity__c == null) || 
				(objLoan.Entity__r.Parent_Entity__c != null && !mapIdToListLoan.containsKey(objLoan.Entity__r.Parent_Entity__c)) )
			{
				
				List<Loan__c> lst = new List<Loan__c>();
				lst.add(objLoan);
				if(objLoan.Entity__r.Parent_Entity__c == null)
					mapIdToListLoan.put(objLoan.Entity__c,lst);
				else
					mapIdToListLoan.put(objLoan.Entity__r.Parent_Entity__c,lst);
			}
			else
			{
				if(objLoan.Entity__r.Parent_Entity__c == null)
					mapIdToListLoan.get(objLoan.Entity__c).add(objLoan);
				else 
				 	mapIdToListLoan.get(objLoan.Entity__r.Parent_Entity__c).add(objLoan);
			}
		}
		for(Insurance__c objInsurance : lstInsurance)
		{
			
			if((!mapIdToListInsurance.containsKey(objInsurance.Entity__c) && objInsurance.Entity__r.Parent_Entity__c == null) || 
				(objInsurance.Entity__r.Parent_Entity__c != null && !mapIdToListInsurance.containsKey(objInsurance.Entity__r.Parent_Entity__c)) )
			{
				
				List<Insurance__c> lst = new List<Insurance__c>();
				lst.add(objInsurance);
				if(objInsurance.Entity__r.Parent_Entity__c == null)
					mapIdToListInsurance.put(objInsurance.Entity__c,lst);
				else
					mapIdToListInsurance.put(objInsurance.Entity__r.Parent_Entity__c,lst);
			}
			else
			{
				if(objInsurance.Entity__r.Parent_Entity__c == null)
					mapIdToListInsurance.get(objInsurance.Entity__c).add(objInsurance);
				else 
				 	mapIdToListInsurance.get(objInsurance.Entity__r.Parent_Entity__c).add(objInsurance);
			}
		}
		for(Asset__c objAsset : lstAsset)
		{
			
			if((!mapIdToListAsset.containsKey(objAsset.Entity__c) && objAsset.Entity__r.Parent_Entity__c == null) || 
				(objAsset.Entity__r.Parent_Entity__c != null && !mapIdToListAsset.containsKey(objAsset.Entity__r.Parent_Entity__c)) )
			{
				
				List<Asset__c> lst = new List<Asset__c>();
				lst.add(objAsset);
				if(objAsset.Entity__r.Parent_Entity__c == null)
					mapIdToListAsset.put(objAsset.Entity__c,lst);
				else
					mapIdToListAsset.put(objAsset.Entity__r.Parent_Entity__c,lst);
			}
			else
			{
				if(objAsset.Entity__r.Parent_Entity__c == null)
					mapIdToListAsset.get(objAsset.Entity__c).add(objAsset);
				else 
				 	mapIdToListAsset.get(objAsset.Entity__r.Parent_Entity__c).add(objAsset);
			}
		}
		for(Investment_Asset__c objInvAsset : lstInvAsset)
		{
			
			if((!mapIdToListInvAsset.containsKey(objInvAsset.Entity__c) && objInvAsset.Entity__r.Parent_Entity__c == null) || 
				(objInvAsset.Entity__r.Parent_Entity__c != null && !mapIdToListInvAsset.containsKey(objInvAsset.Entity__r.Parent_Entity__c)) )
			{
				
				List<Investment_Asset__c> lst = new List<Investment_Asset__c>();
				lst.add(objInvAsset);
				if(objInvAsset.Entity__r.Parent_Entity__c == null)
					mapIdToListInvAsset.put(objInvAsset.Entity__c,lst);
				else
					mapIdToListInvAsset.put(objInvAsset.Entity__r.Parent_Entity__c,lst);
			}
			else
			{
				if(objInvAsset.Entity__r.Parent_Entity__c == null)
					mapIdToListInvAsset.get(objInvAsset.Entity__c).add(objInvAsset);
				else 
				 	mapIdToListInvAsset.get(objInvAsset.Entity__r.Parent_Entity__c).add(objInvAsset);
			}
		}
		
		for(Account objAccount : lstClientAccount)
		{
			Decimal totalCashFlow = 0.0;
			Decimal totalIncome = 0.0;
			Decimal totalExpense = 0.0;
			lstIncome = new List<Income__c>();
			lstExpense = new List<Expense__c>();
			lstLoan = new List<Loan__c>();
			lstInsurance = new List<Insurance__c>();
			lstAsset = new List<Asset__c>();
			lstInvAsset = new List<Investment_Asset__c>();
			Integer currentYear = system.today().year();
			Account objClientAccount = mapIdToClientAccount.get(objAccount.Id);
			system.debug('---objClientAccount.Name-----'+objClientAccount.Name);
			if(objClientAccount.Plan_Generation_Date__c != null) 
	        	currentYear = objClientAccount.Plan_Generation_Date__c.year();
	        else
	        	currentYear = system.today().year();
			//lstCashFlowDetails = new List<CashFlowDetails>();
			
			system.debug('------lstInvAsset-----'+lstInvAsset);
	
			if(mapIdToListIncome.containsKey(objAccount.Id))
				lstIncome = mapIdToListIncome.get(objAccount.Id);
			for(Income__c objIncome : lstIncome)
			{
				Integer endYear;
				if(objIncome.end_Year__c != null) 
				{
                	endYear = Integer.valueof(objIncome.end_year__c);
            	} 
            	else 
            	{
                	endYear = currentYear;
            	}
            	if(endYear >= currentYear && (objIncome.Start_Year__c <= String.valueOf(currentYear)))
            	{
            		if(objIncome.Monthly_Income__c != null)
            		{
						totalIncome += objIncome.Monthly_Income__c*12;
						system.debug('----objIncome.Income_Amount__c*12-----'+Math.ceil(objIncome.Monthly_Income__c)*12);
            		}
				}
			}
			system.debug('-----objClientAccount.Name--'+objClientAccount.Name+'--lstIncome----------'+lstIncome.size());	
			system.debug('---------totalIncome----------'+totalIncome);
			if(mapIdToListExpense.containsKey(objAccount.Id))
				lstExpense = mapIdToListExpense.get(objAccount.Id);
			system.debug('-----objClientAccount.Name--'+objClientAccount.Name+'--lstExpense----------'+lstExpense.size());	
			for(Expense__c objExpense : lstExpense)
			{
				Integer endYear;
				if(objExpense.end_Year__c != null) 
				{
                	endYear = Integer.valueof(objExpense.end_year__c);
	            } 
	            else 
	            {
	                endYear = currentYear;
	            }
	            if(endYear >= currentYear && (objExpense.Start_Year__c <= String.valueOf(currentYear)))
	            {
	            	if(objExpense.MonthlyExpense__c != null)
	            	{
						totalExpense += objExpense.MonthlyExpense__c*12;
						system.debug('----objExpense.MonthlyExpense__c*12-----'+Math.ceil(objExpense.MonthlyExpense__c)*12);
	            	}
	            }
			}
			if(mapIdToListLoan.containsKey(objAccount.Id))
				lstLoan = mapIdToListLoan.get(objAccount.Id);
			system.debug('-----objClientAccount.Name--'+objClientAccount.Name+'--lstLoan----------'+lstLoan.size());	
			for(Loan__c objLoan : lstLoan)
			{
				Decimal balanceYears;
				Integer endYear;
				if(objLoan.Balance_No_of_Years__c != null) 
	            {
	                balanceYears = objLoan.Balance_No_of_Years__c;   
	                endYear = currentYear + Integer.valueof(String.valueOf(balanceYears).trim()); 
	            } 
	            else 
	            {
	                endYear = currentYear;
	            }
	           	if(endYear >= currentYear)
	           	{
	           		if(objLoan.EMI__c != null)
	           		{
						totalExpense += objLoan.EMI__c*12;
						system.debug('----objLoan.EMI__c*12-----'+Math.ceil(objLoan.EMI__c)*12);
	           		}
	           	}
			}
			Decimal insuranceTotal = 0.0;
			Decimal assetsTotal = 0.0;	
			
			if(mapIdToListInsurance.containsKey(objAccount.Id))
				lstInsurance = mapIdToListInsurance.get(objAccount.Id);
			system.debug('-----objClientAccount.Name--'+objClientAccount.Name+'--lstInsurance----------'+lstInsurance.size());
			for(Insurance__c objInsurance : lstInsurance)
			{
				Integer startYear,endYear;
       			Date tempDate  = (objInsurance.Commencement_Date__c);
            
	            if(objInsurance.Commencement_Date__c != null) 
	            {
	                startYear = tempDate.year(); 
	            } else {
	                startYear = currentYear;
	            }
	            Integer iInsuranceEndYear = 0;
	            if(objInsurance.Premium_Paying_Term__c != null)
	            {
	            	iInsuranceEndYear = Integer.valueof(String.valueOf(objInsurance.Premium_Paying_Term__c).trim());
	            }
	            else if(objInsurance.Tenure_of_Insurance__c != null)
	            {
	            	iInsuranceEndYear = Integer.valueof(String.valueOf(objInsurance.Tenure_of_Insurance__c).trim());
	            }
	            
	            if(objInsurance.Premium_Paying_Term__c != null || objInsurance.Tenure_of_Insurance__c != null)
	            {
					endYear = startYear + iInsuranceEndYear;
					endYear = endYear - 1;
	            } 
	            else 
	            {
	                endYear = currentYear; 
	            }
	            system.debug('------startYear------'+startYear);   
	            system.debug('------endYear------'+endYear);   
	            if(endYear >= currentYear)
				{
					if(objInsurance.Annual_Premium_amount__c != null)
					{
						totalExpense += objInsurance.Annual_Premium_amount__c;
						insuranceTotal += objInsurance.Annual_Premium_amount__c;
						system.debug('----objInsurance.Annual_Premium_amount__c-----'+objInsurance.Annual_Premium_amount__c);
					}
				}            	
			}
			
			if(mapIdToListAsset.containsKey(objAccount.Id))
				lstAsset = mapIdToListAsset.get(objAccount.Id);
			system.debug('-----objClientAccount.Name--'+objClientAccount.Name+'--lstAsset----------'+lstAsset.size());	
			for(Asset__c objAsset : lstAsset)
			{
				Integer endYear;
	            if(objAsset.end_Year__c != null) 
	            {
	                endYear = Integer.valueof(objAsset.end_year__c);
	                endYear = endYear - 1;
	            } 
	            else 
	            {
	                endYear = currentYear;
	            }
	            if(endYear >= currentYear && (objAsset.Start_Year__c <= String.valueOf(currentYear)))
				{	
					if(objAsset.Annual_Contribution__c != null)
					{
						totalExpense += objAsset.Annual_Contribution__c;
						assetsTotal += objAsset.Annual_Contribution__c;
						system.debug('----objAsset.Annual_Contribution__c-----'+objAsset.Annual_Contribution__c);
					}
				}
			}
			if(mapIdToListInvAsset.containsKey(objAccount.Id))
				lstInvAsset = mapIdToListInvAsset.get(objAccount.Id);
			
			for(Investment_Asset__c objInvAsset : lstInvAsset)
			{
				if(objInvAsset.Monthly_SIP_Amount__c != null)
				{	
					totalExpense += objInvAsset.Monthly_SIP_Amount__c * 12;
					assetsTotal	 += objInvAsset.Monthly_SIP_Amount__c * 12;
					system.debug('----objInvAsset.Monthly_SIP_Amount__c * 12-----'+objInvAsset.Monthly_SIP_Amount__c * 12);
				}
			}
			system.debug('---------assetsTotal----------'+Math.round(assetsTotal));
			system.debug('---------insuranceTotal----------'+Math.round(insuranceTotal));
			system.debug('-----objClientAccount.Name--'+objClientAccount.Name+'--totalIncome----------'+totalIncome);		
			system.debug('-----objClientAccount.Name--'+objClientAccount.Name+'--totalExpense----------'+totalExpense);		
			totalCashFlow = totalIncome - totalExpense;
			system.debug('-----objClientAccount.Name--'+objClientAccount.Name+'--totalCashFlow----------'+totalCashFlow);		
			lstCashFlowDetails.add(new CashFlowDetails(objClientAccount.Name,totalCashFlow));
		}
	}
	
	
	public class CashFlowDetails
	{
		
		public String EntityName {get;set;}
		public Decimal totalCashFlow {get;set;}
		public CashFlowDetails(String EntityName,Decimal totalCashFlow)
		{
			system.debug('---------CashFlowDetails-EntityName--'+EntityName);
			this.EntityName = EntityName;
			this.totalCashFlow = totalCashFlow;
		}
	}
}