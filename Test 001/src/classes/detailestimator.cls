/* This class is controller used from all 
** pages used in Detail Estimator.
** @ author Anshita Sharma.
*/ 

public class detailestimator
{
    //For Requirement Estimation Object
    List<Requirement_Estimation__c> estReqDetail= new List<Requirement_Estimation__c>();
    List<Requirement_Estimation__c> estDetail= new List<Requirement_Estimation__c>();
    List<Requirement_Estimation__c> estimationVal= new List<Requirement_Estimation__c>();
    List<Requirement_Estimation__c> checkEstDetails= new List<Requirement_Estimation__c>();
    
    //For Release Estimation Object
    Release_Estimation__c estimateDetails=new Release_Estimation__c();
    Release_Estimation__c estimateName = new Release_Estimation__c();
    List <Release_Estimation__c> totalValList = new List<Release_Estimation__c>();
    
    //For Requirement Object
    List<requirement__c> selectedReq = new List<requirement__c>();
    List<Requirement__c> reqlist= new List<Requirement__c>();
    List< Requirement__c> searchlist= new  List< Requirement__c>();
    Requirement__c reqt01=new Requirement__c();
    Requirement__c requirement01 =new Requirement__c();
    
    //For Work Assignment Object
    Work_Assignment__c wrkasgn01=new Work_Assignment__c();
    Work_Assignment__c[] wrkarray;
    Work_Assignment__c workassign01=new Work_Assignment__c();
   
    //Others
    List<ID> wrklist= new List<ID>();
    List<reqWrapper> reqList1 = new List<reqWrapper>();
    List<Estimate_factor__c> lsFactors =new List<Estimate_factor__c>();
    //Added by Nisha
    List <reqWrapper> Searchreq = new List <reqWrapper> ();
    List <reqEstWrapper> DelListWrap  ;
   
    //Variables
    Integer contingency=0;
    //Added by Nisha :Start
    integer fvalue =0;
    integer displaynum  =10;
    integer reqlistsize = 0;
    Boolean ifnextLink = false;
    Boolean ifpreviousLink = false;
    Boolean addrequirement;
    Boolean IsFirst=true;
    Boolean IsEstVal=false;
    Boolean IsDelReq=false;
    Boolean called= false;
    //End
    Double Requirementgatherconfig;
    Double Designconfig ;
    Double BuildUnitconfig;  
    Double SITconfig;
    Double UATconfig;
    Double DeployTrainconfig;
    Double Stabilizeconfig;
    Double total=0.0;
    public String previousPage=ApexPages.currentPage().getParameters().get('prePage');
    public String estId=ApexPages.currentPage().getParameters().get('id');
    public String IsInsert=ApexPages.currentPage().getParameters().get('IsInsert');
    public String IsDetails=ApexPages.currentPage().getParameters().get('IsDetails');
                    
    public detailestimator(ApexPages.StandardController controller) 
    {
        
    }
       
    public detailestimator()
    {
        lsFactors = [SELECT Id, Requirement_Gathering_Simple__c, Requirement_Gathering_Medium__c, Requirement_Gathering_Complex__c, Design_Simple__c, Design_Medium__c, Design_Complex__c, Build_Unit_Test_Simple__c, Build_Unit_Test_Medium__c, Build_Unit_Test_Complex__c, SIT_Simple__c, SIT_Medium__c, SIT_Complex__c, UAT_Simple__c, UAT_Medium__c, UAT_Complex__c, Deploy_Train_Simple__c, Deploy_Train_Medium__c, Deploy_Train_Complex__c, Stabilize_New__c, Stabilize_Medium__c, Stabilize_Complex__c, Component_Name__c  FROM Estimate_Factor__c];
        //Start: Changes by Nisha(NMS Started)
        for(requirement__c obj : [SELECT Estimate__c,Id, Name, Requirement_Title__c,Request_Type__c,Release__c,Release__r.name,Level_of_Effort_Value__c,Status__c from Requirement__c where Is_Selected__c != true limit 999])
            Searchreq.add(new reqWrapper(obj));
        reqlistsize =   Searchreq.size();                                     
        if(reqlistsize  >displaynum )
            ifnextLink =true; 
        //End 
    }
         
  //START: Added for detail estimator by Anshita on 30-June-09
   
   /*This method is called from Detail view
   **of Estimate, on click of 'Add Requirement'
   **and returns a reference to Search page.
   */ 
     
   public pageReference addReq()
   {
        Pagereference searchPage= new PageReference('/apex/RequirementDetail?IsInsert=true&id='+estId+'&IsDetails=false');
        searchPage.setredirect(true);
        return searchPage; 
   }
    
