/**
@Description controller class for ProfilerQuestionPage
*/
public class ProfilerQuestionPageController
{
    public profilerQuestionBean questionBean{get;set;}
    public ProfilerQuestionService questionService{get;set;}
    public FamilyMemberInfoBean fmBean{get;set;}
    public FamilyMemberInfoService fmInfoService{get;set;}
 	//Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
	
    /**
    @description constructor 
    
    */
    public ProfilerQuestionPageController()
    {
    	//Code Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   		isDisplaySaveButton = true;
       	questionBean=new profilerQuestionBean ();
       	questionService= new ProfilerQuestionService ();
       	questionBean.questionInstanceList=new  list<profilerQuestionBean.ProfileQuestionWrpper>();
       	questionBean.currentEntity=System.currentPageReference().getParameters().get('EntityId');
       	fmBean=new FamilyMemberInfoBean();
       	fmInfoService=new FamilyMemberInfoService();
       	fmInfoService.isCostomerProfile(fmBean);
       	questionService.initQuestionList(questionBean);
       	
       	//Added Code on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
        User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
        if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
        {
        	isDisplaySaveButton = false;
        }
    }
    
    /**
    This method is used to save the answers of an entity in EntityProfilerQuestion object
    and navigates  to the profilerOutputPage in salesforce
    */
    public PageReference save()
    {
        questionService.save(questionBean);
       	PageReference pr;
        if(fmBean.isCustomer)
        {
            pr=null;
        }
        else
        {
        	pr =new PageReference('/apex/ProfilerOutputPage?entityId='+questionBean.currentEntity+'&tabname=Financial Planning');
        }
        return pr;
    }
    
    public void cancel()
    {
       questionService.resetAnswer(questionBean);
    }
    

    
}