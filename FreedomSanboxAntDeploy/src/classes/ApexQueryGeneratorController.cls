public class ApexQueryGeneratorController
{
					public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
					public List<Pair> lstfieldname{get;set;}
					public List <Pair> fields {get{return lstfieldname;} set{lstfieldname =value;}}
					public List <SelectOption> objectNames{public get; private set;}
					public String selectedObject {get; set;}
					public String query {get;set;}
					public List<sObject> sob{get;set;}
				//	public List<sObject> queryResult{get;set;}
						public String queryResult{get;set;}
					//public List<selectedObject> selonj;
					//public List<String> queryField{get;set;}
					
					// Intialize objectNames and fields
					
					public ApexQueryGeneratorController() {
					objectNames = initObjNames();
					fields = new List<Pair>();
					}
					// Populate SelectOption list -
					
					// find all sObjects available in the organization
					
					private  List<SelectOption> initObjNames() 
					{
					List<SelectOption> objNames = new List<SelectOption>();
					List<String> entities = new List<String>(schemaMap.keySet());
					entities.sort();
					for(String name : entities)
					{
					objNames.add(new SelectOption(name,name));
					system.debug('***************************************************************'+name);
					}
					return objNames;
					}
					
					// Find the fields for the selected object
					
					public void showFields() {
					//fields.clear();
					system.debug('$$$$$' + selectedObject);
					Map <String, Schema.SObjectField> fieldMap = schemaMap.get(selectedObject).getDescribe().fields.getMap();
					query = 'SELECT  ';
					
					Integer check = 1;
					for(Schema.SObjectField sfield : fieldMap.Values())
					{
						
					schema.describefieldresult dfield = sfield.getDescribe();
						if(fieldMap.Values().size() == check)
						{
							queryResult+= dfield.getname() + '  ';
							query += dfield.getname() + '  ';
						}
						else
						{
							queryResult += dfield.getname() + ' ,';
						    query += dfield.getname() + ' ,';
						}
						check++;
					system.debug('#######' + dfield );
					
					Pair field = new Pair();
					
					field.key = dfield.getname();
					
					
					system.debug('#######4444' + field.key);
					field.val = dfield.getType () + ' : ' + dfield.getLabel ();
					lstfieldname.add(field);
					}
					 query +=  ' FROM '+selectedObject+' LIMIT 100';
					}
					
					public void result()
					{
						//queryResult = query;
						//system.debug('object which we got'+selectedObject);
						//queryResult = query;
					   // sob= new List<sObject>();
					   sob =  Database.query(query);
					   system.debug('All REcords +++++++++++++++++++++++++++++++++++++++++++++++++++++'+sob);
					   
					   for(Sobject sob1  : sob)
					   {
					   	queryResult += sob1;
					   }
					    
					//	sob= Database.Querylocator(query);
					
					  
					}

public class Pair
{
public String key {get; set;}
public String val {get; set;}
}















/*public with sharing class QueryGeneratorController {
	
	private  Map<String, Schema.SObjectType> objectNameMap;
	public   String selectedObj {set;get;}
	public   List<String> allRecords {set;get;}
	public   Map <String, Schema.SObjectField> fieldMap {set;get;}
	public   List<Map <String,String>> showRecords {set;get;}
	public   List<String> fieldNames {set;get;}
	public   Map<String,String> lastRecord {set;get;}
	
	public String query {set; get;}
	
	public PageReference init()
	{
		 allRecords = new List<String>();
	 	 objectNameMap =	Schema.getGlobalDescribe();
	 	 
	 	 return null;
	}
	
	public PageReference generateAction()
	{
		Schema.SObjectType selectedObjectType 		 =  objectNameMap.get(selectedObj);
		Schema.DescribeSObjectResult describeResults =  selectedObjectType.getDescribe();
		
		system.debug('table name :'+describeResults.getName());
		
	    fieldMap=describeResults.fields.getMap();
		
		
		query = 'SELECT ';
		
		Integer counter=1;
		
		for(Schema.SObjectField sfield : fieldMap.Values())
		{
			Schema.DescribeFieldResult dfield = sfield.getDescribe();
			
			if(counter == fieldMap.Values().size())
			{
				query += dfield.getname() + ' ';
			}
			else
			{
				query += dfield.getname() + ', ';
			}
			counter++;
        }
        
		query += ' FROM '+describeResults.getName()+' LIMIT 100';
		
		
		system.debug('query:'+query);
			
		return null;
	}
	
	public String generateQuery()
	{
		return '';
	}
	
	
	public PageReference runQuery()
	{
		List<sObject> allRecords = Database.query(query);
		showRecords = new List<Map<String,String>>();
		fieldNames  = new List<String>();
		
		for(sObject curObject:allRecords)
		{
			Map<String,String> record = new Map<String,String>(); 
			
			for(Schema.SObjectField sfield : fieldMap.Values())
			{
				Object value = curObject.get(sfield);	
				String result = value != null ? String.valueOf(value) : '';
				
				system.debug('result:'+result);
				
				record.put(sfield.getDescribe().getname(),result);
				fieldNames.add(sfield.getDescribe().getname());
				
				lastRecord.put(sfield.getDescribe().getname(),result);
				
			} 
			showRecords.add(record);
		
		}
		
		
		return null;
	}
	
	// populate view option list.
       public List<SelectOption> getObjectList() {
                    
                    List<SelectOption> options = new List<SelectOption>();
                    
                    List<String> allObjects =  new List<String>();
                    allObjects.addAll(objectNameMap.keySet());
                    allObjects.sort();
                    
                    for(String objectName : allObjects)
                    {
                    	options.add(new SelectOption(objectName,objectName));
                    }	
                    
                     return options;
   	   }
  
}


*/



}