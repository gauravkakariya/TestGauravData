/*
	This class is acting as a Controller to decide Goal profile for Rate Calculation and Profile for SIP calculation.
*/
public class GoalProfileSelector 
{
	// Index 0 has Conservative profile years, 1 has Moderately conservative and so on till moderately aggressive
	private final static Integer[] defaulProfileYears = new Integer[] {1,2,2,2};
	
	public static List<Integer> getDefaultProfileYears (String profileName ,Integer goalYears) 
	{
		Integer listIndexLimit = 0 , allocationYears;
		List<Integer> defaultAllocationYears = new List<Integer>();	
			
		if('Aggressive'.equals(profileName)) {
			listIndexLimit = 4;	
		}else if('Moderately Aggressive'.equals(profileName)) {
			listIndexLimit = 3;
		}else if('Moderate'.equals(profileName)) {
			listIndexLimit = 2;
		}else if('Moderately Conservative'.equals(profileName)) {
			listIndexLimit = 1;
		}else {
			listIndexLimit = 0;
		}
		system.Debug('*****listIndexLimit:'+listIndexLimit);
		system.Debug('*****goalYears:'+goalYears);
		//error.debugLog('listIndexLimit-------------->'+listIndexLimit);
		//error.debugLog('goalYears---------------->>>>>>>'+goalYears);		
		for(Integer i = 0 ; i < listIndexLimit ; i++)
		{			
			if(goalYears >= defaulProfileYears[i]) 
			{
				//error.debugLog('listIndexLimit-------if------->'+listIndexLimit);
				//error.debugLog('goalYears--------if-------->>>>>>>'+goalYears);
				goalYears = goalYears - defaulProfileYears[i]; 
				defaultAllocationYears.add(defaulProfileYears[i]);
				system.Debug('*****goalYears Loop:'+goalYears);
				
			}
			else 
			{
				/*The defaultAllocationYears was not getting filled correctlly so changed the code.
				Added (goalYears != 0) condition before filling it*/
				if(goalYears != 0)
					defaultAllocationYears.add(goalYears);
				goalYears = 0;
				break; 
				/*
				//Original code
				defaultAllocationYears.add(goalYears);
				goalYears = 0;
				break;
				*/
			}	
			system.Debug('*****i:'+i);								  
		}
		
		if(goalYears != 0) {
			defaultAllocationYears.add(goalYears);
		}
		return defaultAllocationYears;			
	}
	
