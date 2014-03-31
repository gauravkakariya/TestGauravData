trigger BeforeUpdateOnUser on User (before update) 
{
	HandlerForBeforeUpdateOnUser objUser = new HandlerForBeforeUpdateOnUser();
	objUser.beforeUpdateUser(trigger.new,trigger.old);
}