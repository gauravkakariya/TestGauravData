public with sharing class Financial_Wellness_Report
{
	public Double wellnessScore{get;set;}
	public Boolean check{get;set;}
	public String scoreData{get;set;}
	public String testDBLScore{set;get;}  
	public String wellnessName{get;set;}
	public String test{get;set;}
	public String name{get;set;}
	public String ageData{get;set;}
	public String ageInfo{get;set;}
	public String incomeSource{get;set;}
	
	
	public Financial_Wellness_Report()
	{
		test = ApexPages.currentPage().getParameters().get('value'); 
		name = ApexPages.currentPage().getParameters().get('name'); 
	}
 
	public pageReference verifyScore()
	{
		Double a = Double.valueOf(test);
		system.debug('***a : '+a);
		Financial_Wellness__c objWellness = [Select Name__c, Email_Id__c,Income_Source__c,Age_Range__c From Financial_Wellness__c where Wellness_Score__c =: a  and Name__c =:name Limit 1];
        system.debug('***objWellness : '+objWellness);
        
        system.debug('***wellnessScore : '+wellnessScore);
        
        if(a <10){
        	check = true;
        	scoreData =  objWellness.Name__c+', wake up….wake up now! You scored less than 10 on the wellness test. The inevitable future is staring at you and YOU are behaving like an ostrich who buries its head under the ground in the face of danger, refusing to act. You are not going to be this young ever again. One year from now would you be wiser, better, wealthier, smarter, closer to your dreams or just older? All your friends and colleagues who chose to take control would have moved on far ahead while you will keep wondering what went wrong.Speak to somebody who can help you put your financial life in order - a knowledgeable well wisher or a professional financial advisor, right away. Do a reality check in your life. When you can see what is to come, you will prepare better. That way you will enjoy the journey without a worry in your mind';
        }
        else if(a >=10 && a <20){
        	check = true;
        	scoreData = objWellness.Name__c+',  you know it yourself don’t you? You are concerned about your finances and worry about what might happen if things don’t go your way. The good thing is that you are pragmatic and realistic and view things as they are. If you have the courage to see the truth, you probably also have the courage to take control of things and set them right. Speak to somebody who may help, like a knowledgeable well wisher or a professional financial advisor and then decide your future course of action. And when you put your financial life in order you will see your stress levels reduce. Research has proven that lower stress will result in marked improvements in health, career, relationships etc';
        }
        else if(a >=20 && a <30){
        	check = true;
        	scoreData = objWellness.Name__c+',  you know it yourself don’t you? You are concerned about your finances and worry about what might happen if things don’t go your way. The good thing is that you are pragmatic and realistic and view things as they are. If you have the courage to see the truth, you probably also have the courage to take control of things and set them right. Speak to somebody who may help, like a knowledgeable well wisher or a professional financial advisor and then decide your future course of action. And when you put your financial life in order you will see your stress levels reduce. Research has proven that lower stress will result in marked improvements in health, career, relationships etc';
        }
        else if(a >=30){
        	check = true;
        	scoreData = objWellness.Name__c+',  you know it yourself don’t you? You are concerned about your finances and worry about what might happen if things don’t go your way. The good thing is that you are pragmatic and realistic and view things as they are. If you have the courage to see the truth, you probably also have the courage to take control of things and set them right. Speak to somebody who may help, like a knowledgeable well wisher or a professional financial advisor and then decide your future course of action. And when you put your financial life in order you will see your stress levels reduce. Research has proven that lower stress will result in marked improvements in health, career, relationships etc';
        }
        
        ageInfo = objWellness.Name__c +', to earn your financial freedom, you may have to prioritize your focus as given here. This is based on the standard financial life cycle projection of an individual. The standard financial life cycle projection is as explained in the picture below and assumes certain life events happening at certain ages for individuals.But in case you have had special events going your way which were different from the assumptions made in the standard FLC, then don’t go by this – get your customized financial plan done. The top three things you should do are';
        
        if(objWellness.Age_Range__c == '20 - 35'){
        	ageData = objWellness.Name__c + 'age 1';
        }
        else if(objWellness.Age_Range__c == '36 - 50'){
        	ageData = objWellness.Name__c + 'age 2';
        }
        else if(objWellness.Age_Range__c == '> 50'){
        	ageData = objWellness.Name__c + 'age 3';
        }
        
        if(objWellness.Income_Source__c == 'Salaried'){
        	incomeSource = objWellness.Name__c + ' Salaried';
        }
        else if(objWellness.Income_Source__c == 'Business or Professional'){
        	incomeSource = objWellness.Name__c + ' Business or Professional';
        }
        
        return Null;
   }

}