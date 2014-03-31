trigger SendSMStoPartnerOnFeedComment on FeedComment (after insert, after update) {
	new SendSMStoPartnerOnFeedComment(trigger.old,trigger.new).execute();
}