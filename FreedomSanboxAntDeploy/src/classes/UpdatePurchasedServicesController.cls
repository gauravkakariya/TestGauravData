/* 
*   
*  This class used for updating Purchase order record
*
*   Revision History:
*
*   Version			Author             Date          Description
*   1.0             Gaurav Kakariya    05/04/2013 	 Initial Draft
*/
public with sharing class UpdatePurchasedServicesController 
{
	
	public Purchase_Order__c objProductOrder{get;set;}
	public String entityId{get;set;}
	
	public List<WrapperEditPurchaseOrder>  lstWrapperPurchaseOrder{get;set;}
	public Integer valueAddedServiceCount{get;set;}
	public List<Purchase_Order__c> lstPurchaseOrderForTopUp{get;set;}
	public List<Purchase_Order__c> lstPurchaseOrderForValueAddedServices{get;set;}
	
	public List<SelectOption> baseProductOptions{get;set;}
	public List<SelectOption> valueAddedServiceNameOptions{get;set;}
	public List<SelectOption> topUpGoalValueOptions{get;set;}
	
	private Set<String> setValueAddedServiceName;
	private Product_Master__c objProductMaster;
	private Product_Price_Book__c objPriceBook;
	private String currentBaseProductName;
	
	
	//Constructor
	public UpdatePurchasedServicesController()
	{
		objProductOrder = new Purchase_Order__c();
		objPriceBook = new Product_Price_Book__c(Price_value__c = 0, Discount__c = 0);
		objProductMaster = new Product_Master__c(No_of_Goals_Allowed__c = 0);
		
		lstWrapperPurchaseOrder = new List<WrapperEditPurchaseOrder>();
		entityId = ApexPages.currentPage().getParameters().get('entityid');
		
		
		objProductOrder = [Select Id, Name, Service_Tax__c, Product_Type__c, Order__c,Product_Price__c, Product_Master__c, Is_Cancel__c, 
									      	Discount__c,Entity__c,Payable_Amount__c, Selected_Product__c, Product_Master__r.No_of_Goals_Allowed__c,
									      	Renewal_Grace_Days__c, Renewal_Period_In_Days__c, Subscription_Period_In_Days__c, Product_Master__r.IsTopupService__c   
								From Purchase_Order__c 
							    Where Entity__c =: entityId And Is_Cancel__c= false And Product_Type__c = 'Base Product' And Order_status__c = 'New'];
							    
		currentBaseProductName = objProductOrder.Selected_Product__c;
										  		
		//Picklist Value for Base Service Product	
		Integer baseProudctWeightage = Integer.valueOf([Select Base_Product_Weightage__c from Product_Master__c 
 	 										where Product_Name__c =: objProductOrder.Selected_Product__c].Base_Product_Weightage__c);		
		baseProductOptions = new List<SelectOption>();
 	 	for(Product_Master__c objProductMaster : [Select Product_Name__c,ProductType__c From Product_Master__c Where ProductType__c ='Base Product' and 
 	 												Base_Product_Weightage__c >= :baseProudctWeightage
 	 											  	order by Base_Product_Weightage__c])
 	 	{
 	 		baseProductOptions.add(new SelectOption(objProductMaster.Product_Name__c,objProductMaster.Product_Name__c));
 	 	}	
 	 	
 	 	//Get the Value Added Service Record								  
		lstPurchaseOrderForValueAddedServices = [Select Id, Name, Service_Tax__c, Product_Type__c, Product_Price__c, Product_Master__c, Is_Cancel__c, 
									      			 		Discount__c,Entity__c,Payable_Amount__c, Selected_Product__c  
									      				From Purchase_Order__c 
										  				Where Entity__c =: entityId And Is_Cancel__c= false And Product_Type__c = 'Value Added Services'];
		/*
		for(Purchase_Order__c objPO : lstPurchaseOrderForValueAddedServices)
		{
			setValueAddedServiceName.add(objPO.Selected_Product__c);
		}
		valueAddedServiceCount = setValueAddedServiceName.size();
		*/
 	 	
 	 	//Picklist Value for Servie Name in Value Added Service
 	 	valueAddedServiceNameOptions = new List<SelectOption>();
 	 	valueAddedServiceNameOptions.add(new SelectOption('None','--None--'));
 	 	for(Product_Master__c objProductMaster : [Select Product_Name__c, ProductType__c From Product_Master__c Where ProductType__c ='Value Added Services' 
 	 													]) //and Product_Name__c Not IN :setValueAddedServiceName
 	 	{
 	 		valueAddedServiceNameOptions.add(new SelectOption(objProductMaster.Product_Name__c,objProductMaster.Product_Name__c));
 	 	}
 	 	
 	 	
 	 	
	}
	
	//Getting Product Price
	public void baseProductPrice()
	{ 
		String baseProductName = ApexPages.currentPage().getParameters().get('baseproductName'); 
	
		objProductMaster = [Select Product_Name__c, ProductType__c, No_of_Goals_Allowed__c, IsTopupService__c, Renewal_Grace_Days__c, Renewal_Period_In_Days__c, 	
									Subscription_Period_In_Days__c,Goals_Allowed_List__c, Data_Collection_Analysis_Control__c, Financial_Planing_Output_Report__c, 
									(Select Price_value__c, Sp_Education_Cess__c, VAT__c, Education_Cess__c,Service_Tax__c, Discount__c 
									From Product_Price_Books__r)  
								From Product_Master__c  
 	 							Where Product_Name__c =: baseProductName order by Base_Product_Weightage__c];
 	 							
	 	objPriceBook = objProductMaster.Product_Price_Books__r[0];
	 	
	 	objProductOrder.Selected_Product__c =  baseProductName;
	 	objProductOrder.Product_Price__c = objPriceBook.Price_value__c;
	 	objProductOrder.Discount__c = objPriceBook.Discount__c;
	 	objProductOrder.Product_Master__r.No_of_Goals_Allowed__c = objProductMaster.No_of_Goals_Allowed__c;
	 	objProductOrder.Payable_Amount__c = objPriceBook.Price_value__c - objPriceBook.Discount__c;
	 	
	}
	
	//Getting Value Added Service
	public void valueAddedService()
	{
		Integer indexPosition = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
		String strSelectedValueAddedService = lstWrapperPurchaseOrder[indexPosition].selectedServiceName;
		
		//If selected Service Name is other than 'None' then get the product price
 		if(lstWrapperPurchaseOrder[indexPosition].selectedServiceName != 'None')
		{
			lstWrapperPurchaseOrder[indexPosition].productMaster = [Select Product_Name__c, ProductType__c, No_of_Goals_Allowed__c,
																			  (Select Price_value__c, VAT__c, Education_Cess__c,Sp_Education_Cess__c,Discount__c,Service_Tax__c From Product_Price_Books__r) 
																		From Product_Master__c  
									 	 								Where Product_Name__c =:strSelectedValueAddedService And ProductType__c ='Value Added Services'];
		 	 										
		 	lstWrapperPurchaseOrder[indexPosition].productPriceBook = lstWrapperPurchaseOrder[indexPosition].productMaster.Product_Price_Books__r[0];
		 	lstWrapperPurchaseOrder[indexPosition].payableAmount = lstWrapperPurchaseOrder[indexPosition].productPriceBook.Price_value__c - 
	 																lstWrapperPurchaseOrder[indexPosition].productPriceBook.Discount__c;
		}
		else
		{
			lstWrapperPurchaseOrder[indexPosition].productPriceBook = new Product_Price_Book__c(Price_value__c = 0, Discount__c = 0);
			lstWrapperPurchaseOrder[indexPosition].payableAmount = 0;
		}
		
	}	
	
	//To save Value Addded Services
	public void addValueAddedServices()
	{
		Boolean isNone = false;
		for(WrapperEditPurchaseOrder objWPO :  lstWrapperPurchaseOrder)
		{
			if(objWPO.selectedServiceName == 'None')
			{
				isNone = true;
				break;
			}
		}
		
		if(isNone)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Please select Service Name.'));
    		return ;
		}
		Integer index = lstWrapperPurchaseOrder.size() - 1;
		//if(lstWrapperPurchaseOrder.size() > setValueAddedServiceName.size())
		//	lstWrapperPurchaseOrder[index].payableAmount = lstWrapperPurchaseOrder[index].productPriceBook.Price_value__c - lstWrapperPurchaseOrder[index].productPriceBook.Discount__c;
		lstWrapperPurchaseOrder.add(new WrapperEditPurchaseOrder(new Product_Master__c(), new Product_Price_Book__c(Price_value__c = 0, Discount__c = 0) 
										,lstWrapperPurchaseOrder.size()));
	}	
	
		
	/*To save the new entered records*/
	public PageReference saveProduct()
	{	
		List<Purchase_Order__c> lstPurchaseOrder = new List<Purchase_Order__c>();
		
		update objProductOrder;
		system.debug('***objProductOrder'+objProductOrder);
		
		Purchase_Order__c objPurchaseOrder = new Purchase_Order__c();
		
		for(WrapperEditPurchaseOrder objWPO : lstWrapperPurchaseOrder)
		{	
			system.debug('*** objWPO.productMaster.Id'+ objWPO.productMaster.Id);	
			system.debug('*** objWPO.productMaster.ProductType__c'+ objWPO.productMaster.ProductType__c);	
			
			if(objWPO.selectedServiceName != 'None' && objWPO.selectedServiceName != Null)
			{
				objPurchaseOrder =  new Purchase_Order__c(Order__c = objProductOrder.Order__c,
														  Selected_Product__c =  objWPO.selectedServiceName,
														  Entity__c =  entityId,
														  Product_Master__c =  objWPO.productMaster.Id,
														  Product_Type__c = objWPO.productMaster.ProductType__c,
														  Order_Datetime__c = DateTime.now(),
														  Product_Price__c = objWPO.productPriceBook.Price_value__c, 
														  Discount__c = objWPO.productPriceBook.Discount__c,
														  Order_status__c = 'New', 
														  Payable_Amount__c = objWPO.productPriceBook.Price_value__c - objWPO.productPriceBook.Discount__c,
														  Service_Tax__c = objWPO.productPriceBook.Service_Tax__c, 
														  Sp_Education_Cess__c = objWPO.productPriceBook.Sp_Education_Cess__c, 
														  VAT__c = objWPO.productPriceBook.VAT__c, 
														  Education_Cess__c = objWPO.productPriceBook.Education_Cess__c,
														  Is_Cancel__c = false);
					
				lstPurchaseOrder.add(objPurchaseOrder);
			}
		}
		
		insert lstPurchaseOrder;
		
		
		//Redirect to Entity Detial page.
		PageReference pr = new PageReference('/' + entityId);
		return pr;
		
	}
	
	//Wrapper Class for Purchase Order
	public class WrapperEditPurchaseOrder
	{
		public Product_Master__c productMaster{get;set;}
		public Product_Price_Book__c productPriceBook{get;set;}
		public Purchase_Order__c objPurchaseOrder{get;set;}
		public Double payableAmount {get;set;}
		public String selectedServiceName{get;set;}
		public Integer index {get;set;}
		public Boolean isValueAddedService {get;set;}
		 
		public  WrapperEditPurchaseOrder(){}
		
		public WrapperEditPurchaseOrder(Product_Master__c pProductMaster, Product_Price_Book__c pProductPriceBook ,Integer pIndex)
		{  
			isValueAddedService = false;
			productMaster = pProductMaster;
			productPriceBook = pProductPriceBook;
			productMaster = pProductMaster; 
			
			payableAmount = productPriceBook.Price_value__c - productPriceBook.Discount__c;
			this.index = pIndex;
		}
	}//end of WrapperEditPurchaseOrder
	
}//end of UpdatePurchasedServicesController class