/*
	
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         --           	   --	  		Initial Draft
    2.0			Manasi			   22/06/2011	Issue ID : F0060 :Added check for null condition before using entity id 
    											in constructor of NewAssetAllocationController class and in save methode
	
*/
public class NewAssetAllocationController 
{
    public AssetAllocationService service; 
    public AssetAllocationBean assetAllocationBean { get;set;}
    public String entityId {get;set;}
    //Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
	    
    public NewAssetAllocationController()
    {
    	//Code Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   		isDisplaySaveButton = true;
   		system.debug('***Limits.getQueries()***** '+Limits.getQueries());  
        entityId=Apexpages.currentPage().getParameters().get('entityId');
        service = new AssetAllocationService();
        try 
        {
        	/** Eternus Solutions       **/
			/** Author  : Manasi Ranade **/
			/** Issue Id: F0060      	**/
			/** Date    : 22/06/2011 	**/
			/** Purpose : Added check for null condition before using entity id
			/****************************************************/ 
        	if(entityId != null && entityId != '')
        	{
        		system.debug('***Limits.getQueries()***** 1'+Limits.getQueries());  
            	assetAllocationBean = service.fetchAssetAllocationRecords(entityId);
            	system.debug('***Limits.getQueries()***** 2'+Limits.getQueries());
            	//Added Code on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
			    User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
			    if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
			    {
			    	isDisplaySaveButton = false;
			    }	
        	}
        } 
        catch(Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
    }
    public PageReference save()
    {        
        //System.debug(assetAllocationBean);
        /** Eternus Solutions       **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: F0060      	**/
		/** Date    : 22/06/2011 	**/
		/** Purpose : Added check for null condition before using entity id
		/****************************************************/ 
        if(entityId != null)
        { 
	        try 
	        {
	            service.saveAllocation(assetAllocationBean,entityId);
	             assetAllocationBean = service.fetchAssetAllocationRecords(entityId);
	        } 
	        catch(Exception ex) 
	        {
	            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
	        }  
	        system.debug('***Limits.getQueries()**in save***'+Limits.getQueries());                     
	        pageReference pageRef = new pageReference('/apex/NewAssetAllocationPage?entityId='+entityId+'&tabname=Financial Planning');
	        pageRef.setRedirect(true);  
	        return pageRef;
	        //ApexPages.currentPage().setRedirect(true);                      
	        //return ApexPages.currentPage();
        }
        else
        	return null;
    }        
}