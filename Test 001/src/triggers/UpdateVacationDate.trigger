trigger UpdateVacationDate on Vacation_Assignment__c(After insert, before update)
  { 
     for(Vacation_Assignment__c aa : Trigger.new)
     {
       Vacation_Assignment__c ha=[select Vacation__c,Vacation__r.Start_Date1__c, Vacation__r.End_Date1__c from Vacation_Assignment__c where RoleSetup__c =: aa.RoleSetup__c];
       Vacation_Overview__c hd=[select Start_Date1__c, End_Date1__c from Vacation_Overview__c where id =:ha.Vacation__c]; 
       Project_Assignment__c pa=[select Project_Phase__r.PlanSDate__c,Project_Phase__r.PlanEDate__c,
       Project_Phase__r.DesignSDate__c,Project_Phase__r.DesignEDate__c,
       Project_Phase__r.BuildSDate__c,Project_Phase__r.BuildEDate__c,
       Project_Phase__r.TestSDate__c,Project_Phase__r.TestEDate__c,
       Project_Phase__r.UAT_SDate__c,Project_Phase__r.UAT_EDate__c,
       Project_Phase__r.DeploySDate__c,Project_Phase__r.DeployEDate__c,
       Project_Phase__r.AOS_SDate__c,Project_Phase__r.AOS_EDate__c from Project_Assignment__c where Role__c =: aa.RoleSetup__c];       
       Date HSDate,HEDate,PSDate,PEDate,DeSDate,DeEDate,BSDate,BEDate,TSDate,TEDate,DSDate,DEDate,ASDate,AEDate,USDate,UEDate;
       HSDate = ha.Vacation__r.Start_Date1__c;
       HEdate = ha.Vacation__r.End_Date1__c;
       PSdate = pa.Project_Phase__r.PlanSDate__c;
       PEDate = pa.Project_Phase__r.PlanEDate__c;
       DeSDate =pa.Project_Phase__r.DesignSDate__c;
       DeEDate =pa.Project_Phase__r.DesignEDate__c;
       BSDate = pa.Project_Phase__r.BuildSDate__c;
       BEDate =pa.Project_Phase__r.BuildEDate__c;
       TSDate =pa.Project_Phase__r.TestSDate__c;
       TEDate =pa.Project_Phase__r.TestEDate__c;
       DSDate =pa.Project_Phase__r.DeploySDate__c;
       DEDate =pa.Project_Phase__r.DeployEDate__c;
       USDate =pa.Project_Phase__r.UAT_SDate__c;
       UEDate =pa.Project_Phase__r.UAT_EDate__c;
       ASDate =pa.Project_Phase__r.DeploySDate__c;
       AEDate =pa.Project_Phase__r.DeployEDate__c;
       
       if(HSDate < PSdate && HEdate <= PEdate)
       {
          hd.Start_Date1__c = PSdate;
          update hd;
       }   
       HSDate=hd.Start_Date1__c;
       if(HSDate >= PSDate && HEDate > PEDate)
       {
        hd.End_Date1__c = PEDate;
        update hd;
       }
        HEDate=hd.End_Date1__c;
      if(HSDate < DeSdate && HEdate <= DeEdate)
       {
          hd.Start_Date1__c = DeSdate;
          update hd;
       }
        HSDate=hd.Start_Date1__c;
       if(HSDate >= DeSDate && HEDate > DeEDate)
       {
        hd.End_Date1__c = DeEDate;
        update hd;
       }
        HEDate=hd.End_Date1__c;
     
     }                     
  }