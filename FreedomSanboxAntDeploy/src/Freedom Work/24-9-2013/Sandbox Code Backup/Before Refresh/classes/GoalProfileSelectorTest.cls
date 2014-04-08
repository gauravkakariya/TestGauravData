@isTest
private class GoalProfileSelectorTest
{
	static GoalProfileSelector gpsector;
 	static Account acc;
 	static Goal_Profile__c goalProfile2;
  	static Goal_Profile__c goalProfile7;
    static Goal_Profile__c goalProfile8;
	static Goal_Profile__c goalProfile9;
	static Goal_Profile__c goalProfile10;

 	static Goal_Profile__c goalProfileAggressive;
  	static Goal_Profile__c goalProfileModAggressive;
    static Goal_Profile__c goalProfileModerate;
	static Goal_Profile__c goalProfileModeratelyConservative;
	static Goal_Profile__c goalProfileConservative;
	static Map<String,Goal_Profile__c> goalProfileMap = new Map<String,Goal_Profile__c>();
	
	static  Goal__c gol;
	
	public static void testData()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
    	acc = testData.initializeAccount();
       	upsert acc;
       	System.assertNotEquals(null,acc);
       	
  		
  		goalProfile2 = testData.initialize_GoalProfile(acc,'Aggressive', 'Customized');
       	insert goalProfile2;
       	System.assertNotEquals(null,goalProfile2.id);
		
		goalProfile7 = testData.initialize_GoalProfile(acc,'Moderately Aggressive', 'Customized');
		insert goalProfile7;				
		System.assertNotEquals(null,goalProfile7.id);
		
		goalProfile8 = testData.initialize_GoalProfile(acc,'Moderate', 'Customized');
		insert goalProfile8;
		System.assertNotEquals(null,goalProfile8.id);
		
		goalProfile9 = testData.initialize_GoalProfile(acc,'Moderately Conservative', 'Customized');
		insert goalProfile9;
		system.assertNotEquals(null,goalProfile9.id);
		
		goalProfile10 = testData.initialize_GoalProfile(acc,'Conservative', 'Customized');
		insert goalProfile10;
		System.assertNotEquals(null,goalProfile10.id);
		
		gol = testData.initialize_Goal(acc, 'Marriage', goalProfile2);
		insert gol;
		System.assertNotEquals(null,gol.id);
		
		goalProfileAggressive = testData.initialize_GoalProfile(acc,'Aggressive', 'Standard');
		insert goalProfileAggressive;
       	System.assertNotEquals(null,goalProfileAggressive.id);
		
		goalProfileModAggressive = testData.initialize_GoalProfile(acc,'Moderately Aggressive', 'Standard');
		insert goalProfileModAggressive;				
		System.assertNotEquals(null,goalProfileModAggressive.id);
		
		goalProfileModerate = testData.initialize_GoalProfile(acc,'Moderate', 'Standard');
		insert goalProfileModerate;
		System.assertNotEquals(null,goalProfileModerate.id);
		
		goalProfileModeratelyConservative = testData.initialize_GoalProfile(acc,'Moderately Conservative', 'Standard');
		insert goalProfileModeratelyConservative;
		System.assertNotEquals(null,goalProfileModeratelyConservative.id);
		
		goalProfileConservative = testData.initialize_GoalProfile(acc,'Conservative', 'Standard');
		insert goalProfileConservative;
		System.assertNotEquals(null,goalProfileConservative.id);
		
		goalProfileMap.put('Aggressive' + ' (Customized)', goalProfile2);
		goalProfileMap.put('Moderately Aggressive' + ' (Customized)', goalProfile7);
		goalProfileMap.put('Moderate' + ' (Customized)', goalProfile8);
		goalProfileMap.put('Moderately Conservative' + ' (Customized)', goalProfile9);
		goalProfileMap.put('Conservative' + ' (Customized)', goalProfile10);
				
