/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
//By Aditi for testing Platform User Related Code
//Date : 28/08/12 
@isTest
private class Test_CustomLeadXrayDetailsTransfer 
{
	static testMethod void myUnitTest() 
    {
        // TO DO: implement unit test
     
        test.startTest();
        //==========================================PlatformUserXRayDetail=========================================================================
    	List<X_Ray_Score_Card_Detail__c> lstXrayScoreCardDetail = new List<X_Ray_Score_Card_Detail__c>();
    	
    	Lead_Platform_User__c Custlead1 = new Lead_Platform_User__c(First_Name__c = 'Platform', Name = 'User', Lead_Status__c = 'Open', Lead_Source__c = 'Web', Mobile__c = '9898989898', Age__c = 23);
    	insert Custlead1;
    	
    
    	X_Ray_Score_Card_Detail__c ObjXrayScoreCardDetail1 = new X_Ray_Score_Card_Detail__c();
    	ObjXrayScoreCardDetail1.Name = 'TestXray1';
      	ObjXrayScoreCardDetail1.Platform_User_Lead__c = Custlead1.Id;
      	lstXrayScoreCardDetail.add(ObjXrayScoreCardDetail1);
      	
      	
      	X_Ray_Score_Card_Detail__c ObjXrayScoreCardDetail2 = new X_Ray_Score_Card_Detail__c();
    	ObjXrayScoreCardDetail2.Name = 'TestXray2';
      	ObjXrayScoreCardDetail2.Platform_User_Lead__c = Custlead1.Id;
      	lstXrayScoreCardDetail.add(ObjXrayScoreCardDetail2);
      	
      	X_Ray_Score_Card_Detail__c ObjXrayScoreCardDetail3 = new X_Ray_Score_Card_Detail__c();
    	ObjXrayScoreCardDetail3.Name = 'TestXray3';
      	ObjXrayScoreCardDetail3.Platform_User_Lead__c = Custlead1.Id;
      	lstXrayScoreCardDetail.add(ObjXrayScoreCardDetail3);
      	
      	
      	insert lstXrayScoreCardDetail;
      	//===================================================================================================================
   
        //=============================================StandardUserXRayDetail======================================================================
        
        List<X_Ray_Score_Card_Detail__c> lstXrayScoreCardDetail1 = new List<X_Ray_Score_Card_Detail__c>();
    	
    	list<Lead> Leadlst = new list<Lead>();
    	Lead Lead_1 = new Lead(FirstName = 'Original', LastName = 'Lead',Status = 'Open',LeadSource = 'Web', MobilePhone = '9898989898',Platform_User_Lead__c = Custlead1.Id,  Age__c = 23);
    	insert Lead_1;
    	
    	X_Ray_Score_Card_Detail__c ObjXrayScoreCardDetail4 = new X_Ray_Score_Card_Detail__c();
    	ObjXrayScoreCardDetail4.Name = 'TestXray1';
      	ObjXrayScoreCardDetail4.Lead__c = Lead_1.Id;
      	lstXrayScoreCardDetail1.add(ObjXrayScoreCardDetail4);
      	
      	
      	X_Ray_Score_Card_Detail__c ObjXrayScoreCardDetail5 = new X_Ray_Score_Card_Detail__c();
    	ObjXrayScoreCardDetail5.Name = 'TestXray2';
      	ObjXrayScoreCardDetail5.Lead__c = Lead_1.Id;
      	lstXrayScoreCardDetail1.add(ObjXrayScoreCardDetail5);
      	
      	X_Ray_Score_Card_Detail__c ObjXrayScoreCardDetail6 = new X_Ray_Score_Card_Detail__c();
    	ObjXrayScoreCardDetail6.Name = 'TestXray3';
      	ObjXrayScoreCardDetail6.Lead__c = Lead_1.Id;
      	lstXrayScoreCardDetail1.add(ObjXrayScoreCardDetail6);
      	
      	
      	insert lstXrayScoreCardDetail1;
    	//===================================================================================================================
       	test.stopTest();
    }
}