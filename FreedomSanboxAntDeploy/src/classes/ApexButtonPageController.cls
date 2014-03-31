public class ApexButtonPageController {
    Account theAccount;

    public ApexButtonPageController(ApexPages.StandardController stdController) {
        // get the current Account
        theAccount = (Account)stdController.getRecord();
    }

    public PageReference doMyApexLogic() {
        //whatever logic you want
        //<demo logic>
        theAccount.Industry = 'Spice Trading';
        update theAccount;
        //</demo logic>
        return new PageReference('/' + theAccount.id);
    }
}