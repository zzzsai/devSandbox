/*

Kiran

*/

public class CapacitySummaryNM
{
    private String id ;
    
    
    //test test
    private string test;
    
    private CapacityDetailEstimator__c capSetobj = new CapacityDetailEstimator__c();
    private List<WaveDetailCls> WavePhaseslst = new List<WaveDetailCls>();        
    private List <Allocation_Assignment__c> RoleAlloc;
    Map <String, List<Id>> ProjPhaseAssignMap = new Map <String, List<Id>>();
    static Map <String, List<Project_Assignment__c>> ProjAssignMap = new Map <String, List<Project_Assignment__c>>();    
    static Map <String, List<Vacation_Assignment__c>> VacactionOverviewMap = new Map <String, List<Vacation_Assignment__c>>();
    static Map <String, List<Holiday_Assignment__c>> HolidayMap = new Map <String, List<Holiday_Assignment__c>>();
    static Map <String, List<Ongoing_Activity_Assignment__c>> OnActivityMap = new Map <String, List<Ongoing_Activity_Assignment__c>>();
    static Map <String, List<Allocation_Assignment__c>> ResAllocMap = new Map <String, List<Allocation_Assignment__c>>();
    
    public CapacitySummaryNM(ApexPages.StandardController controller) 
    {
        id = ApexPages.currentPage().getParameters().get('id');
        System.debug('HI!!!'+id); 
        if(id!=null)       
        {
            capSetobj = [SELECT name, Client_Name__c, Project_Name__c, Release__c, Start_Date__c, 
                End_Date__c, Project_Duration__c 
                FROM CapacityDetailEstimator__c WHERE id =: id ];
        }
        calculatePhaseDetails();
        System.debug('getEachPhaseDetail()--' + getEachPhaseDetail());
    }
    public CapacitySummaryNM()
    {
      
    }
    
