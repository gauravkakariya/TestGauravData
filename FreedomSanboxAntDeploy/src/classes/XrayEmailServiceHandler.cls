/*
    Revision History:
    
    Version     Version Author     Date           Comments
    1.0         Gaurav             13/03/2013     This Class is used to parse xml data of Xray and Create respective x ray record.
                                                  This Apex class is Used to download attachment from Inbound Email Service.
 *  This Class implements the Messaging.InboundEmailHandler interface which allows you to process := 
 *  1.The email contents 
 *  2.Headers 
 *  3.Attachments                                                  
    
*/

global class XrayEmailServiceHandler implements Messaging.InboundEmailHandler {
    
    private static string strXmlFileBody;
    private static string strCsvFileName; 
    public static string strFromEmailAddress; 
    /* Using the handleInboundEmail method, we can access an InboundEmail object :=
    * 1. To retrieve the contents, headers, and attachments of inbound email messages.
    */ 
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
                                                           Messaging.InboundEnvelope envelope){
        // Create an InboundEmailResult object for returning
        // the result of the Force.com Email Service
        Messaging.InboundEmailResult inboundEmailResult = new Messaging.InboundEmailResult();
        strFromEmailAddress = envelope.fromAddress;
        system.debug('****strFromEmailAddress'+strFromEmailAddress);
        
                 
        // An InboundEmail object stores text attachments in an InboundEmail.TextAttachment object.
        Messaging.InboundEmail.TextAttachment[] textAttachment = email.textAttachments;
        AttachXrayRecordController attachXrayRecordController = new AttachXrayRecordController(strFromEmailAddress);
        // To check if the attachement is Not NULL and having size > 0
        if(textAttachment != NULL && textAttachment.size() > 0){
           for(Messaging.InboundEmail.TextAttachment textAttachmentFile : textAttachment){
            system.debug('****textAttachmentFile.body'+textAttachmentFile.body);
             if(textAttachmentFile.filename.endsWith('.xml')){ 
                strXmlFileBody = textAttachmentFile.body;
                strCsvFileName = textAttachmentFile.filename;
                
                blob attachmentBody = Blob.valueof(strXmlFileBody);
                system.debug('****strXmlFileBody'+strXmlFileBody);
                /* Pass the body of the Xml file to :
                 * parseXmlFileRecord function in AttachXrayrRecordController class */
                attachXrayRecordController.parseXmlFileRecord(attachmentBody);
               
                
             }//End of Inner if
           }//End of for
        }//End of Outer if
         attachXrayRecordController.sendSuccessMail();      
         // Return the result for the Apex Email Service
         return inboundEmailResult; 
   } //End of handleInboundEmail
    


}