/*
	Revision History:
    Version     Version Author    Date          Comments
	1.0			Prajakta Sanap	 27/12/2013   1. Handler to update Product Default allocation records on change of Products.
	
*/


public class ProductHandler 
{
	/* Function to update Product Default allocation records on change of Products Name, Asset Class and Investment Type. */
	public void updateProductDefaultAllocation(List<Product_Master__c> newList, map<Id, Product_Master__c> oldMap)
	{
		set<Id> setOdProductId = new set<Id>();
		List<Product_Default_Allocation__c> lstUpdatePDallocation = new List<Product_Default_Allocation__c>(); 
		List<Product_Master__c> lstProduct = new List<Product_Master__c>();
		
		for(Product_Master__c objProduct : newList)
		{
			Product_Master__c oldProduct = oldMap.get(objProduct.Id);
			if(objProduct.Asset_Class__c != oldProduct.Asset_Class__c
				|| objProduct.Investment_Type__c != oldProduct.Investment_Type__c
				|| objProduct.Product_Name__c != oldProduct.Product_Name__c)	
			{
				setOdProductId.add(objProduct.Id);
				lstProduct.add(objProduct);
			}
		}
		system.debug('-----setOdProductId--------'+setOdProductId.size() +' - '+setOdProductId);
		
		if(setOdProductId.size() > 0)
		{
			List<Product_Default_Allocation__c> lstPDA = [Select Sequence_No__c, Product__c, Partner__c, Name, Investment_Type__c, 
    													  Id, Business_Unit__c, Asset_Class__c 
    													  From Product_Default_Allocation__c
    													  where Product__c IN: setOdProductId];
			system.debug('-----lstPDA--------'+lstPDA);
			
			map<Id,List<Product_Default_Allocation__c>> mapIdToPDAllocation = new map<Id,List<Product_Default_Allocation__c>>();   
            for(Product_Default_Allocation__c obj : lstPDA)
            {
                if(mapIdToPDAllocation.containsKey(obj.Product__c))
                {
                    mapIdToPDAllocation.get(obj.Product__c).add(obj);
                }
                else
                {
                    List<Product_Default_Allocation__c> lstProdDA = new List<Product_Default_Allocation__c>();
                    lstProdDA.add(obj);
                    mapIdToPDAllocation.put(obj.Product__c,lstProdDA);
                }
            }
            system.debug('----mapIdToPDAllocation------'+mapIdToPDAllocation); 
			
            for(Product_Master__c productObj : lstProduct)
            {
                if(mapIdToPDAllocation.containsKey(productObj.Id))
                {
                    List<Product_Default_Allocation__c> lstPDallocation = mapIdToPDAllocation.get(productObj.Id);
                    system.debug('----lstPDallocation------'+lstPDallocation);
                    
                    for(Product_Default_Allocation__c objPDallocation : lstPDallocation)
                    {
                		objPDallocation.Name = productObj.Product_Name__c;
                		objPDallocation.Asset_Class__c = productObj.Asset_Class__c;
                		objPDallocation.Investment_Type__c = productObj.Investment_Type__c;
                		
                		lstUpdatePDallocation.add(objPDallocation);
                		system.debug('----objPDallocation------'+objPDallocation); 
                    }
                }
            }   
            system.debug('----lstUpdatePDallocation------'+lstUpdatePDallocation);     
		}
		try
		{
			if(!lstUpdatePDallocation.isEmpty())
			{
				database.update(lstUpdatePDallocation,true);
			}
		}
		catch(Exception e)
		{
			system.debug('e'+e);
    		lstProduct[0].addError('Duplicate value on Product Default Allocation Record with same Sequence for same Partner/Business Unit.');
		}
	}
}