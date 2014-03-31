trigger AfterDeleteOnFeedItem on FeedItem (after delete) 
{
	HandlerForAfterDeleteOnFeedItem objHandlerFeedItem = new HandlerForAfterDeleteOnFeedItem();
	objHandlerFeedItem.afterDeleteFeedItem(trigger.old);
}