    /**
        Getting Data for Project Phases /Releases for Capacity
    */
    public void calculatePhaseDetails()
    {   
        List <Id> PhaseIdLst = new List<Id>();
        List <Id> projAssignIdLst = new List<Id>();
        Map <String, integer> RoleCnt = new Map <String, integer>();   
        List<Project_Phase__c> projPhaseslst = new List<Project_Phase__c>();
        projPhaseslst = [SELECT id, name, Focus_Area__c,Release_del__c, 
            Plan__c, Design__c, Build__c, Test__c, UAT__c, Deploy__c, Adapt_Ongoing_Support__c , Related_Estimate__c
            FROM Project_Phase__c WHERE Capacity__c = :id order by Release_del__c ASC];      
            system.debug(projPhaseslst+'eeeeeeeeeeeeeeee');
        for(Project_Phase__c pPhase:projPhaseslst)
        {
            PhaseIdLst.add(pPhase.id);            
        } 
        
        List<Project_Assignment__c > projAssnlst = new List<Project_Assignment__c >();         
        projAssnlst = [SELECT id, Role__c, Project_Phase__c 
                FROM Project_Assignment__c 
                WHERE Project_Phase__c IN: PhaseIdLst ]     ;
                
        for(Project_Assignment__c pAssign:projAssnlst )
        {
            projAssignIdLst.add(pAssign.id);
            
            if(ProjPhaseAssignMap.containsKey(pAssign.Project_Phase__c))
            {
                List <Id> newIdlst = ProjPhaseAssignMap.get(pAssign.Project_Phase__c);
                newIdlst.add(pAssign.id); 
                ProjPhaseAssignMap.remove(pAssign.Project_Phase__c); 
                ProjPhaseAssignMap.put(pAssign.Project_Phase__c, newIdlst);
            }
            else
            {
                List <Id> newIdlst = new List <Id>();
                newIdlst.add(pAssign.id); 
                ProjPhaseAssignMap.put(pAssign.Project_Phase__c, newIdlst);
            }
            
            if(ProjAssignMap.containsKey(pAssign.Project_Phase__c))
            {
                List <Project_Assignment__c> newprjlst = ProjAssignMap.get(pAssign.Project_Phase__c);
                newprjlst.add(pAssign); 
                ProjAssignMap.remove(pAssign.Project_Phase__c); 
                ProjAssignMap.put(pAssign.Project_Phase__c, newprjlst);
            }
            else
            {
                List <Project_Assignment__c> newprjlst = new List <Project_Assignment__c>();
                newprjlst.add(pAssign);  
                ProjAssignMap.put(pAssign.Project_Phase__c, newprjlst);
            }            
        }         
         
       List<Vacation_Assignment__c> vacov = new List<Vacation_Assignment__c>();
        vacov = [select name, RoleSetup__c,Vacation__r.SDate__c,Vacation__r.EDate__c,Vacation__r.Days__c from Vacation_Assignment__c where Vacation__r.Capacity_Setup__c =:id];

        for(Vacation_Assignment__c vac: vacov )
        {   System.debug('Vacation-----------'+vac);
            if(VacactionOverviewMap.containsKey(vac.RoleSetup__c))
            {
                List <Vacation_Assignment__c> newVaclst = VacactionOverviewMap.get(vac.RoleSetup__c);
                newVaclst.add(vac); 
                VacactionOverviewMap.remove(vac.RoleSetup__c); 
                VacactionOverviewMap.put(vac.RoleSetup__c, newVaclst );             
            }
            else
            {
                List <Vacation_Assignment__c> newVaclst = new List <Vacation_Assignment__c>();
                newVaclst.add(vac); 
                VacactionOverviewMap.put(vac.RoleSetup__c, newVaclst );              
            }
        }
        
       List<Holiday_Assignment__c> holyassi=new List<Holiday_Assignment__c>();
        holyassi = [select name, RoleSetup__c, Holiday__r.SDate__c,Holiday__r.EDate__c,Holiday__r.Days__c from Holiday_Assignment__c where Holiday__r.Capacity_Setup__c = :id];
         for(Holiday_Assignment__c hol: holyassi)
         {
            if(HolidayMap.containsKey(hol.RoleSetup__c))
            {
                List <Holiday_Assignment__c> newHollst = HolidayMap.get(hol.RoleSetup__c);
                newHollst.add(hol); 
                HolidayMap.remove(hol.RoleSetup__c); 
                HolidayMap.put(hol.RoleSetup__c, newHollst);             
            }
            else
            {
                List <Holiday_Assignment__c> newHollst = new List <Holiday_Assignment__c>();
                newHollst.add(hol); 
                HolidayMap.put(hol.RoleSetup__c, newHollst);              
            }
         }
        List<Ongoing_Activity_Assignment__c> OngoingAty = [select name, RoleSetup__c, Ongoing_Activity__r.Plan__c,Ongoing_Activity__r.Design__c,Ongoing_Activity__r.Build__c,Ongoing_Activity__r.Test__c,Ongoing_Activity__r.UAT__c,Ongoing_Activity__r.Deploy__c,Ongoing_Activity__r.Adapt_Ongoing_Support__c
              from Ongoing_Activity_Assignment__c where Ongoing_Activity__r.Capacity__c = :id];                        
        
        for(Ongoing_Activity_Assignment__c ongAct: OngoingAty )
        {
            if(OnActivityMap.containsKey(ongAct.RoleSetup__c))
            {
                List <Ongoing_Activity_Assignment__c> newonglst = OnActivityMap.get(ongAct.RoleSetup__c);
                newonglst.add(ongAct); 
                OnActivityMap.remove(ongAct.RoleSetup__c); 
                OnActivityMap.put(ongAct.RoleSetup__c, newonglst);             
            }
            else
            {
                List <Ongoing_Activity_Assignment__c> newonglst = new List <Ongoing_Activity_Assignment__c>();
                newonglst .add(ongAct); 
                OnActivityMap.put(ongAct.RoleSetup__c, newonglst );              
            }
        }        
              
        List <Allocation_Assignment__c> rolealloc = [SELECT Project_Assignment__c, Name, Project_Assignment__r.Role__r.Name,
                Project_Assignment__r.Project_Phase__r.Focus_Area__c, Project_Assignment__r.Project_Phase__r.Focus_Area__r.name,
                Project_Assignment__r.Project_Phase__r.Plan_Days__c, 
                Project_Assignment__r.Project_Phase__r.Design_Days__c,
                Project_Assignment__r.Project_Phase__r.UAT_Days__c,
                Project_Assignment__r.Project_Phase__r.Deploy_Days__c,
                Project_Assignment__r.Project_Phase__r.AOS_Days__c,
                Project_Assignment__r.Project_Phase__r.Build_Days__c,
                Project_Assignment__r.Project_Phase__r.Test_Days__c,
                Project_Assignment__r.Project_Phase__r.PlanSDate__c,
                Project_Assignment__r.Project_Phase__r.PlanEDate__c,
                Project_Assignment__r.Project_Phase__r.DesignSDate__c, 
                Project_Assignment__r.Project_Phase__r.DesignEDate__c,
                Project_Assignment__r.Project_Phase__r.BuildSDate__c, 
                Project_Assignment__r.Project_Phase__r.BuildEDate__c,
                Project_Assignment__r.Project_Phase__r.TestSDate__c, 
                Project_Assignment__r.Project_Phase__r.TestEDate__c,
                Project_Assignment__r.Project_Phase__r.UAT_SDate__c, 
                Project_Assignment__r.Project_Phase__r.UAT_EDate__c,
                Project_Assignment__r.Project_Phase__r.DeploySDate__c,
                Project_Assignment__r.Project_Phase__r.DeployEDate__c,
                Project_Assignment__r.Project_Phase__r.AOS_SDate__c,
                Project_Assignment__r.Project_Phase__r.AOS_EDate__c,
                Project_Assignment__r.Role__r.No_of_Resources__c,
                Project_Assignment__r.Role__r.Onshore_Offshore__c,                
                Role_Allocation__r.Plan__c,
                Role_Allocation__r.Design__c,
                Role_Allocation__r.Build__c,
                Role_Allocation__r.Test__c, 
                Role_Allocation__r.UAT__c,
                Role_Allocation__r.Deploy__c, 
                Role_Allocation__r.Adapt_Ongoing_Support__c  
                FROM Allocation_Assignment__c WHERE Project_Assignment__c IN: projAssignIdLst];               
       
        for(Allocation_Assignment__c rAlloc: rolealloc )
        {
            if(ResAllocMap.containsKey(rAlloc.Project_Assignment__c))
            {
                List <Allocation_Assignment__c> newAlloclst = ResAllocMap.get(rAlloc.Project_Assignment__c);
                newAlloclst.add(rAlloc); 
                ResAllocMap.remove(rAlloc.Project_Assignment__c); 
                ResAllocMap.put(rAlloc.Project_Assignment__c, newAlloclst); 
                           
            }
            else
            {
                List <Allocation_Assignment__c> newAlloclst = new List <Allocation_Assignment__c>();
                newAlloclst.add(rAlloc); 
                ResAllocMap.put(rAlloc.Project_Assignment__c, newAlloclst);              
            }
        } 
        
        for(Project_Phase__c pPhase:projPhaseslst)
        {
            WavePhaseslst.add(new WaveDetailCls(pPhase));
        }                        
    }
    
