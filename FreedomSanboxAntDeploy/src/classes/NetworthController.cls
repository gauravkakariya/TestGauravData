/*
Revision History:

   Version     Version Author     Date          Comments
   1.0         Persistent         NA  		  	Initial Draft
   
   2.0         Niket Chandane	  05/06/2011    Added the new property getLiabilitiesList to add the Detail liability list on the NetworthPageComponent
                                                this is change is done for the Isuue F0035
   2.0 		   Niket Chandane	  21/06/2011    Update the return value of the "getTotalLiabilities".
						  						It will show the total Liabilities for the entity.
   2.0  	   Manasi Ranade	  07/05/2012    Issue Id: 00001613 : Added Remark related functionality
*/
public class NetworthController {
	/** Eternus Solutions      **/
	/** Author  : Manasi Ranade 	**/
	/** Issue Id: 00001613      	**/
	/** Date    : 30/4/2012 	 	**/
	/** Purpose : Created new Property to display Remark in OutputFiled
	/****************************************************/
   	public Remarks__c SelectedRemark{get;set;}
	//FS0309 new property to show Remark
    	public String Remark
    	{
	       get{
	       		String strRemarks = '';
	       		if(accountId != null)
	       		{
	    			for(Remarks__c objRemark : [select Remark__c from Remarks__c where entity__c =:accountId and RecordType.Name=:'Networth' limit 1])
	    			{
	    				strRemarks = objRemark.Remark__c;
	    				SelectedRemark = objRemark;
	    			}
	       		}
	            return strRemarks;
	         }set;
	   } 
	    //public String Remark{set;get;}   
        public NetworthService networthService; 
        public Id accountId ;
                
        private SummaryBean assetSummaryBean,liabilitySummaryBean;
        
        private String chartData;
        public String getChartData(){ return chartData;}
        double incrementFactor;
    	public Static String eId {get;set;} 
        public NetworthController() {
        	//Manasi Plz remove
        	system.debug('***************Start Networth *Limit.getQueries============1==== Last Inside NewPortfolioSummary >'+Limits.getQueries());
        	/*Case:00001681 for Remarks Displayed on PDF: Setty*/
        		SelectedRemark = new Remarks__c(Remark__c = Remark);
                networthService = new NetworthService();
                system.debug('***************End Networth *Limit.getQueries==========2====== Last Inside NewPortfolioSummary >'+Limits.getQueries());
                accountId = eId == null ? System.currentPageReference().getParameters().get('entityId') : eId;
                assetSummaryBean = networthService.getAssetSummaryBean(accountId);
                system.debug('***************End Networth *Limit.getQueries=========3======= Last Inside NewPortfolioSummary >'+Limits.getQueries());
                liabilitySummaryBean = networthService.getLiabilitiesSummaryBean(accountId);
                system.debug('***************End Networth *Limit.getQueries=========33======= Last Inside NewPortfolioSummary >'+Limits.getQueries());
                String chartPath = 'http://chart.apis.google.com/chart?cht=bvs&chs=400x200&chco=458B00|6495ED|CD9B1D';
                List<ChartDataItem> items = new List<ChartDataItem>();
                incrementFactor=getIncrementFactor();
                system.debug('***************End Networth *Limit.getQueries===========4===== Last Inside NewPortfolioSummary >'+Limits.getQueries());
                items.add(new ChartDataItem('Total Assets' , math.roundToLong(getTotalAssets)));
                items.add(new ChartDataItem('Total Liabilities' , math.roundToLong(getTotalLiabilities)));
                items.add(new ChartDataItem('Total Networth' ,math.roundToLong(( getTotalAssets - getTotalLiabilities)))); 
                if(minValue != 0){
                    chartPath = chartPath + '&chxt=x,y&chf=bg,s,F0F0F0&chm=N,000000,0,,12,&chxr=1,'+(MinValue-incrementFactor)+','+maxValue+','+incrementFactor+'&chds='+(MinValue-incrementFactor)+','+maxValue;  
                }else{
                    chartPath = chartPath + '&chxt=x,y&chf=bg,s,F0F0F0&chm=N,000000,0,,12,&chxr=1,'+MinValue+','+maxValue+','+incrementFactor+'&chds='+MinValue+','+maxValue;  
                }
                system.debug('***************End Networth *Limit.getQueries=========5======= Last Inside NewPortfolioSummary >'+Limits.getQueries());
                chartData = chartPath +  getChartInfo(items);
                system.debug('***************End Networth *Limit.getQueries=========6======= Last Inside NewPortfolioSummary >'+Limits.getQueries());
                //Error.debuglog('-----------------Limit Networth--------'+Limits.getQueries());
        }
               
