global class SchedulerBatchRenewPurchasedBaseProduct implements Schedulable
{
     global void execute(SchedulableContext SC) 
     {
        BatchRenewPurchasedBaseProduct obj = new BatchRenewPurchasedBaseProduct();
        Database.executeBatch(obj);
     }
}