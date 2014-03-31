public with sharing class UploadDocument {
    
    private String parentID;
    public UploadDocument(ApexPages.StandardController controller) {
       system.debug('****controller******'+(Account)controller.getRecord());
       Account ID = (Account)controller.getRecord();
       parentID = String.valueOf(ID);
    }

     public Attachment attachment {
     get {
        if (attachment == null)
          attachment = new Attachment();
        return attachment;
      }
     set;
     }
 
  public PageReference upload() {
 
    attachment.OwnerId = UserInfo.getUserId();
    attachment.ParentId = parentID;
    attachment.IsPrivate = true;
 
    try {
      insert attachment;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
      return null;
    } finally {
      attachment = new Attachment(); 
    }
 
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
    return null;
  }

}