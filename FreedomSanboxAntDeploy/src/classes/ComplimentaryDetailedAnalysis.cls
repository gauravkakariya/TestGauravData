public with sharing class ComplimentaryDetailedAnalysis
{
  //Added for Partner Portal=====================
  public Boolean isFreedomUser{get;set;}
  public Boolean isFreedomUserProp{get;set;}
  //public String Accname{get;set;}  
  public Account Partnerlogo{get;set;}
  public Account PartnerPortalLogo{get;set;}
  //=============================================
  public String leadId {set;get;}
  public String entityId {set;get;}
  public String strName  {set;get;}
  Set<ID> setIdXrayScoreCard {set;get;}
  public List<Option_Detail__c> lstOptionDetails {set;get;}
  List<XRay_ScoreCard__c> lstScoreCard {set;get;}
  public X_Ray_Score_Card_Detail__c  objXrayScoreCardDetail{set;get;}
  public List<X_Ray_Score_Card_Detail__c>  lstXrayScoreCardDetail{set;get;}
  public List<Analysis_Matrix__c> lstAnalyasisMatrix{set;get;} 
  public Double freedomScore{set;get;}
  
  public List<ExistingQuestionAnswer> lstInnerClstoBind {set;get;}
  public String strId {set;get;}
  Date CurrentDate {set;get;}
  public String strDate {set;get;}
  public String DisplayButton {set;get;}//
  Map<String,XRay_ScoreCard__c> mapOfIdandXrayScoreCard {set;get;}
  Map<String,List<Option_Detail__c>>mapOfScoreIdandOptions { set;get;}
  public boolean isVisible {set;get;}
  /* Constructor Starts=== */
  public ComplimentaryDetailedAnalysis()
  {
    isVisible = true;
    Id objOwnerId;
    leadId = ApexPages.currentPage().getParameters().get('leadId');
    strId = leadId;
    //Added By Aditi for Partner Protal
    List<Lead> lstLead=[select id,OwnerId from Lead where id =: leadId ];
    if(!lstLead.isEmpty())
    objOwnerId=lstLead[0].OwnerId;
    // if(leadId == null )
    if(leadId == null)
    {
      entityId = ApexPages.currentPage().getParameters().get('entityId');
      strId = entityId; 
      //Added By Aditi for Partner Portal 
      if(entityId!=null)
      {
        List<Account> lstAcc=[select id,OwnerId from Account where id =: entityId ];
        objOwnerId=lstAcc[0].OwnerId;
      }
    }
    strName = ApexPages.currentPage().getParameters().get('name');
    DisplayButton =  ApexPages.currentPage().getParameters().get('DisplayButton');
    setIdXrayScoreCard  = new Set<ID>();
    lstXrayScoreCardDetail = new List<X_Ray_Score_Card_Detail__c>();
    objXrayScoreCardDetail  = new X_Ray_Score_Card_Detail__c();
    lstOptionDetails  = new List<Option_Detail__c>();
    lstScoreCard = new List<XRay_ScoreCard__c>();
    
    lstInnerClstoBind = new List<ExistingQuestionAnswer>();
    mapOfIdandXrayScoreCard  = new Map<String,XRay_ScoreCard__c>();
    mapOfScoreIdandOptions = new Map<String,List<Option_Detail__c>>();
    
    freedomScore = 0;
    CurrentDate = System.today();
    strDate = CurrentDate.format();
    
    //Date : 3/8/12, Code Added by Aditi
    //For Partner portal logo & name
    //=========================================================================================
      Account acc;
      Contact con;
     if(objOwnerId!=null)
    {
      User user=[select Id,Name,ProfileId,ContactId,Profile.Name from User where Id=:objOwnerId];
    
      if(user.ContactId==null)
      {
        isFreedomUser = true;
    //    Accname='Ffreedom';
      }
      else //Else is for Partner Portal
      {
        Id contactId = user.ContactId;
      
        con=[select AccountId from Contact where id =: user.ContactId];
        acc=[select Id,Logo__c, Email_ID__c, Company_Address__c,Phone,Name from account where id =: con.AccountId];
        Partnerlogo = acc;
    //    Accname=acc.Name;
        isFreedomUser = false;
      }
    }
      //===========================================================================================
  }
  
  public Pagereference Init()
  {
    Pagereference pgRef = null;
    lstAnalyasisMatrix = new List<Analysis_Matrix__c>();
    Map<ID,List<Analysis_Matrix__c >> mapQuesIdandAnalysisMatrix = new Map<ID,List<Analysis_Matrix__c >>();
    Map<ID,List<Related_Questions_To_Analysis__c>> mapAnalysisIdRelatedQuesAnalysis = new Map<ID,List<Related_Questions_To_Analysis__c>>();
    
    Map<Id,Analysis_Matrix__c> mapIdOfAnalysisMatrix = new Map<Id,Analysis_Matrix__c>(); 
    Map<String,Analysis_Matrix__c> mapQueAnsofAnyMatrix = new Map<String,Analysis_Matrix__c>(); 
    
    for(Analysis_Matrix__c objAnalysis : [Select a.Name, a.Master_Question__c, a.Id, a.Answer__c, a.Analysis__c From Analysis_Matrix__c a])
    {
      mapIdOfAnalysisMatrix.put(objAnalysis.id,objAnalysis);
      
      if(!mapQuesIdandAnalysisMatrix.isEmpty() && mapQuesIdandAnalysisMatrix.containsKey(objAnalysis.Master_Question__c))
      {
        List<Analysis_Matrix__c> lstAnalysis = mapQuesIdandAnalysisMatrix.get(objAnalysis.Master_Question__c);
        lstAnalysis.add(objAnalysis);
        mapQuesIdandAnalysisMatrix.put(objAnalysis.Master_Question__c,lstAnalysis);
      }
      else
      {
        List<Analysis_Matrix__c> lstAnalysis = new  List<Analysis_Matrix__c>();
        lstAnalysis.add(objAnalysis);
        mapQuesIdandAnalysisMatrix.put(objAnalysis.Master_Question__c,lstAnalysis);
      }
    }
      
    for(Related_Questions_To_Analysis__c objRelatedAnalysis : [Select r.Question_Master__c,r.Question_Master__r.Parent_Question__c,r.Question_Master__r.Question_Number__c, r.Option__c, r.Name, r.Id, r.Answer__c, r.Analysis_Matrix__c From Related_Questions_To_Analysis__c r Order by Question_Master__r.Question_Number__c ASC])//Order by Question_Master__r.Question_Number__c ASC
    {
      if(!mapAnalysisIdRelatedQuesAnalysis.isEmpty() &&  mapAnalysisIdRelatedQuesAnalysis.containsKey(objRelatedAnalysis.Analysis_Matrix__c))
      {
        List<Related_Questions_To_Analysis__c> lstRelatedAnalysis  = mapAnalysisIdRelatedQuesAnalysis.get(objRelatedAnalysis.Analysis_Matrix__c);
        lstRelatedAnalysis.add(objRelatedAnalysis);
        mapAnalysisIdRelatedQuesAnalysis.put(objRelatedAnalysis.Analysis_Matrix__c,lstRelatedAnalysis);
      }
      else
      {
        List<Related_Questions_To_Analysis__c> lstRelatedAnalysis = new  List<Related_Questions_To_Analysis__c>();
        lstRelatedAnalysis.add(objRelatedAnalysis);
        mapAnalysisIdRelatedQuesAnalysis.put(objRelatedAnalysis.Analysis_Matrix__c,lstRelatedAnalysis);
      }
    }
    
    /* This Loop will generate the Final output */
    if(!mapIdOfAnalysisMatrix.isEmpty())
    {
      for(Id AnalysisId : mapIdOfAnalysisMatrix.KeySet())
      {
        List<Related_Questions_To_Analysis__c> lstRelatedAnalysis = mapAnalysisIdRelatedQuesAnalysis.get(AnalysisId);
        String strKey ='';
        if(lstRelatedAnalysis != null && lstRelatedAnalysis.size() > 0)
        {
          for(Related_Questions_To_Analysis__c objRelQuesToAnalysis : lstRelatedAnalysis)
          {
            strKey += objRelQuesToAnalysis.Question_Master__c + String.valueOf(objRelQuesToAnalysis.Option__c);
          }
        }
        mapQueAnsofAnyMatrix.put(strKey,mapIdOfAnalysisMatrix.get(AnalysisId));
      }
    }
    
    if(leadId != null)
    {
      lstXrayScoreCardDetail =  [Select x.Question_Bank__c, x.MasterScore__c, x.Lead__c, x.Id, x.Entity__c 
                      From X_Ray_Score_Card_Detail__c x where Lead__c =:leadId limit 1];
    }
    else if(entityId != null)
    {
      lstXrayScoreCardDetail =  [Select x.Question_Bank__c, x.MasterScore__c, x.Lead__c, x.Id, x.Entity__c 
                      From X_Ray_Score_Card_Detail__c x where Entity__c =:entityId limit 1];
    }
    
    if(lstXrayScoreCardDetail.size()> 0 && lstXrayScoreCardDetail != null)
    {
        objXrayScoreCardDetail = lstXrayScoreCardDetail[0];
        freedomScore = objXrayScoreCardDetail.MasterScore__c; 
        lstScoreCard = [Select x.XRayScoreCardMaster__c, x.Question_Bank_List__c,x.Question_Bank_List__r.Question__c, x.Name, x.Id, x.Display_Sequence__c 
                From XRay_ScoreCard__c x where XRayScoreCardMaster__c =: objXrayScoreCardDetail.Id Order By Display_Sequence__c ASC];
        if(lstScoreCard.size() > 0)
        {
          for(XRay_ScoreCard__c objXrayScoreCard  :lstScoreCard)
          {
            setIdXrayScoreCard.add(objXrayScoreCard.Id);
            mapOfIdandXrayScoreCard.put(objXrayScoreCard.Id,objXrayScoreCard);
          } 
        }
        System.debug('mapOfIdandXrayScoreCard========'+mapOfIdandXrayScoreCard);
        System.debug('mapOfIdandXrayScoreCard.size========'+mapOfIdandXrayScoreCard.size());
        if(setIdXrayScoreCard.size() > 0)
          lstOptionDetails = [Select o.XRayScoreCard__c,o.QuestionMaster__r.Parent_Question__c, o.QuestionMaster__r.IsDummy__c, o.QuestionMaster__c,o.XRayScoreCard__r.Display_Sequence__c,
                     o.Name, o.Id, o.Answer__c,o.QuestionMaster__r.Question_Number__c ,o.Answer__r.Name
                    From Option_Detail__c o where XRayScoreCard__c IN:setIdXrayScoreCard Order BY XRayScoreCard__r.Display_Sequence__c];//Order BY QuestionMaster__r.Question_Number__c
      
      /***** Adding Analysis record in to the List of Analysis *****/
      if(lstOptionDetails.size() > 0 )
      {
        String strIdandIndex;
        for(Integer iCount = 0;iCount <= lstOptionDetails.size()-1;iCount++)
        {
          strIdandIndex = lstOptionDetails[iCount].XRayScoreCard__c;
                    if(!mapOfScoreIdandOptions.isEmpty() && mapOfScoreIdandOptions.containsKey(strIdandIndex))
          {
            List<Option_Detail__c> lstOptions = mapOfScoreIdandOptions.get(strIdandIndex);
            lstOptions.add(lstOptionDetails[iCount]);
            mapOfScoreIdandOptions.put(lstOptionDetails[iCount].XRayScoreCard__c,lstOptions); 
          }
          else
          {
              List<Option_Detail__c> lstOptions = new List<Option_Detail__c>();
                        lstOptions.add(lstOptionDetails[iCount]);
                        mapOfScoreIdandOptions.put(strIdandIndex,lstOptions); 
          }
          
          if(!lstOptionDetails[iCount].QuestionMaster__r.IsDummy__c)
          {
            String strObtainedKey = getGeneratedKey(iCount);
            if(strObtainedKey != null)
            {
              if(!mapQueAnsofAnyMatrix.isEmpty() && mapQueAnsofAnyMatrix.containsKey(strObtainedKey))
              {
                lstAnalyasisMatrix.add(mapQueAnsofAnyMatrix.get(strObtainedKey));
              }
            }
          }
        }
      }
      
      if(!mapOfIdandXrayScoreCard.isEmpty())
      {
        Map<Double,ExistingQuestionAnswer> mapOfinnerClass = new Map<Double,ExistingQuestionAnswer>(); 
        for(String id : mapOfIdandXrayScoreCard.keySet())//mapOfIdandXrayScoreCard
        {
           if(!mapOfScoreIdandOptions.isEmpty() && mapOfScoreIdandOptions.containsKey(id))
           {
             ExistingQuestionAnswer  objExisting =  new ExistingQuestionAnswer();
              objExisting.objScoreCardtoBind = mapOfIdandXrayScoreCard.get(id);
              objExisting.lstOptionDetailtoBind = mapOfScoreIdandOptions.get(id);
              mapOfinnerClass.put(objExisting.objScoreCardtoBind.Display_Sequence__c,objExisting);
                //lstInnerClstoBind.add(objExisting);
             }
        }
        if(!mapOfinnerClass.isEmpty())
        {
          for(Double index = 1;index <= 25;index++)
          {
            if(!mapOfinnerClass.isEmpty() && mapOfinnerClass.containsKey(index))
            {
                            lstInnerClstoBind.add(mapOfinnerClass.get(index));
            }
          }
          System.debug('mapOfinnerClass========'+mapOfinnerClass);
          System.debug('mapOfinnerClass.size========'+mapOfinnerClass.size());
        }
      }
    }
    return pgref;
  }
  
  
  /***** This function will generate the key for the Map of Analysis i.e.mapQueAnsofAnyMatrix
  *****/
  private String getGeneratedKey(Integer index)
  {
    String strGeneratedKey ='';
    if(index < lstOptionDetails.size())
    {
      if(lstOptionDetails[index].Answer__c != null)
      {
        Integer iCount = 0;
        String tempParentId = null;
        strGeneratedKey  = lstOptionDetails[index].QuestionMaster__c + String.valueOf(lstOptionDetails[index].Answer__c);
        
        for(iCount = index ;iCount < lstOptionDetails.size()- 1;iCount++)
        {
          tempParentId = lstOptionDetails[iCount].QuestionMaster__c; 
          if(tempParentId == lstOptionDetails[iCount + 1].QuestionMaster__r.Parent_Question__c )
          {
            tempParentId = lstOptionDetails[iCount + 1].QuestionMaster__r.Parent_Question__c;
            if(lstOptionDetails[iCount + 1].Answer__c != null)
                strGeneratedKey  += lstOptionDetails[iCount + 1].QuestionMaster__c + String.valueOf(lstOptionDetails[iCount + 1].Answer__c);
          }
          else
          {
              break;
          }
        }
      }
      
    }
    return strGeneratedKey;
  }
  
  public void createAnalysisAttachment()
  {
    Pagereference analysisAttachmentPdf = new Pagereference('/apex/GenerateAnalysis');
    DisplayButton ='2';
    //PageReference analysisAttachmentPdf = Page.GenerateAnalysis;
    
    if(leadId != null)
        analysisAttachmentPdf.getParameters().put('leadId',leadId);
      else if(entityId != null)  
        analysisAttachmentPdf.getParameters().put('entityId',entityId);
        
      analysisAttachmentPdf.getParameters().put('name',strName);
      analysisAttachmentPdf.getParameters().put('DisplayButton',DisplayButton);
      analysisAttachmentPdf.setRedirect(false);
      System.debug('=======analysisAttachmentPdf============'+analysisAttachmentPdf);
      Attachment analysisMatrixAttach = new Attachment();
        analysisMatrixAttach.Body = analysisAttachmentPdf.getContentAsPDF();//getContentAsPDF()
        if(leadId != null)
        analysisMatrixAttach.ParentId = leadId;
      else if(entityId != null)
        analysisMatrixAttach.ParentId = entityId;
        
      String strDate = String.valueOf(System.today());  
        analysisMatrixAttach.Name = 'FfreedomXray<'+strName+'><'+strDate+'>.pdf';
        analysisMatrixAttach.ContentType = '';
          Database.Saveresult dbSaveResult = database.insert(analysisMatrixAttach);
          System.debug('=======dbSaveResult ==========='+dbSaveResult.getId());
  }
    
   public Class ExistingQuestionAnswer
    {
      public XRay_ScoreCard__c objScoreCardtoBind{set;get;}
      public List<Option_Detail__c> lstOptionDetailtoBind{set;get;}
      
      public ExistingQuestionAnswer()
      {
        objScoreCardtoBind = new XRay_ScoreCard__c();
        lstOptionDetailtoBind = new List<Option_Detail__c>();  
      }
    }
}