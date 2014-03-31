/*
	Version 	Date   		Author 		Description
	1.0			26/05/2011  Niket 		Object of this class is used to add the messages to the pae
   										It contains boolean variable Success which will be true in case of 
   										success and false in case of failure and success or failure message.
*/

public class Error
{
    public class SVPException extends Exception
    {
    }
    
    public static testMethod void testErrorClass()
    {
        Error err = new Error();
        err.Success = false;
        
        Error eError = new Error();
        eError = Error.DebugLog('Data saved successfully');
        Error errMessage = Error.LogError('Error occured while Saving!!');
        Error errMessageFail = Error.LogSuccess('Data saved successfully');
        
        Contact contactNew = new Contact();
        contactNew.MailingState = 'CA';
        contactNew.MailingPostalCode = '94965';
        contactNew.LastName = 'test';
        
        Database.SaveResult saveResult = Database.insert(contactNew);
        
        try
        {
            Error.LogSaveResult(saveResult, '');
            throw new SVPException('test');
        }
        catch(Exception ex)
        {
            Error.LogException(ex);
        }
    }
    
    Public Error()
    {
      Success = true;
      ErrorMessage = new ApexPages.Message(ApexPages.Severity.Info ,'Success!');
    }
      
    public Boolean Success {get; set;}
    private ApexPages.Message ErrorMessage = new ApexPages.Message(ApexPages.Severity.Info ,'Success!');

    /* Returns: Error */
    /* Parameters: SaveResult, String */
    /* This method create object of Error class depending on the parameters passed to it and
       returns the same.*/
    public static Error LogSaveResult(Database.SaveResult saveResult, String strSuccessMessage)
    {
        Database.Error[] arrErrors = saveResult.getErrors();
        String strErrorMessage = '';
        for(Database.Error errCurrent : arrErrors)
        {
            strErrorMessage += errCurrent.getMessage() + '<br/>';
        }
        Error err = new Error();
        err.Success = saveResult.isSuccess();
        if(saveResult.isSuccess())
            err.ErrorMessage = new ApexPages.Message(ApexPages.Severity.Info ,strSuccessMessage);
        Else
            err.ErrorMessage = new ApexPages.Message(ApexPages.Severity.Error ,strErrorMessage);
        apexPages.addMessage(err.ErrorMessage);
        return err;
    }
    
    /* Returns: Error */
    /* Parameters: String */
    /* This method create object of Error class depending on the parameters passed to it and
       returns the same.*/
    public static Error DebugLog(String strMsg)
    {
        Error err = new Error();
        err.Success = true;
                    
        err.ErrorMessage = new ApexPages.Message(ApexPages.Severity.Info ,strMsg);
        apexPages.addMessage(err.ErrorMessage);
        
        return err;
    }
    
    /* Returns: Error */
    /* Parameters: Boolean, Exception */
    /* This method create object of Error class depending on the parameters passed to it and
       returns the same.*/
    public static Error LogException(Exception ex)
    {
        Error err = new Error();
        err.Success = false;
                    
        err.ErrorMessage = new ApexPages.Message(ApexPages.Severity.Error , ex.getMessage());
        apexPages.addMessage(err.ErrorMessage);
        return err;
    }
    
    /* Returns: Error */
    /* Parameters: Boolean, String */
    /* This method create object of Error class depending on the parameters passed to it and
       returns the same.*/
    public static Error LogError(String strMsg)
    {
        Error err = new Error();
        err.Success = false;
        
        err.ErrorMessage = new ApexPages.Message(ApexPages.Severity.Error ,strMsg);
        apexPages.addMessage(err.ErrorMessage);
        
        return err;
    }
    
    /* Returns: Error */
    /* Parameters: Boolean, String */
    /* This method create object of Error class depending on the parameters passed to it and
     returns the same.*/
    public static Error LogSuccess(String strMsg)
    {
        Error err = new Error();
        err.Success = true;
        
        err.ErrorMessage = new ApexPages.Message(ApexPages.Severity.Info ,strMsg);
        
        apexPages.addMessage(err.ErrorMessage);
        return err;
    }
}