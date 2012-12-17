public class requirementEffortDetails {
   
    double requirement_gathering=0;
    double  sit=0;
    double but=0;
    double uat=0;
    double design=0;
    double traindep=0;
    double adapt=0;
    double total=0;
    integer count=0;
   
    Requirement_Estimation__c estIdVal = new Requirement_Estimation__c();
    Requirement_Estimation__c estDetail = new Requirement_Estimation__c();
    
    list<Datetime> availabledates=new list<Datetime>();
    list<String> allRequirements=new list<String>();
    String reqName ;
    String releaseId;
    String var;
    String parentName;
    datetime max;
    String estimationId;
    String pageId='reqsummary';
    String estid;
    public String reqId=System.currentPageReference().getParameters().get('id');
    
   public requirementEffortDetails (ApexPages.StandardController controller)
   {
       
   }
    
   public void getDetails()
   {
           try
           {
               estIdVal=[Select ReleaseEstimation__c from Requirement_Estimation__c where Requirement_id__c =:reqId AND Is_Estimated__c =TRUE];
               estid =estIdVal.ReleaseEstimation__c;
               estDetail= [Select Row_Total__c,Plan__c,Design__c,Build__c,Test__c,UAT__c,Deploy__c,Adapt_and_Ongoing_Support__c,contingency__c from Requirement_Estimation__c where ReleaseEstimation__c =:estid and Requirement_id__c =:reqId];            
               system.debug('Est details list is $$ Anshita:'+estDetail);
               if(estDetail !=null)
               {
                        requirement_gathering = estDetail.Plan__c;
                        sit=estDetail.Test__c;
                        but=estDetail.Build__c;
                        uat= estDetail.UAT__c;
                        design = estDetail.Design__c;
                        traindep = estDetail.Deploy__c;
                        adapt = estDetail.Adapt_and_Ongoing_Support__c;
                        total = estDetail.Row_Total__c;
              }
              else
              {
                       
              }  
           }
           catch(Exception e)
           {
               String msg ='This requirement is not part of any estimate.';         
               ApexPages.Message ErrMsg = new ApexPages.Message(ApexPages.severity.ERROR, msg);
               ApexPages.addMessage(ErrMsg);
               requirement_gathering =0.0;
               sit=0.0;
               but=0.0;
               uat=0.0;
               design = 0.0;
               traindep  =0.0;
               adapt = 0.0;
               total = 0.0;

           }   
    } 
    
    public double getTraindep()
    {
        return traindep ;
    }    
    public double getRequirement_gathering()
    {
        getDetails();
        return requirement_gathering ;
    }
    public double getSit()
    {
        return this.sit ;
    }
    public double getBut()
    {
        return but ;
    }
    public double getUat()
    {
        return uat ;
    }
    public double getDesign()
    {
        return design ;
    }
    public double getAdapt()
    {
        return adapt ;
     }
    public double getTotal()
    {
        return total ;
    } 
   
    public static testMethod void testrequirementEffortDetails ()
    {
        Requirement__c c = new Requirement__c(Requirement_Title__c='Requirement Unit Test',Is_Selected__c=true);
        insert c;
        
        Release_Estimation__c relest = new Release_Estimation__c (name='Test release Est');
        insert relest ;        
        
        Requirement_Estimation__c reqEst = new Requirement_Estimation__c(Plan__c=2.0, Design__c=3.0, Build__c=3.0, Test__c=7.0, Deploy__c =6.0, UAT__c =7.0, Adapt_and_Ongoing_Support__c=2.5, ReleaseEstimation__c=relest.id, Requirement_id__c= c.id, Is_Estimated__c =TRUE);
        insert reqEst ;
        
        Double Total = reqEst.Plan__c + reqEst.Design__c + reqEst.Build__c+ reqEst.Test__c + reqEst.Deploy__c + reqEst.UAT__c+ reqEst.Adapt_and_Ongoing_Support__c;
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        ApexPages.currentPage().getParameters().put('id', c.id );
        requirementEffortDetails controller = new requirementEffortDetails (sc);
               
        System.assertequals(reqEst.Plan__c,controller.getRequirement_gathering());
        System.assertequals(reqEst.Design__c,controller.getDesign());
        System.assertequals(reqEst.Build__c,controller.getBut());
        System.assertequals(reqEst.Test__c,controller.getSit());
        System.assertequals(reqEst.Deploy__c,controller.getTraindep());
        System.assertequals(reqEst.UAT__c,controller.getUat());
        System.assertequals(reqEst.Adapt_and_Ongoing_Support__c,controller.getAdapt());                
        System.assertequals(Total   , controller.getTotal());
        
       
   }
    
    
    
 }//PMT2009__ 30 occurences replaced by blank on 5thNov09