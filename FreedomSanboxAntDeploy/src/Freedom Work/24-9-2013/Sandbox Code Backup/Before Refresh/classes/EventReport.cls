public with sharing class EventReport
{
	transient List<Event> lstEvent;
    List<User> lstUsers{set;get;}
    public User loggedInUser{set;get;} 
    public Event objEvent{set;get;}
    public Map<String, List<Event>> mapOfEventOwner;
    public transient List<EventInformation> lsrMasterEventInfo{get;set;}
    //Added on : 11/6/13 : Aditi Satpute
    public List<ViewAllInformation> lstViewAllInformation{get;set;}
    public Boolean isViewAll {get;set;}
    
    public String nameofUser{set;get;}
    public Date startDate{set;get;}
    public Date endDate{set;get;}
    public boolean isDisplay{get;set;}
    private Set<Id> userIdSet {get;set;}
    
    
    public EventReport()
    {
	    objEvent = new  Event();
	    userIdSet = new Set<Id>();
       	//Added on : 11/6/13 : Aditi Satpute - Change in display format for View All button
	    isDisplay = false;
	    isViewAll = false;
	    
	    objEvent.StartDateTime =System.today();
	    objEvent.EndDateTime =System.today();
	    startDate  = objEvent.StartDateTime.date();
	    endDate = objEvent.EndDateTime.date().addDays(1);
	    lsrMasterEventInfo = new List<EventInformation>();
	    getLoggedInUser();
    }
  
   public User getLoggedInUser()
   {
	   this.loggedInUser = [select Id, Name, isActive, UserRoleId,ProfileId, UserRole.Name, Workstations__c from User where Id = :Userinfo.getUserId()];
	   Profile objProfile = [select Id,Name from Profile where Id =: this.loggedInUser.ProfileId];
	   system.debug('***loggedInUser****'+loggedInUser);
	   system.debug('***objProfile****'+objProfile);
	   if(objProfile.Name.equalsIgnoreCase('System Administrator'))
	   		isDisplay = true;
	   if(loggedInUser.UserRole.Name.equalsIgnoreCase(Label.Management_Role))	
        	isDisplay = true;
	   return this.loggedInUser;
   }
   
  public List<User> getUserList()
  {
      List<ID> lstofIds = new List<ID>();
      lstUsers = new List<User>();
      if(loggedInUser != null)
      {
	      List<ID> lstDetailIds = new List<ID>(); 
	      
	      List<User_Role_Name__c> lstMasterRole = new  List<User_Role_Name__c>();
	      List<Detail_Role__c> lstDetailRoles = new List<Detail_Role__c> ();
	      lstMasterRole = [Select Name, Id From User_Role_Name__c where Name =: loggedInUser.UserRole.Name];
	      
	      system.debug('********lstMasterRole'+loggedInUser.UserRole.Name);
	      
	      if(lstMasterRole.size() > 0)
	      {
	        for(User_Role_Name__c masterRole:lstMasterRole)
	        {
	          lstDetailIds.add(masterRole.Id);
	        }
	      }         
	      if(lstDetailIds.size() > 0)
	      {
	        lstDetailRoles =[Select Name, Master_Role__r.Name, Master_Role__c, Id, ID__c From Detail_Role__c where Master_Role__c IN:lstDetailIds];
	         system.debug('********lstDetailRoles'+lstDetailRoles);	
	      }
	      if(lstDetailRoles.size() >0)
	      {
	        for(Detail_Role__c objDetail : lstDetailRoles)
	        {
	          lstofIds.add(objDetail.ID__c);
	        }
	      }         
	      if(lstofIds.size() <= 0)
	      {
	        lstUsers.add(loggedInUser);
	      }
	      else
	      {
	        lstUsers = [select Id, Name, isActive, UserRoleId, Workstations__c from User where UserRoleId IN :lstofIds order by Name asc];
	        lstUsers.add(loggedInUser);  
	      }
      }
      system.debug('*******lstUsers'+lstUsers);
      return lstUsers;
  }
    
  public List<SelectOption> getAllUsers()
  {
     List<SelectOption> options = new List<SelectOption>();
     List<User> user = getUserList();
     //options.add(new SelectOption('','None'));
     if(user != null && user.size()>0)
     { 
        for(User objUser : user)
        {
      	   if(objUser.IsActive)
      	   {
           		options.add(new SelectOption(objUser.Id,objUser.Name));
      	   		userIdSet.add(objUser.Id);
      	   }
        }
     }
     return options;
  } 
    
  public void AssignManager()
  {
      System.debug('name of User:==='+nameofUser);
  } 
   
  public void Init()
  {
  	isViewAll = false;
  	System.debug('hiiii');
    lsrMasterEventInfo = new List<EventInformation>();
    lstEvent = new List<Event>();
    System.debug('hiiii**********objEvent.StartDateTime*'+objEvent.StartDateTime);
    System.debug('hiiii**********objEvent.EndDateTime*'+objEvent.EndDateTime);
    System.debug('hiiii*********nameofUser*'+nameofUser);
    if(objEvent.StartDateTime!= NULL && objEvent.EndDateTime != NULL)
    {
      List<Event> lstEvent = [Select e.Id,
                     e.To_Time__c,
                     e.From_Time__c,
                     e.WhoId, 
                     e.WhatId,
                     e.Who.Type, 
                     e.StartDateTime,
                     e.OwnerId,  
                     e.Event_Status__c, 
                     e.Event_Place__c, 
                     e.EndDateTime, 
                     e.Description, 
                     e.CreatedDate, 
                     e.Completion_Date__c ,
                     e.Meeting__c, 
                     e.Event_Category__c  
                     From Event e  
                     where e.Completion_Date__c >= :objEvent.StartDateTime.date()
                     and e.Completion_Date__c <= :objEvent.EndDateTime.date() 
                     and e.Event_Status__c ='Complete' and Event_Category__c = 'Meeting' and OwnerId =:nameofUser];
      system.debug('********lstEvent****'+lstEvent);
    
      if(lstEvent != null && lstEvent.size()>0)
      {
      		System.debug('hiiii**********objEvent.EndDateTime*'+objEvent.EndDateTime);	
            mapOfEventOwner = new Map<String, List<Event>>();
            Set<String> LeadSet = new Set<String>();
            Set<String> EntitySet = new Set<String>();
            integer meetingNo = 0;
            for(Event tmpEvent:lstEvent)
            {  // meetingNo = tmpEvent.Meeting__c;
              if(tmpEvent.Event_Status__c != null && tmpEvent.Event_Status__c.equalsIgnoreCase('complete'))
              {
                if(tmpEvent.WhoId != null)
                  LeadSet.add(tmpEvent.WhoId);
                 
                if(tmpEvent.WhatId != null)
                  EntitySet.add(tmpEvent.WhatId);
                  
                if(mapOfEventOwner.containsKey(tmpEvent.OwnerId))
                {
                  List<Event> lstTempEvent = mapOfEventOwner.get(tmpEvent.OwnerId) ;
                  lstTempEvent.add(tmpEvent);
                }
                else
                {
                  List<Event> lstTempEvent = new List<Event>();
                  lstTempEvent.add(tmpEvent);
                  mapOfEventOwner.put(tmpEvent.OwnerId, lstTempEvent);
                }
              }
            }
            
            Map<Id,User> MapOfUser = GetUserMap(mapOfEventOwner);
            Map<Id,Lead> MapOfLead = GetLeadMap(LeadSet);
            Map<Id,Account> MapOfAccount = GetAccountMap(EntitySet);
            if(mapOfEventOwner != null && mapOfEventOwner.size() > 0)
            {
              for(String strOwnerId : mapOfEventOwner.keySet())
              {
                EventInformation objNewEventInfo = new EventInformation();
                if(MapOfUser.containsKey(strOwnerId))
                {
                  User objTempUser = MapOfUser.get(strOwnerId);
                  objNewEventInfo.StrOwnerName = MapOfUser.get(strOwnerId).FirstName+' '+ MapOfUser.get(strOwnerId).LastName;
                  objNewEventInfo.lstofEvent = mapOfEventOwner.get(strOwnerId);
                  List<EventChildInfo> lstEventChildInfo = new List<EventChildInfo>();
                  for(Event objEvent : objNewEventInfo.lstofEvent)
                  {
                    EventChildInfo objEventChildInfo = new EventChildInfo();
                    objEventChildInfo.ChildEvent = objEvent;
                    objEventChildInfo.intMeetingCount = Integer.valueOf(objEvent.Meeting__c);
                    Datetime dateTimetemp = objEvent.CreatedDate;
                	objEventChildInfo.dtCreatedDate = Date.newInstance(dateTimetemp.year(),dateTimetemp.month(),dateTimetemp.day());
                    
                    if(objEvent.WhoId != null)
                    {
                      if(MapOfLead != null && MapOfLead.containsKey(objEvent.WhoId))
                      {
                        if(MapOfLead.get(objEvent.WhoId).FirstName != null)
                          {
                          objEventChildInfo.StrName = MapOfLead.get(objEvent.WhoId).FirstName +' '+ MapOfLead.get(objEvent.WhoId).LastName;
                          system.debug('$$$$$$$$$$$'+ objEventChildInfo.StrName);
                          }
                        else  
                          objEventChildInfo.StrName = MapOfLead.get(objEvent.WhoId).LastName;
                          system.debug('{}}}}}}}}}}}}}}}}}}}}}}}}'+ objEventChildInfo.StrName);
                        
                        objEventChildInfo.strWhoType = 'Lead';
                      }
                      else
                      {
                        if(MapOfAccount != null && MapOfAccount.containsKey(objEvent.WhatId))
                        {
                          if(MapOfAccount.get(objEvent.WhatId).FirstName != null)
                            {
                            objEventChildInfo.StrName = MapOfAccount.get(objEvent.WhatId).FirstName +' '+ MapOfAccount.get(objEvent.WhatId).LastName;
                            system.debug('PPPPPPPPPPPPPPPPPPPPPPPPPPPPP'+ objEventChildInfo.StrName);
                            }
                          else
                            objEventChildInfo.StrName = MapOfAccount.get(objEvent.WhatId).LastName;
                            system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'+ objEventChildInfo.StrName);
                          objEventChildInfo.strWhoType = 'Entity';
                        }
                      }
                    }
                    lstEventChildInfo.add(objEventChildInfo);
                  }
                  objNewEventInfo.lstEventChildInfo = lstEventChildInfo; 
                  lsrMasterEventInfo.add(objNewEventInfo);
                }
              }
            }
          }
    }
  }
  

  
  /*
  	Added By : Aditi Satpute
  	Date : 07/06/13
  	Purpose : To View All meeting Reports - as per call with Sanat
  	Update on : 11/6/13 : Aditi Satpute - Change in display format for View All button
  */
  public void ViewAll()
  {
  	isViewAll = true;
    lsrMasterEventInfo = new List<EventInformation>();
    
    lstViewAllInformation = new List<ViewAllInformation>();
    
    lstEvent = new List<Event>();
    Set<String> LeadIdSet = new Set<String>();
    Set<String> AccountIdSet = new Set<String>();
    Set<String> ContactIdSet = new Set<String>();
    List<Lead> lstLead = [select Id from Lead where OwnerId IN: userIdSet];
    for(Lead objLead : lstLead)
    {
    	LeadIdSet.add(objLead.Id);
    }
    List<Account> lstAccount = [select Id from Account where OwnerId IN: userIdSet];
    for(Account objAcc : lstAccount)
    {
    	AccountIdSet.add(objAcc.Id);
    }
    
    if(objEvent.StartDateTime!= NULL && objEvent.EndDateTime != NULL)
    {
        mapOfEventOwner = new Map<String,List<Event>>();
        Set<String> LeadSet = new Set<String>();
        Set<String> EntitySet = new Set<String>();
        integer meetingNo = 0;
        List<Event> lstEvent = [Select e.Id,
                     e.To_Time__c,
                     e.From_Time__c,
                     e.WhoId, 
                     e.WhatId,
                     e.Who.Type, 
                     e.StartDateTime,
                     e.OwnerId,  
                     e.Event_Status__c, 
                     e.Event_Place__c, 
                     e.EndDateTime, 
                     e.Description, 
                     e.CreatedDate, 
                     e.Completion_Date__c ,
                     e.Meeting__c, 
                     e.Event_Category__c  
                     From Event e  
                     where e.Completion_Date__c >= :objEvent.StartDateTime.date()
                     and e.Completion_Date__c <= :objEvent.EndDateTime.date() 
                     and e.Event_Status__c ='Complete' and Event_Category__c = 'Meeting' and (WhoId In: LeadIdSet or WhatId IN:AccountIdSet)];
      system.debug('********lstEvent****'+lstEvent);
      system.debug('********userIdSet****'+userIdSet);
      if(lstEvent != null && lstEvent.size()>0)
      {
        	for(Event tmpEvent : lstEvent)
	        {  // meetingNo = tmpEvent.Meeting__c;
	          if(tmpEvent.Event_Status__c != null && tmpEvent.Event_Status__c.equalsIgnoreCase('complete'))
	          {
	           	/*if(tmpEvent.WhoId != null)
	              LeadSet.add(tmpEvent.WhoId);
	             
	            if(tmpEvent.WhatId != null)
	              EntitySet.add(tmpEvent.WhatId);
	            */
	            if(mapOfEventOwner.containsKey(tmpEvent.OwnerId))
	            {
	              List<Event> lstTempEvent = mapOfEventOwner.get(tmpEvent.OwnerId) ;
	              lstTempEvent.add(tmpEvent);
	            }
	            else
	            {
	              List<Event> lstTempEvent = new List<Event>();
	              lstTempEvent.add(tmpEvent);
	              mapOfEventOwner.put(tmpEvent.OwnerId, lstTempEvent);
	            }
	          }
   			}
            
		    Map<Id,User> MapOfUser = GetUserMap(mapOfEventOwner);
		    for(User objUser : MapOfUser.values())
		    {
		    	if(objUser.contactId != null)
		    	{
		    		ContactIdSet.add(objUser.contactId);
		    	}
		    }
		    Map<Id,Contact> MapIdToContact = new Map<Id,Contact>([select Id from Contact where Id IN: ContactIdSet]);
		    Map<Id,Lead> MapOfLead = GetLeadMap(LeadIdSet);
		    Map<Id,Account> MapOfAccount = GetAccountMap(AccountIdSet);
		    if(mapOfEventOwner != null && mapOfEventOwner.size() > 0)
		    {
		      for(String strOwnerId : mapOfEventOwner.keySet())
		      {
    		  	if(MapOfUser.containsKey(strOwnerId))
		        {
		          User objTempUser = MapOfUser.get(strOwnerId);
		          String StrOwnerName = MapOfUser.get(strOwnerId).FirstName+' '+ MapOfUser.get(strOwnerId).LastName;
		          List<Event> lstofEvent = mapOfEventOwner.get(strOwnerId);
		          for(Event objEvent : lstofEvent)
		          {
		          	 ViewAllInformation objViewAllInformation = new ViewAllInformation();
		          	 if(objTempUser.ContactId != null)
			         {
			          		if(MapIdToContact.containsKey(objTempUser.ContactId))
			          		{
			          			Contact objBPCon = MapIdToContact.get(objTempUser.ContactId);
			          			Account objBPAcc = GetVirtualPartnerAccountMap(objBPCon.AccountId);
			          			objViewAllInformation.channelManager = objBPAcc.Channel_Manager__r.Name;
			          		}
			         }
		          	 objViewAllInformation.StrOwnerName = StrOwnerName;
		             objViewAllInformation.ChildEvent = objEvent;
		             objViewAllInformation.intMeetingCount = Integer.valueOf(objEvent.Meeting__c);
		             Datetime dateTimetemp = objEvent.CreatedDate;
		             objViewAllInformation.dtCreatedDate = Date.newInstance(dateTimetemp.year(),dateTimetemp.month(),dateTimetemp.day());
		            
		             if(objEvent.WhoId != null)
		             {
		                 if(MapOfLead != null && MapOfLead.containsKey(objEvent.WhoId))
		                 {
		                     if(MapOfLead.get(objEvent.WhoId).FirstName != null)
		                     {
		                  	     objViewAllInformation.StrName = MapOfLead.get(objEvent.WhoId).FirstName +' '+ MapOfLead.get(objEvent.WhoId).LastName;
		                  	     system.debug('$$$$$$$$$$$'+ objViewAllInformation.StrName);
		                     }
		                  	 else  
		                      	 objViewAllInformation.StrName = MapOfLead.get(objEvent.WhoId).LastName;
	                	  	 objViewAllInformation.strWhoType = 'Lead';
			              	 if(MapOfLead.get(objEvent.WhoId).Virtual_Partner__c != null)
			              	 {				
			              	  	 Account objLeadVPAcc = GetVirtualPartnerAccountMap(MapOfLead.get(objEvent.WhoId).Virtual_Partner__c);
			                  	 objViewAllInformation.PFP_VirtualPartnerName = objLeadVPAcc.Name;
			                  	 objViewAllInformation.channelManager = objLeadVPAcc.Channel_Manager__r.Name;
			              	 }
		              	 }	
		              	 else
		              	 {
		                  	 if(MapOfAccount != null && MapOfAccount.containsKey(objEvent.WhatId))
		                  	 {
		                     	 if(MapOfAccount.get(objEvent.WhatId).FirstName != null)
		                     	 {
		                    		 objViewAllInformation.StrName = MapOfAccount.get(objEvent.WhatId).FirstName +' '+ MapOfAccount.get(objEvent.WhatId).LastName;
		                    		 system.debug('PPPPPPPPPPPPPPPPPPPPPPPPPPPPP'+ objViewAllInformation.StrName);
		                     	 }
		                  	 	 else
		                    		 objViewAllInformation.StrName = MapOfAccount.get(objEvent.WhatId).LastName;
		                    	
		                  		 objViewAllInformation.strWhoType = 'Entity';
		                  		 if(MapOfAccount.get(objEvent.WhatId).Virtual_Partner__c != null)
			                	 {				
			                		 Account objEntityVPAcc = GetVirtualPartnerAccountMap(MapOfAccount.get(objEvent.WhatId).Virtual_Partner__c);
			                		 objViewAllInformation.PFP_VirtualPartnerName = objEntityVPAcc.Name;
			                		 objViewAllInformation.channelManager = objEntityVPAcc.Channel_Manager__r.Name;
			                	 }
		                	 }
		              	 }
		            }
		            lstViewAllInformation.add(objViewAllInformation);
		          }
		          //objNewEventInfo.lstEventChildInfo = lstEventChildInfo; 
		          //lsrMasterEventInfo.add(objNewEventInfo);
		        }
		      }
	    	}
        }
    }
  }
  
  
  public Map<Id,User> GetUserMap(Map<String, List<Event>> mapOfOwnerEventlist)
  {
    Map<Id,User> MapOfUser;
    if(mapOfOwnerEventlist != null && mapOfOwnerEventlist.size() > 0)
    {
      MapOfUser = new Map<Id,User>([select id, FirstName,ContactId, Lastname from User where id IN : mapOfOwnerEventlist.keySet()]);
    }
    return MapOfUser;
  }
  
  public Map<Id,Lead> GetLeadMap(Set<String> setWhoId)
  {
    Map<Id,Lead> MapOfLead;
    if(setWhoId != null && setWhoId.size() > 0)
    {
      MapOfLead = new Map<Id,Lead>([select id, FirstName, Lastname,Virtual_Partner__c from Lead where id IN : setWhoId]);
    }
    return MapOfLead;
  }
  
  public Map<Id,Account> GetAccountMap(Set<String> setWhatId)
  {
    Map<Id,Account> MapOfAccount;
    if(setWhatId != null && setWhatId.size() > 0)
    {
      MapOfAccount = new Map<Id,Account>([select id, FirstName, Lastname,Virtual_Partner__c from Account where id IN : setWhatId]);
    }
    return MapOfAccount;
  }
  
  public Account GetVirtualPartnerAccountMap(String PFP_id)
  {
    Account VPAccount = new Account();
    if(PFP_id != null)
    {
      VPAccount = [select id, FirstName, Lastname,Name,Virtual_Partner__c,Channel_Manager__c,Channel_Manager__r.Name from Account where id = : PFP_id];
    }
    return VPAccount;
  }
  
  //Inner class  
  public class EventInformation
  {
    public String StrOwnerName {get;set;}
    public List<Event> lstofEvent{get;set;}
    public List<EventChildInfo> lstEventChildInfo{get;set;}
    public EventInformation(){
      lstEventChildInfo = new List<EventChildInfo>();
    }
  }
  
  public class EventChildInfo
  {
    public Event ChildEvent {get;set;}
    public String strWhoType {get;set;}
    public String StrName{get;set;}
    public Integer intMeetingCount {get;set;}
    public Date dtCreatedDate {get;set;}
    
    public EventChildInfo()
    {
      
    }
  }
   //Added on : 11/6/13 : Aditi Satpute - Change in display format for View All button
  public class ViewAllInformation
  {
  	public String StrOwnerName {get;set;}
  	public Event ChildEvent {get;set;}
    public String strWhoType {get;set;}
    public String StrName {get;set;}
    public Integer intMeetingCount {get;set;}
    public Date dtCreatedDate {get;set;}
    public String PFP_VirtualPartnerName {get;set;}
    public String channelManager {get;set;}
  }	
  public pageReference ExportData()
  {
    pageReference pageRef = new pageReference('/apex/ExportEventReport');
    return pageRef ;
  }
    
  
}