    /**
        Inner Classes        
    */    
    public class WaveDetailCls
    {
        public Project_Phase__c ProjPhase {get;set;}
        public List<RoleDetails> rdet= new List<RoleDetails>() ;
        public String NameStr {get; set;}
        public Decimal TotalCapacityValue {get; set;}
        public Decimal TotalEstimateValue {get; set;}
        public String cellcolor {get; set;}
        public String fontcolor {get; set;}
        private Decimal T_Plan=0;
        private Decimal T_Design=0;
        private Decimal T_Build=0;
        private Decimal T_Test=0;
        private Decimal T_UAT=0;
        private Decimal T_Deploy=0;
        private Decimal T_AOS=0;
        
        public WaveDetailCls(Project_Phase__c pp)
        {
            ProjPhase = pp;
            TotalCapacityValue  = 0;
            NameStr  = pp.Name;
            cellcolor = '#FFFFFF';
            fontcolor = '#000000'; 
            List<Release_Estimation__c> rec = [SELECT TotalOfTotal__c from Release_Estimation__c WHERE id=:pp.Related_Estimate__c LIMIT 1];
            if(rec !=Null && rec.size()>0){
            TotalEstimateValue =  Math.round(rec.get(0).TotalOfTotal__c);            
            extractRoleDetails(pp.id);
            System.debug('PPPPPPPId'+pp.id);   
            }    
        }
        
        public List<RoleDetails> getrdet()
        {
            return rdet;
        }
                
        public Decimal getT_Plan(){
             System.debug('Plan111111'+T_Plan);
            return T_Plan;
           
        }
       
        public Decimal getT_Design(){
            return T_Design;
        }
        
        public Decimal getT_Build(){
            return T_Build;
        }
       
        public Decimal getT_Test(){
            return T_Test;
        }
        
        public Decimal getT_UAT(){
            return T_UAT;
        }   
       
        public Decimal getT_Deploy(){
            return T_Deploy;
        }   
        
        public Decimal getT_AOS(){
            return T_AOS;
        } 
        
        void extractRoleDetails(String phaseid)
        {
           /* For each object on RoleDetails List Calculate Capacity */
            integer inNumOfWaves=0;
            Decimal CapacityValue =0;
            
            System.debug('ProjAssignMap is '+ProjAssignMap);
            List <Project_Assignment__c> prjAssn = ProjAssignMap.get(phaseid); 
            System.debug('For phaseid:'+phaseid + ' ,prjAssn is:'+ prjAssn );
            
            if(prjAssn !=null)  
            {    
                System.debug('prjAssn111 '+prjAssn );          
                for (Project_Assignment__c pa :prjAssn )
                {
                    RoleDetails abc = new RoleDetails(pa.id, phaseid, pa.Role__c);
                    if(abc.isRoleAvail)
                       rdet.add(new RoleDetails(pa.id, phaseid, pa.Role__c));                                       
                } 
            }
            
            if(rdet!=null) 
            {
                for(RoleDetails Rdt : rdet)
                {                       
                    inNumOfWaves = [SELECT count() FROM Project_Assignment__c WHERE Role__c =: Rdt.Roleid ];
                    if (Rdt !=null){
                        CapacityValue = Rdt.Plan   + Rdt.Design + Rdt.Build + Rdt.Test + Rdt.UAT + Rdt.Deploy + Rdt.AOS;
                        T_Plan =T_Plan + Rdt.Plan;
                        System.debug('Plan-1-------'+ T_Plan);                      
                        T_Design=T_Design + Rdt.Design ; 
                        System.debug('Design-1-------'+T_Design);                          
                        T_Build = T_Build + Rdt.Build;
                        T_Test = T_Test + Rdt.Test;
                        T_Deploy = T_Deploy + Rdt.Deploy;
                        T_UAT = T_UAT +Rdt.UAT;
                        T_AOS = T_AOS + Rdt.AOS;
                    }
                    else
                          CapacityValue = 0;                   
                                
                    if(inNumOfWaves !=0){
                        CapacityValue =(CapacityValue) ;
                    }                   
                    else {
                        CapacityValue  = 0; 
                    }                      
                    TotalCapacityValue  = math.round(TotalCapacityValue  + CapacityValue)  ;   
                    
                } 
            }  
            if(TotalEstimateValue  > TotalCapacityValue)
            {
                cellcolor = '#CC2900;color:#FFFFFF';   // RED
                fontcolor = '#FFFFFF';
            }
            else if (TotalEstimateValue == TotalCapacityValue) 
            {
               cellcolor  = '#007A29;color:#FFFFFF';    // GREEN      
                fontcolor = '#FFFFFF';
            }
            else if (TotalCapacityValue*0.80 <= TotalEstimateValue)  
            {
                cellcolor  =  '#007A29;color:#FFFFFF';   
                fontcolor = '#FFFFFF';                
            }
            else
            {
                cellcolor  = '#FFCC00';   // YELLOW   
                fontcolor = '#000000';
            }
            System.debug('Cell Color is ' + cellcolor  );                                                 
        }     
    }    
    
