public class DataEntrySummaryBean 
{
    public Object linkField {get; set;}  
    public List<Double> fieldList {
        get {
            if(fieldList == null) {
                fieldList = new List<Double>();
            }
            return fieldList;
        }
        set;
    }
}