public with sharing class UserLoginHistroy 
{
	public List<LoginHistoryDetail> lstLoginHistoryDetail {get;set;}
	
	private  Map<String, List<LoginHistoryDetail>> mapUserNameToListOfLoginHistoryDetail = new Map<String,  List<LoginHistoryDetail>>();
	
	public Contact objContact {get;set;}
	public Contact objEndContact {get;set;}
	
	private Map<String, Integer> mapDateToDateCount = new Map<String, Integer>();
	private Map<Id, User> mapIdToUser = new Map<id, User>([select Id, Name from User where IsActive = true and (UserType = 'Standard' or UserType='Partner')]);
	private set<Id> setUserId = mapIdToUser.keySet();
	public List<LoginHistoryDetail> lstLoginHistoryDetailwithPercent {get;set;} 
	
	private DateTime startDate;
	private DateTime endDate;
	public boolean isPercentage {get;set;}
	
	public class LoginHistoryDetail
	{
		public String UserName {get;set;}
		public String strDate {get;set;}
		public Integer countDate {get;set;}
		public decimal percentage {get;set;}
		
		public LoginHistoryDetail(String UserName, String strDate)
		{
			this.UserName = UserName;
			this.strDate = strDate;
		}
		
		public LoginHistoryDetail(String UserName, String strDate, Integer countDate)
		{
			this.UserName = UserName;
			this.strDate = strDate;
			this.countDate = countDate;
		}
		
		public LoginHistoryDetail(String UserName, decimal percentage)
		{
			this.UserName = UserName;
			this.percentage = percentage;
		}
	}
	
	//To view the login description i.e. username with datetime and count
	public class loginDescription
	{
		public String UserName {get;set;}
		public DateTime dtLoginTime {get;set;}
		
		public loginDescription(String UserName, DateTime dtLoginTime)
		{
			this.UserName = UserName;
			this.dtLoginTime = dtLoginTime;
		}
		
	}
	
	public List<loginDescription> lstloginDescription {get;set;}
	/** Constructor**/
	public UserLoginHistroy()
	{
		objContact = new Contact();
		objEndContact = new Contact();
		isPercentage = false;
		lstLoginHistoryDetail = new List<LoginHistoryDetail>();
	}
	
	//Method to show the login history for user
	public void filterLoginHistory()
	{
		if(!validateDate())//Validation for date
		{
			//Cleared both list so that pagemsg and data should not get displayed at the same time
			lstLoginHistoryDetail = new List<LoginHistoryDetail>();
			lstLoginHistoryDetailwithPercent = new List<LoginHistoryDetail>();
			return;
		}	
		
		isPercentage = false;
		startDate = Datetime.newInstance(objContact.birthDate.year(), objContact.birthDate.month(), objContact.birthDate.day(), 00, 00, 00);
		System.debug('---------------------startDate--------------------'+startDate);
		//startDate = startDate.addHours(-5).addMinutes(-30);
		System.debug('---------------------startDate--------------------'+startDate);
		endDate = Datetime.newInstance(objEndContact.birthDate.year(), objEndContact.birthDate.month(), (objEndContact.birthDate.day() + 1), 00, 00, 00);
		System.debug('---------------------endDate--------------------'+endDate);
		//endDate = endDate.addHours(-5).addMinutes(-30);
		System.debug('---------------------endDate--------------------'+endDate);
		/*String strStartDate = startDate.year() +'-'+ startDate.month() +'-'+startDate.day() + 'T00:00:00Z';
		String strEndDate = endDate.year() +'-'+ endDate.month() +'-'+ (endDate.day() + 1) + 'T00:00:00Z';*/
		
		Integer totalDays = objContact.birthDate.daysBetween(objEndContact.birthDate);
		
		//String strQuery = 'SELECT UserId, LoginTime from LoginHistory where LoginTime >' + strStartDate + ' and LoginTime <'+ strEndDate+' and UserId in: setUserId order by LoginTime desc ';
		String strQuery = 'SELECT UserId, LoginTime from LoginHistory where LoginTime >:startDate and LoginTime <:endDate and UserId in: setUserId order by LoginTime desc ';
		
		loginDetail(strQuery);
	}
	
	public void calculatePercentage()
	{
		lstLoginHistoryDetailwithPercent = new List<LoginHistoryDetail>();
		
		if(!validateDate())
		{
			//Cleared both list so that pagemsg and data should not get displayed at the same time
			lstLoginHistoryDetail = new List<LoginHistoryDetail>();
			lstLoginHistoryDetailwithPercent = new List<LoginHistoryDetail>();
			return;
		}	
		Integer totalDays = objContact.birthDate.daysBetween(objEndContact.birthDate);
		isPercentage = true;
		
		startDate = Datetime.newInstance(objContact.birthDate.year(), objContact.birthDate.month(), objContact.birthDate.day(), 00, 00, 00);
		System.debug('---------------------startDate--------------------'+startDate);
		//startDate = startDate.addHours(-5).addMinutes(-30);
		System.debug('---------------------startDate--------------------'+startDate);
		endDate = Datetime.newInstance(objEndContact.birthDate.year(), objEndContact.birthDate.month(), (objEndContact.birthDate.day() + 1), 00, 00, 00);
		System.debug('---------------------endDate--------------------'+endDate);
		//endDate = endDate.addHours(-5).addMinutes(-30);
		System.debug('---------------------endDate--------------------'+endDate);
		/*String strStartDate = startDate.year() +'-'+ startDate.month() +'-'+startDate.day() + 'T00:00:00Z';
		String strEndDate = endDate.year() +'-'+ endDate.month() +'-'+ (endDate.day() + 1) + 'T00:00:00Z';*/
		
		//Integer totalDays = objContact.birthDate.daysBetween(objEndContact.birthDate);
		
		//String strQuery = 'SELECT UserId, LoginTime from LoginHistory where LoginTime >' + strStartDate + ' and LoginTime <'+ strEndDate+' and UserId in: setUserId order by LoginTime desc ';
		String strQuery = 'SELECT UserId, LoginTime from LoginHistory where LoginTime >:startDate and LoginTime <:endDate and UserId in: setUserId order by LoginTime desc ';
		
		
		loginDetail(strQuery);
		set<Id> setId = new set<Id>();

		for(String userId : mapUserNameToListOfLoginHistoryDetail.keySet())
		{
			List<LoginHistoryDetail> lstLHD = mapUserNameToListOfLoginHistoryDetail.get(userId);
			Decimal percent = ((lstLHD.size() * 100.0) / (totalDays+1));
			if(mapIdToUser.get(Id.valueOf(userId)) != null)
			{
				setId.add(userId);
				lstLoginHistoryDetailwithPercent.add(new LoginHistoryDetail(mapIdToUser.get(Id.valueOf(userId)).Name, percent));
			}
			else
			{
				setId.add(userId);
				lstLoginHistoryDetailwithPercent.add(new LoginHistoryDetail(userId, percent));
			}			
		}
		for(String userId : mapIdToUser.keySet())
		{
			if(mapIdToUser.get(Id.valueOf(userId)) != null && !setId.contains(userId))
			{
				lstLoginHistoryDetailwithPercent.add(new LoginHistoryDetail(mapIdToUser.get(Id.valueOf(userId)).Name, 0));
			}
			else if(!setId.contains(userId))
			{
				lstLoginHistoryDetailwithPercent.add(new LoginHistoryDetail(userId, 0));
			}			
		}
	}
	
	//Login History Calculation logic method
	public void loginDetail(String strQuery)
	{
		mapDateToDateCount = new Map<String, Integer>();
		mapUserNameToListOfLoginHistoryDetail = new Map<String,  List<LoginHistoryDetail>>();
		lstLoginHistoryDetail = new List<LoginHistoryDetail>();
		
		lstloginDescription = new List<loginDescription>();
		for(LoginHistory objLoginHistory : Database.query(strQuery))
		{
			Datetime dtLoginTime = objLoginHistory.LoginTime.addHours(5).addMinutes(29).addSeconds(59);
			
			if(mapIdToUser.get(objLoginHistory.UserId) != null)
				lstloginDescription.add(new loginDescription(mapIdToUser.get(objLoginHistory.UserId).Name, dtLoginTime));
			else
				lstloginDescription.add(new loginDescription(objLoginHistory.UserId, dtLoginTime));
				
			///////////////////////////////////////////	
			dtLoginTime = objLoginHistory.LoginTime;
			String strDate =  dtLoginTime.day() + '-' + dtLoginTime.month() + '-' + dtLoginTime.year();
			System.debug('---------------------strDate-------------------------------'+strDate);
			String strKey = objLoginHistory.UserId + '~' + strDate;
			
			if(!mapUserNameToListOfLoginHistoryDetail.containsKey(objLoginHistory.UserId))
			{
				List<LoginHistoryDetail> ListDateToCount = new List<LoginHistoryDetail>();
				ListDateToCount.add(new LoginHistoryDetail(objLoginHistory.UserId, strDate));
				
				mapUserNameToListOfLoginHistoryDetail.put(objLoginHistory.UserId, ListDateToCount);
				mapDateToDateCount.put(strKey, 1);
				
			}
			else
			{
				if(!mapDateToDateCount.containsKey(strKey))
				{
					mapUserNameToListOfLoginHistoryDetail.get(objLoginHistory.UserId).add(new LoginHistoryDetail(objLoginHistory.UserId, strDate));
					mapDateToDateCount.put(strKey, 1);
				}
				else
				{ 
					mapDateToDateCount.put(strKey, mapDateToDateCount.get(strKey) + 1 );
				}
			}
		}
		
		for(String userId : mapUserNameToListOfLoginHistoryDetail.keySet())
		{
			for(LoginHistoryDetail objLHD : mapUserNameToListOfLoginHistoryDetail.get(userId))
			{
				String strKey = userId + '~' + objLHD.strDate;
				if(mapIdToUser.get(Id.valueOf(userId)) != null)
					lstLoginHistoryDetail.add(new LoginHistoryDetail(mapIdToUser.get(Id.valueOf(userId)).Name, objLHD.strDate,  mapDateToDateCount.get(strKey)));
				else
					lstLoginHistoryDetail.add(new LoginHistoryDetail(userId, objLHD.strDate,  mapDateToDateCount.get(strKey)));
			}
		}
	}
	
	//Pagereference to the Show Login History Export to Excel
	public PageReference filterLoginHistoryExportToExcel()
	{
		if(!validateDate())
			return null;
			
		startDate = objContact.birthDate;
		endDate = objEndContact.birthDate;
		String strRedirect = '/apex/UserLoginHistoryExportToExcel?sday='+startDate.day()+'&smonth='+startDate.month()+'&syear='+startDate.year()+
																 '&eday='+endDate.day()+'&emonth='+endDate.month()+'&eyear='+endDate.year()+'&type=detail';
		PageReference pr = new Pagereference(strRedirect);
		return pr;
	}
	
	//Pagereference to the Calculated Percentage Export to Excel
	public PageReference calculatePercentageExportToExcel()
	{
		
		if(!validateDate())
			return null;
			
		startDate = objContact.birthDate;
		endDate = objEndContact.birthDate;
		String strRedirect = '/apex/UserLoginHistoryExportToExcel?sday='+startDate.day()+'&smonth='+startDate.month()+'&syear='+startDate.year()+
																 '&eday='+endDate.day()+'&emonth='+endDate.month()+'&eyear='+endDate.year()+'&type=percentage';
		PageReference pr = new Pagereference(strRedirect);
		return pr;
	}
	
	//Validations method for start date and end date
	private Boolean validateDate()
	{
		if(objEndContact.birthDate == null || objContact.birthDate == null)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please enter both Start date and End date.'));
			return false;
		}
		if(objContact.birthDate >  objEndContact.birthDate)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please enter Start Date less than End Date to view Login History.'));
			return false;
		}
		
		return true;
	}
	
	//Test class for UserLoginHistroy
	public static testMethod void testSiteLoginController()
	{
		UserLoginHistroy objUserLoginHistroy = new UserLoginHistroy();
		objUserLoginHistroy.objContact.birthDate = System.today() - 1;
		objUserLoginHistroy.objEndContact.birthDate = System.today();
		objUserLoginHistroy.loginDetail('SELECT UserId, LoginTime from LoginHistory order by LoginTime desc limit 1000');
		objUserLoginHistroy.calculatePercentage();
		objUserLoginHistroy.filterLoginHistory();
		objUserLoginHistroy.filterLoginHistoryExportToExcel();
		objUserLoginHistroy.calculatePercentageExportToExcel();
		
		
		objUserLoginHistroy.objContact.birthDate = System.today();
		objUserLoginHistroy.objEndContact.birthDate = System.today()- 2;
		objUserLoginHistroy.calculatePercentage();
		objUserLoginHistroy.filterLoginHistory();
		objUserLoginHistroy.filterLoginHistoryExportToExcel();
		objUserLoginHistroy.calculatePercentageExportToExcel();
		
	}
}