        public List<SummaryBean.SummaryDetail> getNetworthSummaryList {
                get{                                        
                        return assetSummaryBean.summaryDetailList;
                }
                set;    
        } 
        
        /*
         Added By : Niket Chandane
         Date 	  : 5 june 2011
         Summary  : This property add the Detail liability list on the NetworthPageComponent
         Issue    : F0035 
        */
        public List<SummaryBean.SummaryDetail> getLiabilitiesList
        {
        	get{
        			return liabilitySummaryBean.summaryDetailList;
        	}set;
        }
		
		/*
			Modified By : Niket Chandane.
			Modified At : 21 June 2011
			Summary 	: Update the return value of the "getTotalLiabilities".
						  It will show the total Liabilities for the entity.
			Issue 		: F0035
		*/        
        public Double getTotalLiabilities {
                get {
                       if(liabilitySummaryBean.summaryDetailList.isEmpty()){
                            return 0;
                       }
                       // return liabilitySummaryBean.summaryDetailList.get(0).summaryValue;
                      return liabilitySummaryBean.totalValue;
                }
                set;            
        }
        public Double getTotalAssets {
                get {
                    return assetSummaryBean.totalValue;    
                }
                set;    
        }

        public Double getTotalNetworth {
                get {                   
                    return assetSummaryBean.totalValue -  getTotalLiabilities;   
                }
                set;    
        }
        
        public String getNetworthChart {
                get {
                    List<String> xAxisDataList =  new String[] {'Total Assets','Total Liabilities', 'Total Networth'};
                    List<String> yAxisDataList = new String[]{};
                                                                
                    yAxisDataList.add('' + getTotalAssets);
                    yAxisDataList.add('' + getTotalLiabilities);                                
                    yAxisDataList.add('' +  (getTotalAssets - getTotalLiabilities));        
                    return GraphMarkUpGenerator.get2DGraph('', '', ''+getTotalAssets, xAxisDataList,
                                                                             yAxisDataList, 'Networth');                    
                }       
                set;
        }
         public pageReference Output(){
        return null;
    }
    
    
      public double MinValue{
       set;
       get{
             Double netWorth=getTotalAssets-getTotalLiabilities;
           if(getTotalAssets<getTotalLiabilities && getTotalAssets<netWorth)
               MinValue=getTotalAssets;
           else if(getTotalLiabilities<getTotalAssets&& getTotalLiabilities<netWorth)
               MinValue=getTotalLiabilities;
           else
               MinValue=netWorth;
           return math.roundToLong(minValue);
       }
   }
   
    public double maxValue{
       set;
       get{
           if(getTotalAssets<getTotalLiabilities)
               maxValue=getTotalLiabilities;
           else 
               maxValue=getTotalAssets;
           return math.roundToLong(maxValue);
       }
   }    
     public double getIncrementFactor(){
       
       if(MinValue<0){
       
           MinValue=MinValue*(-1);
        }
        double value=0;
      //  if(MinValue!=0)
           value=(maxValue-MinValue)/10;
     //  if(value<=MinValue)    
     //      return MinValue;
     //  else 
          return math.roundToLong(value);
      
   }
    private String getChartInfo(List<ChartDataItem> items){
             String chd = ''; //23,34,56 
             String chl = ''; //Hello|World 
                        
             for(ChartDataItem citem : items) {
                 chd += citem.Value + ',';
                 chl += citem.Name+ '|';
             } //remove the last comma or pipe 
             chd = chd.substring(0, chd.length() -1); 
             chl = chl.substring(0, chl.length() -1); 
             String result = '&chbh=a,50,20&chd=t:' + chd + '&chl=' + chl+'&chtt='+'Networth'+'&chf'+ 'b0,lg,0,FFE7C6,0,76A4FB,1'; 
             return result;
       }
         
    public class ChartDataItem{ 
        public String Name{  get;  set; } 
        public Double Value {   get;   set; } 
        public ChartDataItem(String Name, Double Value) {
            this.Name = Name;    
            this.Value = Value; 
        }
    
    }    
}