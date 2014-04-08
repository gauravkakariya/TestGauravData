public with sharing class AdvisorOfficeHomeController 
{
	
	public string name{set;get;}
	public string remark{set;get;}
	public string mobile{set;get;}
	public string email{set;get;}
		
	public pageReference pgReference = null;
	
	public Boolean displayPopUp{get;set;}
	public Boolean displayPopUpContactUs{get;set;}
	public Boolean displayPopUpAboutUs{get;set;}
	public Boolean displayPopUpLogin{get;set;}
	
	public AdvisorOfficeHomeController()
	{
		displayPopUp = false;
		displayPopUpContactUs = false;
		displayPopUpAboutUs = false;
		displayPopUpLogin = false;
	}
	public void showPopUpLogin()
	{
		displayPopUpLogin = true;
		displayPopUpAboutUs = false;
		displayPopUpContactUs = false;
	}
	public void showPopUpAboutUs()
	{
		displayPopUpAboutUs = true;
		displayPopUpLogin = false;
		displayPopUpContactUs = false;
	}
	public void showPopUpContactUs()
	{
		displayPopUpContactUs = true;
		displayPopUpLogin = false;
		displayPopUpAboutUs = false;
	}
	public void showPopUp()
	{
		displayPopUp = true;
	}
	public void closePopUp()
	{
		displayPopUp = false;
		displayPopUpContactUs = false;
		displayPopUpAboutUs = false;
		displayPopUpLogin = false;
	}
	
	public PageReference getPageReference()
	{
		pgReference = page.AdvisorOffice;
		pgReference.setRedirect(true);
		return pgReference;
	}
	
	public pagereference cancel()
	{
		return(getPageReference());
	}
	
	public pageReference send()
	{
		if(name.length()>0 && email != NULL)
		{
			Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
			//mail.setToAddresses(new String[]{'sananta.maharana@ffreedom.in'});//tech@ffreedom.in   //contact@advisoroffice.in
			mail.setToAddresses(new String[]{'aditi.satpute@eternussolutions.com'});//tech@ffreedom.in   //contact@advisoroffice.in
			
			mail.setSubject('This is a contact from Advisor Office site');
			mail.setHtmlBody('<p>Hi Sanjeeva/Prashant</p>' + 'Please be in touch with this contact which comes from the site of Advisor Office. Below are the details - ' + 
			'<p>' + 'Name : ' + name + '</p><p>' + 
					'Email : ' + email + '</p><p>' +
					'Contact No.: ' + mobile + '</p><p>' + 
					'Remark : ' + remark + '</p>');
			
			Messaging.Sendemailresult[] emailResult =  Messaging.sendEmail(new Messaging.Singleemailmessage[] {mail});
		}
		return(getPageReference());
	}
}