public class DatabaseDML
{
	public DatabaseDML(){}
    
    public Id insertObject( Sobject sobj)
    {
    	database.saveResult result;
       	if(sobj == null)
       	{
        	DMLException ex = new DMLException('Object passed has a null reference.');
        	throw ex;              //throw new DMLException('Object passed has a null reference.');
       	}
       	else
       	{
			try
			{
       			result = Database.insert(sobj, true);
       		}
       		catch (Exception e)
       		{
            	DMLException ex = new DMLException('Insert Failed '+ e.getMessage());
            	throw ex;			//throw new DMLException('Insert Failed '+ e.getMessage());
	        }
        }
        System.Debug('getId-------------------->'+result.getId());
        return result.getId();
    }
    
    public Boolean upsertObject(List<Sobject> sobjList)
    {
       	Database.upsertResult[] results;
       	if(sobjList == null)
       	{
           	DMLException ex = new DMLException('Object passed has a null reference.');
           	throw ex;				//throw new DMLException('Object passed has a null reference.');
       	}
       	else
       	{
           	try
           	{
               	results = Database.upsert(sobjList, true);
               	system.debug('-----results----Insurance-'+results);
           	}
           	catch (Exception e)	
           	{
                DMLException ex = new DMLException('Upsert Failed '+ e.getMessage());
                //throw new DMLException('Upsert Failed '+ e.getMessage());
                throw ex;
           	}
       	}
       	integer cntr = 0;
       	
       	for(Database.upsertResult result : results) 
       	{
        	if(result.isSuccess() == true)
                cntr++;
        }
       	
       	if(cntr == results.size())
           	return true;
       	else 
           	return false;
       //System.Debug('===== In DatabaseDML upsertObject(List<sObject) ======'+ids);
       //return null;
    }

    public Id upsertObject(Sobject sobj)
    {
       	Database.upsertResult result;
       	
       	if(sobj == null)
       	{
           	DMLException ex = new DMLException('Object passed has a null reference.');
           	throw ex;			//throw new DMLException('Object passed has a null reference.');
	    }
       	else
       	{
           	try
           	{
               	result = Database.upsert(sobj, true);
           	}
           	catch (Exception e)
           	{
                DMLException ex = new DMLException('Upsert Failed '+ e.getMessage());
                throw ex;
           	}
        }
        System.Debug('===== In DatabaseDML upsertObject(sObject) ======'+result.getId());
        return result.getId();
    }
    
    public void deleteRecords(List<Sobject> sobjList)
    {
        try
        {
        	Database.delete(sobjList);
        }
        catch(Exception e)
        {
            DMLException ex = new DMLException('delete Failed '+ e.getMessage());
            throw ex;			//throw new DMLException('delete Failed '+ e.getMessage());
        }
    }
}