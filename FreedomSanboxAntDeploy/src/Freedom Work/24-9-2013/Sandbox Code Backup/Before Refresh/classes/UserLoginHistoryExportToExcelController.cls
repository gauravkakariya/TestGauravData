public with sharing class UserLoginHistoryExportToExcelController
{
	public List<LoginHistoryDetail> lstLoginHistoryDetail {get;set;}
	
	private  Map<String, List<LoginHistoryDetail>> mapUserNameToListOfLoginHistoryDetail = new Map<String,  List<LoginHistoryDetail>>();
	
	
	private Map<String, Integer> mapDateToDateCount = new Map<String, Integer>();
	private Map<Id, User> mapIdToUser = new Map<id, User>([select Id, Name from User where IsActive = true and (UserType = 'Standard' or UserType='Partner')]);
	private set<Id> setUserId = mapIdToUser.keySet();
	public List<LoginHistoryDetail> lstLoginHistoryDetailwithPercent {get;set;} 
	
	private DateTime startDate{get;set;}
	private DateTime endDate{get;set;}
	public String strStartDate{get;set;}
	public String strEndDate{get;set;}
	
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
	
	private Integer startDay;
	private Integer startMonth;
	private Integer startYear;
	private Integer endDay;
	private Integer endMonth;
	private Integer endYear;
	
	public String strType{get;set;}
	public UserLoginHistoryExportToExcelController()
	{
		lstLoginHistoryDetail = new List<LoginHistoryDetail>();
		
		strType = Apexpages.currentPage().getParameters().get('type');
		
		startDay = Integer.valueOf(Apexpages.currentPage().getParameters().get('sday'));
		startMonth = Integer.valueOf(Apexpages.currentPage().getParameters().get('smonth'));
		startYear = Integer.valueOf(Apexpages.currentPage().getParameters().get('syear'));
		
		endDay = Integer.valueOf(Apexpages.currentPage().getParameters().get('eday'));
		endMonth = Integer.valueOf( Apexpages.currentPage().getParameters().get('emonth'));
		endYear = Integer.valueOf(Apexpages.currentPage().getParameters().get('eyear'));
		
		//startDate =  Datetime.newInstanceGmt(startYear, startMonth, startDay);
		//endDate =  Datetime.newInstanceGmt(endYear, endMonth, endDay);
		
		strStartDate = startDay + '-' + startMonth + '-' + startYear;
		strEndDate = endDay + '-' + endMonth + '-' + endYear;
		
		//startDate = startYear +'-'+ startMonth +'-'+ startDay + 'T00:00:00Z';
		//endDate = endYear +'-'+ endMonth +'-'+ (endDay + 1) + 'T00:00:00Z';
		
		startDate = Datetime.newInstance(startYear, startMonth, startDay, 00, 00, 00);
		System.debug('---------------------startDate--------------------'+startDate);
		//startDate = startDate.addHours(-5).addMinutes(-30);
		System.debug('---------------------startDate--------------------'+startDate);
		endDate = Datetime.newInstance(endYear, endMonth, (endDay + 1), 00, 00, 00);
		System.debug('---------------------endDate--------------------'+endDate);
		//endDate = endDate.addHours(-5).addMinutes(-30);
		System.debug('---------------------endDate--------------------'+endDate);
		
		if(strType.equalsIgnoreCase('detail'))
			filterLoginHistory();
		else
		{
			lstLoginHistoryDetail =  new List<LoginHistoryDetail>();
			calculatePercentage();
		}
		
		
	}

	public void filterLoginHistory()
	{
		String strQuery = 'SELECT UserId, LoginTime from LoginHistory where LoginTime >:startDate  and LoginTime <:endDate and UserId in: setUserId order by LoginTime desc ';
		loginDetail(strQuery);
	}
	
	public void calculatePercentage()
	{
		lstLoginHistoryDetailwithPercent = new List<LoginHistoryDetail>();
		
		String strQuery = 'SELECT UserId, LoginTime from LoginHistory where LoginTime >:startDate  and LoginTime <:endDate and UserId in: setUserId order by LoginTime desc ';
		
		loginDetail(strQuery);
		
		set<Id> setId = new set<Id>();
		
		Date newStartDate = Date.newInstance(startYear, startMonth, startDay);
		Date newEndDate = Date.newInstance(endYear, endMonth, endDay);
		
		Integer totalDays = newStartDate.daysBetween(newEndDate);
		
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
	
	public void loginDetail(String strQuery)
	{
		mapDateToDateCount = new Map<String, Integer>();
		mapUserNameToListOfLoginHistoryDetail = new Map<String,  List<LoginHistoryDetail>>();
		lstLoginHistoryDetail = new List<LoginHistoryDetail>();
		for(LoginHistory objLoginHistory : Database.query(strQuery))
		{
			//Datetime dtLoginTime = objLoginHistory.LoginTime.addHours(5).addMinutes(30);
			Datetime dtLoginTime = objLoginHistory.LoginTime;
			String strDate = dtLoginTime.day() + '-' + dtLoginTime.month() + '-' + dtLoginTime.year();
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
	
	
	public static testMethod void testUserLoginHistoryExportToExcelController()
	{
		Date startDate = System.today();
		Date endDate = System.today() - 10;
		Apexpages.currentPage().getParameters().put('sday', String.valueOf(startDate.day()));
		Apexpages.currentPage().getParameters().put('smonth', String.valueOf(startDate.month()));
		Apexpages.currentPage().getParameters().put('syear', String.valueOf(startDate.year()));
		Apexpages.currentPage().getParameters().put('eday', String.valueOf(endDate.day()));
		Apexpages.currentPage().getParameters().put('emonth', String.valueOf(endDate.month()));
		Apexpages.currentPage().getParameters().put('eyear', String.valueOf(endDate.year()));
		Apexpages.currentPage().getParameters().put('type', 'detail');
		UserLoginHistoryExportToExcelController obj = new UserLoginHistoryExportToExcelController();
		obj.loginDetail('SELECT UserId, LoginTime from LoginHistory order by LoginTime desc limit 1000');
		obj.calculatePercentage();
		obj.filterLoginHistory();
		
		
		Apexpages.currentPage().getParameters().put('sday', String.valueOf(startDate.day()));
		Apexpages.currentPage().getParameters().put('smonth', String.valueOf(startDate.month()));
		Apexpages.currentPage().getParameters().put('syear', String.valueOf(startDate.year()));
		Apexpages.currentPage().getParameters().put('eday', String.valueOf(endDate.day()));
		Apexpages.currentPage().getParameters().put('emonth', String.valueOf(endDate.month()));
		Apexpages.currentPage().getParameters().put('eyear', String.valueOf(endDate.year()));
		Apexpages.currentPage().getParameters().put('type', 'percentage');
		UserLoginHistoryExportToExcelController obj1 = new UserLoginHistoryExportToExcelController();
		//obj1.calculatePercentage();
		//obj1.filterLoginHistory();
	}
}