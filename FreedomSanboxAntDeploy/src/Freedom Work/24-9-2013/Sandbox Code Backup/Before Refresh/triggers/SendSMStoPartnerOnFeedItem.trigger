trigger SendSMStoPartnerOnFeedItem on FeedItem (after insert, after update) {
	new SendSMStoPartnerOnFeedItem(trigger.old,trigger.new).execute();
}