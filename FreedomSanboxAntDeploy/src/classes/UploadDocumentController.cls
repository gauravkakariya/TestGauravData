public with sharing class UploadDocumentController{	
	
	public Account objAccount{get; set;}
	public List<Account> accDocLst {get; set;}
    public Boolean block{get; set;}	
	
	public UploadDocumentController(ApexPages.StandardController controller){
		accDocLst = new List<Account>();		
		system.debug('*************id*************'+ApexPages.currentPage().getParameters().get('EntityId'));
		objAccount = [Select Id, Name From Account Where Id=:ApexPages.currentPage().getParameters().get('EntityId')];
		block=false;
		getUploadedDoc();						
  	}
  	
    //contructor
    public UploadDocumentController(){    	
    }
    
  	public Attachment attachment {
		get {
      		if (attachment == null)
        	attachment = new Attachment();
      		return attachment;
    	}
		set;
	}
 
	public PageReference upload(){		
    	attachment.OwnerId = UserInfo.getUserId();
    	attachment.ParentId = objAccount.Id;
    	attachment.IsPrivate = true;
    
		try {          	
        	insert attachment;        	
         	getUploadedDoc();
    	} catch (DMLException e) {
      		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
      		return null;
    	} finally {
			attachment.Body = null;
			attachment = new Attachment(); 
    	}
 
		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Document uploaded successfully'));
    	return null;
	}

	public void getUploadedDoc(){  	
  		accDocLst = [Select Id, Name,
  	                (Select Id, IsDeleted, IsNote, ParentId, Title, IsPrivate, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp 
  	                 From NotesAndAttachments) 
  	                 From Account 
  	                 where Id=:objAccount.Id]; 
  	    block=true;	
  	} 
  	
  	public PageReference cancel() {
  		PageReference redirectPage = new PageReference('/'+objAccount.Id);		
		redirectPage.setRedirect(true);		
		return redirectPage;		
  	} 	
}