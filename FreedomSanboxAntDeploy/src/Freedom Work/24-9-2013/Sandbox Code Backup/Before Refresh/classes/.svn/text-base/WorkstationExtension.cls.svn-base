/********************************************************************************************************** 
       Eternus Solutions 
       Author  : Mahesh Hirugade
       Date    : 09/02/2012
       Purpose : To add new field "Advisor" to workstation object.
       Summary : According to workstation hierarchy and assignment sheet sent by Swati Thakkar, new field "Advisory" is added to Workstation object.
              I have added w.Advisory__c field to query to show on page, and shown this field on EditWorkstation page.
       
       Eternus Solutions 
       Author  : Anupam Agrawal
       Date    : 28/12/2012
       Purpose : To add new field "Operations" to workstation object.
       Summary :   
*********************************************************************************************************/
public with sharing class WorkstationExtension 
{
  public Workstation__c workstation{set;get;}
  private String Wid{set;get;}
  
  public WorkstationExtension(ApexPages.StandardController stdController)
  {
    this.workstation = (Workstation__c)stdController.getRecord();
    if(workstation !=  null)
    {
      Wid = workstation.Id;
      if(Wid != null)
      {
        workstation = [Select w.Tech__c, w.Name, w.Member_Engagement__c, w.Manager__c, w.Location__c, w.Id, w.Financial_Planner__c, Operations__c,
                   Operations__r.Name, w.Compliance__c, w.Business_Developer__c, w.Advisory__c From Workstation__c w where Id =:Wid];
      }
      else
      {
        Wid = ApexPages.currentPage().getParameters().get('wid');
        if(Wid != null)
        {
          workstation = [Select w.Tech__c, w.Name, w.Member_Engagement__c, w.Manager__c, w.Location__c, w.Id, w.Financial_Planner__c, Operations__c, Operations__r.Name,
                      w.Compliance__c, w.Business_Developer__c, w.Advisory__c From Workstation__c w where Id =:Wid];
        }
      }
    }
  }
  
  public Pagereference Save()
  {
     Boolean successflag=true;
     Pagereference pgref = null;
     if(workstation != null)
     {
       try
       {
         ValidateWorkstation objValidate = new ValidateWorkstation();
        objValidate.PopulateAllMaps();
        if(workstation != null)
          objValidate.validateAllWorkstations(workstation);
       }
       catch(ValidationException e) 
      {
        successflag = false;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
      }
      if(successflag)
      {
        Database.upsert(workstation);
        pgref = new Pagereference('/apex/ViewAllWorkstations');
      }
     }
     return pgRef;
  }
  
  public Pagereference Cancel()
  {
     Pagereference pgref = null;
     pgref = new Pagereference('/apex/ViewAllWorkstations');
     pgref.setRedirect(true);
     return pgref;
  }
}