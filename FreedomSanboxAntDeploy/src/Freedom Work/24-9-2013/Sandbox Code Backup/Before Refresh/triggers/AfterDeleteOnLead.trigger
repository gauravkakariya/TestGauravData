trigger AfterDeleteOnLead on Lead (after delete) 
{
	HandlerForAfterDeleteOnLead objHandlerLead = new HandlerForAfterDeleteOnLead();
	objHandlerLead.afterDeleteLead(trigger.old);
}