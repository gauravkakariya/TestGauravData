public with sharing class HLVPlanningCompRefactoredController
{
	public HLVDetails__c objHLVDetails{get;set;}
	
	public List<InnerClass> getGoalDetails
	{
		get
		{
			List<InnerClass> lstInnerClass = new List<InnerClass>();
			List<String> stringGoalDetails = new List<String>(); 
			if(objHLVDetails != null)
			{
				If(objHLVDetails.GoalDetails__c != null && objHLVDetails.GoalDetails__c != '')
				{
					stringGoalDetails.addAll(objHLVDetails.GoalDetails__c.split(';;'));
				} 
			}
			for(Integer i = 0; i < stringGoalDetails.size(); i++)
			{
				String[] GoalDetail = stringGoalDetails[i].split('::');
				InnerClass obj = new InnerClass();//(GoalDetail[0],Double.valueOf(GoalDetail[1]));
				obj.goalName = GoalDetail[0];
				//if(GoalDetail[1] != null && GoalDetail[1] != '')
				string strAmt = GoalDetail[1].deleteWhitespace();
				obj.goalAmount = Double.valueOf(strAmt);
				lstInnerClass.add(obj);
				//InnnerClass obj = new InnnerClass();
			}
			return lstInnerClass;
		}
		set;
	}
	public class InnerClass
	{
		public String goalName{get;set;}
		public Double goalAmount{get;set;}
		public InnerClass()
		{
			//Do Nothing constructor
		}
	}
	public List<IncomeInnerClass> getIncomeDetails
	{
		get
		{
			List<IncomeInnerClass> lstInnerClass = new List<IncomeInnerClass>();
			List<String> stringIncomeDetails = new List<String>();
			if(objHLVDetails != null)
			{
				If(objHLVDetails.Continuing_Income_Sources_Details__c != null && objHLVDetails.Continuing_Income_Sources_Details__c != '')
				{
					stringIncomeDetails.addAll(objHLVDetails.Continuing_Income_Sources_Details__c.split(';;'));
				} 
			}
			for(Integer i = 0; i < stringIncomeDetails.size(); i++)
			{
				String[] IncomeDetail = stringIncomeDetails[i].split('::');
				IncomeInnerClass obj = new IncomeInnerClass();
				obj.IncomeEntityName = IncomeDetail[0];
				string strAmt = IncomeDetail[1].deleteWhitespace();
				obj.incomeAmount = Double.valueOf(strAmt);
				lstInnerClass.add(obj);
			}
			return lstInnerClass;
		}
		set;
	}
	
	public class IncomeInnerClass
	{
		public String IncomeEntityName{get;set;}
		public Double incomeAmount{get;set;}
		public IncomeInnerClass()
		{
			//Do nothing Constructor
		}
	}
	public List<InnerClassExistingInvestments> getExistingInvestments
	{
		get
		{
			List<InnerClassExistingInvestments> lstInnerClass = new List<InnerClassExistingInvestments>();
			List<String> stringExistingInvestmentsDetails = new List<String>(); 
			if(objHLVDetails != null)
			{
				If(objHLVDetails.Existing_Investments_Details__c != null && objHLVDetails.Existing_Investments_Details__c != '')
				{
					stringExistingInvestmentsDetails.addAll(objHLVDetails.Existing_Investments_Details__c.split(';;'));
				} 
			}
			for(Integer i = 0; i < stringExistingInvestmentsDetails.size(); i++)
			{
				String[] ExistingInvestmentsDetail = stringExistingInvestmentsDetails[i].split('::');
				InnerClassExistingInvestments obj = new InnerClassExistingInvestments();//(ExistingInvestmentsDetail[0],Double.valueOf(ExistingInvestmentsDetail[1]));
				obj.ExistingInvestmentsName = ExistingInvestmentsDetail[0];
				//if(ExistingInvestmentsDetail[1] != null && ExistingInvestmentsDetail[1] != '')
				string strAmt = ExistingInvestmentsDetail[1].deleteWhitespace();
				if(!obj.ExistingInvestmentsName.equals('Mutual Funds') && strAmt != null && strAmt != '')
					obj.ExistingInvestmentsAmount = Double.valueOf(strAmt);
				else 
					obj.ExistingInvestmentsAmount = 0;
				
				lstInnerClass.add(obj);
				//InnnerClass obj = new InnnerClass();
			}
			return lstInnerClass;
		}
		set;
	}
	public class InnerClassExistingInvestments
	{
		public String ExistingInvestmentsName{get;set;}
		public Double ExistingInvestmentsAmount{get;set;}
		public InnerClassExistingInvestments()
		{
			//Do nothing Constructor
		}
		/*public InnerClassExistingInvestments(String gName, Double gAmt)
        {
            ExistingInvestmentsName = gName;
            ExistingInvestmentsAmount = gAmt;
        }*/
	}
	static testMethod void HLVPlanningCompRefactoredControllerTest()
	{
		Test.startTest();
		HLVPlanningCompRefactoredController objHVLPlanning = new HLVPlanningCompRefactoredController();
		Account objAccount=new Account(FirstName='ABC',LastName='DEF',RecordTypeId=RecTypes__c.getInstance('AccountClient').Record_Type_Value__c);
		insert objAccount;
		HLVDetails__c objHLVDetails = new HLVDetails__c(entity__c = objAccount.Id, GoalDetails__c = 'Vacation::240000;;Education::500000;;',
														Continuing_Income_Sources_Details__c = 'Test1::20000;;',
														Existing_Investments_Details__c = 'Equity::5000;;Deposite With Bank::2122;;Mutual Funds::4444;;');
		insert objHLVDetails;
		objHVLPlanning.objHLVDetails = objHLVDetails;
		List<HLVPlanningCompRefactoredController.InnerClass> lstInnerClass = objHVLPlanning.getGoalDetails;
		List<HLVPlanningCompRefactoredController.IncomeInnerClass> lstIncomeInnerClass = objHVLPlanning.getIncomeDetails;
		List<HLVPlanningCompRefactoredController.InnerClassExistingInvestments> lstInnerClassExistingInvestments = objHVLPlanning.getExistingInvestments;
		
		Test.stopTest();
	}
}