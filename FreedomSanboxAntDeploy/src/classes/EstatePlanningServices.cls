/**
 * @Author: Samruddhi P
 * @since : 15th Feb 2011
 * @Description: EstatePlanningServices is service class for EstatePlanningPage in Analysis Section
 */
public class EstatePlanningServices{ 

    DatabaseSOQL dbSOQL;
    
    /**
    * Constructor to initialise service class
    */ 
    public EstatePlanningServices(){
        dbSOQL = new DatabaseSOQL();
    }
    
    /**
    * getSpouseDetails() function returns the details of Entity
    * param:id of particular Account (Entity)
    * returns:Account object instance for that particular Entity
    */  
    public Account getEntityDetails(String entityId){
        return dbSOQL.getEntity(entityId);
    }
    
    /**
    * getSpouseDetails() function returns the details of Entity's spouse
    * param:id of particular Account (Entity)
    * returns:Account object instance for that particular entity's spouse
    */  
    public Account getSpouseDetails(String entityId){
        return dbSOQL.getSpouseEntity(entityId);
    }   
}