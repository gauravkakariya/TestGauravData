trigger AfterInsertChatterEntryOnTask on Task (after insert)
{
	/*
	List<FeedPost> lstPosts = new List<FeedPost>();
	
	if(trigger.isAfter && trigger.isInsert)
	{
		
		for(Task objTask : Trigger.new)
		{
			if(objTask.IsRecurrence == true || objTask.RecurrenceActivityId == null)
			{
				if(objTask != null)
				{
					String bodyText = ' has created ' + objTask.Subject +  ' task.';
					String id = String.valueOf(objTask.Id).substring(0,15);
					FeedPost objFeedPost = new FeedPost();
					objFeedPost.ParentId = objTask.OwnerId;
					objFeedPost.Type = 'LinkPost';
					objFeedPost.Body = bodyText;
					//URL.getSalesforceBaseUrl().toExternalForm();
					objFeedPost.LinkURL = URL.getSalesforceBaseUrl().toExternalForm() +'/'+id;
					lstPosts.add(objFeedPost);
				}
			}
		}
	}
	if(!lstPosts.isEmpty())
	{
		List<Database.Saveresult> lstPostSaveResult = Database.insert(lstPosts);
		System.debug('### lstPostSaveResult ===>> ' + lstPostSaveResult);
	}
	*/
}