    public class RoleDetails
    {
        public String RoleNames{get; set;}
        public String Roleid {get; set;}
        public String FocusArea{get; set;}
        public integer FocusAreaNum {get; set;}
        public decimal Plan  {get; set;}
        public Double Design{get; set;}
        public Double Build {get; set;}
        public Double Test  {get; set;}
        public Double UAT   {get; set;}
        public Double Deploy{get; set;}
        public Double AOS   {get; set;}
        public Double Totaldays {get;set;}
        public Integer Num = 0;
        
        //Checking if allocation available
        public Boolean isRoleAvail = true;
        
        public RoleDetails(String projAssignid, String phaseid, String Rid)
        {
            Roleid =   Rid;
            system.debug('projassignid-------'+projAssignid);
            system.debug('phaseid-------'+phaseid);  
            
            List <Allocation_Assignment__c> rolealloc = ResAllocMap.get(projAssignid);                  
            List<Holiday_Assignment__c> holyassi = HolidayMap.get(Roleid);            
            List<Vacation_Assignment__c> vacov = VacactionOverviewMap.get(Roleid);      
            List<Ongoing_Activity_Assignment__c> OngoingAty = OnActivityMap.get(Roleid);
            
            if(rolealloc!=null && rolealloc.size() > 0)
            {
                Allocation_Assignment__c allocAssign = rolealloc.get(0);
                RoleNames = allocAssign .Project_Assignment__r.Role__r.Name;
                FocusArea =  allocAssign .Project_Assignment__r.Project_Phase__r.Focus_Area__r.name;
                String Shore = allocAssign.Project_Assignment__r.Role__r.Onshore_Offshore__c;             
                Double totalholidays=0.00;
                Double totalvacation=0.00;
                Double totalongac=0.00;     
                Plan=calculate(allocAssign.Project_Assignment__r.Project_Phase__r.Plan_Days__c,Shore,allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c,allocAssign.Role_Allocation__r.Plan__c,totalholidays,totalvacation,totalongac);              
                Design=calculate(allocAssign.Project_Assignment__r.Project_Phase__r.Design_Days__c,Shore,allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c,allocAssign.Role_Allocation__r.Design__c,totalholidays,totalvacation,totalongac);                     
                Build=calculate(allocAssign.Project_Assignment__r.Project_Phase__r.Build_Days__c,Shore,allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c,allocAssign.Role_Allocation__r.Build__c,totalholidays,totalvacation,totalongac);                      
                Test=calculate(allocAssign.Project_Assignment__r.Project_Phase__r.Test_Days__c,Shore,allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c,allocAssign.Role_Allocation__r.Test__c,totalholidays,totalvacation,totalongac);           
                UAT=calculate(allocAssign.Project_Assignment__r.Project_Phase__r.UAT_Days__c,Shore,allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c,allocAssign.Role_Allocation__r.UAT__c,totalholidays,totalvacation,totalongac);                             
                Deploy=calculate(allocAssign.Project_Assignment__r.Project_Phase__r.Deploy_Days__c,Shore,allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c,allocAssign.Role_Allocation__r.Deploy__c,totalholidays,totalvacation,totalongac);                               
                AOS=calculate(allocAssign.Project_Assignment__r.Project_Phase__r.AOS_Days__c,Shore,allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c,allocAssign.Role_Allocation__r.Adapt_Ongoing_Support__c,totalholidays,totalvacation,totalongac);
                                            
                if(holyassi!=null)
                {   System.debug('Holidaytest-1'+holyassi);   
                    for(Holiday_Assignment__c hold:holyassi)
                    {  System.debug('Holidaytest-2'+hold);     
                    system.debug(+'---------'+hold.Holiday__r.SDate__c +'--Holiday_SDate__c--'    + '----------'+allocAssign.Project_Assignment__r.Project_Phase__r.PlanSDate__c+       hold.Holiday__r.EDate__c +allocAssign.Project_Assignment__r.Project_Phase__r.PlanEDate__c);
                       if(hold.Holiday__r.SDate__c < allocAssign.Project_Assignment__r.Project_Phase__r.PlanSDate__c && hold.Holiday__r.EDate__c > allocAssign.Project_Assignment__r.Project_Phase__r.PlanEDate__c)
                      {
                            hold.Holiday__r.Days__c = allocAssign.Project_Assignment__r.Project_Phase__r.Plan_days__c;
                            if(Shore!=null && Shore.equals('Onshore'))
                              
                                 Plan=Plan-((hold.Holiday__r.Days__c*8)* allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);                              
                             else 
                                  Plan=Plan-((hold.Holiday__r.Days__c*9)* allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);                                  
                      }       
                      
                       else
                       if((hold.Holiday__r.SDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.PlanSDate__c && hold.Holiday__r.SDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.PlanEDate__c)&&
                         (hold.Holiday__r.EDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.PlanSDate__c  && hold.Holiday__r.EDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.PlanEDate__c))
                       {                             
                              if(Shore!=null && Shore.equals('Onshore'))
                              
                                 Plan=Plan-((hold.Holiday__r.Days__c*8)* allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);                              
                              else 
                                  Plan=Plan-((hold.Holiday__r.Days__c*9)* allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);                                  
                       }
                       if(hold.Holiday__r.SDate__c < allocAssign.Project_Assignment__r.Project_Phase__r.DesignSDate__c && hold.Holiday__r.EDate__c > allocAssign.Project_Assignment__r.Project_Phase__r.DesignEDate__c)
                       { 
                           hold.Holiday__r.Days__c = allocAssign.Project_Assignment__r.Project_Phase__r.Design_days__c;       
                           if(Shore!=null && Shore.equals('Onshore'))
                                Design=Design-((hold.Holiday__r.Days__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                            else
                                Design=Design-((hold.Holiday__r.Days__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                       }
                       else                  
                       if((hold.Holiday__r.SDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.DesignSDate__c && hold.Holiday__r.SDate__c  <= allocAssign.Project_Assignment__r.Project_Phase__r.DesignEDate__c)&&
                          (hold.Holiday__r.EDate__c>=allocAssign.Project_Assignment__r.Project_Phase__r.DesignSDate__c  && hold.Holiday__r.EDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.DesignEDate__c))
                        {
                            if(Shore!=null && Shore.equals('Onshore'))
                                Design=Design-((hold.Holiday__r.Days__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                            else
                                Design=Design-((hold.Holiday__r.Days__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                        }
                        if(hold.Holiday__r.SDate__c < allocAssign.Project_Assignment__r.Project_Phase__r.BuildSDate__c && hold.Holiday__r.EDate__c > allocAssign.Project_Assignment__r.Project_Phase__r.BuildEDate__c)
                        { 
                             hold.Holiday__r.Days__c = allocAssign.Project_Assignment__r.Project_Phase__r.Build_days__c;       
                             if(Shore!=null && Shore.equals('Onshore'))
                                Build=Build-((hold.Holiday__r.Days__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                             else
                                Build=Build-((hold.Holiday__r.Days__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);                               
                        }
                        else                      
                        if((hold.Holiday__r.SDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.BuildSDate__c && hold.Holiday__r.SDate__c  <= allocAssign.Project_Assignment__r.Project_Phase__r.BuildEDate__c)&&
                          (hold.Holiday__r.EDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.BuildSDate__c  && hold.Holiday__r.EDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.BuildEDate__c))
                        {
                            if(Shore!=null && Shore.equals('Onshore'))
                                Build=Build-((hold.Holiday__r.Days__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                            else
                                Build=Build-((hold.Holiday__r.Days__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);                               
                        }
                        if(hold.Holiday__r.SDate__c < allocAssign.Project_Assignment__r.Project_Phase__r.TestSDate__c && hold.Holiday__r.EDate__c > allocAssign.Project_Assignment__r.Project_Phase__r.TestEDate__c)
                        { 
                             hold.Holiday__r.Days__c = allocAssign.Project_Assignment__r.Project_Phase__r.Test_days__c;       
                             if(Shore!=null && Shore.equals('Onshore'))
                                Test=Test-((hold.Holiday__r.Days__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                            else
                                Test=Test-((hold.Holiday__r.Days__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                        }
                        else
                        if((hold.Holiday__r.SDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.TestSDate__c && hold.Holiday__r.SDate__c  <= allocAssign.Project_Assignment__r.Project_Phase__r.TestEDate__c)&&
                           (hold.Holiday__r.EDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.TestSDate__c  && hold.Holiday__r.EDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.TestEDate__c))
                        {
                            if(Shore!=null && Shore.equals('Onshore'))
                                Test=Test-((hold.Holiday__r.Days__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                            else
                                Test=Test-((hold.Holiday__r.Days__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                        }
                        if(hold.Holiday__r.SDate__c < allocAssign.Project_Assignment__r.Project_Phase__r.UAT_SDate__c && hold.Holiday__r.EDate__c > allocAssign.Project_Assignment__r.Project_Phase__r.UAT_EDate__c)
                        { 
                             hold.Holiday__r.Days__c = allocAssign.Project_Assignment__r.Project_Phase__r.UAT_days__c;       
                             if(Shore!=null && Shore.equals('Onshore'))
                                UAT=UAT-((hold.Holiday__r.Days__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                            else
                                UAT=UAT-((hold.Holiday__r.Days__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                        }
                        else                        
                        if((hold.Holiday__r.SDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.UAT_SDate__c && hold.Holiday__r.SDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.UAT_EDate__c)&&
                           (hold.Holiday__r.EDate__c>= allocAssign.Project_Assignment__r.Project_Phase__r.UAT_SDate__c  && hold.Holiday__r.EDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.UAT_EDate__c))

                        {
                            if(Shore!=null && Shore.equals('Onshore'))
                                UAT=UAT-((hold.Holiday__r.Days__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                            else
                               UAT=UAT-((hold.Holiday__r.Days__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                        }
                        if(hold.Holiday__r.SDate__c < allocAssign.Project_Assignment__r.Project_Phase__r.DeploySDate__c && hold.Holiday__r.EDate__c > allocAssign.Project_Assignment__r.Project_Phase__r.DeployEDate__c)
                        { 
                             hold.Holiday__r.Days__c = allocAssign.Project_Assignment__r.Project_Phase__r.Deploy_days__c;       
                             if(Shore!=null && Shore.equals('Onshore'))
                                Deploy=Deploy-((hold.Holiday__r.Days__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                            else
                                Deploy=Deploy-((hold.Holiday__r.Days__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                       }
                       else             
                       if((hold.Holiday__r.SDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.DeploySDate__c && hold.Holiday__r.SDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.DeployEDate__c)&&
                          (hold.Holiday__r.EDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.DeploySDate__c  && hold.Holiday__r.EDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.DeployEDate__c))
                        {
                            if(Shore!=null && Shore.equals('Onshore'))
                                Deploy=Deploy-((hold.Holiday__r.Days__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                            else
                                Deploy=Deploy-((hold.Holiday__r.Days__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                        }
                        if(hold.Holiday__r.SDate__c < allocAssign.Project_Assignment__r.Project_Phase__r.AOS_SDate__c && hold.Holiday__r.EDate__c > allocAssign.Project_Assignment__r.Project_Phase__r.AOS_EDate__c)
                        { 
                             hold.Holiday__r.Days__c = allocAssign.Project_Assignment__r.Project_Phase__r.AOS_Days__c;       
                             if(Shore!=null && Shore.equals('Onshore'))
                                AOS=AOS-((hold.Holiday__r.Days__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                            else
                                AOS=AOS-((hold.Holiday__r.Days__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                       }
                       else   
                       if((hold.Holiday__r.SDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.AOS_SDate__c && hold.Holiday__r.SDate__c  <= allocAssign.Project_Assignment__r.Project_Phase__r.AOS_EDate__c)&&
                          (hold.Holiday__r.EDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.AOS_SDate__c  && hold.Holiday__r.EDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.AOS_EDate__c))
                        {
                            if(Shore!=null && Shore.equals('Onshore'))
                                AOS=AOS-((hold.Holiday__r.Days__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                            else
                                AOS=AOS-((hold.Holiday__r.Days__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                        }                                                             
                     }                     
                }                        
                if(vacov!=null)  
                {   System.debug('Vacation------------'+vacov );
                    for(Vacation_Assignment__c vacover:vacov)
                    {   System.debug('Vacation2------------'+vacover);                  
                       if(vacover.Vacation__r.SDate__c < allocAssign.Project_Assignment__r.Project_Phase__r.PlanSDate__c && vacover.Vacation__r.EDate__c > allocAssign.Project_Assignment__r.Project_Phase__r.PlanEDate__c)
                       {  
                          vacover.Vacation__r.Days__c = allocAssign.Project_Assignment__r.Project_Phase__r.Plan_Days__c;      
                         if(Shore!=null && Shore.equals('Onshore'))                                  
                              Plan=Plan-(vacover.Vacation__r.Days__c*8);    
                            else                               
                              Plan=Plan-(vacover.Vacation__r.Days__c*9);         
                        }
                        else 
                        if    
                        ((vacover.Vacation__r.SDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.PlanSDate__c && vacover.Vacation__r.SDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.PlanEDate__c)&&
                         (vacover.Vacation__r.EDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.PlanSDate__c && vacover.Vacation__r.EDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.PlanEDate__c))
                        {
                           System.debug('Vacation_11-------------'+vacover);
                            if(Shore!=null && Shore.equals('Onshore'))
                                Plan=Plan-(vacover.Vacation__r.Days__c*8);                          
                            else                               
                                Plan=Plan-(vacover.Vacation__r.Days__c*9);    
                        }
                        
                        if(vacover.Vacation__r.SDate__c < allocAssign.Project_Assignment__r.Project_Phase__r.DesignSDate__c && vacover.Vacation__r.EDate__c > allocAssign.Project_Assignment__r.Project_Phase__r.DesignSDate__c)
                        {
                          vacover.Vacation__r.Days__c = allocAssign.Project_Assignment__r.Project_Phase__r.Design_Days__c;
              
                         if(Shore!=null && Shore.equals('Onshore'))  
                                Design=Design-(vacover.Vacation__r.Days__c*8);
                            else                                
                                Design=Design-(vacover.Vacation__r.Days__c*9);  
                        }
                        else 
                        if((vacover.Vacation__r.SDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.DesignSDate__c && vacover.Vacation__r.SDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.DesignEDate__c)&&
                           (vacover.Vacation__r.EDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.DesignSDate__c && vacover.Vacation__r.EDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.DesignEDate__c))
                        {
                            if(Shore!=null && Shore.equals('Onshore'))  
                                Design=Design-(vacover.Vacation__r.Days__c*8);
                            else                                
                                Design=Design-(vacover.Vacation__r.Days__c*9);          
                        }
                        if(vacover.Vacation__r.SDate__c < allocAssign.Project_Assignment__r.Project_Phase__r.BuildSDate__c && vacover.Vacation__r.EDate__c > allocAssign.Project_Assignment__r.Project_Phase__r.BuildSDate__c)
                        {
                          vacover.Vacation__r.Days__c = allocAssign.Project_Assignment__r.Project_Phase__r.Build_Days__c;
              
                         if(Shore!=null && Shore.equals('Onshore'))  
                                Build=Build-(vacover.Vacation__r.Days__c*8);
                            else                                
                                Build=Build-(vacover.Vacation__r.Days__c*9);  
                        }
                       else               
                       if((vacover.Vacation__r.SDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.BuildSDate__c && vacover.Vacation__r.SDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.BuildEDate__c)&&
                          (vacover.Vacation__r.EDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.BuildSDate__c && vacover.Vacation__r.EDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.BuildEDate__c))
                       {
                            if(Shore!=null && Shore.equals('Onshore'))
                                Build=Build-(vacover.Vacation__r.Days__c*8);
                            else
                                Build=Build-(vacover.Vacation__r.Days__c*9);
                       }
                       if(vacover.Vacation__r.SDate__c < allocAssign.Project_Assignment__r.Project_Phase__r.TestSDate__c && vacover.Vacation__r.EDate__c > allocAssign.Project_Assignment__r.Project_Phase__r.TestSDate__c)
                        {
                          vacover.Vacation__r.Days__c = allocAssign.Project_Assignment__r.Project_Phase__r.Test_Days__c;
                          if(Shore!=null && Shore.equals('Onshore'))  
                                Test=Test-(vacover.Vacation__r.Days__c*8);
                            else                                
                                Test=Test-(vacover.Vacation__r.Days__c*9);  
                        }
                        else
                        if((vacover.Vacation__r.SDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.TestSDate__c && vacover.Vacation__r.SDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.TestEDate__c)&&
                         (vacover.Vacation__r.EDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.TestSDate__c && vacover.Vacation__r.EDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.TestEDate__c))
                        {

                            if(Shore!=null && Shore.equals('Onshore'))
                                Test=Test-(vacover.Vacation__r.Days__c*8);
                            else
                                Test=Test-(vacover.Vacation__r.Days__c*9);
                        }
                        if(vacover.Vacation__r.SDate__c < allocAssign.Project_Assignment__r.Project_Phase__r.UAT_SDate__c && vacover.Vacation__r.EDate__c > allocAssign.Project_Assignment__r.Project_Phase__r.UAT_EDate__c)
                        {
                          vacover.Vacation__r.Days__c = allocAssign.Project_Assignment__r.Project_Phase__r.UAT_Days__c;
              
                         if(Shore!=null && Shore.equals('Onshore'))  
                                UAT=UAT-(vacover.Vacation__r.Days__c*8);
                            else                                
                                 UAT=UAT-(vacover.Vacation__r.Days__c*9);
                        }        
                       else 
                       if((vacover.Vacation__r.SDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.UAT_SDate__c && vacover.Vacation__r.SDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.UAT_EDate__c)&&
                          (vacover.Vacation__r.EDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.UAT_SDate__c && vacover.Vacation__r.EDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.UAT_EDate__c))
                       {
                            if(Shore!=null && Shore.equals('Onshore'))
                                UAT=UAT-(vacover.Vacation__r.Days__c*8);
                            else
                                UAT=UAT-(vacover.Vacation__r.Days__c*9);
                       }
                       if(vacover.Vacation__r.SDate__c < allocAssign.Project_Assignment__r.Project_Phase__r.DeploySDate__c && vacover.Vacation__r.EDate__c > allocAssign.Project_Assignment__r.Project_Phase__r.DeployEDate__c)
                        {
                            vacover.Vacation__r.Days__c = allocAssign.Project_Assignment__r.Project_Phase__r.Deploy_Days__c;
                            if(Shore!=null && Shore.equals('Onshore'))
                                Deploy=Deploy-(vacover.Vacation__r.Days__c*8);
                            else
                                Deploy=Deploy-(vacover.Vacation__r.Days__c*9);
                        }
                       else
                        if((vacover.Vacation__r.SDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.DeploySDate__c && vacover.Vacation__r.SDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.DeployEDate__c)&&
                           (vacover.Vacation__r.EDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.DeploySDate__c && vacover.Vacation__r.EDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.DeployEDate__c))
                        {    if(Shore!=null && Shore.equals('Onshore'))
                                Deploy=Deploy-(vacover.Vacation__r.Days__c*8);
                            else
                                Deploy=Deploy-(vacover.Vacation__r.Days__c*9);
                        }
                        if(vacover.Vacation__r.SDate__c < allocAssign.Project_Assignment__r.Project_Phase__r.AOS_SDate__c && vacover.Vacation__r.EDate__c > allocAssign.Project_Assignment__r.Project_Phase__r.AOS_EDate__c)
                        {
                            vacover.Vacation__r.Days__c = allocAssign.Project_Assignment__r.Project_Phase__r.AOS_days__c;
                            if(Shore!=null && Shore.equals('Onshore'))
                                AOS=AOS-(vacover.Vacation__r.Days__c*8);
                            else
                                AOS=AOS-(vacover.Vacation__r.Days__c*9);
                        }
                       else
                       if((vacover.Vacation__r.SDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.AOS_SDate__c && vacover.Vacation__r.SDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.AOS_EDate__c)&&
                          (vacover.Vacation__r.EDate__c >= allocAssign.Project_Assignment__r.Project_Phase__r.AOS_SDate__c && vacover.Vacation__r.EDate__c <= allocAssign.Project_Assignment__r.Project_Phase__r.AOS_EDate__c))
                       {

                            if(Shore!=null && Shore.equals('Onshore'))
                                AOS=AOS-(vacover.Vacation__r.Days__c*8);
                            else
                                AOS=AOS-(vacover.Vacation__r.Days__c*9);
                       }
                    }  
                } 
                
                if(OngoingAty!=null)
                {                   
                    for(Ongoing_Activity_Assignment__c onga:OngoingAty)
                    {                         
                        if(Shore!=null && Shore.equals('Onshore'))
                            Plan=Plan-((onga.Ongoing_Activity__r.Plan__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                        else
                            Plan=Plan-((onga.Ongoing_Activity__r.Plan__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);    
                       
                        if(Shore!=null && Shore.equals('Onshore'))
                            Design=Design-((onga.Ongoing_Activity__r.Design__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                        else
                            Design=Design-((onga.Ongoing_Activity__r.Design__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);                            
                        
                        if(Shore!=null && Shore.equals('Onshore'))
                            Build=Build-((onga.Ongoing_Activity__r.Build__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                        else
                            Build=Build-((onga.Ongoing_Activity__r.Build__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);                        
                       
                        if(Shore!=null && Shore.equals('Onshore'))
                            Test=Test-((onga.Ongoing_Activity__r.Test__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                        else
                            Test=Test-((onga.Ongoing_Activity__r.Test__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                       
                        if(Shore!=null && Shore.equals('Onshore'))
                            UAT=UAT-((onga.Ongoing_Activity__r.UAT__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                        else
                            UAT=UAT-((onga.Ongoing_Activity__r.UAT__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);                             
                       
                        if(Shore!=null && Shore.equals('Onshore'))
                            Deploy=Deploy-((onga.Ongoing_Activity__r.Deploy__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                        else
                            Deploy=Deploy-((onga.Ongoing_Activity__r.Deploy__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                        
                        if(Shore!=null && Shore.equals('Onshore'))
                            AOS=AOS-((onga.Ongoing_Activity__r.Adapt_Ongoing_Support__c*8)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);
                        else
                            AOS=AOS-((onga.Ongoing_Activity__r.Adapt_Ongoing_Support__c*9)*allocAssign.Project_Assignment__r.Role__r.No_of_Resources__c);                                                      
                    }

                }   
                system.debug('shoreeeeeeeeeeee'+Shore);        
                if(Shore!=null && Shore.equals('Onshore'))
                {
                    Plan = math.round(Plan/8);
                    Design= math.round(Design/8);
                    Build= math.round(Build/8);
                    Test= math.round(Test/8);
                    UAT= math.round(UAT/8);
                    Deploy= math.round(Deploy/8);
                    AOS= math.round(AOS/8);
                } 
                else if(Shore.equals('Offshore'))
                {
                    
                    Plan = math.round(Plan/9);
                    Design= math.round(Design/9);
                    Build= math.round(Build/9);
                    Test= math.round(Test/9);
                    UAT= math.round(UAT/9);
                    Deploy= math.round(Deploy/9);
                    AOS= math.round(AOS/9);
                }                     

            }            
            else
                isRoleAvail = false;                          
        }
        
        public Double calculate(Decimal days,String shor,Decimal resources,Decimal alloc,Double holid,Double vac,Double ongacti){
            Double finalplan=days;
            System.debug('plan-----------'+finalplan);
            if(finalplan != null && resources != null && alloc != null)
                
                finalplan=finalplan*resources*(alloc/100);
            if(shor=='Onshore'){
                finalplan=finalplan*8;
                system.debug('plan3-----'+finalplan);
            }
            else{
                finalplan=finalplan*9;
                system.debug('plan4-----'+finalplan);
            }               
            return finalplan;    
        }  
        
    }
    /**
        All Getters and Setters for  CapacitySummaryNM class      
    **/
    public CapacityDetailEstimator__c getCapacityDetail()
    {
        return capSetobj ;
    }        
    public List<WaveDetailCls> getEachPhaseDetail()
    {
        return WavePhaseslst ;
    }
    public pagereference editpage(){
        Id phaseid=system.currentpagereference().getparameters().get('phaseid');
        Pagereference p = new pagereference('/apex/ProjectPhasesetupEdit?id='+phaseid);
        return p;
    }
   
}