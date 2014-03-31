/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AccountLookupCustomControllerTest {

    static testMethod void AccountLookupCustomControllerUnitTest() {
       
       AccountLookUpCustomController objAccount = new AccountLookUpCustomController();
       objAccount.search();
       objAccount.getFormTag();
       objAccount.getTextBox();
    }
}