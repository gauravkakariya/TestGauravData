/*
     	Author: Gaurav
     	Date : 09/1/2013
     	Subject: Wellness Lead Transfer Code
     */

trigger WellnessLeadTrigger on Lead (after update) {
	
     WellnessLeadHandler handler = new WellnessLeadHandler();  
     handler.onAfterUpdate(Trigger.new, Trigger.old);
}