  /*This method is called from Detail view
  **of Estimate, on click of 'Edit Estimate'
  **and returns a reference to create/edit estimate page.
  */
  
  public pageReference editEst()
  {
        Pagereference editEstPage= new PageReference('/apex/Details_Estimation?id='+estId+'&IsInsert=false&IsDetails=true');
        editEstPage.setredirect(true);
        return editEstPage; 
  }
    
  /* This method will be called to display 
  ** the detail page of estimate from detail estimate list page
  ** and on create/edit estimate page.
  */
  
  public Release_Estimation__c getEstimateName()
  {
         estimateName=[Select name from Release_Estimation__c where id=:estId];
         return estimateName;
  }
  
  /* This method is called while creating/editing 
  ** any estimate.
  */ 
  
  public List <Requirement_Estimation__c> getEstReqDetail()
  {    
        if(IsFirst == true)
        {
            if(IsInsert != 'true')
            {
                //Edit estimated req 
                estReqDetail= [Select Comments__c,Batch_comp__c, Batch_Complex__c, Config_complex__c, Config_Component__c, contingency__c, Custom_Complexity__c, Custom_Component__c, Data_comp__c, Data_Complex__c, Real_Comp__c, Real_Complex__c, Report_Complexity__c, Report_Component__c, Requirement__c, User_Comp__c, User_complexity__c, Workflow_Complex__c, Workflow_Component__c, Requirement_id__c,Requirement_id__r.Requirement_Title__c from Requirement_Estimation__c where ReleaseEstimation__c =:estId];
               
            }
            else
            {
                //estimate new req
                estReqDetail=[Select Comments__c,Batch_comp__c, Batch_Complex__c, Config_complex__c, Config_Component__c, contingency__c, Custom_Complexity__c, Custom_Component__c, Data_comp__c, Data_Complex__c, Real_Comp__c, Real_Complex__c, Report_Complexity__c, Report_Component__c, Requirement__c, User_Comp__c, User_complexity__c, Workflow_Complex__c, Workflow_Component__c, Requirement_id__c,Requirement_id__r.Requirement_Title__c from Requirement_Estimation__c where ReleaseEstimation__c =:estId and Is_Estimated__c != true];
                
            }
         }
         return estReqDetail;
    }
  
  /* This method is used to display estimated values on 
  ** estimate details view page. 
  */
  
  
  public List <reqEstWrapper> getEstDetail()
  {    
        DelListWrap  =null;
        DelListWrap  = new List <reqEstWrapper>();
        estDetail= [Select Row_Total__c,Plan__c,Design__c,Build__c,Test__c,UAT__c,Deploy__c,Adapt_and_Ongoing_Support__c,contingency__c,Requirement_id__r.Requirement_Title__c from Requirement_Estimation__c where ReleaseEstimation__c =:estId];
        for(Requirement_Estimation__c est :estDetail)        
            DelListWrap.add(new reqEstWrapper(est));            
        return DelListWrap;
  }
     
  /* This method is used to display estimated totals on 
  ** estimate details view page.
  */
  public Release_Estimation__c getTotalValList()
  {    
        Release_Estimation__c totalVal = new Release_Estimation__c();
        totalVal = [Select Total_Contigency__c,Total_Adapt__c,total_build__c, total_deploy__c, total_design__c, total_plan__c, total_test__c, total_UAT__c, TotalOfTotal__c from Release_Estimation__c where id=:estId ];        
        return totalVal ;
  }
  
  /* This method is called to get the estimate name.
  ** on estimate details and create/edit pages.
  */
  
  public Release_Estimation__c getEstimateDetails()
  {
         estimateDetails=[Select name from Release_Estimation__c where id=:estId];
         return estimateDetails;
  }
  
