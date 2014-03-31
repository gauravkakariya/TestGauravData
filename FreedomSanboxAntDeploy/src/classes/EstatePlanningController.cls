/**
	This class is an interface to VisualForce page to get/hold all dara for 
			landing page and output page.
			
Revision History:
	
    Version     Version Author     Date        Comments
    1.0         Samruddhi P  	   15/02/2011  EstatePlanningController is controller class for EstatePlanningPage in Analysis Section
    2.0			Manasi Ranade      7/05/2012   Commented Original Code & created same property which will return the Remarks__c object
*/
    
public class EstatePlanningController{
	//FS0309 new property to show Remark
	public String accountId{get;set;}
	/** Eternus Solutions       **/
	/** Author  : Manasi Ranade **/
	/** Issue Id: 00001613     	**/
	/** Date    : 7/5/2012 	    **/
	/** Purpose : Commented Original Code & created same property which will return the Remarks__c object
	/****************************************************/
	/*public String Remark
	{
       get{
       		String strRemarks = '';
       		if(entityId != null)
       		{
    			for(Remarks__c objRemark : [select Remark__c from Remarks__c where entity__c =:entityId and recordtype.Name=:'SuccessionPlanning' limit 1])
    			{
    				strRemarks = objRemark.Remark__c;	
    			}
       		}
       		
            return strRemarks;
       }set;
    }*/
    public Remarks__c ORemark
	{
       get{
       		Remarks__c objRemarks;
       		if(entityId != null)
       		{
       			
    			for(Remarks__c objRemark : [select Remark__c, RichText_Remark__c from Remarks__c where entity__c =:entityId and recordtype.Name=:'SuccessionPlanning' limit 1])
    			{
    				objRemarks = objRemark;	
    			}
       		}
       		
            return objRemarks;
       }set;
    }
    public String entityId;
    public EstatePlanningBean bean {get; set;}
    EstatePlanningServices service {get; set;}
    public Static String eId {get;set;} 
    /**
    * Constructor to initialise the bean class,service class and fetch existing data
    */
    public EstatePlanningController()
    {
        entityId = eId == null ? ApexPages.currentPage().getParameters().get('EntityId') : eId;
        if(entityId!=null)
        {
            bean = new EstatePlanningBean();
            service = new EstatePlanningServices();
            bean.entity = service.getEntityDetails(entityId);
            if(bean.entity.Will__c==false){
                bean.spouse = service.getSpouseDetails(entityId);
            }    
        }
     //   Error.debuglog('-----------------Limit Estate--------'+Limits.getQueries());
    }
}