public class PurchaseOrderHandler 
{
	public static Boolean isRecursiveAccountFlatCommission = true;
	
	public void onAfterInsert(Map<Id, Purchase_Order__c> mapNewIdTopPurchaseOrder)
	{
		try{
			Map<Id, Purchase_Order__c> mapEntityIdToPurchaseOrder = new Map<Id, Purchase_Order__c>();
			List<FeedItem> lstFeedItem = new List<FeedItem>();
			Set<String> setProudctOrderNumber = new Set<String>();
			
			for(Purchase_Order__c objPO : mapNewIdTopPurchaseOrder.values())
			{
				if(objPO.Product_Type__c == 'Base Product')
				{
					mapEntityIdToPurchaseOrder.put(objPO.Entity__c, objPO);
					setProudctOrderNumber.add(objPO.Order__c);
				}
			}
			
			
			Map<Id, List<Purchase_Order__c>> mapEntityIdToLstCompletedPurchaseOrder = new Map<Id, List<Purchase_Order__c>>();
			
			for(Purchase_Order__c objPO : [Select Selected_Product__c, Order__c, Entity__c from Purchase_Order__c 
											where Order__c IN: setProudctOrderNumber  and Entity__c IN: mapEntityIdToPurchaseOrder.keySet() 
											order by CreatedDate desc])
			{
				if(!mapEntityIdToLstCompletedPurchaseOrder.containsKey(objPO.Entity__c))
				{
					mapEntityIdToLstCompletedPurchaseOrder.put(objPO.Entity__c, new List<Purchase_Order__c>{objPO});
				}
				else
				{
					mapEntityIdToLstCompletedPurchaseOrder.get(objPO.Entity__c).add(objPO);
				}
			}
			
			Map<Id, Account> mapIdToEntity = new Map<Id, Account>([Select Name, OwnerId from Account where Id IN : mapEntityIdToPurchaseOrder.keySet()]);
			
			for(Id entityId : mapEntityIdToPurchaseOrder.keySet())
			{
				FeedItem post = new FeedItem();
				post.ParentId = mapIdToEntity.get(entityId).OwnerId;
				if(!mapEntityIdToLstCompletedPurchaseOrder.containsKey(entityId))
				{
					post.Body = 'New Order: '+ mapEntityIdToPurchaseOrder.get(entityId).Order__c + ' has been created for Entity "'+ mapIdToEntity.get(entityId).Name+'".';
				}
				else
				{
					Purchase_Order__c objPurchaseOrder = mapEntityIdToLstCompletedPurchaseOrder.get(EntityId)[0];
					post.Body = 'Purchase Order '+ mapEntityIdToPurchaseOrder.get(entityId).Order__c + ' has been successfully upgraded for Entity "'+ mapIdToEntity.get(entityId).Name+'" with "';
					post.Body += mapEntityIdToPurchaseOrder.get(entityId).Selected_Product__c +'" Base Proudct.';
				}				     			
				lstFeedItem.add(post);
			}
			
			insert lstFeedItem;
		}
		catch(Exception e)
		{
			System.debug('------------------------error-----------------'+e);
		}
	}
	
	
	public void onAfterInsertPurchaseOrder(Map<Id, Purchase_Order__c> mapNewIdTopPurchaseOrder)
	{
		if(isRecursiveAccountFlatCommission)
		{
			Map<Id, Purchase_Order__c> mapEntityIdToPurchaseOrder = new Map<Id, Purchase_Order__c>();
			Map<Id, String> mapPurchaseOrderIdToProductMaster = new Map<Id, String>();
			Map<Id, Product_Price_Book__c> mapProductMasterIdToPriceBook = new Map<Id, Product_Price_Book__c>();
			Map<Id, Account> mapIdToVirtualPartner = new Map<Id, Account>();
			Map<Id, Account> mapIdToVirtualPartnerId = new Map<Id, Account>();
			Map<Id, Account> mapIdToAccount = new Map<Id, Account>();
			Double flatCommission = 0;
			
			for(Purchase_Order__c objPO : mapNewIdTopPurchaseOrder.values())
			{
					mapEntityIdToPurchaseOrder.put(objPO.Entity__c, objPO);
					mapPurchaseOrderIdToProductMaster.put(objPO.Id, objPO.Product_Master__c);	
			}
														 
			List<Product_Price_Book__c> lstPriceBook =  [Select Product_code__c, 
																Price_value__c, 
																Name, 
																Flat_Commission__c 
														 From Product_Price_Book__c
														 Where Product_code__c IN : mapPurchaseOrderIdToProductMaster.values()];
														 
			for(Product_Price_Book__c objProductPriceBook : lstPriceBook)	
			{
				mapProductMasterIdToPriceBook.put(objProductPriceBook.Product_code__c, objProductPriceBook);
				system.debug('************mapProductMasterIdToPriceBook'+mapProductMasterIdToPriceBook);
			}										 
														 
			List<Account> lstAccount = [Select Id, Virtual_Partner__c, Total_Flat_Commission__c, 
				 															(Select Id 
				 															 From Product_Orders__r 
				 															 Where Id IN: mapNewIdTopPurchaseOrder.keyset() )
				 							 					    From Account 
				 							 					    Where Id IN: mapEntityIdToPurchaseOrder.keyset()]; 
				 							 					    
			for(Account objAccount : lstAccount)	
			{
				mapIdToVirtualPartnerId.put(objAccount.Virtual_Partner__c, objAccount);
				system.debug('************mapIdToVirtualPartnerId'+mapIdToVirtualPartnerId);
				mapIdToAccount.put(objAccount.Id, objAccount);
			} 							 					    
			
			map<Id, Account> mapIdToVirtualPartnerAccount = new Map<Id, Account>([Select Id, Virtual_Partner__c, Total_Flat_Commission__c 
								 							 					  From Account 
								 							 					  Where Id IN: mapIdToVirtualPartnerId.keyset()]); 									 
			for(Account objAccount : mapIdToVirtualPartnerAccount.values())
			{
				mapIdToVirtualPartner.put(objAccount.Virtual_Partner__c, objAccount);
				system.debug('************mapIdToVirtualPartner'+mapIdToVirtualPartner);
			}
			
			
			for(Purchase_Order__c objPO  : mapNewIdTopPurchaseOrder.values())
			{
				system.debug('************objPO'+objPO);
				Account objAccount =  mapIdToAccount.get(objPO.Entity__c);
				Account objPartnerAccount = mapIdToVirtualPartnerAccount.get(objAccount.Virtual_Partner__c);	
				
				system.debug('************objAccount'+objAccount);
				system.debug('************objPartnerAccount'+objPartnerAccount);
				
				Product_Price_Book__c objProductPriceBook = mapProductMasterIdToPriceBook.get(objPO.Product_Master__c);
				
				flatCommission = objPartnerAccount.Total_Flat_Commission__c != null ?  objPartnerAccount.Total_Flat_Commission__c : 0;
				objProductPriceBook.Flat_Commission__c = objProductPriceBook.Flat_Commission__c != null ? objProductPriceBook.Flat_Commission__c: 0;
				objPartnerAccount.Total_Flat_Commission__c= flatCommission + objProductPriceBook.Flat_Commission__c ;
				system.debug('************bjPartnerAccount.Total_Flat_Commission__c'+objPartnerAccount.Total_Flat_Commission__c);
				
				mapIdToVirtualPartnerAccount.put(objPartnerAccount.Id, objPartnerAccount);
			}
							 
			if(mapIdToVirtualPartnerAccount.size() > 0 && mapIdToVirtualPartnerAccount.keyset() != null)
				update mapIdToVirtualPartnerAccount.values();
			isRecursiveAccountFlatCommission = false;	
		}			 
	}
	/*
	public void onAfterUpdatePurchaseOrder(Map<Id, Purchase_Order__c> mapNewIdTopPurchaseOrder)
	{
		
		{
			Map<Id, Purchase_Order__c> mapEntityIdToPurchaseOrder = new Map<Id, Purchase_Order__c>();
			Map<Id, String> mapPurchaseOrderIdToProductMaster = new Map<Id, String>();
			Map<Id, Product_Price_Book__c> mapProductMasterIdToPriceBook = new Map<Id, Product_Price_Book__c>();
			Map<Id, Account> mapIdToVirtualPartner = new Map<Id, Account>();
			Map<Id, Account> mapIdToVirtualPartnerId = new Map<Id, Account>();
			Map<Id, Account> mapIdToAccount = new Map<Id, Account>();
			Double flatCommission = 0;
			
			for(Purchase_Order__c objPO : mapNewIdTopPurchaseOrder.values())
			{
					mapEntityIdToPurchaseOrder.put(objPO.Entity__c, objPO);
			}
						
			List<Purchase_Order__c> lstFinalPurcahseOrder = new List<Purchase_Order__c>(); 		
			lstFinalPurcahseOrder = [Select Selected_Product__c,Entity__c, Product_Type__c, 
																Product_Price__c, Product_Master__c, Name, Id 
													     From Purchase_Order__c 
													     Where Entity__c IN: mapEntityIdToPurchaseOrder.keyset()  
													    and Product_Type__c = 'Base Product' order By CreatedDate Desc limit 1];
			mapPurchaseOrderIdToProductMaster.put(lstFinalPurcahseOrder[0].Id, lstFinalPurcahseOrder[0].Product_Master__c);											    
													    			
			List<Purchase_Order__c>  lstPurchaseOrder = [Select Selected_Product__c,Entity__c, Product_Type__c, 
																Product_Price__c, Product_Master__c, Name, Id 
													     From Purchase_Order__c 
													     Where Entity__c IN: mapEntityIdToPurchaseOrder.keyset() and Product_Type__c != 'Base Product'  
													    ];
													    
			lstFinalPurcahseOrder.addAll(lstPurchaseOrder);	
												     		
			for(Purchase_Order__c objPurchaseOrder : lstPurchaseOrder)
			{
				mapPurchaseOrderIdToProductMaster.put(objPurchaseOrder.Id, objPurchaseOrder.Product_Master__c);	
			}									
				
			system.debug('************mapPurchaseOrderIdToProductMaster'+mapPurchaseOrderIdToProductMaster);	
			system.debug('************lstFinalPurcahseOrdersize'+lstFinalPurcahseOrder.size());	
			system.debug('************lstFinalPurcahseOrder'+lstFinalPurcahseOrder);	
												 
			List<Product_Price_Book__c> lstPriceBook =  [Select Product_code__c, 
																Price_value__c, 
																Name, 
																Flat_Commission__c 
														 From Product_Price_Book__c
														 Where Product_code__c IN : mapPurchaseOrderIdToProductMaster.values()];
														 
			for(Product_Price_Book__c objProductPriceBook : lstPriceBook)	
			{
				mapProductMasterIdToPriceBook.put(objProductPriceBook.Product_code__c, objProductPriceBook);
				system.debug('************mapProductMasterIdToPriceBook'+mapProductMasterIdToPriceBook);
			}										 
														 
			List<Account> lstAccount = [Select Id, Virtual_Partner__c, Total_Flat_Commission__c, 
				 															(Select Id 
				 															 From Product_Orders__r 
				 															 Where Id IN: mapNewIdTopPurchaseOrder.keyset() )
				 							 					    From Account 
				 							 					    Where Id IN: mapEntityIdToPurchaseOrder.keyset()]; 
				 							 					    
			for(Account objAccount : lstAccount)	
			{
				objAccount.Total_Flat_Commission__c = 0;
				mapIdToVirtualPartnerId.put(objAccount.Virtual_Partner__c, objAccount);
				system.debug('************mapIdToVirtualPartnerId'+mapIdToVirtualPartnerId);
				mapIdToAccount.put(objAccount.Id, objAccount);
			} 							 					    
			
			map<Id, Account> mapIdToVirtualPartnerAccount = new Map<Id, Account>([Select Id, Virtual_Partner__c, Total_Flat_Commission__c 
								 							 					  From Account 
								 							 					  Where Id IN: mapIdToVirtualPartnerId.keyset()]); 									 
			for(Account objPartnerAccount : mapIdToVirtualPartnerAccount.values())
			{
				objPartnerAccount.Total_Flat_Commission__c =  0;
				mapIdToVirtualPartner.put(objPartnerAccount.Virtual_Partner__c, objPartnerAccount);
				system.debug('************mapIdToVirtualPartner'+mapIdToVirtualPartner);
			}
			
			
			

			for(Purchase_Order__c objPO  : lstFinalPurcahseOrder)
			{
				system.debug('************objPO'+objPO);
				Account objAccount =  mapIdToAccount.get(objPO.Entity__c);
				Account objPartnerAccount = mapIdToVirtualPartnerAccount.get(objAccount.Virtual_Partner__c);	
				
				system.debug('************objPartnerAccount Tf'+objPartnerAccount.Total_Flat_Commission__c);
				system.debug('************objPartnerAccount'+objPartnerAccount);
				
				Product_Price_Book__c objProductPriceBook = mapProductMasterIdToPriceBook.get(objPO.Product_Master__c);
				objProductPriceBook.Flat_Commission__c = objProductPriceBook.Flat_Commission__c != null ? objProductPriceBook.Flat_Commission__c: 0;
				//flatCommission = objAccount.Total_Flat_Commission__c != null ?  objAccount.Total_Flat_Commission__c : 0;
				//objAccount.Total_Flat_Commission__c= flatCommission + objProductPriceBook.Flat_Commission__c ;
				
				flatCommission = objPartnerAccount.Total_Flat_Commission__c != null ?  objPartnerAccount.Total_Flat_Commission__c : 0;
				//objProductPriceBook.Flat_Commission__c = objProductPriceBook.Flat_Commission__c != null ? objProductPriceBook.Flat_Commission__c: 0;
				objPartnerAccount.Total_Flat_Commission__c= flatCommission + objProductPriceBook.Flat_Commission__c ;
				//objPartnerAccount.Total_Flat_Commission__c = flatCommission + objAccount.Total_Flat_Commission__c;
				system.debug('************bjPartnerAccount.Total_Flat_Commission__c'+objPartnerAccount.Total_Flat_Commission__c);
				
				mapIdToVirtualPartnerAccount.put(objPartnerAccount.Id, objPartnerAccount);
			}
							 
			if(mapIdToVirtualPartnerAccount.size() > 0 && mapIdToVirtualPartnerAccount.keyset() != null)
				update mapIdToVirtualPartnerAccount.values();
		}			 
		
		
	}	*/
	
