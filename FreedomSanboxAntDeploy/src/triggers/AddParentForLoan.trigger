trigger AddParentForLoan on Loan__c (before insert, before update) 
{
    HandlerForParentOfLoan objLoan = new HandlerForParentOfLoan();
    if(trigger.isInsert)
    {
       objLoan.beforeLoanInsert(trigger.new);
       
    }
    if(Trigger.isUpdate)
    {
         objLoan.beforeUpdateLoan(trigger.new,trigger.old);
    }
}