  /* This method will be used for
  ** deleting selected requirements
  ** from estimates.
  */
  public PageReference DelReq()
  {
       List <Requirement_Estimation__c> reqToDel = new List <Requirement_Estimation__c>();
       List<Requirement__c> reqToUpdate= new List<Requirement__c>();
       Boolean isChecked = false;
       for(reqEstWrapper reqdel: DelListWrap)
       {
            if(reqdel.selected == true)
            {
                isChecked = true;
                List<Requirements_Selected__c> reqSelDel = new List<Requirements_Selected__c>();
                reqSelDel =[Select p.Capacity_Id__c from Requirements_Selected__c p where p.Requirement_Id__c=:reqdel.reqt.id];
                if(reqSelDel.size()==0)
                {
                    reqToDel.add(reqdel.reqt); 
                    Requirement__c delReq= new Requirement__c(id=reqdel.reqt.Requirement_id__c, is_Selected__c=false);                      
                    reqToUpdate.add(delReq);
                }
            }
       }
       if(!isChecked)
       {
           String msg1 ='Atleast one requirement should be selected to remove.';         
           ApexPages.Message ErrMsg1 = new ApexPages.Message(ApexPages.severity.ERROR, msg1);
           ApexPages.addMessage(ErrMsg1);
           return null;
       }
       else
       {
          if(reqToDel.size()>0)
          {
                delete reqToDel; 
                update reqToUpdate;              
          }                  
          else
          {
               String msg='This requirement can not be deleted as it is associated with Capacity Planning for this estimate.';         
               ApexPages.Message ErrMsg = new ApexPages.Message(ApexPages.severity.ERROR, msg);
               ApexPages.addMessage(ErrMsg);
               return null;
         }
       } 
       
     
       Pagereference estDetailBack= new PageReference('/apex/Details_Estimation_RO?id='+estId);
       estDetailBack.setredirect(true);
       return estDetailBack;
  }
  
  /* This is inner class is used
  ** to display estimate details and
  ** identifying selected requirements to delete.
  */
  public class reqEstWrapper
  {
        public Requirement_Estimation__c reqt{get; set;}
        public Boolean selected {get; set;}
        public reqEstWrapper(Requirement_Estimation__c r)
        {
            reqt = r;
            selected = false;
        }
        public reqEstWrapper(Requirement_Estimation__c r, Boolean bSelect)
        {
            reqt = r;
            selected = bSelect;
        }        
  }  
      
  /* This method is called on click of
  ** 'Create Estimate' button from create/Edit
  ** estimate page and saves the values in DB.
  */ 
   
