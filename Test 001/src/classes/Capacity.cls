/*

Test Kiran - Test

*/


public class Capacity 
{
    List<Capacity__c> VarCapacity ;
    Capacity__c VarCapacity1; 
    List<Requirements_Selected__c> VarRequirement ; 
    public String capacityID=ApexPages.currentPage().getParameters().get('id');
    List <Requirement_Estimation__c> ReqEstlist = new List <Requirement_Estimation__c>();
    Requirement_Estimation__c ReqEst ;
    String CapacityName = null;
    List <Release_Capacity__c> availableCap ;    
    Boolean CapAvailable = false;
    String currURL;
    
    //Test Kiran
    Double Kiran	=	0;
    
    Double TotalPlan = 0.0;
    Double TotalDesign = 0.0;    
    Double TotalBuild = 0.0;
    Double TotalTest = 0.0;
    Double TotalUAT = 0.0;
    Double TotalDeploy = 0.0;
    Double TotalAdapt = 0.0;
    Double TotalTotal = 0.0;    
    
    Datetime ddmmyy;//for start date and end date;

    public Capacity(ApexPages.StandardController controller)  { 
        VarRequirement = new List<Requirements_Selected__c>();  
        availableCap = new List<Release_Capacity__c> ();
        VarCapacity1=[SELECT Id, Name, Start_Date__c, End_Date__c, Release_Type__c, Capacity_Type__c, No_of_Days__c, Release_Name__r.Name FROM Capacity__c WHERE ID =: CapacityID ];  
        
        CapacityName = VarCapacity1.Name;
        availableCap =[SELECT p.Id, p.Name, p.Adapt_and_Ongoing_Support__c, p.Build__c, p.Capacity_Id__c, p.Deploy__c, p.Design__c, p.Plan__c, p.Resource_Type__c, p.SIT__c, p.UAT__c FROM Release_Capacity__c p WHERE Capacity_Id__c = :capacityId]; 
        /*if (availableCap.size() > 0 )
            CapAvailable = true;  */  
        VarRequirement=[SELECT Id, Name, Requirement_Id__r.Id, Requirement_Id__r.Name, Requirement_Id__r.Plan__c, Requirement_Id__r.Design__c, Requirement_Id__r.Build__c, Requirement_Id__r.Test__c, Requirement_Id__r.UAT__c, Requirement_Id__r.Deploy__c, Requirement_Id__r.Adapt_and_Ongoing_Support__c,  Requirement_id__r.Requirement_id__r.Requirement_Title__c, Requirement_Id__r.Row_Total__c FROM Requirements_Selected__c where Capacity_Id__r.Id =:CapacityID];                    
        if (VarRequirement.size() > 0 )
            CapAvailable = true;   
        else
            CapAvailable = false;            
        
   }
 
    public capacity() 
    {
        VarRequirement=[SELECT Id, Name, Requirement_Id__r.Id, Requirement_Id__r.Name, Requirement_Id__r.Plan__c, Requirement_Id__r.Design__c, Requirement_Id__r.Build__c, Requirement_Id__r.Test__c, Requirement_Id__r.UAT__c, Requirement_Id__r.Deploy__c, Requirement_Id__r.Adapt_and_Ongoing_Support__c,  Requirement_id__r.Requirement_id__r.Requirement_Title__c, Requirement_Id__r.Row_Total__c FROM Requirements_Selected__c where Capacity_Id__r.Id =:CapacityID];                        
    }                                            

    public List<Requirements_Selected__c> getVarRequirement()
    {        
        return VarRequirement;
    }

    Public List<Capacity__c> getVarCapacity()
    {
        // VarCapacity=[SELECT Id, Name, Start_Date__c, End_Date__c, Release_Type__c, Capacity_Type__c, No_of_Days__c FROM Capacity__c WHERE ID =: CapacityID ];  
        // Update in Oct 08 , 2009
        //VarCapacity=[SELECT Id, Name, Start_Date__c, End_Date__c, Release_Type__c, Capacity_Type__c, No_of_Days__c, Release_Name__r.Name FROM Capacity__c WHERE ID =: CapacityID ];          
        VarCapacity=[SELECT Id, Name, Release_Start_Date_New__c, Release_Planned_End_Date_New__c, Release_Type__c, Capacity_Type__c, No_of_Days__c, Release_Name__r.Name FROM Capacity__c WHERE ID =: CapacityID ];          
        return VarCapacity;
    }
       
