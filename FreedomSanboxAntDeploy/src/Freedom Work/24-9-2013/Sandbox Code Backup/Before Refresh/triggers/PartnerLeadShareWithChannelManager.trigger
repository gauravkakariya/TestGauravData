trigger PartnerLeadShareWithChannelManager on Lead (after update) 
{
	 PartnerLeadShare objPartnerLeadShare = new PartnerLeadShare();
 
	 if(Trigger.isAfter && Trigger.isInsert)
	 {
	     //Share Business partner Lead with Channel manger of Lead(Gold partenr license holder Manager)
	     objPartnerLeadShare.onAfterUpdate(Trigger.new);
	 } 
}