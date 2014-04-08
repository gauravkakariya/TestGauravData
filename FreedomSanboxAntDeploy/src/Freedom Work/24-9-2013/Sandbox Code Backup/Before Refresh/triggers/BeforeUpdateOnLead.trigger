trigger BeforeUpdateOnLead on Lead (before update) 
{
	HandlerForBeforeUpdateOnLead objLead = new HandlerForBeforeUpdateOnLead();
	objLead.beforeUpdateLead(trigger.new,trigger.old);
}