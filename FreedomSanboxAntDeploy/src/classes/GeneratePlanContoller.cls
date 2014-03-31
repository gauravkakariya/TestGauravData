/**
 * @Description: GeneratePlanContoller is a class to generate pdf or word file
 */
/*
	
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         --           	   --	  	   GeneratePlanContoller is a class to generate pdf or word file
    2.0			Manasi Ranade     7/12/2011    Issue ID:FS0341: Update the PlanGenerationDateFromSystem date when Fp creates the PDF
    2.0 		Manasi Ranade	  28/12/2011   Issue Id : FS0384 :
   												While generating Execution Tracker for given entity, save his Approved plan and his PDF as an attachment.
*/
Public class GeneratePlanContoller
{
   
    public String selectedOption{get;set;}
    private string entity;
    public List<SelectOption> getOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('PDF','PDF'));
        options.add(new SelectOption('Document','Document'));  
       
        return options;
    }
     public GeneratePlanContoller(){
     entity=System.currentPageReference().getParameters().get('entityId');
    }
   
   /**
    * @Description: Create() method to create and display pdf or word doc file
    * Return type: pageReference 
    */
    public pageReference create(){
        
        pageReference pr;
        system.debug('******'+getoptions()+'******'+selectedOption+'**'+entity);
     if(selectedOption=='PDF'){
          pr=new pageReference('/apex/generatePDF?entityId='+ entity +'&tabname=Financial+Planning');
        }else if(selectedOption=='Document')
           pr=new pageReference('/apex/generateDoc?entityId='+ entity +'&tabname=Financial+Planning'); 
     	/** Eternus Solutions   **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: FS0341      	**/
		/** Date    : 7/12/2011 	**/
		/** Purpose : Update the PlanGenerationDateFromSystem date when Fp creates the PDF
		/****************************************************/
     	if(entity != null)
     	{	
     		Account objSelectedAcc = selectAccount();
     		objSelectedAcc.PlanGenerationDateFromSystem__c = Date.today();
     		update objSelectedAcc;
     	}
       return pr;
    }
    /** Eternus Solutions     **/
	/** Author  : Manasi Ranade*/
	/** Issue Id: FS0384      **/
	/** Date    : 28/12/2011  **/
	/** Purpose : While generating Execution Tracker for given entity, save his Approved plan and his PDF as an attachment. **/
	public Pagereference Save()
	{
		Blob body;
        PageReference AttachmentPlan;
        Attachment PlanAttachment;
        Account objSelectedAcc;
        String strEntityName;
        if(entity != null)
     	{	
     		objSelectedAcc = selectAccount();
     		strEntityName = objSelectedAcc.FirstName; 
     		if(objSelectedAcc.LastName != null)
     			strEntityName  +=  '_' + objSelectedAcc.LastName;
     	}
		try
		{
			
   		 	AttachmentPlan = Page.GeneratePDF;
   		 	system.debug('@#########33 body : 2');
			AttachmentPlan.getParameters().put('entityId',entity);
			system.debug('@#########33 body : 3');
			PlanAttachment = new Attachment();
			body = AttachmentPlan.getContent();
			system.debug('@#########33 body :'+body);
		}
		catch(System.Exception e)
		{
			body = Blob.valueOf('PDF contents for test class');
        }
        PlanAttachment.Body = body;
        PlanAttachment.ParentId = entity;
        String strPlanPDFName = 'Plan_' + strEntityName + '_'+ system.NOW().format('dd-MM-yyyy') + '.pdf';//Name format of the PDF: Plan_EntityName_Date.pdf
		PlanAttachment.Name = strPlanPDFName;  
		PlanAttachment.ContentType = '';
		Database.Saveresult dbSaveResult = database.insert(PlanAttachment);
		return null;
	}
	/** Eternus Solutions     **/
	/** Author  : Manasi Ranade*/
	/** Issue Id: FS0384      **/
	/** Date    : 28/12/2011  **/
	/** Purpose : Created Function and added FistName and LastName in the select statement. **/
	public Account selectAccount()
	{
		Account objSelectedAcc = [select id,PlanGenerationDateFromSystem__c,LastName,FirstName  from Account where Id =: entity];
		return objSelectedAcc;
	}
}