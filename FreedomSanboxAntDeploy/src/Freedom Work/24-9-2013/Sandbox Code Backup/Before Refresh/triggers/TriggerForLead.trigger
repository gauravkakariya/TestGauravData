trigger TriggerForLead on Lead (after update)
{
	
	
	
				
					
					
					
				//	public List<sObject> queryResult{get;set;}
					
					//public List<selectedObject> selonj;
					//public List<String> queryField{get;set;}
					
					// Intialize objectNames and fields
 
  

 
/*public List<Selectoption> SFDCObjectsList = new List<Selectoption>();
  public void getAllSFDCObjects()
	 {
	 	List<sObject> SFDCObjectsList;
	 	
	   Schema.Sobjecttype objSFDCObject;
	   
	   //Retreive a Map of all SFDC Object Tokens and SFDC Objects from the Org
	   Map<String, Schema.Sobjecttype> GlobalDescribeMap = Schema.getGlobalDescribe();
	   
	 
	   
	   
	   
	   
	   //Check if new objects are created or Object list is requested for the first time
	   if(GlobalDescribeMap.size() > SFDCObjectsList.size() || SFDCObjectsList.isEmpty())
	   {
		   List<String> KeyList = new List<String>();
		   KeyList.addAll(GlobalDescribeMap.keySet());
		   KeyList.sort();	//Sort the Objects according to their names
		   system.debug('**********************################################'+keyList);
		   if(!SFDCObjectsList.isEmpty())	//clear the list, if elements exist
		   		SFDCObjectsList.clear();
		   
		   for(String strKey : KeyList)
		   {
		   		if(GlobalDescribeMap.containsKey(strKey))	//check whether the key exists
		   			objSFDCObject = GlobalDescribeMap.get(strKey);
		   		
		   		//Add the Label and API Name values to be displayed in the picklist in the following format: Label(API Name)
			   	 SFDCObjectsList.add(new Selectoption(
			   	 	objSFDCObject.getDescribe().getName()+ '#' + objSFDCObject.getDescribe().getLabel(), 
			   	 	objSFDCObject.getDescribe().getName() + ' (' + objSFDCObject.getDescribe().getLabel()  + ')'));
			   	 	
			   	 	system.debug('**********************################################'+objSFDCObject);
		   }//for
	   }
	 }

 */
 
}