  public PageReference saveEstimate()
  {
        List<String> reqIdList =new List<String>();
        for(Requirement_Estimation__c rst:estReqDetail)
        {
             Database.SaveResult result=Database.update(rst);
             reqIdList.add(rst.id);
        }
        Requirement_Estimation__c[] datacontent=[Select p.Id, p.Name, p.Batch_comp__c, p.Batch_Complex__c, p.Config_complex__c, p.Config_Component__c, p.contingency__c, p.Custom_Complexity__c, p.Custom_Component__c, p.Data_comp__c, p.Data_Complex__c, p.Real_Comp__c, p.Real_Complex__c, p.Report_Complexity__c, p.Report_Component__c, p.User_Comp__c, p.User_complexity__c, p.Workflow_Complex__c, p.Workflow_Component__c from Requirement_Estimation__c p where id in:reqIdList]; 
        for(Requirement_Estimation__c inserteddata:datacontent)
        {
            Requirementgatherconfig=0.0;
            Designconfig =0.0;
            BuildUnitconfig=0.0;
            SITconfig=0.0;
            UATconfig=0.0;
            DeployTrainconfig=0.0;
            Stabilizeconfig=0.0;
           
            if(inserteddata.contingency__c!=null)
                contingency=integer.valueof(inserteddata.contingency__c);
            else
                contingency=0;
            for(Estimate_factor__c factor:lsFactors)
            {                    
                     //Config Components
                if(inserteddata.Config_complex__c=='Simple' && factor.Component_Name__c=='Configuration Ratings')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Simple__c)*(inserteddata.Config_Component__c)*(1+ contingency/100));
                         Designconfig = Designconfig+((factor.Design_Simple__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Simple__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Simple__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Simple__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Simple__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_New__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                         
                }

                if(inserteddata.Config_complex__c=='Medium' && factor.Component_Name__c=='Configuration Ratings')
                {
                        Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Medium__c)*(inserteddata.Config_Component__c)*(1+ contingency/100));
                         Designconfig = Designconfig +((factor.Design_Medium__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Medium__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Medium__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Medium__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Medium__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_Medium__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                        
                }
                
                if(inserteddata.Config_complex__c=='Complex'&& factor.Component_Name__c=='Configuration Ratings')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Complex__c)*(inserteddata.Config_Component__c)*(1+ contingency/100));
                         Designconfig = Designconfig + ((factor.Design_Complex__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Complex__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Complex__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Complex__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Complex__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_Complex__c)*(inserteddata.Config_Component__c)*(1+contingency/100));
                        
                    
                }
                //Workflow components
                if(inserteddata.Workflow_Complex__c=='Simple' && factor.Component_Name__c=='Workflow and Approval Ratings')
                {
                         Requirementgatherconfig=Requirementgatherconfig +((factor.Requirement_Gathering_Simple__c)*(inserteddata.Workflow_Component__c)*(1+ contingency/100));
                         Designconfig = Designconfig+((factor.Design_Simple__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Simple__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Simple__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Simple__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Simple__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_New__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                }        
                    
                if(inserteddata.Workflow_Complex__c=='Medium' && factor.Component_Name__c=='Workflow and Approval Ratings')
                {
                         Requirementgatherconfig = Requirementgatherconfig +((factor.Requirement_Gathering_Medium__c)*(inserteddata.Workflow_Component__c)*(1+ contingency/100));
                         Designconfig = Designconfig +((factor.Design_Medium__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Medium__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Medium__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Medium__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Medium__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_Medium__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                      
                }

                if(inserteddata.Workflow_Complex__c=='Complex' && factor.Component_Name__c=='Workflow and Approval Ratings')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Complex__c)*(inserteddata.Workflow_Component__c)*(1+ contingency/100));
                         Designconfig = Designconfig +((factor.Design_Complex__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Complex__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Complex__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Complex__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Complex__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_Complex__c)*(inserteddata.Workflow_Component__c)*(1+contingency/100));
                       
                }
                //User Administration Components
                if(inserteddata.User_complexity__c=='Simple' && factor.Component_Name__c=='User Administration Ratings')
                {
                         Requirementgatherconfig=Requirementgatherconfig +((factor.Requirement_Gathering_Simple__c)*(inserteddata.Config_Component__c)*(1+ contingency/100));
                         Designconfig = Designconfig+((factor.Design_Simple__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Simple__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Simple__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Simple__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Simple__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_New__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                      
                     
                }

                if(inserteddata.User_complexity__c=='Medium' && factor.Component_Name__c=='User Administration Ratings')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Medium__c)*(inserteddata.Config_Component__c)*(1+ contingency/100));
                         Designconfig = Designconfig +((factor.Design_Medium__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Medium__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Medium__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Medium__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Medium__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_Medium__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                      
                }

                if(inserteddata.User_complexity__c=='Complex'&& factor.Component_Name__c=='User Administration Ratings')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Complex__c)*(inserteddata.Config_Component__c)*(1+ contingency/100));
                         Designconfig = Designconfig + ((factor.Design_Complex__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Complex__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Complex__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Complex__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Complex__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_Complex__c)*(inserteddata.User_Comp__c)*(1+contingency/100));
                      
                }
                //Report components
                if(inserteddata.Report_Complexity__c=='Simple' && factor.Component_Name__c=='Report & Dashboard')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Simple__c)*(inserteddata.Report_Component__c)*(1+ contingency/100));
                         Designconfig = Designconfig+((factor.Design_Simple__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Simple__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Simple__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Simple__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Simple__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_New__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                        
                }

                if(inserteddata.Report_Complexity__c=='Medium' && factor.Component_Name__c=='Report & Dashboard')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Medium__c)*(inserteddata.Report_Component__c)*(1+ contingency/100));
                         Designconfig = Designconfig +((factor.Design_Medium__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Medium__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Medium__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Medium__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Medium__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_Medium__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                       
                }
                
                if(inserteddata.Report_Complexity__c=='Complex'&& factor.Component_Name__c=='Report & Dashboard')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Complex__c)*(inserteddata.Report_Component__c)*(1+ contingency/100));
                         Designconfig = Designconfig + ((factor.Design_Complex__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Complex__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Complex__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Complex__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Complex__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_Complex__c)*(inserteddata.Report_Component__c)*(1+contingency/100));
                        
                }
                //Customization Components
                if(inserteddata.Custom_Complexity__c=='Simple' && factor.Component_Name__c=='Customization')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Simple__c)*(inserteddata.Custom_Component__c)*(1+ contingency/100));
                         Designconfig = Designconfig+((factor.Design_Simple__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Simple__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Simple__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Simple__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Simple__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_New__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
               }       

                if(inserteddata.Custom_Complexity__c=='Medium' && factor.Component_Name__c=='Customization')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Medium__c)*(inserteddata.Custom_Component__c)*(1+ contingency/100));
                         Designconfig = Designconfig +((factor.Design_Medium__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Medium__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Medium__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Medium__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Medium__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_Medium__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                         
                }
                
                if(inserteddata.Custom_Complexity__c=='Complex'&& factor.Component_Name__c=='Customization')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Complex__c)*(inserteddata.Custom_Component__c)*(1+ contingency/100));
                         Designconfig = Designconfig + ((factor.Design_Complex__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Complex__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Complex__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Complex__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Complex__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_Complex__c)*(inserteddata.Custom_Component__c)*(1+contingency/100));
                      
                }
                //Data MIgration Components
                if(inserteddata.Data_Complex__c=='Simple' && factor.Component_Name__c=='Data Migration')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Simple__c)*(inserteddata.Data_comp__c)*(1+ contingency/100));
                         Designconfig = Designconfig+((factor.Design_Simple__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Simple__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Simple__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Simple__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Simple__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_New__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                         
                }

                if(inserteddata.Data_Complex__c=='Medium' && factor.Component_Name__c=='Data Migration')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Medium__c)*(inserteddata.Data_comp__c)*(1+ contingency/100));
                         Designconfig = Designconfig +((factor.Design_Medium__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Medium__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Medium__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Medium__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Medium__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_Medium__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                        
                }
                
                if(inserteddata.Data_Complex__c=='Complex'&& factor.Component_Name__c=='Data Migration')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Complex__c)*(inserteddata.Data_comp__c)*(1+ contingency/100));
                         Designconfig = Designconfig + ((factor.Design_Complex__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Complex__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Complex__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Complex__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Complex__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_Complex__c)*(inserteddata.Data_comp__c)*(1+contingency/100));
                        
                   
                }
                //Integration Batch Components
                if(inserteddata.Batch_Complex__c=='Simple' && factor.Component_Name__c=='Integration (Batch)')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Simple__c)*(inserteddata.Batch_comp__c)*(1+ contingency/100));
                         Designconfig = Designconfig+((factor.Design_Simple__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Simple__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Simple__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Simple__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Simple__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_New__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                         
                }

                if(inserteddata.Batch_Complex__c=='Medium' && factor.Component_Name__c=='Integration (Batch)')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Medium__c)*(inserteddata.Batch_comp__c)*(1+ contingency/100));
                         Designconfig = Designconfig +((factor.Design_Medium__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Medium__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Medium__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Medium__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Medium__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_Medium__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                        
                }
                
                if(inserteddata.Batch_Complex__c=='Complex'&& factor.Component_Name__c=='Integration (Batch)')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Complex__c)*(inserteddata.Batch_comp__c)*(1+ contingency/100));
                         Designconfig = Designconfig + ((factor.Design_Complex__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Complex__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Complex__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Complex__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Complex__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_Complex__c)*(inserteddata.Batch_comp__c)*(1+contingency/100));
                        
                }
                //Integration Real-time Components
                if(inserteddata.Real_Complex__c=='Simple' && factor.Component_Name__c=='Integration (Real Time)')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Simple__c)*(inserteddata.Real_Comp__c)*(1+ contingency/100));
                         Designconfig = Designconfig+((factor.Design_Simple__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Simple__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Simple__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Simple__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Simple__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_New__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         
                }

                if(inserteddata.Real_Complex__c=='Medium' && factor.Component_Name__c=='Integration (Real Time)')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Medium__c)*(inserteddata.Real_Comp__c)*(1+ contingency/100));
                         Designconfig = Designconfig +((factor.Design_Medium__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Medium__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Medium__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Medium__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Medium__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_Medium__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         
                }
                
                if(inserteddata.Real_Complex__c=='Complex'&& factor.Component_Name__c=='Integration (Real Time)')
                {
                         Requirementgatherconfig =Requirementgatherconfig +((factor.Requirement_Gathering_Complex__c)*(inserteddata.Real_Comp__c)*(1+ contingency/100));
                         Designconfig = Designconfig + ((factor.Design_Complex__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         BuildUnitconfig = BuildUnitconfig + ((factor.Build_Unit_Test_Complex__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         SITconfig = SITconfig +((factor.SIT_Complex__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         UATconfig = UATconfig + ((factor.UAT_Complex__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         DeployTrainconfig = DeployTrainconfig +((factor.Deploy_Train_Complex__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
                         Stabilizeconfig = Stabilizeconfig + ((factor.Stabilize_Complex__c)*(inserteddata.Real_Comp__c)*(1+contingency/100));
               }         
            }  //end of inner for loop
            
          
            inserteddata.Plan__c=decimal.valueOf(Requirementgatherconfig).setScale(2);
            inserteddata.Design__c=decimal.valueOf(Designconfig).setScale(2);
            inserteddata.Build__c=decimal.valueOf(BuildUnitconfig).setScale(2);
            inserteddata.Test__c=decimal.valueOf(SITconfig).setScale(2);
            inserteddata.UAT__c=decimal.valueOf(UATconfig).setScale(2);
            inserteddata.Deploy__c=decimal.valueOf(DeployTrainconfig).setScale(2);
            inserteddata.Adapt_and_Ongoing_Support__c=decimal.valueOf(Stabilizeconfig).setScale(2);
            inserteddata.Is_Estimated__c=true;
         
            update  inserteddata;
        }
                                         
        Pagereference savedEstPage= new PageReference('/apex/Details_Estimation_RO?id='+estId);
        savedEstPage.setredirect(true);
        return savedEstPage;
   }
   
   
  /* This method is used ti enable/disable
  ** 'Edit Estimate' Button on detail view
  ** page of estimate.
  */  
  public void setVal()
  {
      called =true;
      checkEstDetails=[Select Requirement_id__c,Requirement_id__r.Requirement_Title__c from Requirement_Estimation__c where ReleaseEstimation__c =:estId];
      if(checkEstDetails.size() != 0)
      {
          IsEstVal= false;
          IsDelReq= false;
      }
      else
      {
          IsEstVal=true;
          IsDelReq=true;
      }
  }
  
  /* This method is used ti enable/disable
  ** 'Delete Requirement' Button on detail view
  ** page of estimate.
   
  public boolean getIsDelReq()
  {
      checkEstDetails=[Select Requirement_id__c,Requirement_id__r.Requirement_Title__c from Requirement_Estimation__c where ReleaseEstimation__c =:estId];
      if(checkEstDetails.size() != 0)
          IsDelReq= false;
      else
          IsDelReq=true;
      return IsDelReq;
  }      
   */
  //END:  Added for detail estimator by Anshita on 30-June-09
    
    
  /* This method is called on click
  ** of 'Done' button from estimate
  ** detail view page.
  */   
  public PageReference gototab()
  {
      return new pageReference('/a0L/o');
  } 
     
  /* This method will give all searched values 
  ** to display on page.
  */  
  public List<Requirement__c> getreqlist()
  {  
         return reqlist;
  }
    
  //Getter and Setter Methods 
   
    public boolean getAddrequirement()
    {
          return addrequirement;
    }
    public double getRequirementgatherconfig()
    {
          return Requirementgatherconfig;
    }
    public double getDesignconfig()
    {
          return Designconfig;
    }
    public double getBuildUnitconfig()
    {
          return BuildUnitconfig;
    }
    public double getSITconfig()
    {
         return SITconfig;
    }
    public double getUATconfig()
    {
         return UATconfig;
    }
    public double getDeployTrainconfig()
    {
        return DeployTrainconfig;
    }
    public double getStabilizeconfig()
    {
        return Stabilizeconfig;
    }
    public double getTotal()
    {
       return total;
    }
    public Work_Assignment__c getWorkassign01()
    {
        return workassign01;
    }
    public void setWorkassign01(Work_Assignment__c wrkasgn01)
    {
        this.workassign01= wrkasgn01;
    }
    public Requirement__c getrequirement01()
    {
        return requirement01;
    }
    public void setRequirement01(Requirement__c reqt01)
    {
        this.requirement01=reqt01;
    }
    public Boolean getifnextLink()
    {
        return ifnextLink;
    }   
    
    public Boolean getifpreviousLink()
    {
        return ifpreviousLink ;
    }  
    public integer getnextvalue()
    {
        return fvalue;
    }            
    public integer getdisplaynum ()
    {
        return displaynum ;
    } 
    public boolean getIsEstVal()
    {
        setVal();
        return IsEstVal;
    }
    public boolean getIsDelReq()
    {
        if(!called)
            setVal();
        return IsDelReq;
    }
    
    /* This method is called to search available
    ** requirements for estimates.
    ** Modified by Anshita on 30-06-09
    */
    public pagereference search()
    {
            reqlist.clear();
            boolean iswherecondition=false;
            String Operator='=';
            String Query='SELECT id,Estimate__c, Name, Requirement_Title__c,Request_Type__c,Release__c, Release__r.name,Level_of_Effort_Value__c,Status__c from Requirement__c where Is_Selected__c != true';
            String Requirementtitle='%'+Requirement01.Requirement_Title__c+'%';
            String Systemimpacted=requirement01.System_Impacted__c;
            String Status=requirement01.Status__c;
            String Release=requirement01.Release__c;
            String Requesttype=requirement01.Request_Type__c;
            String[] requestypearr = null;
            String operatorlike='like';
            String Assignment= workassign01.Assignment__c;
            String Name= workassign01.Name__c;
            String Progress= workassign01.Progress__c;
            List<String> type1=new list<String>();
                       
            if(Requirement01.Requirement_Title__c!=null && Requirement01.Requirement_Title__c!='')
            {
                if(Requirementtitle.indexOf('%')>-1)Operator='like';
                Query+=' AND Requirement_Title__c '+'like'+' :Requirementtitle';
                iswherecondition=true;
               
            }
            if(requirement01.Status__c!=null && requirement01.Status__c!='')
            {
                
                  Query+=' AND Status__c'+' like'+': Status';
                  iswherecondition=true;
            }
            if(Release!=null && Release!='')
            {
                   Query+=' AND Release__c =: Release';
                   iswherecondition=true;
            }
            if(Requesttype!=null && Requesttype!='')
            {
                requestypearr=Requesttype.split(';');
                for(integer i=0;i<requestypearr.size();i++)
                {
                type1.add(requestypearr[i]);
                }
                
                Query+=' AND Request_Type__c IN: type1';
                iswherecondition=true;
            }
            if(Systemimpacted!=null && Systemimpacted!='')
            {
                Query+=' AND System_Impacted__c =: Systemimpacted';
                iswherecondition=true;
            }
            if(Assignment != null && Assignment!='')
            {
                  wrkarray=[SELECT Requirement_Number__c from Work_Assignment__c where Assignment__c =: Assignment];            
                                   
                  for(Integer i=0;i<wrkarray.size();i++){
                  if(wrkarray[i].Requirement_Number__c!=null)
                  wrklist.add(wrkarray[i].Requirement_Number__c);
                  }
                  Query+=' AND ID IN: wrklist';
                  iswherecondition=true;
            }
            if(Name!= null && Name!='')
            {
                  wrkarray=[SELECT Requirement_Number__c from Work_Assignment__c where Name__c =: Name];            
                                   
                  for(Integer i=0;i<wrkarray.size();i++){
                  if(wrkarray[i].Requirement_Number__c!=null)
                  wrklist.add(wrkarray[i].Requirement_Number__c);
                  }
                     Query+=' AND ID IN: wrklist';
                     iswherecondition=true;
            }
            if(Progress!= null && Progress!='')
            {
                  wrkarray=[SELECT Requirement_Number__c from Work_Assignment__c where Progress__c =: progress];            
                                   
                  for(Integer i=0;i<wrkarray.size();i++){
                  if(wrkarray[i].Requirement_Number__c!=null)
                  wrklist.add(wrkarray[i].Requirement_Number__c);
                  }
                   Query+=' AND ID IN: wrklist';
                   iswherecondition=true;
            }
            
            Query+=' limit 999';  
            if(iswherecondition)
            {
                //When search criteria is given
                reqlist=Database.Query(Query);
            }
            else
            {
                //When no search criteria is given
                reqlist=[SELECT id,Estimate__c, Name, Requirement_Title__c,Request_Type__c,Release__c, Release__r.name,Level_of_Effort_Value__c,Status__c from Requirement__c where Is_Selected__c != true limit 999];
            }
            
             //START: Added by Nisha for Detail Estimator 
            
            Searchreq =null;
            Searchreq = new List <reqWrapper> ();
            for(requirement__c obj : reqlist)
                Searchreq.add(new reqWrapper(obj));
            reqlistsize =   Searchreq.size();
                               
            if(reqlistsize  >displaynum )
                ifnextLink =true;
            else
                ifnextLink =false;                                                            
            fvalue =0;            
            ifpreviousLink = false;                  
            
            return null;  
                   
     } 
      
   public PageReference addRows()
   {
        Searchreq = null;
        ifnextLink = false;
        fvalue=0;   
        Searchreq = new List <reqWrapper> ();     
            
        for(requirement__c obj : [SELECT Estimate__c,Id, Name, Requirement_Title__c,Request_Type__c,Release__c,Release__r.name,Level_of_Effort_Value__c,Status__c from Requirement__c where Is_Selected__c != true limit 999])
            Searchreq.add(new reqWrapper(obj));
        reqlistsize =   Searchreq.size();                                     
        if(reqlistsize  >displaynum )
            ifnextLink =true;              
        addrequirement=true;
        return null;
   }
  
   public class reqWrapper
   {
        Public requirement__c reqObj {get; set;}
        public boolean checked {get; set;}

        public reqWrapper(requirement__c temp)
        {
            ReqObj=temp;
            checked=false;
        }
   }
     
   public List<reqWrapper> getReq()
   {
        for(requirement__c obj : [SELECT Id, Name, Business_Benefit_Value__c, Business_Benefit__c, Capacity_Type__c, Closed_Deferred__c, Comments__c, Functional_Description__c, Level_of_Effort_Value__c, Estimate__c, Quick_Hit__c, ROI__c, Client_Requirement_ID__c, Regions_Requesting__c, Removed_Release__c, Request_Type__c, Requirement_Description__c, Status__c, System_Impacted__c, Technical_Description__c, Test_Case__c, Total_Priority_Ranking__c, Urgency_of_Requirement_Value__c, Urgency_of_Requirement__c, Urgency_of_Change_Value__c, Urgency_of_Change__c, Requirement_Title__c, Req__c, Des__c, BUT__c, SIT__c, UAT__c, TrnDep__c, Adapt__c, Cont__c, Total__c, LOE__c, TotEst__c, Regions_Impacted__c, Overall_Priority__c FROM Requirement__c ])
            reqList1.add(new reqWrapper(obj));
       return reqList1;
   }
     
     /* This method will save all selected requirements
     ** and also update the selected flag in Requirement object.
     */    
   public PageReference estimateSelected()
   {
        List <String> ReqId = new List<String> ();
        List <Requirement__c> reqToUpdate= new List<Requirement__c> ();
        List <Requirement_Estimation__c> reqEstToInsert= new List<Requirement_Estimation__c> ();
        List <Requirement_Estimation__c> tempSerReq = new List<Requirement_Estimation__c> ();                
        Boolean ReqSelected = false;
        
        List <String> reqIdlist = new List <String> ();
        for(reqWrapper reqwrapper : Searchreq)
        {
            if(reqwrapper.checked == true)
            {
                Requirement__c tempReq = new Requirement__c(id=reqwrapper.ReqObj.Id, is_Selected__c=true);
                reqToUpdate.add(tempReq);
                
                Requirement_Estimation__c tempReqEst = new Requirement_Estimation__c ();                
                tempReqEst.Requirement_id__c = reqwrapper.ReqObj.Id;
                tempReqEst.ReleaseEstimation__c = estId;
               
                reqEstToInsert.add(tempReqEst);
                ReqSelected = true;
                
                if(IsDetails == 'true')
                {
                    reqIdlist.add(reqwrapper.ReqObj.Id);
                }
            }
        }
        
        if(ReqSelected)        
        { 
             if(reqToUpdate!= null)
                       update reqToUpdate;
             if(reqEstToInsert != null)
                       insert reqEstToInsert;             
             addrequirement=false;             
        } 
        else
        {
            String msg='Atleast one requirement should be selected for estimation.';         
            ApexPages.Message ErrMsg = new ApexPages.Message(ApexPages.severity.ERROR, msg);
            ApexPages.addMessage(ErrMsg);
            return null;
        } 
        if(IsDetails == 'true')
        {
            tempSerReq = [Select Comments__c,Batch_comp__c, Batch_Complex__c, Config_complex__c, Config_Component__c, contingency__c, Custom_Complexity__c, Custom_Component__c, Data_comp__c, Data_Complex__c, Real_Comp__c, Real_Complex__c, Report_Complexity__c, Report_Component__c, Requirement__c, User_Comp__c, User_complexity__c, Workflow_Complex__c, Workflow_Component__c, Requirement_id__c,Requirement_id__r.Requirement_Title__c from Requirement_Estimation__c where ReleaseEstimation__c =:estId and Requirement_id__c In :reqIdlist];
            for(Requirement_Estimation__c rec: tempSerReq )                       
                estReqDetail.add(rec);
            IsFirst=false;
        }        
        Pagereference createEstPage;
        if(IsDetails == 'false'){
            createEstPage = new PageReference('/apex/Details_Estimation?IsInsert=true&id='+estId+'&IsDetails=true&prePage=addReq');
            createEstPage.setredirect(true);
        }
        return createEstPage;    
     
   }
   //Added to retain data
   
   public List<reqWrapper> getSearchreq()
   {
        return Searchreq;
   }
   
   /* This method is called when
   ** next link is clicked, while
   ** adding requirementsin estimate.
   */ 
    
   public void OnClickNext()
   {
        fvalue = fvalue + displaynum ;
        if(fvalue+10 >= reqlistsize )
           ifnextLink = false; 
        if(fvalue >= displaynum )           
            ifpreviousLink = true;
   }
   
   /* This method is called when
   ** previous link is clicked, while
   ** adding requirementsin estimate.
   */ 
       
   public void OnClickPrevious()
   {
        fvalue = fvalue - displaynum ;
        if(fvalue+ displaynum  < reqlistsize )
           ifnextLink = true;            
        if(fvalue >= displaynum )           
            ifpreviousLink = true;
        else   
            ifpreviousLink = false;          
   } 
   
   //END: Added by Nisha for Detail Estimator     
   
    public PageReference gotoPreviousPage()
   {
       Pagereference PreviousPageURL;
       if(previousPage == 'addReq')
           PreviousPageURL= new PageReference('/apex/RequirementDetail?IsInsert=true&id='+estId+'&IsDetails=false');
       else
           PreviousPageURL= new PageReference('/apex/Details_Estimation_RO?id='+estId);
       PreviousPageURL.setredirect(true);
       return PreviousPageURL; 
       
   }

}//PMT2009__ 497 occurences replaced by blank