    public double getTotalPlan(){
        System.debug ('VarRequirement.size() ' + VarRequirement.size());
        System.debug ('VarRequirement ' +VarRequirement);
        if(VarRequirement.size() > 0) 
        for(Requirements_Selected__c varreq :VarRequirement){
            if(varreq.Requirement_Id__r.Plan__c !=null)
                TotalPlan = TotalPlan  + varreq.Requirement_Id__r.Plan__c;
        }
        return TotalPlan;
    }
    
    public double getTotalDesign (){
        for(Requirements_Selected__c varreq :VarRequirement)
        {
            if(varreq.Requirement_Id__r.Design__c !=null ) 
                TotalDesign = TotalDesign  + varreq.Requirement_Id__r.Design__c;
        }
        return TotalDesign ;
    }    
    
    public double getTotalBuild(){
        for(Requirements_Selected__c varreq :VarRequirement)
        {
            if(varreq.Requirement_Id__r.Build__c !=null)
                TotalBuild = TotalBuild + varreq.Requirement_Id__r.Build__c;
        }
        return TotalBuild ;
    }
    
    public double getTotalTest(){
        for(Requirements_Selected__c varreq :VarRequirement)
        {
            if(varreq.Requirement_Id__r.Test__c !=null)
                TotalTest = TotalTest  + varreq.Requirement_Id__r.Test__c;
        }
        return TotalTest ;
    }    
    
    public double getTotalUAT (){
        for(Requirements_Selected__c varreq :VarRequirement)
        {
            if(varreq.Requirement_Id__r.UAt__c !=null)
                TotalUAT =TotalUAT + varreq.Requirement_Id__r.UAt__c;
        }
        return TotalUAT ;
    }   
     
    public double getTotalDeploy (){
        for(Requirements_Selected__c varreq :VarRequirement)
        {
            if(varreq.Requirement_Id__r.Deploy__c != null) 
                TotalDeploy = TotalDeploy + varreq.Requirement_Id__r.Deploy__c;
        }
        return TotalDeploy ;
    }    
    
    public double getTotalAdapt(){
        for(Requirements_Selected__c varreq :VarRequirement)
        {
            if(varreq.Requirement_Id__r.Adapt_and_Ongoing_Support__c !=null)
                TotalAdapt = TotalAdapt + varreq.Requirement_Id__r.Adapt_and_Ongoing_Support__c;
        }
        return TotalAdapt ;
    }   
    
    public double getTotalTotal(){
        TotalTotal = TotalPlan + TotalDesign + TotalBuild  + TotalTest +TotalUAT + TotalDeploy +TotalAdapt ;
        return TotalTotal ;
    }                  
 
    public String getCapacityID(){
        return CapacityID;
    } 
   
    public String getCapacityName (){
        return CapacityName ;
    }
    
    public String getStartTime(){
        //Changed on 8th oct'09
        //Date myDT =VarCapacity[0].Start_Date__c;
        String ststr;
        Date myDT =VarCapacity[0].Release_Start_Date_New__c;
        if(myDT != null)
        {
            Datetime myDate = Datetime.newInstance(myDT.year(),myDT.month(),myDT.day(),0,0,0);                            
            //return myDate.format('MM/dd/yyyy');                
            ststr = myDate.format('MM/dd/yyyy'); 
        }
        return ststr;
    }

    public String getEndTime(){
        //Changed on 8th oct'09
        //Date myDT =VarCapacity[0].End_Date__c;
        Date myDT =VarCapacity[0].Release_Planned_End_Date_New__c   ;
        String endstr;
        if (myDT != null){
            Datetime myDate = Datetime.newInstance(myDT.year(),myDT.month(),myDT.day(),0,0,0);                
            //return myDate.format('MM/dd/yyyy');  
            endstr = myDate.format('MM/dd/yyyy');
        }            
        return endstr ;        
    }      

