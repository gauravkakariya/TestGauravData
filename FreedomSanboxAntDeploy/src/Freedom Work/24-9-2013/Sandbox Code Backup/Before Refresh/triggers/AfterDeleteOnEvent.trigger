trigger AfterDeleteOnEvent on Event (after delete) 
{
    HandlerForAfterDeleteOnEvent objHandlerEvent = new HandlerForAfterDeleteOnEvent();
    objHandlerEvent.afterDeleteEvent(trigger.old);
}