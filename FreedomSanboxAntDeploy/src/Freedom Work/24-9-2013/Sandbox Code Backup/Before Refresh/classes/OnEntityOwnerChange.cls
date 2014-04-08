/*
    Created By : Niket Chandane
    Created At : 24 June 2011
    Summary    : This Class is used for the "UpdateEntityOwner" trigger.
    Issue      : F0062 (Enhancement).
*/
public without sharing class OnEntityOwnerChange 
{
        
     public void UpdateEntityOwner(Map<Id,Account> mapUpdatedEntity)  
     {
         if(mapUpdatedEntity!= null && mapUpdatedEntity.size() >0)
        {
             List<Account> lstAccountToUpdate = New List<Account>();
            /** Eternus Solutions       **/
            /** Author  : Manasi Ranade **/
            /** Issue Id: F0061         **/
            /** Date    : 29/06/2011    **/
            /** Purpose : "UpdateEntityOwner" trigger was throwing an exception while changing owner of an Inactive entity.
                           So added condition 'Entity_Status__c = Active'in where clause while selecting an entity
            /****************************************************/ 
            /*
                    Author : Trupti
                    Date :11/17/2011
                    Purpose :Change owner of all entity there is no entity status field in child entity
                    Issue : FS0288 
            */
           
           List<Account> lstAccount = [Select a.OwnerId,a.Parent_Entity__c From Account a where a.Parent_Entity__c In : mapUpdatedEntity.keySet()];
           System.debug('lstAccount ====================>'+lstAccount);
                                            
            if(lstAccount != null && lstAccount.size() > 0)
            {
                for(Account ObjAccount : lstAccount)
                {
                    if(mapUpdatedEntity.ContainsKey(ObjAccount.Parent_Entity__c))
                    {
                        ObjAccount.OwnerId = mapUpdatedEntity.get(ObjAccount.Parent_Entity__c).OwnerId;
                        lstAccountToUpdate.add(ObjAccount);
                    }
                 }
                if(lstAccountToUpdate != null && lstAccountToUpdate.size() > 0 )
                {
                    database.update(lstAccountToUpdate);
                }
            }
        }
    }
    /*********************************************UpdateEntityOwner Ends*************************************/
    
   /*****Code for Change Of Owner Before Update Trigger **********
    
    public void ChangeOfOwner(Map<Id,Account> NewMapEntity,MAp<Id,Account> mapOldEntities)
    {
    	 System_Admin__c objSystemAdmin = System_Admin__c.getInstance('System Administrator');
    	 List<Account> lstNewAccount = trigger.new;
    	 if(objSystemAdmin!= null && objSystemAdmin.System_Administrator_Id__c != null)
         {
         	for(Account objAccNew : lstNewAccount)
		    {
		     	Account objAccOld = mapOldEntities.get(objAccNew.Id);
		        if(objAccNew.OwnerId != objAccOld.OwnerId)
				{
                	if(Userinfo.getProfileId() != objSystemAdmin.System_Administrator_Id__c)
                	{
                		objAccNew.addError(Label.ErrorMsgForEntityOwnerChange);
                	}
		         }
		 	}
	     }
    }*/
    /*
		Author : Mahesh Hirugade
		Date :02 April 2012
		Purpose :	As requested by Haren access of changing entity owner are gine to Sunitha V
					Commented above code
		Case No : 00001574
    */
    public void ChangeOfOwner(Map<Id,Account> NewMapEntity,MAp<Id,Account> mapOldEntities)
    {
    	 System_Admin__c objSystemAdmin = System_Admin__c.getInstance('System Administrator');
    	 Compliance_Profile__c objComplainceProfile = Compliance_Profile__c.getInstance('Profile Id');
    	 
    	 //Sunitha_User_Id__c objSunithaUserId = Sunitha_User_Id__c.getInstance('Sunitha');
    	 List<Account> lstNewAccount = trigger.new;
    	 if(objSystemAdmin!= null && objSystemAdmin.System_Administrator_Id__c != null)
         {
         	for(Account objAccNew : lstNewAccount)
		    {
		     	Account objAccOld = mapOldEntities.get(objAccNew.Id);
		        if(objAccNew.OwnerId != objAccOld.OwnerId)
				{
                	if(Userinfo.getProfileId() != objSystemAdmin.System_Administrator_Id__c && Userinfo.getProfileId().substring(0, 15) != objComplainceProfile.Compliance_Profile_Id__c)// && Userinfo.getUserId() != objSunithaUserId.UserId__c)
                	{
                		objAccNew.addError(Label.ErrorMsgForEntityOwnerChange);
                	}
		        }
		 	}
	     }
    }
    
    /* Aditi - Updation of Entity owner of family memeber on insertion for Business partner only */
    /* Aditi Updated on : 12/6/13- Updation of Entity owner of family memeber on insertion for all types of Partners */
    public void updateOwnerofFamilyMember(List<Account> lstNewAccount)
    {
    	
    	Map<Id,Account> mapIdtoAccount = new Map<Id,Account>(); 
    	Map<Id,User> mapIdToUser = new Map<Id,User>(); 
    	Id familyRecId = RecTypes__c.getInstance('AccountFamily').Record_Type_Value__c;
    	List<Account> lstFamilyMemberUpdate = new List<Account>();
    	
    	mapIdToAccount = new Map<Id,Account>([Select Id, Name,Related_To__c,Channel_Manager__c, OwnerId, owner.name from Account where RecordType.Name = 'Client']);
		mapIdToUser = new Map<Id,User>([select Id,Name,ContactId , ManagerId, Email from User where isActive = true]);
    	
    	for(Account objAcc : lstNewAccount)
    	{
    		system.debug('*****objAcc********'+objAcc);
    		if(objAcc.RecordTypeId == familyRecId)
    		{
	    		if(objAcc.Parent_Entity__c != null)
	    		{
	    			if(mapIdToAccount.containsKey(objAcc.Parent_Entity__c))
	    			{
	    				Account parentAcc = mapIdToAccount.get(objAcc.Parent_Entity__c);
	    				//if(parentAcc.Related_To__c == 'Business Partner')
	    				//{
	    					if(mapIdToUser.containsKey(parentAcc.OwnerId))
	    					{
	    						objAcc.OwnerId = parentAcc.OwnerId;
	    						system.debug('--------objAcc------'+objAcc);
	    					}
	    				//}
	    			}
	    		}
    		}
    	}
    }
}