    public pageReference editScope(){
        //Pagereference pgRef= new PageReference('/apex/establishScopePage?id='+capacityId );
        //https://pmt2009.na6.visual.force.com/apex/EstablishScopeTabPage?id=a0Q80000000PSAC
        Pagereference pgRef= new PageReference('/apex/EstablishScopeTabPage?id='+capacityId );
        pgRef.setredirect(true);
        return pgRef;         
    }
    
    public Boolean getCapAvailable(){
        return CapAvailable;
    }
    
    public String getoutputStr(){
        return 'Scope to be Determined';
    }
    
    //Method to be removed
    public String getcurrURL (){
        return currURL ;
    }
    
    public Pagereference OnClickCancel()
    {
        Pagereference pgRef= new PageReference('/'+capacityId );
        pgRef.setredirect(true);
        return pgRef;       
    }
    
    public Pagereference  Checkinline()    
    {
        String inline = null;
        Pagereference pgRef=null;
        try
        {
            inline=ApexPages.currentPage().getParameters().get('inline');
        }
        catch(Exception ex){
        }
        if(inline !=null)
            pgRef= new PageReference('/'+capacityId );
        return pgRef;            
    }
    
    public Pagereference   checkinlinesamePage(){
        System.debug('checkinlinesamePage ');
        String inline = null;
        Pagereference pgRef=null;
        try
        {
            inline=ApexPages.currentPage().getParameters().get('inline');
        }
        catch(Exception ex){
        }
        System.debug('inline '+inline);
        if(inline =='1'){
            pgRef= new PageReference('/apex/ReleaseOutputPage?id='+capacityId );
            pgRef.setRedirect(true);
        }            
        return pgRef;     
    }
 
    
    public static testMethod void testCapacity()
    {   
        Release__c Rel =new Release__c(Name='Test Release', Release_Actual_End_Date__c = System.today(), Release_Planned_End_Date__c = System.today(), Release_Start_Date__c = System.today()-8, Release__c = 1.0, Status__c = 'Green' );
        insert Rel;
        
        Resource_Factor_Master__c resFactMaster = new Resource_Factor_Master__c(Name ='Test Factor Master', Release_Type__c = 'Minor' );
        insert  resFactMaster ;
        Resource_Factor__c resFact = new Resource_Factor__c(Resource_Type_New__c = 'Business Analyst', Capacity_Type__c = 'Capacity', Plan_Factor__c = 7.0, Design_Factor__c = 10.0, Build_Factor__c =10.0, SIT_Factor__c = 10.0, UAT_Factor__c= 8.0, Deploy_Factor__c = 10.0, Adapt_Factor__c =10.0 ,Resourse_Factor_Master__c=resFactMaster.id);
        insert resFact;
        Capacity__c capacityObj = new Capacity__c(Start_Date__c=System.today(), End_Date__c=System.today()+8,Capacity_Type__c= 'Known Resource-Mix', Release_Name__c =Rel.id, Resourse_Factor_Name__c =resFactMaster .Id );
        insert capacityObj;
        
        
        ApexPages.CurrentPage().getParameters().put('id', capacityObj.id);
        ApexPages.StandardController stdc = new ApexPages.StandardController(capacityObj);
        Capacity cap = new Capacity(stdc );

        cap.getTotalPlan();
        cap.getVarRequirement();
        cap.getVarCapacity();
        cap.getTotalPlan();
        cap.getTotalDesign();
        cap.getTotalBuild();
        cap.getTotalTest();
        cap.getTotalUAT();
        cap.getTotalDeploy();
        cap.getTotalAdapt();
        cap.getTotalTotal();
        cap.getCapacityID();
        cap.getCapacityName();
        cap.getStartTime();
        cap.getEndTime();
        cap.getCapAvailable();
        cap.getoutputStr();
        cap.OnClickCancel();
        cap.Checkinline();
        cap.editScope();
        cap.checkinlinesamePage();
        
        
        
        
        //Requirements_Selected__c requireSelect = new Requirements_Selected__c();        
        
        
         
    }
}//PMT2009__ replaced by blank on 5thNov09 on 50 places.