public class PurchaseOrderHandler 
{
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
		
}