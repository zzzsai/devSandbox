trigger UpdateDate on Holiday_Assignment__c(before insert, before update)
  {
     for(Holiday_Assignment__c aa : Trigger.new)
     {
       Holiday_Assignment__c ha=[select Holiday__c,Holiday__r.Start_Date1__c, Holiday__r.End_Date1__c from Holiday_Assignment__c where RoleSetup__c =: aa.RoleSetup__c];
       Holiday_Details__c hd=[select Start_Date1__c, End_Date1__c from Holiday_Details__c where id =:ha.Holiday__c]; 
       Project_Assignment__c pa=[select Project_Phase__r.PlanSDate__c,Project_Phase__r.PlanEDate__c,
       Project_Phase__r.DesignSDate__c,Project_Phase__r.DesignEDate__c,
       Project_Phase__r.BuildSDate__c,Project_Phase__r.BuildEDate__c,
       Project_Phase__r.TestSDate__c,Project_Phase__r.TestEDate__c,
       Project_Phase__r.UAT_SDate__c,Project_Phase__r.UAT_EDate__c,
       Project_Phase__r.DeploySDate__c,Project_Phase__r.DeployEDate__c,
       Project_Phase__r.AOS_SDate__c,Project_Phase__r.AOS_EDate__c from Project_Assignment__c where Role__c =: aa.RoleSetup__c];       
       Date HSDate,HEDate,PSDate,PEDate,DeSDate,DeEDate,BSDate,BEDate,TSDate,TEDate,DSDate,DEDate,ASDate,AEDate,USDate,UEDate;
         System.debug('Holiday Assign:'+ha);
         System.debug('Holiday Details:'+hd);
         System.debug('Project Assign:'+pa);
     
       HSDate = ha.Holiday__r.Start_Date1__c;
       HEdate = ha.Holiday__r.End_Date1__c;
       PSdate = pa.Project_Phase__r.PlanSDate__c;
       PEDate = pa.Project_Phase__r.PlanEDate__c;
       System.debug('HSDate-111'+ HSDate);
        System.debug('HEDate-111'+ HEDate);
         System.debug('PSDate-111'+ PSDate);
          System.debug('PEDate-111'+ PEDate);
       
             
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
       
       if((HSDate <= PSdate && HEdate >= PSdate)&&
          (HSDate <= PSdate && HEdate <= PEDate))
       {
          hd.Start_Date1__c = PSdate;
      //    update hd;
      //     System.debug('HEDate-222'+ ha.Holiday__r.End_Date1__c);
           System.debug('Date1-333333'+ hd);
       }
       else if((HSDate <= DeSdate && HEdate >= DeSdate)&&
          (HSDate <= DeSdate && HEdate <= DeEDate))
       {
          hd.Start_Date1__c = DeSdate;
        //  update hd;
          System.debug('Date2-333333'+ hd);
       }
       else if((HSDate <= BSdate && HEdate >= BSdate)&&
          (HSDate <= BSdate && HEdate <= BEDate))
       {
          hd.Start_Date1__c = BSdate;
        //  update hd;
          System.debug('Date3-333333'+ hd);
       }
       else if((HSDate <= TSdate && HEdate >= TSdate)&&
          (HSDate <= TSdate && HEdate <= TEDate))
       {
          hd.Start_Date1__c = TSdate;
        //  update hd;
          System.debug('Date4-333333'+ hd);
       }
       else if((HSDate <= USdate && HEdate >= USdate)&&
          (HSDate <= USdate && HEdate <= UEDate))
       {
          hd.Start_Date1__c = USdate;
         // update hd;
           System.debug('Date5-333333'+ hd);
       }
       else if((HSDate <= ASdate && HEdate >= ASdate)&&
          (HSDate <= ASdate && HEdate <= AEDate))
       {
          hd.Start_Date1__c = ASdate;
        //  update hd;
           System.debug('Date6-333333'+ hd);
       }
       if(HSDate >= PSdate && HEDate >= PEDate) 
       {  
        hd.End_Date1__c = PEdate;        
      //  update hd;
        System.debug('HEDate-444444'+ hd);
         System.debug('Date7-333333'+ hd);
         
       }
       if(HSDate >= DeSdate && HEDate >= DeEDate) 
       {  
        hd.End_Date1__c = DeEdate;        
      //  update hd; 
       System.debug('Date8-333333'+ hd);
       }
       if(HSDate >= BSdate && HEDate >= BEDate) 
       {  
        hd.End_Date1__c = BEdate;        
      //  update hd; 
       System.debug('Date9-333333'+ hd);
       }
       if(HSDate >= TSdate && HEDate >= TEDate) 
       {  
        hd.End_Date1__c = TEdate;        
      //  update hd;
       System.debug('Date10-333333'+ hd); 
       }
      if(HSDate >= DSdate && HEDate >= DEDate) 
       {  
        hd.End_Date1__c = DEdate;        
      //  update hd; 
       System.debug('Date11-333333'+ hd);
       }
      if(HSDate >= USdate && HEDate >= UEDate) 
       {  
        hd.End_Date1__c = UEdate;        
      //  update hd;
       System.debug('Date12-333333'+ hd); 
       }
       if(HSDate >= ASdate && HEDate >= AEDate) 
       {  
        hd.End_Date1__c = AEdate;        
     //   update hd; 
      System.debug('Date13-333333'+ hd);
       }
       if(HSDate < PSdate && HEDate > PEDate) 
       {  
        hd.Start_Date1__c = PSdate; 
        hd.End_Date1__c = PEdate;        
     //   update hd;
        System.debug('Date14-5555555'+ hd);
        
       }
       if(HSDate < DeSdate && HEDate > DeEDate) 
       {  
        hd.Start_Date1__c = DeSdate; 
        hd.End_Date1__c = DeEdate;        
     //   update hd; 
      System.debug('Date15-333333'+ hd);
       }
       if(HSDate < BSdate && HEDate > BEDate) 
       {  
        hd.Start_Date1__c = BSdate; 
        hd.End_Date1__c = BEdate;        
      //  update hd; 
       System.debug('Date16-333333'+ hd);
       } 
       if(HSDate < TSdate && HEDate > TEDate) 
       {  
        hd.Start_Date1__c = TSdate; 
        hd.End_Date1__c = TEdate;        
      //  update hd; 
       System.debug('Date17-333333'+ hd);
       }
       if(HSDate < DSdate && HEDate > DEDate) 
       {  
        hd.Start_Date1__c = DSdate; 
        hd.End_Date1__c = DEdate;        
      //  update hd; 
       System.debug('Date18-333333'+ hd);
       }
       if(HSDate < USdate && HEDate > UEDate) 
       {  
        hd.Start_Date1__c = USdate; 
        hd.End_Date1__c = UEdate;        
      //  update hd; 
       System.debug('Date19-333333'+ hd);
       }
       if(HSDate < ASdate && HEDate > AEDate) 
       {  
        hd.Start_Date1__c = ASdate; 
        hd.End_Date1__c = AEdate;        
     //   update hd; 
      System.debug('Date20-333333'+ hd);
       }
        System.debug('Date21-333333'+ hd);    
       update hd;                 
    }
  }