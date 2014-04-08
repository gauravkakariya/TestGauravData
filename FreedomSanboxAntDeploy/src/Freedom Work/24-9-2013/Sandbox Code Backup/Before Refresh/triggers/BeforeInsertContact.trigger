trigger BeforeInsertContact on Contact (before insert) 
{
   HandlerForBeforeInsertContact objContact = new HandlerForBeforeInsertContact();
   objContact.beforeInsertContact(trigger.new);
}