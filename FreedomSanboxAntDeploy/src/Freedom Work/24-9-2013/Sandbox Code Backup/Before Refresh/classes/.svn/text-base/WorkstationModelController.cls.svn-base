public with sharing class WorkstationModelController
{
	public WorkstationModelController()
	{
	}
	
	public void Init(){}
	
	public Pagereference CreateWorkstation(){
		Pagereference pgRef=null;
		pgRef = new Pagereference('/apex/createworkstation');
		pgRef.setRedirect(true);
		return pgRef; 
		
	}
	
	public Pagereference ViewWorkstation(){
		Pagereference pgRef=null;
		pgRef = new Pagereference('/apex/ViewAllWorkstations');
		pgRef.setRedirect(true);
		return pgRef;
	}
	
	
	public Pagereference Close()
	{
		Pagereference pgRef=null;
		pgRef = new Pagereference('/apex/WorkstationModel');
		pgRef.setRedirect(true);
		return pgRef ; 
	}
}