	// This call is to get Goal profile to grow asset progressively
	public static String getCurrentGoalProfileForRateCalculation(Goal_Profile__c currentProfile,Integer currentYear,Integer Goalyear) {
		String currentProfileName = currentProfile.name;
		System.debug(currentProfileName + ' CurrentYear = ' + currentYear + ' , GoalYear = ' + Goalyear);				
		if(currentProfileName.equals('Aggressive')) {
			return (((Goalyear- currentYear)> 7 ) ?  (currentProfile.Goal_Profile_Type__c.contains('Customized') ? currentProfile.name  + ' (Customized)': currentProfile.name) : ((Goalyear- currentYear) > 5 ? (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Moderately Aggressive'  + ' (Customized)': 'Moderately Aggressive') :((Goalyear- currentYear) > 3 ? (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Moderate'  + ' (Customized)': 'Moderate') : ((Goalyear- currentYear) > 1 ?  (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Moderately Conservative'  + ' (Customized)': 'Moderately Conservative') : (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Conservative'  + ' (Customized)': 'Conservative')))));
			/*						
			if((Goalyear- currentYear) > 7) {
				return currentProfileName;
			} else if((Goalyear- currentYear) > 5) {
				return 'Moderately Aggressive';
			} else if ((Goalyear- currentYear) > 3) {
				return 'Moderate';
			}else if((Goalyear- currentYear) >1){
				return 'Moderately Conservative';	
			}else 
				return 'Conservative'; */									
		}else if(currentProfileName.equals('Moderately Aggressive')) {
			return ((Goalyear- currentYear)> 5 ? (currentProfile.Goal_Profile_Type__c.contains('Customized') ? currentProfile.name  + ' (Customized)': currentProfile.name) : ((Goalyear- currentYear)> 3 ? (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Moderate'  + ' (Customized)': 'Moderate') : ((Goalyear- currentYear)> 1 ? (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Moderately Conservative'  + ' (Customized)': 'Moderately Conservative') : (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Conservative'  + ' (Customized)': 'Conservative') )));
			/*
			if((Goalyear- currentYear) > 5) {
				return 'Moderately Aggressive';
			} else if ((Goalyear- currentYear) > 3) {
				return 'Moderate';
			}else if((Goalyear- currentYear) >1) {
				return 'Moderately Conservative';	
			}else { 
				return 'Conservative';
			} */		
		} else if(currentProfileName.equals('Moderate')) {
			return ((Goalyear- currentYear)> 3 ? (currentProfile.Goal_Profile_Type__c.contains('Customized') ? currentProfile.name  + ' (Customized)': currentProfile.name) : ((Goalyear- currentYear)> 1  ? (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Moderately Conservative'  + ' (Customized)': 'Moderately Conservative') : (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Conservative'  + ' (Customized)': 'Conservative')));
			/*
			if ((Goalyear- currentYear) > 3) {
				return 'Moderate';
			}else if((Goalyear- currentYear) >1) {
				return 'Moderately Conservative';	
			}else { 
				return 'Conservative';
			} */		
		} else if(currentProfileName.equals('Moderately Conservative')) {
			return ((Goalyear- currentYear)> 1 ? (currentProfile.Goal_Profile_Type__c.contains('Customized') ? currentProfile.name  + ' (Customized)': currentProfile.name) : (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Conservative'  + ' (Customized)': 'Conservative'));			
			/*if((Goalyear- currentYear) >1) {
				return 'Moderately Conservative';	
			}else { 
				return 'Conservative';
			}*/		
		}else if(currentProfileName.equals('Conservative')) {
			return (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Conservative'  + ' (Customized)': 'Conservative');
		}
		// Execution should not reach here
		return null;		
	}
	/*
		This call is to get Goal Profile for PMT calculation 
	*/	
	public static String getCurrentGoalProfile(Goal__c goalObj,
												Goal_Profile__c currentProfile,Integer currentYear,Integer goalYear) {
		//Decimal allocationYears;
		//String currentProfileName = currentProfile.name;
		if(currentProfile.name.startsWith('Aggressive')){
			/*allocationYears = goalObj.moderately_aggressive_profile_years__c +
								goalObj.moderate_profile_years__c +
								goalObj.moderately_conservative_profile_years__c +
								goalObj.conservative_profile_years__c;*/ 
			return (( (goalYear- currentYear)> 7 ) && (goalObj.aggressive_profile_years__c != 0 )?  (currentProfile.Goal_Profile_Type__c.contains('Customized') ? currentProfile.name  + ' (Customized)': currentProfile.name) : (((goalYear- currentYear)> 5) && (goalObj.moderately_aggressive_profile_years__c != 0) ?  (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Moderately Aggressive'  + ' (Customized)': 'Moderately Aggressive') : (((goalYear- currentYear)> 3) && (goalObj.moderate_profile_years__c != 0) ?  (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Moderate'  + ' (Customized)': 'Moderate') : (((goalYear- currentYear)> 1) && (goalObj.moderately_conservative_profile_years__c != 0) ?  (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Moderately Conservative'  + ' (Customized)': 'Moderately Conservative') : (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Conservative'  + ' (Customized)': 'Conservative')))));
			/*if((Goalyear- currentYear) > allocationYears) {
				return currentProfileName;
			} else {
				if(goalObj.moderately_aggressive_profile_years__c != 0){
					return 'Moderately Aggressive';
				}else if(goalObj.moderate_profile_years__c != 0){
					return 'Moderate';
				}else if(goalObj.moderately_conservative_profile_years__c != 0 ) {
					return 'Moderately Conservative';
				}else if (goalObj.moderately_conservative_profile_years__c != 0 ) {
					return 'Conservative';
				}
			}*/					
		}else if(currentProfile.name.startsWith('Moderately Aggressive')) {
			return (((goalYear- currentYear)> 5)&& (goalObj.moderately_aggressive_profile_years__c != 0 ) ?  (currentProfile.Goal_Profile_Type__c.contains('Customized') ? currentProfile.name  + ' (Customized)': currentProfile.name) : (((goalYear- currentYear)> 3) && (goalObj.moderate_profile_years__c != 0) ? (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Moderate'  + ' (Customized)': 'Moderate') : (((goalYear- currentYear)> 1) && (goalObj.moderately_conservative_profile_years__c != 0) ? (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Moderately Conservative'  + ' (Customized)': 'Moderately Conservative') : (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Conservative'  + ' (Customized)': 'Conservative') )));
			/*allocationYears = goalObj.moderate_profile_years__c +
								goalObj.moderately_conservative_profile_years__c +
								goalObj.conservative_profile_years__c;
			if((Goalyear- currentYear) > allocationYears) {
				return currentProfileName;
			} else {
				if(goalObj.moderate_profile_years__c != 0){
					return 'Moderate';
				}else if(goalObj.moderately_conservative_profile_years__c != 0 ) {
					return 'Moderately Conservative';
				}else if (goalObj.moderately_conservative_profile_years__c != 0 ) {
					return 'Conservative';
				}
			}*/								
		}else if(currentProfile.name.startsWith('Moderate')) {
			return (((Goalyear- currentYear)> 3) && (goalObj.moderate_profile_years__c != 0) ? (currentProfile.Goal_Profile_Type__c.contains('Customized') ? currentProfile.name  + ' (Customized)': currentProfile.name) :	(((goalYear- currentYear)> 1) && (goalObj.moderately_conservative_profile_years__c != 0) ?  (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Moderately Conservative'  + ' (Customized)': 'Moderately Conservative') : (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Conservative'  + ' (Customized)': 'Conservative') ));
						
			/*allocationYears =  goalObj.moderately_conservative_profile_years__c +
								goalObj.conservative_profile_years__c;
			if((Goalyear- currentYear) > allocationYears) {
				return currentProfileName;
			} else {
				if(goalObj.moderately_conservative_profile_years__c != 0 ) {
					return 'Moderately Conservative';
				}else if (goalObj.moderately_conservative_profile_years__c != 0 ) {
					return 'Conservative';
				}
			}*/											
		}else if(currentProfile.name.startsWith('Moderately Conservative')) {
			return (((goalYear- currentYear)> 1) && (goalObj.moderately_conservative_profile_years__c != 0) ? (currentProfile.Goal_Profile_Type__c.contains('Customized') ? currentProfile.name  + ' (Customized)': currentProfile.name) : (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Conservative'  + ' (Customized)': 'Conservative') );
			
			/*allocationYears = goalObj.conservative_profile_years__c;
			if((Goalyear- currentYear) > allocationYears) {
				return currentProfileName;
			} else {
				if (goalObj.moderately_conservative_profile_years__c != 0 ) {
					return 'Conservative';
				}
			}	*/																						
		}else if(currentProfile.name.startsWith('Conservative')) {
			return (currentProfile.Goal_Profile_Type__c.contains('Customized') ? 'Conservative'  + ' (Customized)': 'Conservative');
		}
		// Execution should not reach here
		return null;
	}
}