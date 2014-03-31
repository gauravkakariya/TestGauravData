/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class LeadLookUpCustomControllerTest {

    static testMethod void leadLookupTest() {
        
       LeadLookupCustomController objLead = new LeadLookupCustomController();
       objLead.search();
       objLead.getFormTag();
       objLead.getTextBox();
        
    }
}