		goalProfileMap.put('Aggressive', goalProfileAggressive);
		goalProfileMap.put('Moderately Aggressive' , goalProfileModAggressive);
		goalProfileMap.put('Moderate' , goalProfileModerate);
		goalProfileMap.put('Moderately Conservative' , goalProfileModeratelyConservative);
		goalProfileMap.put('Conservative', goalProfileConservative);
				
		gpsector=new GoalProfileSelector();
	}
	
	public static testMethod void getDefaultProfileYearstTest(){
		test.startTest();
   
		GoalProfileSelector.getDefaultProfileYears('Aggressive',3);
    	GoalProfileSelector.getDefaultProfileYears('Aggressive',1);
    	GoalProfileSelector.getDefaultProfileYears('Moderately Aggressive',3);
     	GoalProfileSelector.getDefaultProfileYears('Moderately Aggressive',1);
     	GoalProfileSelector.getDefaultProfileYears('Moderate',1);
     	GoalProfileSelector.getDefaultProfileYears('Moderate',3);
     	GoalProfileSelector.getDefaultProfileYears('Moderately Conservative',3);
     	GoalProfileSelector.getDefaultProfileYears('Moderately Conservative',2);
     	GoalProfileSelector.getDefaultProfileYears(' Conservative',3);
     	GoalProfileSelector.getDefaultProfileYears(' Conservative',2);
     	test.stopTest();
  	}
	public static testMethod void getDefaultProfileYearstTest1(){
		test.startTest();
		testData();
		Goal_Profile__C currentGoalProfileStandard,currentGoalProfile;
		
		currentGoalProfile = goalProfile2;
		currentGoalProfileStandard = goalProfileAggressive;
		for(Integer currentYear = 2011;currentYear<= 2021; currentYear++ ) {
			System.debug(GoalProfileSelector.getCurrentGoalProfileForRateCalculation(currentGoalProfile,currentYear,2021));
			System.debug(GoalProfileSelector.getCurrentGoalProfileForRateCalculation(currentGoalProfileStandard,currentYear,2021));			
     	}
     	//GoalProfileSelector.getCurrentGoalProfileForRateCalculation(goalProfile2,2011,2020);
     	//GoalProfileSelector.getCurrentGoalProfileForRateCalculation(goalProfile2,2011,2018);
     	//GoalProfileSelector.getCurrentGoalProfileForRateCalculation(goalProfile2,2011,2016);
     	//GoalProfileSelector.getCurrentGoalProfileForRateCalculation(goalProfile2,2011,2013);
     	
		currentGoalProfile = goalProfile7;
		currentGoalProfileStandard = goalProfileModAggressive;		     	
		for(Integer currentYear = 2011;currentYear<= 2021; currentYear++){
			currentGoalProfile = goalProfileMap.get( GoalProfileSelector.getCurrentGoalProfileForRateCalculation(currentGoalProfile,currentYear,2021));
			currentGoalProfileStandard = goalProfileMap.get( GoalProfileSelector.getCurrentGoalProfileForRateCalculation(currentGoalProfileStandard,currentYear,2021));
     	}
        
		//GoalProfileSelector.getCurrentGoalProfileForRateCalculation(goalProfile7,2011,2018);
  		//GoalProfileSelector.getCurrentGoalProfileForRateCalculation(goalProfile7,2011,2016);
   		//GoalProfileSelector.getCurrentGoalProfileForRateCalculation(goalProfile7,2011,2013);
		currentGoalProfile = goalProfile8;
		currentGoalProfileStandard = goalProfileModerate;		     	
		     
    	for(Integer currentYear = 2011;currentYear<= 2021; currentYear++){
			currentGoalProfile = goalProfileMap.get( GoalProfileSelector.getCurrentGoalProfileForRateCalculation(currentGoalProfile,currentYear,2021));
			currentGoalProfileStandard = goalProfileMap.get(GoalProfileSelector.getCurrentGoalProfileForRateCalculation(currentGoalProfileStandard,currentYear,2021));
    	}
		//GoalProfileSelector.getCurrentGoalProfileForRateCalculation(goalProfile8,2011,2016);
 		//GoalProfileSelector.getCurrentGoalProfileForRateCalculation(goalProfile8,2011,2013);
		currentGoalProfile = goalProfile9;
		currentGoalProfileStandard = goalProfileModeratelyConservative;		     	
		     
    	for(Integer currentYear = 2011;currentYear<= 2021; currentYear++) {
			currentGoalProfile = goalProfileMap.get( GoalProfileSelector.getCurrentGoalProfileForRateCalculation(currentGoalProfile,currentYear,2021));
			currentGoalProfileStandard = goalProfileMap.get(GoalProfileSelector.getCurrentGoalProfileForRateCalculation(currentGoalProfileStandard,currentYear,2021));
    	}
     	currentGoalProfile = goalProfile10;
		currentGoalProfileStandard = goalProfileConservative;		     	     	
     	for(Integer currentYear = 2011;currentYear<= 2021; currentYear++) {	
			currentGoalProfile = goalProfileMap.get( GoalProfileSelector.getCurrentGoalProfileForRateCalculation(currentGoalProfile,currentYear,2021));
			currentGoalProfileStandard = goalProfileMap.get(GoalProfileSelector.getCurrentGoalProfileForRateCalculation(currentGoalProfileStandard,currentYear,2021));
     	}
      	test.stopTest();
     }
     
	public static testMethod void getCurrentGoalProfileTest1(){
		Goal_Profile__C currentGoalProfileStandard,currentGoalProfile;
		test.startTest();
     	testData();
     	
		currentGoalProfile = goalProfile2;
		currentGoalProfileStandard = goalProfileAggressive;
     	
     	for(Integer currentYear = 2021;currentYear>= System.today().year(); currentYear--) {
			GoalProfileSelector.getCurrentGoalProfile(gol,currentGoalProfile,System.today().year(),currentYear);
			GoalProfileSelector.getCurrentGoalProfile(gol,currentGoalProfileStandard,System.today().year(),currentYear);
     	}
     	
		currentGoalProfile = goalProfile7;
		currentGoalProfileStandard = goalProfileModAggressive;		     	
     	     	     	
     	for(Integer currentYear =2021;currentYear>= System.today().year(); currentYear--) {
			GoalProfileSelector.getCurrentGoalProfile(gol,currentGoalProfile,System.today().year(),currentYear);
			GoalProfileSelector.getCurrentGoalProfile(gol,currentGoalProfileStandard,System.today().year(),currentYear);
     	}

		currentGoalProfile = goalProfile8;
		currentGoalProfileStandard = goalProfileModerate;		     	     	
		for(Integer currentYear = 2021;currentYear>= System.today().year(); currentYear--) {
			GoalProfileSelector.getCurrentGoalProfile(gol,currentGoalProfile,System.today().year(),currentYear);
			GoalProfileSelector.getCurrentGoalProfile(gol,currentGoalProfileStandard,System.today().year(),currentYear);
     	}     
     	//GoalProfileSelector.getCurrentGoalProfile(gol,goalProfile8,2011,2016);
     	currentGoalProfile = goalProfile9;
		currentGoalProfileStandard = goalProfileModeratelyConservative;		     	     	
     	for(Integer currentYear = 2021;currentYear>= System.today().year(); currentYear--) {
			GoalProfileSelector.getCurrentGoalProfile(gol,currentGoalProfile,System.today().year(),currentYear);
			GoalProfileSelector.getCurrentGoalProfile(gol,currentGoalProfileStandard,System.today().year(),currentYear);
     	}
		
		currentGoalProfile = goalProfile10;
		currentGoalProfileStandard = goalProfileConservative;		     	     	     	
     	for(Integer currentYear = 2021;currentYear>= System.today().year(); currentYear--) {
			GoalProfileSelector.getCurrentGoalProfile(gol,currentGoalProfile,System.today().year(),currentYear);
			GoalProfileSelector.getCurrentGoalProfile(gol,currentGoalProfileStandard,System.today().year(),currentYear);
     	}
      	test.stopTest();          
     }
}