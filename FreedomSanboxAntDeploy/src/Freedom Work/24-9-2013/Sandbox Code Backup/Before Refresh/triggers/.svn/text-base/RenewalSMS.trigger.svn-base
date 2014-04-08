trigger RenewalSMS on Renewal__c (before update) {

	/*Setty : SMS Magic uninstall 19/09/2012
	
		List<smsmagicvc1__smsMagic__c> smsObjects = new List<smsmagicvc1__smsMagic__c>();
		String renewalTplText=null;
		String discontinueTplText=null;
		
		
		smsmagicvc1__SMS_Template__c template =  [select smsmagicvc1__Text__c from smsmagicvc1__SMS_Template__c where smsmagicvc1__Name__c = 'Renewal Discontinuation Template' and smsmagicvc1__ObjectName__c = 'Renewal__c'];
		smsmagicvc1__SMS_Template__c renewaltpl =  [select smsmagicvc1__Text__c from smsmagicvc1__SMS_Template__c where smsmagicvc1__Name__c = 'Renewal Template Renewal' and smsmagicvc1__ObjectName__c = 'Renewal__c'];
		
		 system.debug('template '+template);
		 system.debug('renewaltpl '+renewaltpl);
		if(Renewaltpl.smsmagicvc1__Text__c!=null){
	        renewalTplText = Renewaltpl.smsmagicvc1__Text__c;
	    }
	     
	    if(template.smsmagicvc1__Text__c!=null){
	        discontinueTplText = template.smsmagicvc1__Text__c;
	    }
	    
		for(Renewal__c ren:Trigger.new){
			smsmagicvc1__smsMagic__c smsObj = new smsmagicvc1__smsMagic__c();
			Renewal__c beforeUpdatedRenewal = Trigger.oldMap.get(ren.Id);
			//System.debug('beforeUpdatedRenewal'+beforeUpdatedRenewal.Renewal_SMS_Sent__c);
			//System.debug('ren.Renewal_SMS_Sent__c'+ren.Renewal_SMS_Sent__c);
			if(beforeUpdatedRenewal.Renewal_SMS_Sent__c==false && ren.Renewal_SMS_Sent__c==true){
				try{
					smsmagicvc1.TemplateEngine TEngine = new smsmagicvc1.TemplateEngine(renewalTplText);
			        TEngine.getFieldMap(ren);
			        renewalTplText = TEngine.getReplacedTextForObject(ren, 0);
				}
				catch(QueryException e){
	                system.debug(e.getMessage());
	            }
	
	End:Setty */
	
				/*  Author : 
				*   Modified by :Dipak Nikam
				*	Date : 18/01/2012
				*   Reason : Wrong Assignment Phone number to Email Address in Code.
				*			Changed the field Assignment.
				*      smsObj.smsmagicvc1__PhoneNumber__c = ren.Email__c;  
				*/    
				
	/*Setty : SMS Magic uninstall 19/09/2012
				      
				smsObj.smsmagicvc1__PhoneNumber__c = ren.Mobile__c;
				//system.debug('phone: '+smsObj.smsmagicvc1__PhoneNumber__c);
				
	            smsObj.smsmagicvc1__SMSText__c = renewalTplText;
	           // system.debug('renewal text: '+smsObj.smsmagicvc1__SMSText__c);
	            
	            smsObj.smsmagicvc1__senderId__c = 'Ffreedom';
	            
	            smsObj.smsmagicvc1__Name__c = ren.Name;
	          //  system.debug('Name: '+smsObj.smsmagicvc1__Name__c);
	            
	            smsObj.Renewal__c = ren.Id;
	           
	            smsObjects.add(smsObj);
			}
			
			else if(beforeUpdatedRenewal.Discontinuation_SMS_Sent__c ==false && ren.Discontinuation_SMS_Sent__c ==true){
				try{
					smsmagicvc1.TemplateEngine TEngine = new smsmagicvc1.TemplateEngine(discontinueTplText);
				    TEngine.getFieldMap(ren);
				    discontinueTplText = TEngine.getReplacedTextForObject(ren, 0);
				}
				catch(QueryException e){
	                system.debug(e.getMessage());
	            }
	   
	End:Setty */
	           
	            /*  Author : 
				*   Modified by :Dipak Nikam
				*	Date : 18/01/2012
				*   Reason : Wrong Assignment Phone number to Email Address in Code.
				*			Changed the field Assignment.
				*         smsObj.smsmagicvc1__PhoneNumber__c = ren.Email__c;  
				*/    
	
	/*Setty : SMS Magic uninstall 19/09/2012
				
	            smsObj.smsmagicvc1__PhoneNumber__c = ren.Mobile__c;
				//system.debug('phone: '+smsObj.smsmagicvc1__PhoneNumber__c);
				
	            smsObj.smsmagicvc1__SMSText__c = discontinueTplText;
	           // system.debug('renewal text: '+smsObj.smsmagicvc1__SMSText__c);
	            
	            smsObj.smsmagicvc1__senderId__c = 'Ffreedom';
	            
	            smsObj.smsmagicvc1__Name__c = ren.Name;
	          //  system.debug('Name: '+smsObj.smsmagicvc1__Name__c);
	            
	            smsObj.Renewal__c = ren.Id;
	           
	            smsObjects.add(smsObj);
			}
		}
		
		insert smsObjects;
		
		End:Setty */
		
///*Setty:NewCod
		List<smagicbasic__smsMagic__c> smsObjects = new List<smagicbasic__smsMagic__c>();
		String renewalTplText=null;
		String discontinueTplText=null;
		smagicbasic__SMS_Template__c template =  [select smagicbasic__Text__c from smagicbasic__SMS_Template__c where smagicbasic__Name__c = 'Renewal Discontinuation Template' and smagicbasic__ObjectName__c = 'Renewal__c'];
		smagicbasic__SMS_Template__c renewaltpl =  [select smagicbasic__Text__c from smagicbasic__SMS_Template__c where smagicbasic__Name__c = 'Renewal Template Renewal' and smagicbasic__ObjectName__c = 'Renewal__c'];
		if(Renewaltpl.smagicbasic__Text__c!=null){
	        renewalTplText = Renewaltpl.smagicbasic__Text__c;
	    }
	     
	    if(template.smagicbasic__Text__c!=null){
	        discontinueTplText = template.smagicbasic__Text__c;
	    }
	    
		for(Renewal__c ren:Trigger.new){
			smagicbasic__smsMagic__c smsObj = new smagicbasic__smsMagic__c();
			Renewal__c beforeUpdatedRenewal = Trigger.oldMap.get(ren.Id);
			if(beforeUpdatedRenewal.Renewal_SMS_Sent__c==false && ren.Renewal_SMS_Sent__c==true){
				try{
					smagicbasic.TemplateEngine TEngine = new smagicbasic.TemplateEngine(renewalTplText);
			        TEngine.getFieldMap(ren);
			        renewalTplText = TEngine.getReplacedTextForObject(ren, 0);
				}
				catch(QueryException e){
	                system.debug(e.getMessage());
	            }

				smsObj.smagicbasic__PhoneNumber__c = ren.Mobile__c;
				
	            smsObj.smagicbasic__SMSText__c = renewalTplText;
	           
	            smsObj.smagicbasic__senderId__c = 'Ffreedom';
	            
	            smsObj.smagicbasic__Name__c = ren.Name;
	            
	            smsObj.Renewal__c = ren.Id;
	           
	            smsObjects.add(smsObj);
			}
			
			else if(beforeUpdatedRenewal.Discontinuation_SMS_Sent__c ==false && ren.Discontinuation_SMS_Sent__c ==true){
				try{
					smagicbasic.TemplateEngine TEngine = new smagicbasic.TemplateEngine(discontinueTplText);
				    TEngine.getFieldMap(ren);
				    discontinueTplText = TEngine.getReplacedTextForObject(ren, 0);
				}
				catch(QueryException e){
	                system.debug(e.getMessage());
	            }
	   
	            smsObj.smagicbasic__PhoneNumber__c = ren.Mobile__c;
			
	            smsObj.smagicbasic__SMSText__c = discontinueTplText;
	            
	            smsObj.smagicbasic__senderId__c = 'Ffreedom';
	            
	            smsObj.smagicbasic__Name__c = ren.Name;
	            
	            smsObj.Renewal__c = ren.Id;
	           
	            smsObjects.add(smsObj);
			}
		}
		if(!Test.isRunningTest())
			insert smsObjects;

//*/	
}