/*
    Revision History:
    Version     Version Author    Date              Comments
    1.0         Prajakta Sanap   28/11/2013   1. Handler for ProductDefaultAllocationTrigger to check 
    											 When Default Product Allocation record is inserted for each Partner, 
    											 sequence will be inserted upto 3 records.
                                 
*/

public class ProductDefaultAllocationHandler 
{
	/* Function to check for duplicate allocation to same partner/Biz Unit the same product with asset class and investment type*/
	public void DupeCheckforSequence(List<Product_Default_Allocation__c> newList)
	{
		//try
		//{
			for(Product_Default_Allocation__c objPDA : newList)
			{
				if(objPDA.Partner__c != null)
				{
					objPDA.SequenceUniqueKey__c = objPDA.Partner__c 
												//+ ' ' + objPDA.Product__c 
												+ ' ' + objPDA.Asset_Class__c 
												+ ' ' + objPDA.Investment_Type__c 
												+ ' ' + objPDA.Sequence_No__c;
					system.debug('-------objPDA.SequenceUniqueKey__c----------'+objPDA.SequenceUniqueKey__c);
				}
				else if(objPDA.Business_Unit__c != null)
				{
					objPDA.SequenceUniqueKey__c = objPDA.Business_Unit__c 
												//+ ' ' + objPDA.Product__c
												+ ' ' + objPDA.RecordTypeId /* Prajakta 0 30-12-2013 - To differentiate between Business Unit/Basket products */
												+ ' ' + objPDA.Asset_Class__c 
												+ ' ' + objPDA.Investment_Type__c 
												+ ' ' + objPDA.Sequence_No__c;
					system.debug('-------objPDA.Business_Unit__c------'+objPDA.SequenceUniqueKey__c);
				}
			}
		//}
		//catch(Exception e)
		//{
			//if(e.getTypeName().contains('Duplicate value on record'))
    	//		e.setMessage('Duplicate value on record with same Sequence for same Partner.');
    		//throw new CustomException(e.getMessage());
		//}
	}
	
	/* Function to check for duplicate allocation to same partner/Biz Unit the same product with asset class and investment type*/
	public void DupeCheckofProductForSamePartner(List<Product_Default_Allocation__c> newList)
	{
		for(Product_Default_Allocation__c objPDA : newList)
		{
			if(objPDA.Partner__c != null)
			{
				objPDA.CustomUniqueKey__c = objPDA.Partner__c 
											+ ' ' + objPDA.Product__c 
											+ ' ' + objPDA.Asset_Class__c 
											+ ' ' + objPDA.Investment_Type__c;
				//objPDA.addError('Duplicate record.');							
				system.debug('-------CustomUniqueKey__c-----a-----'+objPDA.CustomUniqueKey__c);
			}
			else if(objPDA.Business_Unit__c != null)
			{
				objPDA.CustomUniqueKey__c = objPDA.Business_Unit__c 
											+ ' ' + objPDA.Product__c
											+ ' ' + objPDA.RecordTypeId /* Prajakta 0 30-12-2013 - To differentiate between Business Unit/Basket products */
											+ ' ' + objPDA.Asset_Class__c 
											+ ' ' + objPDA.Investment_Type__c;
				system.debug('-------Business_Unit__c---a---'+objPDA.CustomUniqueKey__c);
			}
		}
	}
	
	/*
	//Check if For that Partner, 3 different products are entered with different sequence no.
	public void checkSequence(List<Product_Default_Allocation__c>NewList)//, map<Id, Product_Default_Allocation__c> oldMap) //List<Product_Default_Allocation__c>oldList
    {
    	set<Id> setOfPartner = new set<Id>();
    	set<Id> setOfProducts = new set<Id>();
    	set<Id> setOfAssetClass = new set<Id>();
    	set<Id> setOfInvType = new set<Id>();
    	set<Id> setOfBizUnit = new set<Id>();
    	map<String, List<Product_Default_Allocation__c>> mapPartnerIdTolstPDA = new map<String, List<Product_Default_Allocation__c>>();
    	List<Product_Default_Allocation__c> lstDefault = new List<Product_Default_Allocation__c>();
    	
    	for(Product_Default_Allocation__c objPDA : NewList)
    	{
    		//if(oldMap != null && objPDA.Sequence_No__c != oldMap.get(objPDA.Id).Sequence_No__c)
    		{
    			setOfPartner.add(objPDA.Partner__c);
    			setOfProducts.add(objPDA.Product__c);
    			setOfAssetClass.add(objPDA.Asset_Class__c);
    			setOfInvType.add(objPDA.Investment_Type__c);
    			setOfBizUnit.add(objPDA.Business_Unit__c);
    		}
    	}
    	system.debug('-------setOfPartner ------'+setOfPartner);
    	system.debug('-------setOfAssetClass ------'+setOfAssetClass);
    	system.debug('-------setOfInvType ------'+setOfInvType);
    	system.debug('-------setOfProducts ------'+setOfProducts);
    	
    	if(setOfPartner.size() != null)
    	{
    		List<Product_Default_Allocation__c> lstPDA = [Select Sequence_No__c, Product__c, Partner__c, Name, Investment_Type__c, 
    													  Id, Business_Unit__c, Asset_Class__c 
    													  From Product_Default_Allocation__c
    													  where Partner__c != null
    													  and Partner__c IN: setOfPartner];
    		system.debug('-------lstPDA------'+lstPDA);
    		
    		for(Product_Default_Allocation__c objPDA : lstPDA)
	    	{
	    		String strKey = objPDA.Partner__c + objPDA.Sequence_No__c;
	    		List<Product_Default_Allocation__c> lstAllocation = new List<Product_Default_Allocation__c>();
	    		if(mapPartnerIdTolstPDA.containsKey(strKey))
	    		{
	    			lstAllocation = mapPartnerIdTolstPDA.get(strKey);
	    			lstAllocation.add(objPDA);	
	    		}
	    		else
	    		{
	    			lstAllocation.add(objPDA);
	    		}
	    		mapPartnerIdTolstPDA.put(strKey, lstAllocation);
	    	}
	    	system.debug('-------mapPartnerIdTolstPDA------'+mapPartnerIdTolstPDA);
	    	
	    	for(Product_Default_Allocation__c objPDA : NewList)
	    	{
	    		String strKey = objPDA.Partner__c + objPDA.Sequence_No__c;
	    		
	    		if(mapPartnerIdTolstPDA.containsKey(strKey))
	    		{
	    			lstDefault.add(objPDA);
	    			system.debug('-------lstDefault------'+lstDefault);
	    		}
	    		else
	    		{
	    			objPDA.Sequence_No__c.addError('Ha ha ha... Error.');
	    		}
	    	}
    	}
    }*/
}