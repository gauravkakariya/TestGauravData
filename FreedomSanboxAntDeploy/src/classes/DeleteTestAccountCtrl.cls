public class DeleteTestAccountCtrl {
    public Account acc{get; set;}
    public Contact c {get; set;}
    public Account getAcc() {
        if(acc== null) {
            RecordType recType = [select id,name,sobjectType,ispersontype from recordType where ispersontype=true and sobjectType='account' limit 1];            
           // student = new Account(recordtypeid=recType.id); 
            acc= new Account(); 
        }
        return acc;
    }
    public DeleteTestAccountCtrl(ApexPages.StandardController controller) {

    }

}