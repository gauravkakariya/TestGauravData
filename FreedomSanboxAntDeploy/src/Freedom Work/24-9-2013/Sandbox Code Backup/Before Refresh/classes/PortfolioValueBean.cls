/*
 * @Author: Anju G
 * @since :5th Feb 2011
 * @Description:PortfolioValueBean is bean class for PortfolioSummaryPage
 */
  public class PortfolioValueBean {
    public double currentValue{get;set;}
    public double suggestedPercent{get;set;}
    public PortfolioValueBean(){
        currentValue=0;
        suggestedPercent=0;
      }
 }