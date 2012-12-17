@isTest
private class TestCapacitySummaryNM{
/*
 public static Account acc01;
 public static Opportunity opp01; 
*/
 static testMethod void testCapacitySummaryNM(){         
   /* acc01 = new Account(name='TestAccount');
    Insert(acc01);
    
    opp01=new Opportunity(Name='SFDC',
                          StageName='Test Prospecting',
                          CloseDate=Date.toDay());                                     
    insert(opp01);
  */  
    Release__c rel= new Release__c();
    rel.Name='SFDC Demo';
    insert rel;
    
    
    
    CapacityDetailEstimator__c capSetobj = new CapacityDetailEstimator__c();
    capSetobj.Name='SFDC Test';
    //capSetobj.Client_Name__c=acc01.id;                                                    
    capSetobj.Release__c=rel.id;                                                                  
    //capSetobj.Project_Name__c=opp01.id;                                                                  
    insert capSetobj ; 
    
    
    
   
   ApexPages.currentPage().getParameters().put('id',capSetobj.id);
   
    //CapacityDetailEstimator__c capSetobj1 = new CapacityDetailEstimator__c();
    //System.debug('CapacityDetailEstimator factor setup values-----'+capSetobj.Name); 
   
    RoleSetup__c role= new RoleSetup__c(Name='SFDC Developer',
                                       No_of_Resources__c=25,
                                       Onshore_Offshore__c='onshore');
    role.Capacity__c = capSetobj.Id;
    insert role;
    
    RoleSetup__c role11= new RoleSetup__c(Name='SFDC Developer',
                                       No_of_Resources__c=25,
                                       Onshore_Offshore__c='offshore');
    role11.Capacity__c = capSetobj.Id;
    insert role11;
    
    
  
    Release_Estimation__c tRel=new Release_Estimation__c();  
    insert tRel;
    
   
    
    Project_Phase__c proRel= new Project_Phase__c();
    proRel.Focus_Area__c=rel.id;
    proRel.Related_Estimate__c=tRel.id;
    proRel.Capacity__c = capSetobj.id;
    proRel.Design_Days__c =5;
    proRel.Design_Start_Date__c='11/26/2010';
    proRel.Design_End_Date__c='11/29/2010';
    proRel.Plan_Days__c =10;
    proRel.Plan_Start_Date__c='11/26/2010';
    proRel.Plan_End_Date__c='11/29/2010';
    proRel.Build_Days__c =10;
    proRel.Build_Start_Date__c='11/26/2010';
    proRel.Build_End_Date__c='11/29/2010';
    proRel.UAT_Days__c =10;
    proRel.UAT_Start_Date__c='11/26/2010';
    proRel.UAT_End_Date__c='11/29/2010';
    proRel.Test_Days__c =10;
    proRel.Test_Start_Date__c='11/26/2010';
    proRel.Test_End_Date__c='11/29/2010';
    proRel.Deploy_Days__c =10;
    proRel.Deploy_Start_Date__c='11/26/2010';
    proRel.Deploy_End_Date__c='11/29/2010';
    proRel.AOS_Days__c =10;
    proRel.AOS_Start_Date__c='11/26/2010';
    proRel.AOS_End_Date__c='11/29/2010';
    insert proRel;
   
    Project_Assignment__c ProjAssign = new Project_Assignment__c();    
    ProjAssign.Role__c=role.id;
    ProjAssign.Project_Phase__c= proRel.id;
    insert ProjAssign;
    
    
    Project_Assignment__c ProjAssign11 = new Project_Assignment__c();    
    ProjAssign11.Role__c=role11.id;
    ProjAssign11.Project_Phase__c= proRel.id;
    insert ProjAssign11;
    
    
    
    Role_Allocation__c roleAllo = new Role_Allocation__c();
    roleAllo.Name='Build';
    roleAllo.Capacity__c=capSetobj.Id;
    roleAllo.Project_Assignment__c=ProjAssign.id;
    roleAllo.Role_Description__c=role.id;
    insert roleAllo;
    
    
    Role_Allocation__c roleAllo11 = new Role_Allocation__c();
    roleAllo11.Name='Build';
    roleAllo11.Capacity__c=capSetobj.Id;
    roleAllo11.Project_Assignment__c=ProjAssign11.id;
    roleAllo11.Role_Description__c=role11.id;
    insert roleAllo11;
    
    
    
    Allocation_Assignment__c ResAlloc =new Allocation_Assignment__c();
    ResAlloc.Role_Allocation__c=roleAllo.id;
    ResAlloc.Project_Assignment__c=ProjAssign.id;
    ResAlloc.Role_Summary_del__c=role.id;
    insert ResAlloc;
    
    
    Allocation_Assignment__c ResAlloc11 =new Allocation_Assignment__c();
    ResAlloc11.Role_Allocation__c=roleAllo11.id;
    ResAlloc11.Project_Assignment__c=ProjAssign11.id;
    ResAlloc11.Role_Summary_del__c=role11.id;
    insert ResAlloc11;
    
    
    Vacation_Overview__c vac = new Vacation_Overview__c();
    vac.Name='Fever';
    vac.Capacity_Setup__c = capSetobj.Id;
    vac.Start_Date1__c=Date.toDay()- 5;
    vac.End_Date1__c=Date.toDay();
    vac.Days__c=2;
    insert Vac;
   
    Vacation_Assignment__c VacAssign = new Vacation_Assignment__c();
    VacAssign.Vacation__c=vac.id;
    VacAssign.Release_Assignment__c=ProjAssign.id;
    VacAssign.RoleSetup__c=role.id;
    insert VacAssign;
    
    Vacation_Assignment__c VacAssign11 = new Vacation_Assignment__c();
    VacAssign11.Vacation__c=vac.id;
    VacAssign11.Release_Assignment__c=ProjAssign11.id;
    VacAssign11.RoleSetup__c=role11.id;
    insert VacAssign11;
    
    
    
    Holiday_Details__c hDay = new Holiday_Details__c();
    hDay.Name='Dewali';
    hDay.Capacity_Setup__c = capSetobj.Id;
    hDay.Start_Date1__c=Date.toDay() - 5;
    hDay.End_Date1__c=Date.toDay();
    hDay.Days__c=2;
    insert hDay;
    
    Holiday_Assignment__c holiday =new Holiday_Assignment__c();
    holiday.Holiday__c=hDay.id;
    holiday.Release_Assignment__c=ProjAssign.id;
    holiday.RoleSetup__c=role.id;
    insert holiday;
    
    
    Holiday_Assignment__c holiday11 =new Holiday_Assignment__c();
    holiday11.Holiday__c=hDay.id;
    holiday11.Release_Assignment__c=ProjAssign11.id;
    holiday11.RoleSetup__c=role11.id;
    insert holiday11;
     
    Ongoing_Activity__c ongoing = new Ongoing_Activity__c();
    ongoing.Capacity__c = capSetobj.Id;
    ongoing.Plan__c=2;
    ongoing.Design__c=2;
    ongoing.UAT__c=2;
    ongoing.Test__c=2;
    ongoing.Deploy__c=2;
    ongoing.Build__c=2;
    ongoing.Adapt_Ongoing_Support__c=2;
    insert ongoing;
    
    Ongoing_Activity_Assignment__c OnActivity = new Ongoing_Activity_Assignment__c();
    OnActivity.Release_Assignment__c=ProjAssign.id;
    OnActivity.RoleSetup__c=role.id;
    OnActivity.Ongoing_Activity__c=ongoing.id;
    insert OnActivity;
    
    Ongoing_Activity_Assignment__c OnActivity11 = new Ongoing_Activity_Assignment__c();
    OnActivity11.Release_Assignment__c=ProjAssign11.id;
    OnActivity11.RoleSetup__c=role11.id;
    OnActivity11.Ongoing_Activity__c=ongoing.id;
    insert OnActivity11;
    
    Release__c rel2= new Release__c();
    rel2.Name='SFDC Demo2';
    insert rel2;
    
    RoleSetup__c role2= new RoleSetup__c(Name='SFDC Developer',
                                       No_of_Resources__c=5,
                                       Onshore_Offshore__c='Offshore');
    role2.Capacity__c = capSetobj.Id;
    insert role2;
    
    
    RoleSetup__c role22= new RoleSetup__c(Name='SFDC Developer',
                                       No_of_Resources__c=5,
                                       Onshore_Offshore__c='Onshore');
    role22.Capacity__c = capSetobj.Id;
    insert role22;
    
    
    Release_Estimation__c tRe2=new Release_Estimation__c();  
    insert tRe2;
   
    Project_Phase__c proRel2= new Project_Phase__c();
    proRel.Focus_Area__c=rel2.id;
    proRel2.Related_Estimate__c=tRe2.id;
    proRel2.Capacity__c = capSetobj.id;
    proRel2.Design_Days__c =10;
    proRel2.Design_Start_Date__c='11/25/2010';
    proRel2.Design_End_Date__c='11/30/2010';
    proRel2.Plan_Days__c =10;
    proRel2.Plan_Start_Date__c='11/25/2010';
    proRel2.Plan_End_Date__c='11/30/2010';
    proRel2.Build_Days__c =10;
    proRel2.Build_Start_Date__c='11/25/2010';
    proRel2.Build_End_Date__c='11/30/2010';
    proRel2.UAT_Days__c =10;
    proRel2.UAT_Start_Date__c='11/25/2010';
    proRel2.UAT_End_Date__c='11/30/2010';
    proRel2.Test_Days__c =10;
    proRel2.Test_Start_Date__c='11/25/2010';
    proRel2.Test_End_Date__c='11/30/2010';
    proRel2.Deploy_Days__c =10;
    proRel2.Deploy_Start_Date__c='11/25/2010';
    proRel2.Deploy_End_Date__c='11/30/2010';
    proRel2.AOS_Days__c =10;
    proRel2.AOS_Start_Date__c='11/25/2010';
    proRel2.AOS_End_Date__c='11/30/2010';
    insert proRel2;
   
    Project_Assignment__c ProjAssign2 = new Project_Assignment__c();    
    ProjAssign2.Role__c=role2.id;
    ProjAssign2.Project_Phase__c= proRel2.id;
    insert ProjAssign2;
    
    
    Project_Assignment__c ProjAssign22 = new Project_Assignment__c();    
    ProjAssign22.Role__c=role22.id;
    ProjAssign22.Project_Phase__c= proRel2.id;
    insert ProjAssign22;
    
    
    Role_Allocation__c roleAllo2 = new Role_Allocation__c();
    roleAllo2.Name='Build';
    roleAllo2.Capacity__c=capSetobj.Id;
    roleAllo2.Project_Assignment__c=ProjAssign2.id;
    roleAllo2.Role_Description__c=role2.id;
    insert roleAllo2;
    
    
    Role_Allocation__c roleAllo22 = new Role_Allocation__c();
    roleAllo22.Name='Build';
    roleAllo22.Capacity__c=capSetobj.Id;
    roleAllo22.Project_Assignment__c=ProjAssign22.id;
    roleAllo22.Role_Description__c=role22.id;
    insert roleAllo22;
    
    
    Allocation_Assignment__c ResAlloc2 =new Allocation_Assignment__c();
    ResAlloc2.Role_Allocation__c=roleAllo2.id;
    ResAlloc2.Project_Assignment__c=ProjAssign2.id;
    ResAlloc2.Role_Summary_del__c=role2.id;
    insert ResAlloc2;
    
    
    Allocation_Assignment__c ResAlloc22 =new Allocation_Assignment__c();
    ResAlloc22.Role_Allocation__c=roleAllo22.id;
    ResAlloc22.Project_Assignment__c=ProjAssign22.id;
    ResAlloc22.Role_Summary_del__c=role22.id;
    insert ResAlloc22;
    
    Vacation_Overview__c vac2 = new Vacation_Overview__c();
    vac2.Name='Fever';
    vac2.Capacity_Setup__c = capSetobj.Id;
    vac2.Start_Date1__c=Date.toDay()-4;
    vac2.End_Date1__c=Date.toDay();
    vac2.Days__c=2;
    insert Vac2;
    
    Vacation_Assignment__c VacAssign2 = new Vacation_Assignment__c();
    VacAssign2.Vacation__c=vac2.id;
    VacAssign2.Release_Assignment__c=ProjAssign2.id;
    VacAssign2.RoleSetup__c=role2.id;
    insert VacAssign2;
    
    Vacation_Assignment__c VacAssign22 = new Vacation_Assignment__c();
    VacAssign22.Vacation__c=vac2.id;
    VacAssign22.Release_Assignment__c=ProjAssign22.id;
    VacAssign22.RoleSetup__c=role22.id;
    insert VacAssign22;
    
    
    Holiday_Details__c hDay2 = new Holiday_Details__c();
    hDay2.Name='Dewali';
    hDay2.Capacity_Setup__c = capSetobj.Id;
    hDay2.Start_Date1__c=Date.toDay()-4;
    hDay2.End_Date1__c=Date.toDay();
    hDay2.Days__c=2;
    insert hDay2;
    
    Holiday_Assignment__c holiday2 =new Holiday_Assignment__c();
    holiday2.Holiday__c=hDay2.id;
    holiday2.Release_Assignment__c=ProjAssign2.id;
    holiday2.RoleSetup__c=role2.id;
    insert holiday2;
    
    
    Holiday_Assignment__c holiday22 =new Holiday_Assignment__c();
    holiday22.Holiday__c=hDay2.id;
    holiday22.Release_Assignment__c=ProjAssign22.id;
    holiday22.RoleSetup__c=role22.id;
    insert holiday22;
    
    Ongoing_Activity__c ongoing2 = new Ongoing_Activity__c();
    ongoing2.Capacity__c = capSetobj.Id;
    ongoing2.Plan__c=2;
    ongoing2.Design__c=2;
    ongoing2.UAT__c=2;
    ongoing2.Test__c=2;
    ongoing2.Deploy__c=2;
    ongoing2.Build__c=2;
    ongoing2.Adapt_Ongoing_Support__c=2;
    insert ongoing2;
    
    Ongoing_Activity_Assignment__c OnActivity2 = new Ongoing_Activity_Assignment__c();
    OnActivity2.Release_Assignment__c=ProjAssign2.id;
    OnActivity2.RoleSetup__c=role2.id;
    OnActivity2.Ongoing_Activity__c=ongoing2.id;
    insert OnActivity2;
    
    
    Ongoing_Activity_Assignment__c OnActivity22 = new Ongoing_Activity_Assignment__c();
    OnActivity22.Release_Assignment__c=ProjAssign22.id;
    OnActivity22.RoleSetup__c=role22.id;
    OnActivity22.Ongoing_Activity__c=ongoing2.id;
    insert OnActivity22;
    
     ApexPages.standardController cont=new ApexPages.standardController(capSetobj); 
     CapacitySummaryNM cpSummaryNM = new CapacitySummaryNM (cont);
     cpSummaryNM.calculatePhaseDetails();
     cpSummaryNM.getCapacityDetail();
     
     CapacitySummaryNM.WaveDetailCls waveCal=new CapacitySummaryNM.WaveDetailCls(proRel);
     waveCal.getT_Design();
     waveCal.getT_Plan();
     waveCal.getT_Build();
     waveCal.getT_Test();
     waveCal.getT_UAT();
     waveCal.getT_Deploy();
     waveCal.getT_AOS();
     waveCal.getrdet();
   
     CapacitySummaryNM.RoleDetails roleDetails =new CapacitySummaryNM.RoleDetails(ResAlloc.Project_Assignment__c,proRel.Focus_Area__c,role.id);
     cpSummaryNM.editpage();
     
  }
}