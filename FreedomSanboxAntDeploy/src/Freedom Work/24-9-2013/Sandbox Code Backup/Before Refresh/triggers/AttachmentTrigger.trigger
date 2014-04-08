trigger AttachmentTrigger on Attachment (after insert) {
	
	AttachmentHandler handler = new AttachmentHandler();   
                                                
       if(Trigger.isInsert && Trigger.isAfter){
         //handler.OnAfterInsert(Trigger.new); 
      }          
	
}//AttachmentTrigger