	public void onAfterUpdatePurchaseOrder(Map<Id, Purchase_Order__c> mapNewIdTopPurchaseOrder)
	{
		Map<Id, List<Purchase_Order__c>> mapProductMasterIdTolstPurchaseOrder = new Map<Id, List<Purchase_Order__c>>(); 
		Map<Id, Purchase_Order__c> mapEntityIdToPurchaseOrder = new Map<Id, Purchase_Order__c>();
		Map<Id, Purchase_Order__c> mapEntityIdToPurchaseOrderNew = new Map<Id, Purchase_Order__c>();
		Map<Id, String> mapPurchaseOrderIdToProductMaster = new Map<Id, String>();
		Map<Id, Product_Price_Book__c> mapProductMasterIdToPriceBook = new Map<Id, Product_Price_Book__c>();
		Map<Id, Account> mapIdToVirtualPartner = new Map<Id, Account>();
		Map<Id, Account> mapIdToVirtualPartnerAccount = new Map<Id, Account>();
		Map<Id, Account> mapIdToAccount = new Map<Id, Account>();
		List<Product_Price_Book__c> lstPriceBook = new List<Product_Price_Book__c> ();
		Map<Id, List<Purchase_Order__c>> mapEntityIdTolstPurchaseOrder = new Map<Id, List<Purchase_Order__c>>(); 
		Set<Id> setVirtualPartnerId = new Set<Id>();
		
			
		system.debug('************mapNewIdTopPurchaseOrder'+mapNewIdTopPurchaseOrder);	
		
		
		List<Purchase_Order__c>  lstPurchaseOrder = [Select Selected_Product__c,Entity__c, Product_Type__c,
																Entity__r.Virtual_Partner__c,Product_Master__r.Name,
																Entity__r.RecordTypeId,
																Product_Price__c, Product_Master__c, Name, Id 
													 From Purchase_Order__c 
													 Where Id IN: mapNewIdTopPurchaseOrder.keySet()
													 //and Entity__r.RecordTypeId = '01220000000DnK3'
													 ];
													 
		for(Purchase_Order__c objPurchaseOrder: lstPurchaseOrder)//mapNewIdTopPurchaseOrder.values())
		{
			//mapEntityIdToPurchaseOrder.put(objPurchaseOrder.Entity__c, objPurchaseOrder);
			setVirtualPartnerId.add(objPurchaseOrder.Entity__r.Virtual_Partner__c);
			
		}
		system.debug('************setVirtualPartnerId'+setVirtualPartnerId);
		
		
			List<Purchase_Order__c> lstUpdatedPurchaseOrder = new List<Purchase_Order__c>(); 		
			List<Purchase_Order__c> lstPurchaseOrder0 = [Select Selected_Product__c,Entity__c, Product_Type__c, 
																Entity__r.Virtual_Partner__c,
																Product_Master__r.Name,
																Product_Price__c, Product_Master__c, Name, Id 
													     From Purchase_Order__c 
													     Where  Entity__r.Virtual_Partner__c IN: setVirtualPartnerId
															 and Entity__r.RecordTypeId = '01220000000DnK3'
													    and Product_Type__c = 'Base Product' order By CreatedDate Desc];
			for(Purchase_Order__c objPurchaseOrder: lstPurchaseOrder0)
			{
				if(!mapEntityIdToPurchaseOrderNew.containsKey(objPurchaseOrder.Entity__c))
				{
					mapEntityIdToPurchaseOrderNew.put(objPurchaseOrder.Entity__c, objPurchaseOrder);
					lstUpdatedPurchaseOrder.add(objPurchaseOrder);
				}	
			}										    
												    
													    			
			List<Purchase_Order__c>  lstPurchaseOrder1 = [Select Selected_Product__c,Entity__c, Product_Type__c, 
																Entity__r.Virtual_Partner__c,
																Product_Master__r.Name,
																Product_Price__c, Product_Master__c, Name, Id 
													     From Purchase_Order__c 
													     Where  Product_Type__c != 'Base Product'
													     and Entity__r.Virtual_Partner__c IN: setVirtualPartnerId  
													     and Entity__r.RecordTypeId = '01220000000DnK3'
													    ];
			
													    
				
														    
			lstUpdatedPurchaseOrder.addAll(lstPurchaseOrder1);	
			
			
		/*	
		
		List<Purchase_Order__c>  lstUpdatedPurchaseOrder = [Select Selected_Product__c,Entity__c, Product_Type__c,
																Entity__r.Virtual_Partner__c,
																Product_Price__c, Product_Master__c,Product_Master__r.Name, Name, Id 
															 From Purchase_Order__c 
															 Where Entity__r.Virtual_Partner__c IN: setVirtualPartnerId
															 and Entity__r.RecordTypeId = '01220000000DnK3'
															 and Product_Type__c = 'Base Product' order By CreatedDate Desc
															 ];
		*/													 
		if(!lstUpdatedPurchaseOrder.isEmpty())	
		{													 
			for(Purchase_Order__c objPurchaseOrder: lstUpdatedPurchaseOrder)	
			{
				if(!mapProductMasterIdTolstPurchaseOrder.containsKey(objPurchaseOrder.Product_Master__c))
					mapProductMasterIdTolstPurchaseOrder.put(objPurchaseOrder.Product_Master__c , new List<Purchase_Order__c>{objPurchaseOrder});
				else
					mapProductMasterIdTolstPurchaseOrder.get(objPurchaseOrder.Product_Master__c).add(objPurchaseOrder);
					
				mapPurchaseOrderIdToProductMaster.put(objPurchaseOrder.Id , objPurchaseOrder.Product_Master__c);
				
				if(!mapEntityIdTolstPurchaseOrder.containsKey(objPurchaseOrder.Entity__r.Virtual_Partner__c))
					mapEntityIdTolstPurchaseOrder.put(objPurchaseOrder.Entity__r.Virtual_Partner__c , new List<Purchase_Order__c>{objPurchaseOrder});
				else
					mapEntityIdTolstPurchaseOrder.get(objPurchaseOrder.Entity__r.Virtual_Partner__c).add(objPurchaseOrder);
					
			}												 
					
			lstPriceBook =  [Select Product_code__c, 
									Price_value__c, 
									Name, 
									Flat_Commission__c 
						     From Product_Price_Book__c
					         Where Product_code__c IN : mapProductMasterIdTolstPurchaseOrder.keyset()];
		}	
		
		system.debug('************mapEntityIdTolstPurchaseOrder'+mapEntityIdTolstPurchaseOrder);	
		system.debug('************lstUpdatedPurchaseOrder'+lstUpdatedPurchaseOrder.size());	
											     
		if(!lstPriceBook.isEmpty())	
		{									     
			for(Product_Price_Book__c objPriceBook: lstPriceBook)	
			{
				mapProductMasterIdToPriceBook.put(objPriceBook.Product_code__c, objPriceBook);
				system.debug('************mapProductMasterIdToPriceBook'+mapProductMasterIdToPriceBook);
			}									     
		}
		system.debug('************mapProductMasterIdToPriceBookFinal'+mapProductMasterIdToPriceBook);
		
		if(mapEntityIdTolstPurchaseOrder.keySet() != null)	
		{
			for(Id virtualPartnerId : mapEntityIdTolstPurchaseOrder.keySet())
			{
				Account objAccount = new Account(Id = virtualPartnerId);
				objAccount.Total_Flat_Commission__c = 0;
					
				List<Purchase_Order__c> lstPurchaseOrderUpdated = mapEntityIdTolstPurchaseOrder.get(virtualPartnerId); 	
				for(Purchase_Order__c objPurchaseOrder : lstPurchaseOrderUpdated)
				{
					if(objPurchaseOrder.Entity__r.Virtual_Partner__c == objAccount.Id )
					{
						system.debug('************objPurchaseOrder.Entity__r'+objPurchaseOrder.Entity__c +'Product Name  '+ objPurchaseOrder.Product_Master__r.Name);	
						Id objProductMasterId = mapPurchaseOrderIdToProductMaster.get(objPurchaseOrder.Id);
						Product_Price_Book__c objPriceBook = mapProductMasterIdToPriceBook.get(objProductMasterId);
						
						objPriceBook.Flat_Commission__c = objPriceBook.Flat_Commission__c != null ? objPriceBook.Flat_Commission__c: 0;
						objAccount.Total_Flat_Commission__c += objPriceBook.Flat_Commission__c;
						mapIdToVirtualPartnerAccount.put(objAccount.Id, objAccount);
						
						system.debug('************objAccount'+objAccount.Total_Flat_Commission__c );	
						
					}	
				}
			}
		}
		if(mapIdToVirtualPartnerAccount.size() > 0 && mapIdToVirtualPartnerAccount.keyset() != null)
				update mapIdToVirtualPartnerAccount.values();											 
		system.debug('************mapIdToVirtualPartnerAccount'+mapIdToVirtualPartnerAccount);												 													 
	}
	
	
	public void onAfterDeletePurchaseOrder(Map<Id, Purchase_Order__c> mapNewIdTopPurchaseOrder)
	{
		Map<Id, List<Purchase_Order__c>> mapProductMasterIdTolstPurchaseOrder = new Map<Id, List<Purchase_Order__c>>(); 
		Map<Id, Purchase_Order__c> mapEntityIdToPurchaseOrder = new Map<Id, Purchase_Order__c>();
		Map<Id, Purchase_Order__c> mapEntityIdToPurchaseOrderNew = new Map<Id, Purchase_Order__c>();
		Map<Id, String> mapPurchaseOrderIdToProductMaster = new Map<Id, String>();
		Map<Id, Product_Price_Book__c> mapProductMasterIdToPriceBook = new Map<Id, Product_Price_Book__c>();
		Map<Id, Account> mapIdToVirtualPartner = new Map<Id, Account>();
		Map<Id, Account> mapIdToVirtualPartnerAccount = new Map<Id, Account>();
		Map<Id, Account> mapIdToAccount = new Map<Id, Account>();
		List<Product_Price_Book__c> lstPriceBook = new List<Product_Price_Book__c> ();
		Map<Id, List<Purchase_Order__c>> mapEntityIdTolstPurchaseOrder = new Map<Id, List<Purchase_Order__c>>(); 
		Set<Id> setVirtualPartnerId = new Set<Id>();
		Set<Id> setVirtualPartnerId1 = new Set<Id>();	
			
		system.debug('************mapNewIdTopPurchaseOrder'+mapNewIdTopPurchaseOrder);	
		for(Purchase_Order__c objPurchaseOrder: mapNewIdTopPurchaseOrder.values())//mapNewIdTopPurchaseOrder.values())
		{
			setVirtualPartnerId1.add(objPurchaseOrder.Entity__c);
			//mapEntityIdToPurchaseOrder.put(objPurchaseOrder.Entity__c, objPurchaseOrder);
			
		}
		system.debug('************setVirtualPartnerId1'+setVirtualPartnerId1);
		
		List<Account> lstAccount = [Select Id, Name,Virtual_Partner__c, Total_Flat_Commission__c 
								 							 					  From Account 
								 							 					  Where  Id IN: setVirtualPartnerId1];
								 							 					  
		for(Account objAccount: lstAccount)
		{
			
			setVirtualPartnerId.add(objAccount.Virtual_Partner__c);
		}						 							 					  
								 							 					  
		system.debug('************setVirtualPartnerId'+setVirtualPartnerId);
		
		
			List<Purchase_Order__c> lstUpdatedPurchaseOrder = new List<Purchase_Order__c>(); 		
			List<Purchase_Order__c> lstPurchaseOrder0 = [Select Selected_Product__c,Entity__c, Product_Type__c, 
																Entity__r.Virtual_Partner__c,
																Product_Master__r.Name,
																Product_Price__c, Product_Master__c, Name, Id 
													     From Purchase_Order__c 
													     Where  Entity__r.Virtual_Partner__c IN: setVirtualPartnerId
															 and Entity__r.RecordTypeId = '01220000000DnK3'
													    and Product_Type__c = 'Base Product' order By CreatedDate Desc];
			for(Purchase_Order__c objPurchaseOrder: lstPurchaseOrder0)
			{
				if(!mapEntityIdToPurchaseOrderNew.containsKey(objPurchaseOrder.Entity__c))
				{
					mapEntityIdToPurchaseOrderNew.put(objPurchaseOrder.Entity__c, objPurchaseOrder);
					lstUpdatedPurchaseOrder.add(objPurchaseOrder);
				}	
			}										    
												    
													    			
			List<Purchase_Order__c>  lstPurchaseOrder1 = [Select Selected_Product__c,Entity__c, Product_Type__c, 
																Entity__r.Virtual_Partner__c,
																Product_Master__r.Name,
																Product_Price__c, Product_Master__c, Name, Id 
													     From Purchase_Order__c 
													     Where  Product_Type__c != 'Base Product'
													     and Entity__r.Virtual_Partner__c IN: setVirtualPartnerId  
													     and Entity__r.RecordTypeId = '01220000000DnK3'
													    ];
			
													    
				
														    
			lstUpdatedPurchaseOrder.addAll(lstPurchaseOrder1);	
			
			
		/*	
		
		List<Purchase_Order__c>  lstUpdatedPurchaseOrder = [Select Selected_Product__c,Entity__c, Product_Type__c,
																Entity__r.Virtual_Partner__c,
																Product_Price__c, Product_Master__c,Product_Master__r.Name, Name, Id 
															 From Purchase_Order__c 
															 Where Entity__r.Virtual_Partner__c IN: setVirtualPartnerId
															 and Entity__r.RecordTypeId = '01220000000DnK3'
															 and Product_Type__c = 'Base Product' order By CreatedDate Desc
															 ];
		*/													 
		if(!lstUpdatedPurchaseOrder.isEmpty())	
		{													 
			for(Purchase_Order__c objPurchaseOrder: lstUpdatedPurchaseOrder)	
			{
				if(!mapProductMasterIdTolstPurchaseOrder.containsKey(objPurchaseOrder.Product_Master__c))
					mapProductMasterIdTolstPurchaseOrder.put(objPurchaseOrder.Product_Master__c , new List<Purchase_Order__c>{objPurchaseOrder});
				else
					mapProductMasterIdTolstPurchaseOrder.get(objPurchaseOrder.Product_Master__c).add(objPurchaseOrder);
					
				mapPurchaseOrderIdToProductMaster.put(objPurchaseOrder.Id , objPurchaseOrder.Product_Master__c);
				
				if(!mapEntityIdTolstPurchaseOrder.containsKey(objPurchaseOrder.Entity__r.Virtual_Partner__c))
					mapEntityIdTolstPurchaseOrder.put(objPurchaseOrder.Entity__r.Virtual_Partner__c , new List<Purchase_Order__c>{objPurchaseOrder});
				else
					mapEntityIdTolstPurchaseOrder.get(objPurchaseOrder.Entity__r.Virtual_Partner__c).add(objPurchaseOrder);
					
			}												 
					
			lstPriceBook =  [Select Product_code__c, 
									Price_value__c, 
									Name, 
									Flat_Commission__c 
						     From Product_Price_Book__c
					         Where Product_code__c IN : mapProductMasterIdTolstPurchaseOrder.keyset()];
		}	
		
		system.debug('************mapEntityIdTolstPurchaseOrder'+mapEntityIdTolstPurchaseOrder);	
		system.debug('************lstUpdatedPurchaseOrder'+lstUpdatedPurchaseOrder.size());	
											     
		if(!lstPriceBook.isEmpty())	
		{									     
			for(Product_Price_Book__c objPriceBook: lstPriceBook)	
			{
				mapProductMasterIdToPriceBook.put(objPriceBook.Product_code__c, objPriceBook);
				system.debug('************mapProductMasterIdToPriceBook'+mapProductMasterIdToPriceBook);
			}									     
		}
		system.debug('************mapProductMasterIdToPriceBookFinal'+mapProductMasterIdToPriceBook);
		
		if(mapEntityIdTolstPurchaseOrder.keySet() != null)	
		{
			for(Id virtualPartnerId : mapEntityIdTolstPurchaseOrder.keySet())
			{
				Account objAccount = new Account(Id = virtualPartnerId);
				objAccount.Total_Flat_Commission__c = 0;
					
				List<Purchase_Order__c> lstPurchaseOrderUpdated = mapEntityIdTolstPurchaseOrder.get(virtualPartnerId); 	
				for(Purchase_Order__c objPurchaseOrder : lstPurchaseOrderUpdated)
				{
					if(objPurchaseOrder.Entity__r.Virtual_Partner__c == objAccount.Id )
					{
						system.debug('************objPurchaseOrder.Entity__r'+objPurchaseOrder.Entity__c +'Product Name  '+ objPurchaseOrder.Product_Master__r.Name);	
						Id objProductMasterId = mapPurchaseOrderIdToProductMaster.get(objPurchaseOrder.Id);
						Product_Price_Book__c objPriceBook = mapProductMasterIdToPriceBook.get(objProductMasterId);
						
						objPriceBook.Flat_Commission__c = objPriceBook.Flat_Commission__c != null ? objPriceBook.Flat_Commission__c: 0;
						objAccount.Total_Flat_Commission__c += objPriceBook.Flat_Commission__c;
						mapIdToVirtualPartnerAccount.put(objAccount.Id, objAccount);
						
						system.debug('************objAccount'+objAccount.Total_Flat_Commission__c );	
						
					}	
				}
			}
		}
		if(mapIdToVirtualPartnerAccount.size() > 0 && mapIdToVirtualPartnerAccount.keyset() != null)
				update mapIdToVirtualPartnerAccount.values();											 
		system.debug('************mapIdToVirtualPartnerAccount'+mapIdToVirtualPartnerAccount);												 													 
	}
		
}