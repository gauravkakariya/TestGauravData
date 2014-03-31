@isTest
private class TestSendEmailFunctionality {

    static testMethod void myUnitTest() {
    	Test.startTest();
    	
    	Lead lead = new Lead();
    	lead.LastName = 'Test';
    	lead.Status = 'Open';
    	insert lead;
    	Exception ex;
    	Attachment fileAttachment = new Attachment();
        fileAttachment.ParentId = lead.Id;
        fileAttachment.Body = Blob.valueOf('Test');
    	fileAttachment.Name = 'Test';
    	insert fileAttachment;
    	SendEmailFunctionality.sendCVattachment(lead, fileAttachment);
        SendEmailFunctionality.GetEmailfileattachmentByAttachment(fileAttachment);
        SendEmailFunctionality.SendExceptionMail(ex);
        Test.stopTest();
        
    }
}