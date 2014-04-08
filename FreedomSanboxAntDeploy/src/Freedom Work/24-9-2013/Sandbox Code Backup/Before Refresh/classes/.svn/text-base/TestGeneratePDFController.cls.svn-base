/**
 * @Description: GeneratePDFController is a class to generate pdf file for desired details
 */
/**
Revision History:
	
    Version     Version Author     Date        Comments
    1.0         --           	   --	  		Initial Draft
    
    2.0			Niket Chandane      31/05/2011  Update the goalMappingBeanList property for the where added the if condition for
    											not null for the goalIdList
    2.0			Manasi Ranade	   31/10/2011   Issue ID: FS0230: 
												Passed the SIP values to the component : "GoalComponent"
	2.0  		Manasi 			   28/11/2011   Issue Id: FS0309 : Code to Add Remark in the page
	2.0  		Manasi 			   19/1/2012    Issue Id: 00001461 : Change in function : GeneratePDFController :
												Added Check for Null before using
	2.0  		Manasi 			   07/05/2012   Issue Id: 00001613 :  Added new property for remark
	2.0  		Manasi 			   07/05/2012   Issue Id: 00001616 :  Calculate Continuing Income Source value from Spouse/Dependent
	
*/

public with sharing class TestGeneratePDFController
{

	//Properties added for Partner Portal Implementation purpose By Aditi Satpute
	//============================================================================
	public Boolean isFreedomUser{get;set;}
	//public String Accname{get;set;}
	public String email{get;set;}
	public String CcEmail{get;set;}
	public String BccEmail{get;set;}
	public Boolean isFreedomUserProp{get;set;}
	public String address{get;set;}
	public String addressInComponent{get;set;}
	User user;
//	public String emailId{get;set;}
//	public String accountName {get;set;}
//	public String titleName {get;set;}
//	public String PlanName{get;set;}
	public Account Partnerlogo{get;set;}
	public Account Logo_partner{get;set;}
	public Account VirtualCreatedEntity{get;set;}
	//public String lstAddressInComponent;
	public List<String> lstAdd
	{
		get
		{
			if(lstAdd == null)
				lstAdd = new List<String>();
			return lstAdd;
		}
		set;
	}
	public List<String> lstAddwithComma
	{
		get
		{
			if(lstAddwithComma == null)
				lstAddwithComma = new List<String>();
			return lstAddwithComma;
		}
		set;
	}
	
	//==============================================================
		
//001W0000005xbbE
	//==============================================================================
  //// Code to display buttons on GenerateHTML page, 13/Jan/2012
  	public String DisplayButton {get;set;}
  	public String AttachmentId {get;set;}
  	public String strMessage {get; set;}
  	public String emailBody {get; set;}
  	public Boolean isSendEmail {get; set;}
  //==============================================================================
  //FS0309 new property to show Remark
  public String strRemark {get;set;}
  /** Eternus Solutions  **/
  /** Author  : Manasi Ranade	**/
  /** Issue Id: 00001613      **/
  /** Date    : 07/05/2012 	**/
  /** Purpose : Added new property for remark**/
  /****************************************************/
  public Remarks__c objRemark {get;set;}
  public GeneratePDFBean bean{get;set;}
  public GeneratePDFServices service{get;set;}
  public String planGenerationDate{get;set;}
  public NewGoalService goalService {get;set;} 
  public Map<String,GoalMappingBean> goalMappingBeanMap { get;set;}
  /////////////////////////////////////////////////////
  Map<Id,Account> accMap;
  public Account parentAcc{get;set;}
  public Account spouce{get;set;}
  public List<Goal__c> goalList{get;set;}
  Id entityId; 
  /////////////////////////////////////////////////////
  public TestGeneratePDFController()
  {
  	entityId = '001W0000005xb4U';
  	//Account
  	accMap = new Map<Id,Account>([select Id, Name, isPersonAccount, Parent_Entity__c, FirstName, LastName,Total_Assets__c,
                                                        Total_Income__c,
                                                        RecordTypeId,Adjustment_Factor__c,
                                                        PersonTitle, PersonContactId, PersonBirthdate, PersonHomePhone,Salutation,
                                                        PersonMobilePhone, Alternate_Mobile__c, PersonEmail, Alternate_E_Mail_Address__c,
                                                        Retirement_Year__c,Residential_Status_del__c,Retirement_Age__c,Estimated_Life_Expectancy__c,
                                                        Estimated_Life_EndYear__c,Relationship_to_Entity__pc, Description
                                                        from Account where id =: entityId or Parent_Entity__c =: entityId ]);
  	for(Id accId : accMap.keySet())
  	{
  		Account objAcc = accMap.get(accId);
  		if(objAcc.Parent_Entity__c == null)
  			parentAcc = objAcc;
  		if(objAcc.Relationship_to_Entity__pc == 'Wife' ||  objAcc.Relationship_to_Entity__pc == 'Husband')
  			spouce = objAcc;
  	}
  	//Goal 
  	goalList = [Select Id,Inflation_Rate__c,  Cost_of_Goal_Annual__c,Priority__c
  				,SelectedGoalProfile__r.name,Name, Goal_Type__c,description__c
  				, Goal_End_Year__c,Goal_Start_Year__c from Goal__c where entity__c =:entityId ];
  }
	
}