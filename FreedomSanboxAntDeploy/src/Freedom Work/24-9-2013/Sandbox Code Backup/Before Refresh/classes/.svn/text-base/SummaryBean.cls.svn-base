public class SummaryBean {
    
    public Double growthPercent { get; set;}
    //public Integer yearIndex =0; 
    public Integer yearEndIndex {get; set;}     
    public String header {get; set;}    
     
    public  Double totalValue {
        get; set; 
            
    }
    public Double monthlySummary {
        get {
            return math.floor(totalValue/12);
        }   
    }
        
    public SummaryBean(String header,Double growthPercent,Integer yearEndIndex) {
        totalValue = 0;
        this.growthPercent = growthPercent;
        this.yearEndIndex = yearEndIndex;
        this.header = header;
    }
    
    public SummaryBean(){
        totalValue = 0;
    }

    
    public List<Double> totalValueByYear {
        get {
            List<Double> totalValueList = new List<Double>();                                      
            for(Integer index=0; index<yearEndIndex ;index++) {
                if(index == 0) {
                    totalValueList.add(totalValue);
                } else {                                        
                    totalValueList.add(FinancialUtil.calculateCompound(totalValue, index, growthPercent));
                }                       
            }                    
            return totalValueList;
        }               
    }
    
    
    public List<SummaryBean.SummaryDetail> summaryDetailList {
        get {
            if(summaryDetailList == null) {
                summaryDetailList  =new List<SummaryDetail>();
            }            
            return summaryDetailList;       
        }
        set; 
    } 

    public void populateSummaryDetailList(SummaryDetail summaryDetail) {
        summaryDetailList.add(summaryDetail);
        summaryDetail.bean = this;  
    }   

    public class SummaryDetail {
                
        public  SummaryDetail (String name,Double summaryValue){           	             
            this.name= name;        
            this.summaryValue = summaryValue;            	                   	           
        }
                                
        public String name {get; set;}
        public Double summaryValue { get; set;}
            
        private SummaryBean bean { get; set {
            bean = value;                   
            if(summaryValue != null)
                bean.totalValue = bean.totalValue + summaryValue;
            }
        }               
        
        public Double monthlySummary {
            get {               
                return math.floor(summaryValue/12);
            }   
        }
                
        public Double summaryPercent {
            get {                   
                if(this.summaryValue != null){
                	if(bean.totalValue != 0) {                      
                    	return ( summaryValue * 100) /bean.totalValue;
                	} else{
                    	return 0;	
                    }	
                }else{
                    return null;
                }                                                       
            }
            set;            
        }   
        public List<Double> totalValueByYear {                
            get {
                List<Double> totalValueList = new List<Double>();
                                      
                for(Integer index=0; index<bean.yearEndIndex ;index++) {
                    if(index == 0) {
                        totalValueList.add(this.summaryValue);
                    } else {
                        totalValueList.add(FinancialUtil.calculateCompound(summaryValue, index, bean.growthPercent));
                    }                       
                }
                return totalValueList;
            }       
        }                               
    }   
}