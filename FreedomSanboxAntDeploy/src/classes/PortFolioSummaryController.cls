/*
 * @Author: Anju G
 * @since :24th Jan 2011
 * @Description:PortFolioSummaryController is controller class for PortfolioSummaryPage
 */
    public class PortFolioSummaryController 
    {
        public PortfolioSummaryService portfolioService{get;set;}
        public List<PortfolioBean>portfolioList{get;set;}
        private String chartData;
        private String suggestedChartData;
        
        public PortFolioSummaryController()
        {
            portfolioService=new PortfolioSummaryService();
            portfolioList=new List<PortfolioBean>();
            String entityId=Apexpages.currentPage().getParameters().get('entityId');
            List<Account>EntityList=portfolioService.getFamilyDetails(entityId);
            List<AggregateResult> aggregateList=portfolioService.getPortfolioAssets(EntityList);
            
            if(aggregateList !=null && aggregateList.size()>0)
            {
                addAggregateAssetToMap(aggregateList);
            }
            
            List<AggregateResult>investmentList=portfolioService.getPortfolioInvestmentAssets(EntityList);
            if (investmentList!=null && investmentList.size()>0) 
            {
                addAggregateInvestmentAssetToMap(investmentList);
            }
            
            List<AggregateResult>insuranceList=portfolioService.getPortfolioInsurance(EntityList);
            if (insuranceList!=null && insuranceList.size()>0) 
            {
                addAggregateInsuranceToMap(insuranceList);
            }
            
            List<AggregateResult>suggestedAssetList=portfolioService.getSuggestedAssets(entityList);
            suggestedAssetList.addAll(portfolioService.getSuggestedInvestmentAssets(entityList));
            suggestedAssetList.AddAll(portfolioService.getSuggestedInsurance(entityList));
            if (suggestedAssetList!=null && suggestedAssetList.size()>0) 
            {
                addAggregateSuggestedToMap(suggestedAssetList);
            }
            
            portfolioService.getSuggestedAsset();
            portfolioList=portfolioService.getPortfolioList();
            
            String chartPath = 'http://chart.apis.google.com/chart?cht=p3&chs=350x200&chco=71B549|8C86C3|AB2E0E|DC3912|A9F5F2&chtt=Current Asset Allocation';
            String SuggestedchartPath = 'http://chart.apis.google.com/chart?cht=p3&chs=350x200&chco=71B549|8C86C3|AB2E0E|DC3912|A9F5F2&chtt=Suggested Asset Allocation';
            
            List<ChartDataItem> items = new List<ChartDataItem>();
                items.add(new ChartDataItem('Cash and Cash Equivalent', getCashEquivalent));
                items.add(new ChartDataItem('Shares and Mutual Funds (Equity)',getShares));
                items.add(new ChartDataItem('Debt/FixedIncome Securities',getDebtSecurities)); 
                items.add(new ChartDataItem('Gold',getGold)); 
                items.add(new ChartDataItem('Real Estate',getRealEstate)); 
           
            List<ChartDataItem> suggestedItem= new List<ChartDataItem>();   
                suggestedItem.add(new ChartDataItem('Cash and Cash Equivalent', getSuggestedCashEquivalent));
                suggestedItem.add(new ChartDataItem('Shares and Mutual Funds (Equity)',getSuggestedShares));
                suggestedItem.add(new ChartDataItem('Debt/FixedIncome Securities',getSuggestedDebtSecurities)); 
                suggestedItem.add(new ChartDataItem('Gold',getSuggestedGold)); 
                suggestedItem.add(new ChartDataItem('Real Estate',getSuggestedRealEstate)); 
                chartData = chartPath +  getChartInfo(items);   
                suggestedChartData=SuggestedchartPath +  getChartInfo(suggestedItem);
                         
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
            String chdl='';  
            String result='';         
            for(ChartDataItem citem : items) 
            {
                if(citem.Value >0)
                {
                    chd += citem.Value + ',';
                    chdl += citem.Name+ '|'; 
                    chl+=citem.Value +'%'+'|';
                }
            } 
            if(chd!='')
            {
                chd = chd.substring(0, chd.length() -1); 
            }
            if(chl!='')
            {
                chl = chl.substring(0, chl.length() -1); 
            }
            if(chdl!='')
            {
                chdl=chdl.substring(0, chdl.length() -1); 
            }
            if(chd!='' && chdl!='' && chl!='')
            {
                result = '&chbh=a,50,20&chd=t:' + chd + '&chl=' + chl + '&chdl=' + chdl+'&chdlp=b'; 
            }
            return result;
        }
        
    /*
     * ChartDataItem class is used for storing the data related to chart
     */ 
        public class ChartDataItem
        { 
               public String Name{get;  set; } 
               public Double Value {get; set; } 
               public ChartDataItem(String Name, Double Value) 
               {
                    this.Name = Name;    
                    this.Value = Value; 
               }
        } 
        
     
        private void addAggregateInsuranceToMap(List<AggregateResult> insuranceList)
        {
            Double currentValue=0;
             String policyType;
            for(AggregateResult ar:insuranceList)
            {
                if(ar.get('totalInsurance')!=null)
                {
                    currentValue=(Double)ar.get('totalInsurance');
                }
                policyType=(String)ar.get('PolicyType');
                if(policyType.equalsIgnoreCase('ULIP - Equity'))
                {
                    portfolioService.addmapValue('Shares and Mutual Funds (Equity)',currentValue,ar); 
                }
                else 
                {
                    portfolioService.addmapValue('Debt/FixedIncome Securities',currentValue,ar);
                }
            }
            
        }
        
        
        private void addAggregateSuggestedToMap(List<AggregateResult> suggestedAssetList)
        {
            system.debug('%%%%%%%%%%suggestedAssetList%%%%%%%%%'+suggestedAssetList);
            for(AggregateResult ar:suggestedAssetList)
            {
                Double suggestedPercent=0;
                if(ar.get('allocatedPercent')!=null)
                {
                    suggestedPercent=(Double)ar.get('allocatedPercent');
                }
                String assetClass=(String)ar.get('assetClass');
                if(assetClass.equalsIgnoreCase('Cash and Cash Equivalents'))
                {
                    portfolioService.addmapPercent('Cash and Cash Equivalents',suggestedPercent,ar); 
                }
                else if(assetClass.equalsIgnoreCase('Deposits with Bank') || 
                        assetClass.equalsIgnoreCase('Govt. Saving Schemes')||
                        assetClass.equalsIgnoreCase('Retirement Accounts') ||assetClass.equalsIgnoreCase('Fixed Income'))
                {
                    portfolioService.addmapPercent('Debt/FixedIncome Securities',suggestedPercent,ar);
                }
                else if(assetClass.equalsIgnoreCase('Stocks'))
                {
                    portfolioService.addmapPercent('Shares and Mutual Funds (Equity)',suggestedPercent,ar); 
                }
                /* Prajakta - FP changes - 01-03-2013 - Added for new record type GOLD */
                else if(assetClass.equalsIgnoreCase('Gold') || assetClass.equalsIgnoreCase('Personal Assets'))
                {
                    portfolioService.addmapPercent('Gold',suggestedPercent,ar);
                }
                else if(assetClass.equalsIgnoreCase('Real Estate Assets'))
                {
                    portfolioService.addmapPercent('Real Estate',suggestedPercent,ar);
                }
                else if(assetClass.equalsIgnoreCase('Mutual Fund'))
                {
                    String assetType=(String)ar.get('assetType');
                    if(assetType!=null && assetType!='')
                    {
                        if(assetType.contains('Equity') || assetType.contains('equity'))
                        {
                            portfolioService.addmapPercent('Shares and Mutual Funds (Equity)',suggestedPercent,ar); 
                        }
                        else if(assetType.contains('Debt')||assetType.contains('debt'))
                        {
                            portfolioService.addmapPercent('Debt/FixedIncome Securities',suggestedPercent,ar);
                        }
                    }
                }
                else if(assetClass.equalsIgnoreCase('Life Insurance'))
                {
                    String policyType=(String)ar.get('PolicyType');
                    if(policyType.equalsIgnoreCase('ULIP - Equity'))
                    {
                        portfolioService.addmapPercent('Shares and Mutual Funds (Equity)',suggestedPercent,ar);
                    }
                    else
                    {
                        portfolioService.addmapPercent('Debt/FixedIncome Securities',suggestedPercent,ar);
                    }
                }
            }
        }
        
        private void addAggregateInvestmentAssetToMap(List<AggregateResult> investmentList)
        {
            double currentValue=0;
            for(AggregateResult ar:investmentList)
            {
                if(ar.get('totalAsset')!=null)
                {
                    currentValue=(Double)ar.get('totalAsset');
                }
                
                String assetClass=(String)ar.get('assetClass');
                if(assetClass.equalsIgnoreCase('Stocks'))
                {
                    portfolioService.addmapValue('Shares and Mutual Funds (Equity)',currentValue,ar); 
                }
                
                else if(assetClass.equalsIgnoreCase('Fixed Income'))
                {
                    portfolioService.addmapValue('Debt/FixedIncome Securities',currentValue,ar);
                }
                /* Prajakta - FP changes - 01-03-2013 - Added for new record type GOLD */
                else if(assetClass.equalsIgnoreCase('Gold'))
                {
                    portfolioService.addmapValue('Gold',currentValue,ar);
                }  
                
                else if(assetClass.equalsIgnoreCase('Mutual Fund'))
                {
                    String assetType=(String)ar.get('assetType');
                    if(assetType.contains('Equity') || assetType.contains('equity'))
                    {
                        portfolioService.addmapValue('Shares and Mutual Funds (Equity)',currentValue,ar); 
                    }
                    else if(assetType.contains('Debt')||assetType.contains('debt'))
                    {
                        portfolioService.addmapValue('Debt/FixedIncome Securities',currentValue,ar);
                    }
                }
            }
        }
        private void addAggregateAssetToMap(List<AggregateResult> aggregateList)
        {
            double currentValue=0;
            String assetClass;
            for(AggregateResult ar:aggregateList)
            {
                if(ar.get('current_balance') !=null)
                {
                    currentValue=(double)ar.get('current_balance') ;
                }
                else if(ar.get('current_value')!=null)
                {
                    currentValue=(double)ar.get('current_value');
                }
                else if(ar.get('accumulated_value')!=null)
                {
                    currentValue=(double)ar.get('accumulated_value');
                }
                assetClass=(String)ar.get('assetClass');
                if(assetClass.equalsIgnoreCase('Cash and Cash Equivalents'))
                {
                      portfolioService.addmapValue('Cash and Cash Equivalents',currentValue,ar); 
                }
                else if(assetClass.equalsIgnoreCase('Deposits with Bank') || 
                    assetClass.equalsIgnoreCase('Govt. Saving Schemes')||
                    assetClass.equalsIgnoreCase('Retirement Accounts'))
                    {
                    portfolioService.addmapValue('Debt/FixedIncome Securities',currentValue,ar);
                }
                else if(assetClass.equalsIgnoreCase('Personal Assets'))
                {
                    portfolioService.addmapValue('Gold',currentValue,ar);
                }
                else if(assetClass.equalsIgnoreCase('Real Estate Assets'))
                {
                    portfolioService.addmapValue('Real Estate',currentValue,ar);
                }
            }
        }     
         
        public Long getCashEquivalent
        {
            get
            {
                double cashEquivalent=0;
                for(PortfolioBean pfbean:portfolioList)
                {
                    if(pfbean.recordType.equalsIgnoreCase('Cash and Cash Equivalents'))
                    {
                        cashEquivalent=pfbean.currentPercent;
                        break;
                    }
                }
                return cashEquivalent.round();
            }
            set;
        }
        
        public Long getShares
        {
            get
            {
                double shares=0;
                for(PortfolioBean pfbean:portfolioList)
                {
                    if(pfbean.recordType.equalsIgnoreCase('Shares and Mutual Funds (Equity)'))
                    {
                        shares=pfbean.currentPercent;
                        break;
                    }
                }
                return shares.round();
            }
            set;
        }
        
        public Long getDebtSecurities
        {
            get
            {
                double debt=0;
                for(PortfolioBean pfbean:portfolioList)
                {
                    if(pfbean.recordType.equalsIgnoreCase('Debt/FixedIncome Securities'))
                    {
                        debt=pfbean.currentPercent;
                        break;
                    }
                }
                return debt.round();
            }
            set;
        }
        
        public Long getGold
        {
            get
            {
                double gold=0;
                for(PortfolioBean pfbean:portfolioList)
                {
                    if(pfbean.recordType.equalsIgnoreCase('Gold'))
                    {
                        gold=pfbean.currentPercent;
                        break;
                    }
                }
                return gold.round();
            }
              set;
        }
        
        public Long getRealEstate
        {
            get
            {
                double realEstate=0;
                for(PortfolioBean pfbean:portfolioList)
                {
                    if(pfbean.recordType.equalsIgnoreCase('Real Estate'))
                    
                    {
                        realEstate=pfbean.currentPercent;
                        break;
                    }
                }
                return realEstate.round();
            }
            set;
        }
              
        public Long getSuggestedCashEquivalent
        {
            get
            {
                double cashEquivalent=0;
                for(PortfolioBean pfbean:portfolioList)
                {
                    if(pfbean.recordType.equalsIgnoreCase('Cash and Cash Equivalents'))
                    {
                        cashEquivalent=pfbean.suggestedPercent;
                        break;
                    }
                }
                return cashEquivalent.round();
            }
            set;
        }
        
        public Long getSuggestedShares
        {
            get
            {
                double shares=0;
                for(PortfolioBean pfbean:portfolioList)
                {
                    if(pfbean.recordType.equalsIgnoreCase('Shares and Mutual Funds (Equity)'))
                    {
                        shares=pfbean.suggestedPercent;
                        break;
                    }
                }
                return shares.round();
            }
            set;
        }
        
        public Long getSuggestedDebtSecurities
        {
            get
            {
                double debt=0;
                for(PortfolioBean pfbean:portfolioList)
                {
                    if(pfbean.recordType.equalsIgnoreCase('Debt/FixedIncome Securities'))
                    {
                        debt=pfbean.suggestedPercent;
                        break;
                    }
                }
                return debt.round();
            }
            set;
        }
        
        public Long getSuggestedGold
        {
            get
            {
                double gold=0;
                for(PortfolioBean pfbean:portfolioList)
                {
                    if(pfbean.recordType.equalsIgnoreCase('Gold'))
                    {
                        gold=pfbean.suggestedPercent;
                        break;
                    }
                }
                return gold.round();
            }
            set;
        }
        
        public Long getSuggestedRealEstate
        {
            get
            {
                double realEstate=0;
                for(PortfolioBean pfbean:portfolioList)
                {
                    if(pfbean.recordType.equalsIgnoreCase('Real Estate'))
                    {
                        realEstate=pfbean.suggestedPercent;
                        break;
                    }
                }
                return realEstate.round();
            }
            set;
        }
    }