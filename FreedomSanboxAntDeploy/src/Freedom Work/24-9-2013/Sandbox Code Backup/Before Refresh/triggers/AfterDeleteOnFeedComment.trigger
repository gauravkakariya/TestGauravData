trigger AfterDeleteOnFeedComment on FeedComment (after delete) 
{
	HandlerForAfterDeleteOnFeedComment objHandlerFeedComment = new HandlerForAfterDeleteOnFeedComment();
	objHandlerFeedComment.afterDeleteFeedComment(trigger.old);
}