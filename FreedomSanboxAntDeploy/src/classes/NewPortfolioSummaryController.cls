/*
	
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         --           	   --	  		Initial Draft
    2.0			Manasi			   2/4/2012 	Issue ID : 00001559 :Changed the code for proper colors in pie chart
    2.0			Manasi Ranade	   30/4/2012    Issue ID : 00001613 : Added output Filed to preserve new line characters
	
*/
public class NewPortfolioSummaryController 
{
	//FS0309 new property to show Remark
	public String accountId{get;set;}
	/** Eternus Solutions      **/
	/** Author  : Manasi Ranade 	**/
	/** Issue Id: 00001613      	**/
	/** Date    : 30/4/2012 	 	**/
	/** Purpose : Commented previous Remark
	/****************************************************/
	/*public String Remark{
       get{
       		String strRemarks = '';
       		if(accountId != null){
    			for(Remarks__c objRemark : [select Remark__c from Remarks__c where entity__c =:accountId and recordtype.Name=:'PortfolioSummary' limit 1]){
    				strRemarks = objRemark.Remark__c;	
    			}
       		}
            return strRemarks;
       }set;
   	}*/ 
   	/** Eternus Solutions      **/
	/** Author  : Manasi Ranade 	**/
	/** Issue Id: 00001613      	**/
	/** Date    : 30/4/2012 	 	**/
	/** Purpose : Created new Property to display Remark in OutputFiled
	/****************************************************/
   	public Remarks__c objRemark{
       get{
       		Remarks__c selectedRemarks;
       		if(accountId != null){
    			for(Remarks__c objRemark : [select RichText_Remark__c,Remark__c from Remarks__c where entity__c =:accountId and recordtype.Name=:'PortfolioSummary' limit 1]){
    				selectedRemarks = objRemark;	
    				
    			}
       		}
            return selectedRemarks;
       }set;
   	}
	public NewPortfolioSummaryService portfolioService{get;set;}
	private String chartData;
	private String suggestedChartData;
	public Static String eId {get;set;}
	/*
		Constructor will create Service object and do portfolio calculation.
		It also has support for Chart generation.
	*/
	public NewPortFolioSummaryController()
	{		
		system.debug('****************Limit.getQueries================ first Inside NewPortfolioSummary >'+Limits.getQueries());
		try 
		{
			/** Eternus Solutions       **/
			/** Author  : Manasi Ranade **/
			/** Issue Id: 00001559     	**/
			/** Date    : 2/4/2012	 	**/
			/** Purpose : Changed the code for proper colors in pie chart**/
			/****************************************************/ 
			/*portfolioService = new NewPortfolioSummaryService();
			String entityId = Apexpages.currentPage().getParameters().get('entityId');
			accountId = entityId;
			system.debug('Limits.getQueries()============getPortfolioSummary 1=>'+Limits.getQueries());
			portfolioBeanList = portfolioService.getPortfolioSummary(entityId);
			system.debug('Limits.getQueries()============getPortfolioSummary 2=>'+Limits.getQueries());
			String chartPath = 'http://chart.apis.google.com/chart?cht=p3&chs=350x200&chco=71B549|8C86C3|AB2E0E|DC3912|A9F5F2&chtt=Current Asset Allocation';
			String SuggestedchartPath = 'http://chart.apis.google.com/chart?cht=p3&chs=350x200&chco=71B549|8C86C3|AB2E0E|DC3912|A9F5F2&chtt=Suggested Asset Allocation';
			List<ChartDataItem> items = new List<ChartDataItem>();
			items.add(new ChartDataItem(label.CashandCashEquivalent, portfolioBeanList.get(0).currentPercent.setScale(2,System.Roundingmode.HALF_EVEN)));
			items.add(new ChartDataItem(Label.SharesandMutualFunds,portfolioBeanList.get(1).currentPercent.setScale(2,System.Roundingmode.HALF_EVEN)));
			items.add(new ChartDataItem(Label.DebtFixedIncomeSecurities,portfolioBeanList.get(2).currentPercent.setScale(2,System.Roundingmode.HALF_EVEN))); 
			items.add(new ChartDataItem(Label.Gold,portfolioBeanList.get(3).currentPercent.setScale(2,System.Roundingmode.HALF_EVEN))); 
			items.add(new ChartDataItem(Label.RealEstate,portfolioBeanList.get(4).currentPercent.setScale(2,System.Roundingmode.HALF_EVEN)));
		
			List<ChartDataItem> suggestedItem= new List<ChartDataItem>();   
			suggestedItem.add(new ChartDataItem(label.CashandCashEquivalent, portfolioBeanList.get(0).suggestedPercent.setScale(2,System.Roundingmode.HALF_EVEN)));
			suggestedItem.add(new ChartDataItem(Label.SharesandMutualFunds,portfolioBeanList.get(1).suggestedPercent.setScale(2,System.Roundingmode.HALF_EVEN)));
			suggestedItem.add(new ChartDataItem(Label.DebtFixedIncomeSecurities,portfolioBeanList.get(2).suggestedPercent.setScale(2,System.Roundingmode.HALF_EVEN))); 
			suggestedItem.add(new ChartDataItem(Label.Gold,portfolioBeanList.get(3).suggestedPercent.setScale(2,System.Roundingmode.HALF_EVEN))); 
			suggestedItem.add(new ChartDataItem(Label.RealEstate,portfolioBeanList.get(4).suggestedPercent.setScale(2,System.Roundingmode.HALF_EVEN))); 
			chartData = chartPath +  getChartInfo(items);   
			suggestedChartData = SuggestedchartPath +  getChartInfo(suggestedItem);
			
			system.debug('****************Limit.getQueries================ Last Inside NewPortfolioSummary >'+Limits.getQueries());
			*/
			
			portfolioService = new NewPortfolioSummaryService();
			String entityId = eId == null ? Apexpages.currentPage().getParameters().get('entityId') : eId;
			accountId = entityId;
			
			portfolioBeanList = portfolioService.getPortfolioSummary(entityId);
			system.debug('****************Limit.getQueries================ second Inside NewPortfolioSummary >'+Limits.getQueries());
			system.Debug('portfolioBeanListportfolioBeanList===>'+portfolioBeanList);
			//00001559
			List<String> currentAssetAllocationColorList = new List<string>{'660099','8C86C3','AB2E0E','DC3912','006633','66FF99'};
			List<String> suggestedAssetAllocationColorList = new List<string>{'660099','8C86C3','AB2E0E','DC3912','006633','66FF99'};
			List<String> extraColorList = new List<String>{'FFF55C','FF9FE7','4A49FF','FF7560','A2FFE9'};
			List<ChartDataItem> items = new List<ChartDataItem>();
			Integer iExtraColorCount = 0;
			for(Integer iCount = 0 ;iCount <= 4 ;iCount++)
			{
				if(portfolioBeanList.get(iCount).currentPercent.setScale(2,System.Roundingmode.HALF_EVEN) <= 0 || portfolioBeanList.get(iCount).suggestedPercent.setScale(2,System.Roundingmode.HALF_EVEN) <= 0)
				{
					if(portfolioBeanList.get(iCount).currentPercent.setScale(2,System.Roundingmode.HALF_EVEN) <= 0 && portfolioBeanList.get(iCount).suggestedPercent.setScale(2,System.Roundingmode.HALF_EVEN) <= 0)
					{
						currentAssetAllocationColorList[iCount] = null;
						suggestedAssetAllocationColorList[iCount] = null;
					}
					else
					{
						if(portfolioBeanList.get(iCount).currentPercent.setScale(2,System.Roundingmode.HALF_EVEN) <= 0)
							currentAssetAllocationColorList[iCount] = null;
						else
							currentAssetAllocationColorList[iCount] = extraColorList[iExtraColorCount++];
						
						if(portfolioBeanList.get(iCount).suggestedPercent.setScale(2,System.Roundingmode.HALF_EVEN) <= 0)
							suggestedAssetAllocationColorList[iCount] = null;
						else
							suggestedAssetAllocationColorList[iCount] = extraColorList[iExtraColorCount++];	
					}
				}
				
			}
			String strColorCurrent,strColorSuggested;
			for(Integer iCnt = 0;iCnt < currentAssetAllocationColorList.size(); iCnt++)
			{
				if(strColorCurrent != null)
				{
					if(currentAssetAllocationColorList[iCnt] != null)
						strColorCurrent = strColorCurrent + '|' + currentAssetAllocationColorList[iCnt];
				}
				else
					strColorCurrent = currentAssetAllocationColorList[iCnt];
			}
			for(Integer iCnt = 0;iCnt < suggestedAssetAllocationColorList.size(); iCnt++)
			{
				if(strColorSuggested != null)
				{
					if(suggestedAssetAllocationColorList[iCnt] != null)
						strColorSuggested = strColorSuggested + '|' + suggestedAssetAllocationColorList[iCnt];
				}
				else
					strColorSuggested = suggestedAssetAllocationColorList[iCnt];
			}

			String chartPath = 'http://chart.apis.google.com/chart?cht=p3&chs=350x200&chco='+strColorCurrent+'&chtt=Current Asset Allocation'; // Prajakta
			String SuggestedchartPath = 'http://chart.apis.google.com/chart?cht=p3&chs=350x200&chco='+strColorSuggested+'&chtt=Suggested Asset Allocation';
			items.add(new ChartDataItem(label.CashandCashEquivalent, portfolioBeanList.get(0).currentPercent.setScale(2,System.Roundingmode.HALF_EVEN)));
			items.add(new ChartDataItem(Label.SharesandMutualFunds,portfolioBeanList.get(1).currentPercent.setScale(2,System.Roundingmode.HALF_EVEN)));
			items.add(new ChartDataItem(Label.DebtFixedIncomeSecurities,portfolioBeanList.get(2).currentPercent.setScale(2,System.Roundingmode.HALF_EVEN))); 
			items.add(new ChartDataItem(Label.Gold,portfolioBeanList.get(3).currentPercent.setScale(2,System.Roundingmode.HALF_EVEN))); 
			items.add(new ChartDataItem(Label.RealEstate,portfolioBeanList.get(4).currentPercent.setScale(2,System.Roundingmode.HALF_EVEN)));
			items.add(new ChartDataItem(Label.Portfolio_Life_Insurance,portfolioBeanList.get(5).currentPercent.setScale(2,System.Roundingmode.HALF_EVEN)));
		
			List<ChartDataItem> suggestedItem= new List<ChartDataItem>();   
			suggestedItem.add(new ChartDataItem(label.CashandCashEquivalent, portfolioBeanList.get(0).suggestedPercent.setScale(2,System.Roundingmode.HALF_EVEN)));
			suggestedItem.add(new ChartDataItem(Label.SharesandMutualFunds,portfolioBeanList.get(1).suggestedPercent.setScale(2,System.Roundingmode.HALF_EVEN)));
			suggestedItem.add(new ChartDataItem(Label.DebtFixedIncomeSecurities,portfolioBeanList.get(2).suggestedPercent.setScale(2,System.Roundingmode.HALF_EVEN))); 
			suggestedItem.add(new ChartDataItem(Label.Gold,portfolioBeanList.get(3).suggestedPercent.setScale(2,System.Roundingmode.HALF_EVEN))); 
			suggestedItem.add(new ChartDataItem(Label.RealEstate,portfolioBeanList.get(4).suggestedPercent.setScale(2,System.Roundingmode.HALF_EVEN))); 
			suggestedItem.add(new ChartDataItem(Label.Portfolio_Life_Insurance,portfolioBeanList.get(5).suggestedPercent.setScale(2,System.Roundingmode.HALF_EVEN))); 
			chartData = chartPath +  getChartInfo(items);   
			suggestedChartData = SuggestedchartPath +  getChartInfo(suggestedItem);
			
			system.debug('****************Limit.getQueries================ Last Inside NewPortfolioSummary >'+Limits.getQueries());
			//Error.debuglog('-----------------Limit NewPortfolioSummary--------'+Limits.getQueries());
		}
		catch(Exception ex)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,ex.getMessage()));																						
		}		
	}
	
	public List<PortfolioBean> portfolioBeanList {get; set;}
	
	// Total calculation for suggested/current asset allocation.
	public Double totalValue {
		get {
			return portfolioService.totalAsset;
		}
	}
	
	//13Feb2012
	// Total calculation for suggested
	public Double totalValueSuggested {
		get {
			return portfolioService.totalAssetSuggested;
		}
	}
    /*
     * getChartData() Method returning the data for generating Current AssetAssociation Chart
     * params:none
     * ReturnType:String
     */     
	public String getChartData()
	{ 
		return chartData;
	} 
	
    /*
     * getSuggestedChartData() Method returning the data for generating Suggested AssetAssociation Chart
     * params:none
     * ReturnType:String
     */ 
	public String getSuggestedChartData()
	{
		return suggestedChartData;
	}  
	     
	private String getChartInfo(List<ChartDataItem> items)
	{
		String chd = ''; 
		String chl = ''; 
		String chdl = '';  
		String result = '';   
		      
		for(ChartDataItem citem : items) 
		{
			if(citem.Value >0)
			{
				chd += citem.Value + ',';
				chdl += citem.Name + '|'; 
				chl+=citem.Value + '%' + '|';
			}
		} 
		if(chd != '')
		{
			chd = chd.substring(0, chd.length() -1); 
		}
		if(chl != '')
		{
			chl = chl.substring(0, chl.length() -1); 
		}
		if(chdl != '')
		{
			chdl=chdl.substring(0, chdl.length() -1); 
		}
		if(chd != '' && chdl != '' && chl != '')
		{
			result = '&chbh=a,50,20&chd=t:' + chd + '&chl=' + chl + '&chdl=' + chdl + '&chdlp=b'; 
		}
		return result;
	}       
    /*
     * ChartDataItem class is used for storing the data related to chart
     */ 
	public class ChartDataItem
	{ 
		public String Name{get;  set;} 
		public Double Value {get; set;} 
		
		public ChartDataItem(String Name, Decimal Value) 
		{
			this.Name = Name;    
			this.Value = Value; 
		}            
	}    		
}