//Test
public without sharing class AccountHandler 
{
	public static string BUSINESS_PARTNER = 'Business Partner';
	
	public static void updateGlobalAssumption(List<Account> lstAccount,Map<Id,Account> MapAccount,Boolean isInsert)
	{
		if(lstAccount.IsEmpty())
		return;
		
		Map<Id,Id> MapAccIdVsUserId = new Map<Id,Id>(); 
		Map<String,String> MapUserIdAccId = new Map<String,String>();
		Map<String,List<Entity_Global_Assumption__c>> MapAccIdofGBA = new Map<String,List<Entity_Global_Assumption__c>>();  
		List<Entity_Global_Assumption__c> lstEntityGlobalAssumption = new List<Entity_Global_Assumption__c>();
		
		if(isInsert)
		{
			for(Account objAcc : [Select Related_To__c,OwnerId from Account where id in :lstAccount])
			{
				if(objAcc.Related_To__c == null) continue;
				
				System.debug('Before ============ objAcc.OwnerId =>'+objAcc.OwnerId);
				if(String.valueOf(objAcc.Related_To__c).equalsIgnoreCase(BUSINESS_PARTNER)){
					MapAccIdVsUserId.put(objAcc.Id,objAcc.OwnerId);
				}
			}
		}else{
				for(Account objAcc : lstAccount){
				if(objAcc.Related_To__c == null) continue;
				if(String.valueOf(objAcc.Related_To__c).equalsIgnoreCase(BUSINESS_PARTNER)){
					MapAccIdVsUserId.put(objAcc.Id,objAcc.OwnerId);
				}
			}
		}
		
		if(MapAccIdVsUserId != Null && MapAccIdVsUserId.KeySet() != Null)
		{
			// Collect Global Assumption
			for(Entity_Global_Assumption__c objGBA : [select IsChanged__c,LastModifiedDate, CreatedDate,Expected_Return_on_Investment__c,Account__c,Income_Growth_Rate__c,Inflation_Rate__c,Stock_Growth_Rate__c ,Gold_Growth_Rate__c,	   
								Number_Of_Months__c,Default_Retirement_Age__c,Default_Estimated_Life_Expectancy__c from Entity_Global_Assumption__c
								where Account__c =: MapAccIdVsUserId.KeySet() and IsChanged__c = false])
			{
				if(MapAccIdofGBA.ContainsKey(objGBA.Account__c))
					MapAccIdofGBA.get(objGBA.Account__c).add(objGBA);
				else{
					List<Entity_Global_Assumption__c> lstEGBA = new List<Entity_Global_Assumption__c>();
					lstEGBA.add(objGBA);
					MapAccIdofGBA.put(objGBA.Account__c,lstEGBA);
				}	
			}
			
			if(MapAccIdVsUserId.IsEmpty()) return;
			for(User objUser : [Select u.AccountId From User u where Id in : MapAccIdVsUserId.values()]){
				MapUserIdAccId.put(objUser.Id,objUser.AccountId);
			}
			
			if(MapUserIdAccId.IsEmpty()) return;
			
			Map<Id,Account> mapAcc = new Map<Id,Account>([select Id,Logo__c, Email_ID__c,IsCreatedByPartner__c,Expected_Return_on_Investment__c,Income_Growth_Rate__c,
	                    			Gold_Growth_Rate__c,Stock_Growth_Rate__c,Inflation_Rate__c,Default_Estimated_Life_Expectancy__c,
	                    			Number_Of_Months__c,Company_Address__c,Default_Retirement_Age__c,Phone,Name from Account where id in : MapUserIdAccId.values()]);
	        
	        
	        System.debug('=========mapAcc ==============> 3'+mapAcc);
	          			
	        for(String strAccId : MapAccIdVsUserId.keySet()){
	        	if(mapAcc.get(MapUserIdAccId.get(MapAccIdVsUserId.get(strAccId))) != null){
	        		Account objAcc = mapAcc.get(MapUserIdAccId.get(MapAccIdVsUserId.get(strAccId)));
	        		if(MapAccIdofGBA.get(strAccId) != null)
	        		{
	        			for(Entity_Global_Assumption__c globalAspt : MapAccIdofGBA.get(strAccId))
	        			{
	        				if(globalAspt.IsChanged__c)
	        				continue;
	        				
	        				globalAspt.Expected_Return_on_Investment__c = objAcc.Expected_Return_on_Investment__c;
	                        globalAspt.Income_Growth_Rate__c = objAcc.Income_Growth_Rate__c;
	                        globalAspt.Inflation_Rate__c = objAcc.Inflation_Rate__c;
	                        globalAspt.Number_Of_Months__c = objAcc.Number_Of_Months__c;
	                        globalAspt.Default_Retirement_Age__c = objAcc.Default_Retirement_Age__c;
	                        globalAspt.Default_Estimated_Life_Expectancy__c = objAcc.Default_Estimated_Life_Expectancy__c;
	                        globalAspt.Stock_Growth_Rate__c = objAcc.Stock_Growth_Rate__c;
	                        globalAspt.Gold_Growth_Rate__c = objAcc.Gold_Growth_Rate__c;
	                        lstEntityGlobalAssumption.add(globalAspt);	
	        			}
	        		}
	        	}
	        }
		}
        if(!lstEntityGlobalAssumption.IsEmpty())
        	update lstEntityGlobalAssumption;
	}
	
	// Added by Niket Chandane : 14 June 2013 : To avoid to many SOQL on Account
	public static void BeforeInsertBeforeUpdateAccount(List<Account> lstAccount)
	{
		if(lstAccount == null || lstAccount.isEmpty()) return;
		Set<Id> setOwner = new Set<Id>(); 
		Map<Id,Account> MapClientsIdToAccount = new  Map<Id,Account>();
		set<Id> parentIdSet = new set<Id>(); 
		Boolean isParentEntity = false;
		
		Map<Id,Id> MapUserIdVsConId = new Map<Id,Id>();
		
		Set<Id> SetOwnerId = new Set<Id>();
		for(Account objAcc : lstAccount){
			SetOwnerId.add(objAcc.OwnerId);
		}
		
		for(User objUser : [select Id,Name,ProfileId,ContactId,Profile.Name from User where Id in : SetOwnerId])
			MapUserIdVsConId.put(objUser.Id,objUser.ContactId);
		
		if(isParentEntity)
			MapClientsIdToAccount = new Map<Id,Account>([select id,Related_To__c,Virtual_Partner__c from Account where Id in: parentIdSet ]);
		Set<Id> virtualPartnerIdSet = new Set<Id>();
		for(Account objAccount : lstAccount)
   		{
   			if(objAccount.Virtual_Partner__c != null)
   				virtualPartnerIdSet.add(objAccount.Virtual_Partner__c);
   		}
		
		Map<Id,Account> mapIdToAccount = new Map<Id,Account>();
   	
   		for(Account objAccount : [select Id, Name, OwnerId, Owner.Name,Related_To__c from Account where Id IN: virtualPartnerIdSet])
   		{
   			mapIdToAccount.put(objAccount.Id,objAccount);
   		}	
		
    	for(account a : lstAccount)
		{
	        if(a.Parent_Entity__c == null && a.IsCreatedByPartner__c == false)
	        {
	        	// Uncomment for Virtual Partner if( a.Related_To__c == 'Ffreedom';)
	        	if(MapUserIdVsConId.get(a.OwnerId)!= null){
				 	//need to comment below statement
			 		a.Related_To__c = 'Business Partner';
					a.IsCreatedByPartner__c =true;
				}
				//need to comment below else block
				else if(a.Virtual_Partner__c != null)
				{
				 	//a.Related_To__c = 'Virtual Partner';
				 	if(mapIdToAccount.containsKey(a.Virtual_Partner__c))
			 		{
			 			if(mapIdToAccount.get(a.Virtual_Partner__c).Related_To__c == 'Ffreedom')
			 			{
			 				a.Related_To__c = 'Ffreedom';
			 			}
					 	else
					 	{
					 		a.Related_To__c = 'Virtual Partner';
					 	}
			 		}
				}
				else if(a.RecordTypeId != RecTypes__c.getInstance('General_Business').Record_Type_Value__c){
				 	//need to comment below statement
				 	a.IsCreatedByPartner__c =false;
				 	a.Related_To__c = 'Ffreedom';
				}
	        }
	        else{
	        	if(!MapClientsIdToAccount.IsEmpty() && MapClientsIdToAccount.containsKey(a.Parent_Entity__c)){
	        		Account objAcc = MapClientsIdToAccount.get(a.Parent_Entity__c);
	        		a.Virtual_Partner__c =  objAcc.Virtual_Partner__c;
	        		a.Related_To__c = objAcc.Related_To__c;
	        	}
	        }
		}
		
	}
	
	// Added by Niket Chandane : 14 June 2013 : To avoid to many SOQL on Account
	public static void SendRenewalSMS(List<Account> lstAccount,Map<Id,Account> oldMap)
	{
		if(lstAccount == null || lstAccount.isEmpty()) return;
		
		List<smagicbasic__smsMagic__c> smsObjects = new List<smagicbasic__smsMagic__c>();
		String renewalTplText=null;
		String discontinueTplText=null;
		
		smagicbasic__SMS_Template__c template=  [select smagicbasic__Text__c from smagicbasic__SMS_Template__c where smagicbasic__Name__c = 'Discontinuation Template' and smagicbasic__ObjectName__c = 'Account'];
		smagicbasic__SMS_Template__c renewaltpl =  [select smagicbasic__Text__c from smagicbasic__SMS_Template__c where smagicbasic__Name__c = 'Renewal Template' and smagicbasic__ObjectName__c = 'Account'];
		
		if(Renewaltpl.smagicbasic__Text__c!=null){
	        renewalTplText = Renewaltpl.smagicbasic__Text__c;
	    }
	     
	    if(template.smagicbasic__Text__c!=null){
	        discontinueTplText = template.smagicbasic__Text__c;
	    }
	    
		for(Account  acc: lstAccount){
			smagicbasic__smsMagic__c smsObj = new smagicbasic__smsMagic__c();
			Account beforeUpdatedAccount = oldMap.get(acc.Id);
		
			if(beforeUpdatedAccount.Renewal_SMS_Sent__c == false && acc.Renewal_SMS_Sent__c == true){
				try{
					smagicbasic.TemplateEngine TEngine = new smagicbasic.TemplateEngine(renewalTplText);
			        TEngine.getFieldMap(acc);
			        renewalTplText = TEngine.getReplacedTextForObject(acc, 0);
				}
				catch(QueryException e){
	                system.debug(e.getMessage());
	            }
	            smsObj.smagicbasic__PhoneNumber__c = acc.PersonMobilePhone;
		        smsObj.smagicbasic__SMSText__c = renewalTplText;
	            smsObj.smagicbasic__senderId__c = 'Ffreedom';
	            smsObj.smagicbasic__Name__c = acc.Name;
	            smsObj.Account__c = acc.Id;
	            smsObjects.add(smsObj);
			}
			
			else if(beforeUpdatedAccount.Renewal_SMS_Sent__c==true && acc.Renewal_SMS_Sent__c==false){
				try{
					smagicbasic.TemplateEngine TEngine = new smagicbasic.TemplateEngine(discontinueTplText);
				    TEngine.getFieldMap(acc);
				    discontinueTplText = TEngine.getReplacedTextForObject(acc, 0);
				}
				catch(QueryException e){
	                system.debug(e.getMessage());
	            }
	            smsObj.smagicbasic__PhoneNumber__c = acc.PersonMobilePhone;
			    smsObj.smagicbasic__SMSText__c = renewalTplText;
				smsObj.smagicbasic__senderId__c = 'Ffreedom';
	            smsObj.smagicbasic__Name__c = acc.Name;
	            smsObj.Account__c = acc.Id;
	            smsObjects.add(smsObj);
			}
		}
		if(!Test.isRunningTest())
			insert smsObjects;
		
	}
	
	// Added by Niket Chandane : 14 June 2013 : to avoid to many SOQL on Account  
	public static void SendDiscontinuationSMS(List<Account> lstAccount,Map<Id,Account> oldMap)
	{
		if(lstAccount == null || lstAccount.isEmpty()) return;
		
		List<smagicbasic__smsMagic__c> smsObjects = new List<smagicbasic__smsMagic__c>();
		String discontinueTplText = null;
		smagicbasic__smsMagic__c smsObj = new smagicbasic__smsMagic__c();
		List<smagicbasic__SMS_Template__c> template = [select smagicbasic__Text__c from smagicbasic__SMS_Template__c where smagicbasic__Name__c = 'Discontinuation Template' and smagicbasic__ObjectName__c = 'Account'];
		if(template.size()>0)
		{
			if(template[0].smagicbasic__Text__c!=null)
			{
	      	  discontinueTplText = template[0].smagicbasic__Text__c;
	    	}
		}
	    
		for(Account acc : lstAccount)
		{
			Account beforeUpdatedAccount = oldMap.get(acc.Id);
			if(beforeUpdatedAccount.Discontinuation_SMS_Sent__c == false && acc.Discontinuation_SMS_Sent__c == true){
				try{
					smagicbasic.TemplateEngine TEngine = new smagicbasic.TemplateEngine(discontinueTplText);
			        TEngine.getFieldMap(acc);
			        discontinueTplText = TEngine.getReplacedTextForObject(acc, 0);
				}
				catch(QueryException e){
	                system.debug(e.getMessage());
	            }
	            smsObj.smagicbasic__PhoneNumber__c = acc.PersonMobilePhone;
				smsObj.smagicbasic__SMSText__c = discontinueTplText;
	            smsObj.smagicbasic__senderId__c = 'Ffreedom';
	            smsObj.smagicbasic__Name__c = acc.Name;
	            smsObj.Account__c = acc.Id;
	            smsObjects.add(smsObj);
			}
		}
		if(!smsObjects.isEmpty())
			insert smsObjects;
	}
	
	public void onBeforeInsert(List<Account> lstNewAccount)
	{
		RecordType objRecordType = [Select Id from RecordType where Name = 'Client' and sObjectType = 'Account'];
		List<Account> lstAccount = new List<Account>();
		Map<Id, List<Account>> mapPFPIdTolstAccount = new Map<Id, List<Account>>();
		
		for(Account objAccount : lstNewAccount)
		{
			if(objAccount.RecordTypeId == objRecordType.Id && objAccount.Virtual_Partner__c != null)
			{
				if(!mapPFPIdTolstAccount.containsKey(objAccount.Virtual_Partner__c))
				{
					mapPFPIdTolstAccount.put(objAccount.Virtual_Partner__c, new List<Account>{objAccount});
				}
				else
				{
					mapPFPIdTolstAccount.get(objAccount.Virtual_Partner__c).add(objAccount);
				}
			}
		}
		
		Map<String, Id> mapEntityNameToId = new Map<String, Id>();
   		
   		for(Account objAccount : [select Id, Name, OwnerId, Related_To__c from Account where Id IN: mapPFPIdTolstAccount.keySet() ])
   		{
   			mapEntityNameToId.put(objAccount.Name, objAccount.Id);
   		}
   		
   		for(User objUser : [Select Id, Name, ManagerId from User where Name IN: mapEntityNameToId.keySet()])
   		{
   			for(Account objAccount : mapPFPIdTolstAccount.get(mapEntityNameToId.get(objUser.Name)))
   			{
   				objAccount.OwnerId = objUser.Id;
   				objAccount.Channel_Manager__c = objUser.ManagerId;
   			}
   		}
	}
	
	
	public void executeOnBeforeUpdate(List<Account> lstNewAccountList, Set<Id> setAccountId)
	{
		List<String> lstSelectedProduct = new List<String>();
		
	    Map<String, Product_Master__c> mapProductMaster = new Map<String, Product_Master__c>();
		Map<Id, Purchase_Order__c> mapPurchaseOrder = new Map<Id, Purchase_Order__c>();
		Map<Id, Renewal__c> mapRenewal = new Map<Id, Renewal__c>();
		
			
		for(Purchase_Order__c objPO : [Select Id,Selected_Product__c, Entity__c From Purchase_Order__c 
											Where Product_Type__c = 'Base Product' and Is_Cancel__c = false and Order_Status__c = 'Executed' And Entity__c IN: setAccountId ])		
		{
			mapPurchaseOrder.put(objPO.Entity__c, objPO);
			lstSelectedProduct.add(objPO.Selected_Product__c);
		}											
		
		
		//Getting Product Master record from Selected Product Name from purchase order
		for(Product_Master__c objProductMaster : [Select Id, Name,Product_Name__c,Renewal_Grace_Days__c, Renewal_Period_In_Days__c From Product_Master__c
																 Where Product_Name__c IN : lstSelectedProduct])
		{
			mapProductMaster.put(objProductMaster.Product_Name__c, objProductMaster);
		}
		
		//Getting Renewal Record from Account
		for(Renewal__c objRenewal : [Select Id, Renewal_Date__c, Entity__c,Is_Renew__c from Renewal__c where Entity__c IN: setAccountId])		
		{
			mapRenewal.put(objRenewal.Entity__c, objRenewal);
		}
		
		//Iterate the Account and Update the Renewal Lapse date
		for(Account objAccount: lstNewAccountList)
		{	
			Product_Master__c objproductMaster = mapProductMaster.get(mapPurchaseOrder.get(objAccount.Id).Selected_Product__c);
			
			if(objProductMaster.Renewal_Grace_Days__c != Null || objProductMaster.Renewal_Period_In_Days__c != Null)
			{
				objAccount.Renewal_Start_Date__c = objAccount.Membership_End_Date__c.addDays(-1 * Integer.valueOf(objProductMaster.Renewal_Period_In_Days__c));
				objAccount.Renewal_Lapse_Date__c = objAccount.Membership_End_Date__c.addDays(Integer.valueOf(objProductMaster.Renewal_Grace_Days__c));
			}	
			
			mapRenewal.get(objAccount.Id).Renewal_Date__c =  objAccount.Membership_End_Date__c;		
				
		}//end for
		
		update mapRenewal.values();
	}
}