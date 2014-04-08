public class OrderDetailHandler 
{
	public void onAfterInsert(Map<Id, Order_Detail__c> mapNewIdToOrderDetail)
	{
		Map<Id, Order_Detail__c> mapEntityIdToOrderDetail = new Map<Id, Order_Detail__c>();
		List<FeedItem> lstFeedItem = new List<FeedItem>();
		for(Order_Detail__c objOD : mapNewIdToOrderDetail.values())
		{
			mapEntityIdToOrderDetail.put(objOD.Account__c, objOD);
		}
		
		Map<Id, Account> mapIdToEntity = new Map<Id, Account>([Select Name from Account where Id IN : mapEntityIdToOrderDetail.keySet()]);
		
		for(Id entityId : mapIdToEntity.keySet())
		{
			FeedItem post = new FeedItem();
			post.ParentId = entityId;
			post.Body = 'New Order: '+ mapEntityIdToOrderDetail.get(entityId).Order_Number__c + ' has created for Entity "'+ mapIdToEntity.get(entityId).Name+'".';
							     			
			lstFeedItem.add(post);
		}
		
		insert lstFeedItem;
	}
}