trigger SendSmsOnLeadCreation on Lead (before update) {
   
  /*Setty : SMS Magic uninstall 19/09/2012
   
    List<smsmagicvc1__smsMagic__c> smsObjects = new List<smsmagicvc1__smsMagic__c>();
    String meetingFixedTplText = null;
      smsmagicvc1__SMS_Template__c meetingFixedStpl = null; 
      String convertedTplText = null;
      smsmagicvc1__SMS_Template__c convertedStpl = null; 
      String meetingDoneTplText = null;
      smsmagicvc1__SMS_Template__c meetingDoneStpl = null;
      String tplText = null;
      smsmagicvc1__SMS_Template__c sTpl = null; 
      Id leadId = null;
      Map<Id, Id> leadOwnerId = new Map<Id, Id>();
      Map<Id, String> userName = new Map<Id, String>();
      
      for (Lead l : Trigger.new)
      {
          leadOwnerId.put(l.Id, l.OwnerId);
      }
       
      for(User u: [select Id, Name from User where Id IN :leadOwnerId.values()]){
          userName.put(u.Id, u.Name);
      }
     
    meetingFixedStpl =  [select smsmagicvc1__Text__c from smsmagicvc1__SMS_Template__c where smsmagicvc1__Name__c = 'Meeting Fixed SMS' and smsmagicvc1__ObjectName__c = 'Lead'];
    if(meetingFixedStpl.smsmagicvc1__Text__c!=null){
        meetingFixedTplText = meetingFixedStpl.smsmagicvc1__Text__c;
      }
      
      convertedStpl =  [select smsmagicvc1__Text__c from smsmagicvc1__SMS_Template__c where smsmagicvc1__Name__c = 'Converted SMS' and smsmagicvc1__ObjectName__c = 'Lead'];
    if(convertedStpl.smsmagicvc1__Text__c!=null){
        convertedTplText = convertedStpl.smsmagicvc1__Text__c;
      }
      
      meetingDoneStpl =  [select smsmagicvc1__Text__c from smsmagicvc1__SMS_Template__c where smsmagicvc1__Name__c = 'Meeting Done SMS' and smsmagicvc1__ObjectName__c = 'Lead'];
    if(meetingDoneStpl.smsmagicvc1__Text__c!=null){
        meetingDoneTplText = meetingDoneStpl.smsmagicvc1__Text__c;
      }
        
        
      for(Lead l : Trigger.new){
        if(Trigger.isBefore && Trigger.isUpdate){
          
        
          Lead beforeUpdateLead = Trigger.oldMap.get(l.Id);
        //  if(beforeUpdateLead.Status!= 'Meeting Fixed' && l.Status=='Meeting Fixed'){
          if( l.Appointment_Time__c!=null && beforeUpdateLead.Appointment_Time__c!= l.Appointment_Time__c){
            try{
                      smsmagicvc1.TemplateEngine TEngine = new smsmagicvc1.TemplateEngine(meetingFixedTplText);
                      l.Lead_Owner_Name__c = userName.get(leadOwnerId.get(l.Id));
                      l.Appointment_SMS__c = l.Appointment_Time__c.format('EEE, d MMM h:mm aaa');
                      TEngine.getFieldMap(l);
                      //Comented due to error : need to uncomment : Aditi
             //         meetingFixedTplText = TEngine.getReplacedTextForObject(l, 0);
                  }
                  catch(QueryException e){
                      system.debug(e.getMessage());
                  }
                  smsmagicvc1__smsMagic__c smsObj = new smsmagicvc1__smsMagic__c();
                  if(l.MobilePhone!=null && meetingFixedTplText!=null){
                    smsObj.smsmagicvc1__PhoneNumber__c = l.MobilePhone;
                    smsObj.smsmagicvc1__SMSText__c = meetingFixedTplText;
                    smsObj.smsmagicvc1__senderId__c = 'Ffreedom';
                    smsObj.smsmagicvc1__Name__c = l.Name;
                    smsObj.smsmagicvc1__Lead__c = l.Id;
                     //Added by Aditi for Platform User related changes
                    //Date : 29/08/12
                    if(l.Platform_User_Lead__c != null)
                    {
                    	smsObj.Platform_User_Lead__c = l.Platform_User_Lead__c;
                    }
                    smsObjects.add(smsObj);
                  }    
          } 
          else if(beforeUpdateLead.Status!= 'Meeting Done' && l.Status=='Meeting Done'){
            try{
                      smsmagicvc1.TemplateEngine TEngine = new smsmagicvc1.TemplateEngine(meetingDoneTplText);
                      TEngine.getFieldMap(l);
                      //Comented due to error : need to uncomment : Aditi
                      //meetingDoneTplText = TEngine.getReplacedTextForObject(l, 0);
                  }
                  catch(QueryException e){
                      system.debug(e.getMessage());
                  }
                  smsmagicvc1__smsMagic__c smsObj = new smsmagicvc1__smsMagic__c();
                  if(l.MobilePhone!=null && meetingDoneTplText!=null){
                    smsObj.smsmagicvc1__PhoneNumber__c = l.MobilePhone;
                    smsObj.smsmagicvc1__SMSText__c = meetingDoneTplText;
                    smsObj.smsmagicvc1__senderId__c = 'Ffreedom';
                    smsObj.smsmagicvc1__Name__c = l.Name;
                    smsObj.smsmagicvc1__Lead__c = l.Id;
                     //Added by Aditi for Platform User related changes
                    //Date : 29/08/12
                    if(l.Platform_User_Lead__c != null)
                    {
                    	smsObj.Platform_User_Lead__c = l.Platform_User_Lead__c;
                    }
                    smsObjects.add(smsObj);
                  }
                  
          }
          else if(beforeUpdateLead.Status!= 'Converted' && l.Status=='Converted'){
            try{
                      smsmagicvc1.TemplateEngine TEngine = new smsmagicvc1.TemplateEngine(convertedTplText);
                      TEngine.getFieldMap(l);
                      //Comented due to error : need to uncomment : Aditi
                    //  convertedTplText = TEngine.getReplacedTextForObject(l, 0);
                  }
                  catch(QueryException e){
                      system.debug(e.getMessage());
                  }
                  smsmagicvc1__smsMagic__c smsObj = new smsmagicvc1__smsMagic__c();
                  if(l.MobilePhone!=null && convertedTplText!=null){
                    smsObj.smsmagicvc1__PhoneNumber__c = l.MobilePhone;
                    smsObj.smsmagicvc1__SMSText__c = convertedTplText;
                    smsObj.smsmagicvc1__senderId__c = 'Ffreedom';
                    smsObj.smsmagicvc1__Name__c = l.Name;
                    smsObj.smsmagicvc1__Lead__c = l.Id;
                     //Added by Aditi for Platform User related changes
                    //Date : 29/08/12
                    if(l.Platform_User_Lead__c != null)
                    {
                    	smsObj.Platform_User_Lead__c = l.Platform_User_Lead__c;
                    }
                    smsObjects.add(smsObj);
                  }
                  
          }
        }
        
    End:Setty */    
        
      //////////////////////////////////////////////////////////////////////////////
        /*else if(Trigger.isAfter && Trigger.isInsert){
                
                if(l.LeadSource=='Lead Engines'){
                    sTpl =  [select smsmagicvc1__Text__c from smsmagicvc1__SMS_Template__c where smsmagicvc1__Name__c = 'New Lead SMS' and smsmagicvc1__ObjectName__c = 'Lead'];
                    if(sTpl.smsmagicvc1__Text__c!=null){
                    tplText = sTpl.smsmagicvc1__Text__c;
                    } 
                    
                    try{
                        smsmagicvc1.TemplateEngine TEngine = new smsmagicvc1.TemplateEngine(tplText);
                        TEngine.getFieldMap(l);
                        tplText = TEngine.getReplacedTextForObject(l, 0);
                    }
                    catch(QueryException e){
                        system.debug(e.getMessage());
                    }
                    if(l.MobilePhone!=null){
                      smsmagicvc1__smsMagic__c smsObj = new smsmagicvc1__smsMagic__c();
                      smsObj.smsmagicvc1__PhoneNumber__c = l.MobilePhone;
                      smsObj.smsmagicvc1__SMSText__c = tplText;
                      smsObj.smsmagicvc1__senderId__c = 'Ffreedom';
                      smsObj.smsmagicvc1__Name__c = l.Name;
                      smsObj.smsmagicvc1__Lead__c = l.Id;
                      smsObjects.add(smsObj);   
                    }
                }
        }*/
        
  /*Setty : SMS Magic uninstall 19/09/2012      
      }
  insert smsObjects;
  
 End:Setty */ 
 
// /*Setty:NewCode
 	List<smagicbasic__smsMagic__c> smsObjects = new List<smagicbasic__smsMagic__c>();
    String meetingFixedTplText = null;
      smagicbasic__SMS_Template__c meetingFixedStpl = null; 
      String convertedTplText = null;
      smagicbasic__SMS_Template__c convertedStpl = null; 
      String meetingDoneTplText = null;
      smagicbasic__SMS_Template__c meetingDoneStpl = null;
      String tplText = null;
      smagicbasic__SMS_Template__c sTpl = null; 
      Id leadId = null;
      Map<Id, Id> leadOwnerId = new Map<Id, Id>();
      Map<Id, String> userName = new Map<Id, String>();
      
      for (Lead l : Trigger.new)
      {
          leadOwnerId.put(l.Id, l.OwnerId);
      }
       
      for(User u: [select Id, Name from User where Id IN :leadOwnerId.values()]){
          userName.put(u.Id, u.Name);
      }
     
    meetingFixedStpl =  [select smagicbasic__Text__c from smagicbasic__SMS_Template__c where smagicbasic__Name__c = 'Meeting Fixed SMS' and smagicbasic__ObjectName__c = 'Lead'];
    if(meetingFixedStpl.smagicbasic__Text__c!=null){
        meetingFixedTplText = meetingFixedStpl.smagicbasic__Text__c;
      }
      
      convertedStpl =  [select smagicbasic__Text__c from smagicbasic__SMS_Template__c where smagicbasic__Name__c = 'Converted SMS' and smagicbasic__ObjectName__c = 'Lead'];
    if(convertedStpl.smagicbasic__Text__c!=null){
        convertedTplText = convertedStpl.smagicbasic__Text__c;
      }
      
      meetingDoneStpl =  [select smagicbasic__Text__c from smagicbasic__SMS_Template__c where smagicbasic__Name__c = 'Meeting Done SMS' and smagicbasic__ObjectName__c = 'Lead'];
    if(meetingDoneStpl.smagicbasic__Text__c!=null){
        meetingDoneTplText = meetingDoneStpl.smagicbasic__Text__c;
      }
        
        
      for(Lead l : Trigger.new){
        if(Trigger.isBefore && Trigger.isUpdate){
          
        
          Lead beforeUpdateLead = Trigger.oldMap.get(l.Id);
          if( l.Appointment_Time__c!=null && beforeUpdateLead.Appointment_Time__c!= l.Appointment_Time__c){
            try{
                      smagicbasic.TemplateEngine TEngine = new smagicbasic.TemplateEngine(meetingFixedTplText);
                      l.Lead_Owner_Name__c = userName.get(leadOwnerId.get(l.Id));
                      l.Appointment_SMS__c = l.Appointment_Time__c.format('EEE, d MMM h:mm aaa');
                      TEngine.getFieldMap(l);
                      meetingFixedTplText = TEngine.getReplacedTextForObject(l, 0);
                  }
                  catch(QueryException e){
                      system.debug(e.getMessage());
                  }
                  smagicbasic__smsMagic__c smsObj = new smagicbasic__smsMagic__c();
                  if(l.MobilePhone!=null && meetingFixedTplText!=null){
                    smsObj.smagicbasic__PhoneNumber__c = l.MobilePhone;
                    smsObj.smagicbasic__SMSText__c = meetingFixedTplText;
                    smsObj.smagicbasic__senderId__c = 'Ffreedom';
                    smsObj.smagicbasic__Name__c = l.Name;
                    smsObj.smagicbasic__Lead__c = l.Id;
                    smsObjects.add(smsObj);
                  }    
          } 
          else if(beforeUpdateLead.Status!= 'Meeting Done' && l.Status=='Meeting Done'){
            try{
                      smagicbasic.TemplateEngine TEngine = new smagicbasic.TemplateEngine(meetingDoneTplText);
                      TEngine.getFieldMap(l);
                      meetingDoneTplText = TEngine.getReplacedTextForObject(l, 0);
                  }
                  catch(QueryException e){
                      system.debug(e.getMessage());
                  }
                  smagicbasic__smsMagic__c smsObj = new smagicbasic__smsMagic__c();
                  if(l.MobilePhone!=null && meetingDoneTplText!=null){
                    smsObj.smagicbasic__PhoneNumber__c = l.MobilePhone;
                    smsObj.smagicbasic__SMSText__c = meetingDoneTplText;
                    smsObj.smagicbasic__senderId__c = 'Ffreedom';
                    smsObj.smagicbasic__Name__c = l.Name;
                    smsObj.smagicbasic__Lead__c = l.Id;
                    smsObjects.add(smsObj);
                  }
                  
          }
          else if(beforeUpdateLead.Status!= 'Converted' && l.Status=='Converted'){
            try{
                      smagicbasic.TemplateEngine TEngine = new smagicbasic.TemplateEngine(convertedTplText);
                      TEngine.getFieldMap(l);
                      convertedTplText = TEngine.getReplacedTextForObject(l, 0);
                  }
                  catch(QueryException e){
                      system.debug(e.getMessage());
                  }
                  smagicbasic__smsMagic__c smsObj = new smagicbasic__smsMagic__c();
                  if(l.MobilePhone!=null && convertedTplText!=null){
                    smsObj.smagicbasic__PhoneNumber__c = l.MobilePhone;
                    smsObj.smagicbasic__SMSText__c = convertedTplText;
                    smsObj.smagicbasic__senderId__c = 'Ffreedom';
                    smsObj.smagicbasic__Name__c = l.Name;
                    smsObj.smagicbasic__Lead__c = l.Id;
                    smsObjects.add(smsObj);
                  }
                  
          }
        }
     
      }
  insert smsObjects;
// */
}