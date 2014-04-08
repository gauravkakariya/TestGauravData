public with sharing class ConveyanceController 
{
	//public Conveyance_Manager__c objConveyanceManager;
	public Conveyance_Manager__c objConveyanceManager{get;set;}
	public Conveyance_Manager__c tmpConveyanceManager{get;set;}
	//public Conveyance_Detail__c objConveyanceDetail{set; get;}
	public Integer icount{set; get;}
	//Database.Saveresult saveResult = null;
	public List<ConveyanceDetails> lstConveyanceInfo {get;set;}
	public String BillingDescription{set; get;}
	public Boolean flag{set; get;}
	public Boolean ipflagShow{set; get;}
	public String strConManId {get;set;}
	public String eventId {get;set;}
	
	//Existing List of "Conveyance_Detail__c"
	List<Conveyance_Detail__c> lstConDetail{get;set;}
	/* Need to remove some items*/
	List<Conveyance_Detail__c> lstConDetailDelete{get;set;}
	public	Event__c objEvent{set;get;}
	
	public ConveyanceController()
	{
		//get the event id
		eventId = ApexPages.currentPage().getParameters().get('eventId');
		
		if(eventId !=null && eventId != '')
		{
			objEvent = [Select e.OwnerId, e.Name, e.Id, e.Event_Status__c, e.Event_Place__c, e.Event_Category__c, e.End__c, e.Email__c, e.Duration__c, e.Description__c From Event__c e where e.Id =: eventId];
		}
		else
		{
			String StrtmpId = ApexPages.currentPage().getParameters().get('id');
			if(StrtmpId != null)
			{
				Conveyance_Manager__c objtmpConveyence = [Select 
															c.Remarks__c, 
															c.Name,c.Is_Submitted__c, 
															c.Id, 
															c.Event__c,
															c.Event__r.Name
														From Conveyance_Manager__c c 
														where c.Id =:StrtmpId];
	      		if(objtmpConveyence != null)
	      		{
	      			eventId = objtmpConveyence.Event__c;
	      			objEvent = [Select e.OwnerId, 
	      							   e.Name, 
	      							   e.Id, 
	      							   e.Event_Status__c, 
	      							   e.Event_Place__c, 
	      							   e.Event_Category__c, 
	      							   e.End__c,
	      							   e.Email__c, 
	      							   e.Duration__c,
	      							   e.Description__c 
	      							   From Event__c e 
	      							   where e.Id =: eventId];
	      		}
			}
		}
		
		// Need to inititalise the Removed Detail list
		lstConDetailDelete = new List<Conveyance_Detail__c>();
		if(ApexPages.currentPage().getParameters().get('id') != null && ApexPages.currentPage().getParameters().get('id') != '')
		{
			strConManId = ApexPages.currentPage().getParameters().get('id');
			objConveyanceManager = [Select c.Travel_Type__c, 
										   c.Remarks__c, 
										   c.Reimbursement_date__c, 
										   c.OwnerId, 
										   c.Name__c, 
										   c.Name,c.Is_Submitted__c, 
										   c.Mode_of_Travel__c, 
										   c.Id, 
										   c.Event__c,
										   c.Event__r.Name, 
										   c.Date_of_Travel__c, 
										   c.Claim_Date__c, 
										   c.Amount_Reimbursed__c, 
										   c.Amount_Claimed__c,
										   c.Event__r.Id
									From Conveyance_Manager__c c 
									where c.Id =: strConManId];
									
			lstConDetail = [Select c.Bill_Number__c,
								   c.Remarks__c, 
								   c.Name, 
								   c.Is_Bill_Available__c, 
								   c.Id, 
								   c.Conveyance_Manager__c, 
								   c.Bill_Details__c, 
								   c.Amount__c 
								   From Conveyance_Detail__c c 
								   where c.Conveyance_Manager__c =: strConManId ORDER By c.CreatedDate];
			
			// Auto populating List
			lstConveyanceInfo = autoPopulateDetails(lstConDetail);
			/*if(ApexPages.currentPage().getParameters().get('mode') != null && ApexPages.currentPage().getParameters().get('mode') == 'edit')*/
			if(objConveyanceManager.Is_Submitted__c)
			{		 		
				flag = false;
			}
			else
			{
				flag = true;
			}
		}
		else
			flag = true;
		
		if(objConveyanceManager == Null)
		{
			objConveyanceManager = new Conveyance_Manager__c();
			objConveyanceManager.Date_of_Travel__c = System.today();
			objConveyanceManager.Claim_Date__c =  System.today();
			objConveyanceManager.Travel_Type__c = 'Local';
			objConveyanceManager.Mode_of_Travel__c = 'Cab';
		}
		if(lstConveyanceInfo == null)
		{
			lstConveyanceInfo = new List<ConveyanceDetails>();
			lstConveyanceInfo.add(new ConveyanceDetails(new Conveyance_Detail__c(),1));
		}
	}
	
	
	private List<ConveyanceDetails> autoPopulateDetails(List<Conveyance_Detail__c> lstConveyanceDetail)
	{
		List<ConveyanceDetails> lstConveyanceDetailsInfo = new List<ConveyanceDetails>();
		if(lstConveyanceDetail != null && lstConveyanceDetail.size() > 0)
		{
			Integer iIndex = 0;
			for(Conveyance_Detail__c objConDetail :lstConveyanceDetail)
			{
				iIndex ++;
				lstConveyanceDetailsInfo.add(new ConveyanceDetails(objConDetail,iIndex));
			}
		}
		return lstConveyanceDetailsInfo;
	}
	
	//Save Fuctionality//
	public PageReference save()
	{
		Pagereference pgReference = null;
			
		
			if(lstConDetailDelete != null && lstConDetailDelete.size() > 0)
			{
				// need to delete Details who get removed from the UI.
				List<Database.DeleteResult> sp	=Database.delete(lstConDetailDelete);
			}
			System.debug('========= In save=====');
			
			//objConveyanceManager.Name = objConveyanceManager.Event__r.Id;
		try
		{
			objConveyanceManager.Event__c = eventId;
			System.debug('========= objConveyanceManager.Event__c====='+eventId);
			objConveyanceManager.Mode_of_Travel__c = objConveyanceManager.Mode_of_Travel__c;
			objConveyanceManager.Claim_Date__c = objConveyanceManager.Claim_Date__c;
			objConveyanceManager.Travel_Type__c = objConveyanceManager.Travel_Type__c;
			objConveyanceManager.Remarks__c = objConveyanceManager.Remarks__c;
			objConveyanceManager.Date_of_Travel__c = objConveyanceManager.Date_of_Travel__c;
		
			Database.Upsertresult saveResult = Database.Upsert(objConveyanceManager);
			if(saveResult.isSuccess())
			{
				List<Conveyance_Detail__c> lstRecordsToInsert = new List<Conveyance_Detail__c>();
				
				if(lstConveyanceInfo !=null && lstConveyanceInfo.size()>0)
				{
					Conveyance_Detail__c objConveyanceDetail;
					
					for(ConveyanceDetails tmpConveyanceDetails : lstConveyanceInfo)
					{
						if(String.valueOf(tmpConveyanceDetails.objConveyance_Details.Id) != Null)
							objConveyanceDetail = new Conveyance_Detail__c(Id = tmpConveyanceDetails.objConveyance_Details.Id);
						else
						{
							objConveyanceDetail = new Conveyance_Detail__c();
							objConveyanceDetail.Conveyance_Manager__c = saveResult.getId();
						}
					objConveyanceDetail.Amount__c = tmpConveyanceDetails.objConveyance_Details.Amount__c;
					objConveyanceDetail.Bill_Details__c = tmpConveyanceDetails.objConveyance_Details.Bill_Details__c;
					objConveyanceDetail.Is_Bill_Available__c = tmpConveyanceDetails.objConveyance_Details.Is_Bill_Available__c;
					objConveyanceDetail.Bill_Number__c = tmpConveyanceDetails.objConveyance_Details.Bill_Number__c;
					lstRecordsToInsert.add(objConveyanceDetail);	
				}		
				
				List <Database.Upsertresult> lstUpResult = Database.upsert(lstRecordsToInsert);
				
				// lstUpResult can be used when we need to check that record is
				// Upserted or not.
			}
				pgReference = new Pagereference('/apex/ConveyanceManager?id='+saveResult.getId()+'&eventId='+eventId);
			
				//If you want to redirect via server mode please use SetRedirect(True)
				pgReference.setRedirect(true);
		}
			return pgReference;
		}
		catch(Exception ex)
		{
			pgReference = new Pagereference('/apex/ConveyanceManager?eventId='+eventId);
			
		}
		return pgReference;
	}
	
	

	//Add More ConveyanceDetails
	public void AddMore()
	{
		System.debug('In Add more fuction');
		lstConveyanceInfo.add(new ConveyanceDetails(new Conveyance_Detail__c(Conveyance_Manager__c = objConveyanceManager.Id),lstConveyanceInfo.size()+1));//lstConveyanceInfo.size()+1
		//Error.DebugLog('In Add more fuction');
	}
    
	public PageReference Cancel()
	{
		PageReference pgReference = null;
		if(eventId !=null)
		{
			pgReference = new Pagereference('/'+eventId);
			return pgReference;
		}
		else
		{
			return pgReference;
		}
	}
	
	
	//Submission of conveyance
	public PageReference Submit()
	{
		Database.Upsertresult saveResult = null;
		Pagereference pgReference = null;
		
		System.debug('========= In submit=====');
		try
		{	
			if(lstConDetailDelete != null && lstConDetailDelete.size() > 0)
			{
			// need to delete Details who get removed from the UI.
				Database.delete(lstConDetailDelete);
			}
			objConveyanceManager.Event__c = eventId;
			System.debug('=========Event name in submit====='+eventId);
			objConveyanceManager.Mode_of_Travel__c = objConveyanceManager.Mode_of_Travel__c;
			objConveyanceManager.Claim_Date__c = objConveyanceManager.Claim_Date__c;
			objConveyanceManager.Travel_Type__c = objConveyanceManager.Travel_Type__c;
			objConveyanceManager.Remarks__c = objConveyanceManager.Remarks__c;
			objConveyanceManager.Date_of_Travel__c = objConveyanceManager.Date_of_Travel__c;
			objConveyanceManager.Is_Submitted__c = true;
			saveResult = Database.upsert(objConveyanceManager);
			if(saveResult.isSuccess())
			{
				List<Conveyance_Detail__c> lstRecordsToInsert =new List<Conveyance_Detail__c>();
				if(lstConveyanceInfo !=null && lstConveyanceInfo.size()>0)
				{
					Conveyance_Detail__c objConveyanceDetail;
					for(ConveyanceDetails tmpConveyanceDetails:lstConveyanceInfo)
					{
						if(String.valueOf(tmpConveyanceDetails.objConveyance_Details.Id) != Null)
							objConveyanceDetail = new Conveyance_Detail__c(Id = tmpConveyanceDetails.objConveyance_Details.Id);
						else
						{
							objConveyanceDetail = new Conveyance_Detail__c();
							objConveyanceDetail.Conveyance_Manager__c = saveResult.getId();
						}
						objConveyanceDetail.Amount__c = tmpConveyanceDetails.objConveyance_Details.Amount__c;
						objConveyanceDetail.Bill_Details__c = tmpConveyanceDetails.objConveyance_Details.Bill_Details__c;
						objConveyanceDetail.Is_Bill_Available__c = tmpConveyanceDetails.objConveyance_Details.Is_Bill_Available__c;
						System.debug('=========objConveyanceDetail====='+tmpConveyanceDetails);
						System.debug('=========tmpConveyanceDetails.objConveyance_Details.Amount__c====='+tmpConveyanceDetails.objConveyance_Details.Amount__c);
						objConveyanceDetail.Bill_Number__c = tmpConveyanceDetails.objConveyance_Details.Bill_Number__c;
						lstRecordsToInsert.add(objConveyanceDetail);	
					}		
					List<Database.Upsertresult> lstSaveResult = Database.upsert(lstRecordsToInsert);
				}
				pgReference = new Pagereference('/apex/ConveyanceManager?id='+saveResult.getId()+'&mode=edit'+'&eventId='+eventId);
				pgReference.setRedirect(true);
			}
		}
		catch(Exception ex)
		{
			
		}
		
		return pgReference;
	}
	
	
	//To remove detail object from database as well as from UI
	public void Remove()
	{
		if(lstConveyanceInfo != null && lstConveyanceInfo.size()>1)
		{
			ConveyanceDetails objRemovedDetail = lstConveyanceInfo.get(lstConveyanceInfo.size()-1);
			lstConDetailDelete.add(objRemovedDetail.objConveyance_Details);
			lstConveyanceInfo.remove(lstConveyanceInfo.size()-1);
		}
		else 
		{
			Error.DebugLog('Please add atleast one Conveyance details record');
		}
	}
	
	
	//Inner Class
	public class ConveyanceDetails
	{
		public Integer iIndex {get;set;}
        public Conveyance_Detail__c objConveyance_Details {get;set;}
		
		public ConveyanceDetails(){}
		public ConveyanceDetails(Conveyance_Detail__c objConveyance_Details , Integer iCount)
        {
        	if(objConveyance_Details != null)
       		{
        		this.objConveyance_Details = objConveyance_Details;
       			this.iIndex = iCount;
        	}
        	else
        	{
        	 	//Error.DebugLog('Null Value');
        	}
        }
       
	}
}