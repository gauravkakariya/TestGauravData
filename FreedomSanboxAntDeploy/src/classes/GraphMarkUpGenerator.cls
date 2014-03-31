public class GraphMarkUpGenerator {

	public static String get2DGraph(String xAxisName,String yAxisName, String yAxisMaxValue,
									List<String> xAxisDataList,List<String> yAxisDataList,String caption){
		
		String graphTag =	'<graph xaxisname='+'\"' + xAxisName 
								+ '\"' +' yaxisname='+'\"' + yAxisName 
								+ '\"' +' hovercapbg='+ '\"' + 'DEDEBE' 
								+ '\"' +' hovercapborder='+ '\"' + '889E6D' 
								+ '\"' +' rotateNames='+ '\"' +'0'+ '\"' 
								+' animation='+ '\"' +'1' + '\"' 
								+' yAxisMaxValue='+ '\"'+yAxisMaxValue +'\"' 
								+' numdivlines=' + '\"' +'9' + '\"' 
								+' divLineColor='+ '\"' +'CCCCCC'+ '\"' 
								+ ' divLineAlpha='+ '\"' +'80'+ '\"' 
								+' decimalPrecision='+ '\"' + '0'+ '\"' 
								+' showAlternateHGridColor='+ '\"' +'1' + '\"' 
								+' AlternateHGridAlpha='+ '\"' +'10' + '\"' 
								+' AlternateHGridColor='+ '\"' +'CCCCCC' + '\"' 
								+' caption='+'\"' + caption + '\"' +' subcaption='+'\"\"'+'>';
								
			graphTag = graphTag + getCategoriesTag('Arial' , '11' , '000000' , xAxisDataList);
			graphTag = graphTag + getDataSetTag(yAxisDataList,new String[]{'D64646','D646FF','D6FF46'},'100');						
			graphTag = graphTag + '</graph>';
			return graphTag;
	}
	
	
	
	private static String getCategoriesTag(String font,String fontSize,String fontColor,List<String> xAxisDataList) {
		String categoriesTag;
		
		categoriesTag = '<categories font='+ '\"' + font + '\"' 
								+ ' fontSize='+ '\"' + fontSize+ '\"' 
								+ ' fontColor='+ '\"' +'000000' + '\"' 
								+'>';
		for(String xAxisData : xAxisDataList){
			categoriesTag = categoriesTag + getCategoryTag(xAxisData,xAxisData);
		}	
		return categoriesTag + '</categories>';
	}
	
	private static String getCategoryTag(String name,String hoverText){
		return '<category name='+ '\"' + name+ '\"' +' hoverText='+ '\"' + name+ '\"' + '/>';
	}
	
	private static String getSetTag(String yAxisValue,String color){
		return '<set value='+ '\"' + yAxisValue + '\"' + ' color=' + '\"' + color + '\"' +' />';
	}	
	private static String getDataSetTag(List<String> yAxisDataList,List<String> colorList,String alpha){
		String dataSetTag;
		
		//dataSetTag = '<dataset color='+ '\"' + color + '\"'
		dataSetTag = '<dataset ' +' alpha=' + '\"' + alpha + '\"' +'>';        
		for(Integer i=0;i<yAxisDataList.size();i++){
			dataSetTag = dataSetTag + getSetTag(yAxisDataList.get(i),colorList.get(i));
		}	
		return dataSetTag + '</dataset>';				
	}
		
}