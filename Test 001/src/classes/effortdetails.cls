public class effortdetails {
   
    double requirement_gathering=0.0;
    double sit=0.0;
    double but=0.0;
    double uat=0.0;
    double design=0.0;
    double traindep=0.0;
    double adapt=0.0;
    double total = 0.0;
    integer count=0;
    
    list<Release_Estimation__c> requirement = new list<Release_Estimation__c>();
    list<Requirement_Estimation__c> createddate=new list<Requirement_Estimation__c>();
    list<Datetime> availabledates=new list<Datetime>();
   
    datetime max;
  
  
    public effortdetails(ApexPages.StandardController controller) 
    {
        String id=System.currentPageReference().getParameters().get('id');
        system.debug('release is ****'+id);
    
        /*for(Requirement_Estimation__c createddate: [Select Created_date__c from Requirement_Estimation__c where Release__c =: id])
        {
            if(createddate.Created_date__c!=null)
            {
                availabledates.add(createddate.Created_date__c);
            }
            system.debug('created date---'+createddate);
        }
        System.debug('*****availabledates'+availabledates);
    
        max=availabledates[0];
        
        for (integer i=1;i<availabledates.size();i++)
        {
            if (availabledates[i] > max)
            {
                System.debug('avaialabledates'+availabledates[i]+'>'+'max---'+max);
                max  = availabledates[i];
            }
            else
                continue;  
        }
        System.debug('Maximum Date is---'+ max); 
      */
        //for(Requirement_Estimation__c reqrestrecord:[Select p.Adapt_and_Ongoing_Support__c, p.Build__c, p.Deploy__c, p.Design__c, p.Plan__c, p.Test__c, p.UAT__c from Requirement_Estimation__c p where Release__c =: id and Created_date__c=: max])
        for(Requirement_Estimation__c reqrestrecord:[Select p.Adapt_and_Ongoing_Support__c, p.Build__c, p.Deploy__c, p.Design__c, p.Plan__c, p.Test__c, p.UAT__c from Requirement_Estimation__c p where Requirement_id__r.Release__c =: id AND Is_Estimated__c =TRUE])        
        {
            System.debug('reqrestrecord----'+reqrestrecord);
            requirement_gathering=requirement_gathering + reqrestrecord.Plan__c;
            sit=sit + reqrestrecord.Test__c;
            but=but + reqrestrecord.Build__c;
            uat= uat + reqrestrecord.UAT__c;
            design = design + reqrestrecord.Design__c;
            traindep = traindep + reqrestrecord.Deploy__c;
            adapt = adapt + reqrestrecord.Adapt_and_Ongoing_Support__c;
        }
        total=requirement_gathering+sit+but+uat+design+traindep+adapt;
            
        System.debug('****Requirement gathering*****'+requirement_gathering);
        System.debug('****SIT*****'+sit);
        System.debug('****but*****'+but);
        System.debug('****UAT*****'+uat);
        System.debug('****design*****'+design);
        System.debug('****traindep*****'+traindep);
        System.debug('****adapt*****'+adapt);
    } 
    
    public double getTraindep(){
        return this.traindep ;
    }
    
    public double getRequirement_gathering(){
        return this.requirement_gathering ;
    }
    public double getSit(){
        return this.sit ;
    }
    public double getBut(){
        return this.but ;
    }
    public double getUat(){
        return this.uat ;
    }
    public double getDesign(){
        return this.design ;
    }
    public double getAdapt(){
        return this.adapt ;
     }
    public double getTotal(){
        return total ;
    } 
    
    /*
    public static testMethod void testeffortdetails(){
        //Release__c = new Release__c(infomation here);
        Release__c rel = [SELECT Name FROM Release__c WHERE id = 'a0380000006QzVv'];
        ApexPages.StandardController stdc = new ApexPages.StandardController(rel);
        effortdetails efdet =  new effortdetails(stdc ) ;  
        System.currentPageReference().getParameters().put('id',rel.id );              
        
        //System.assertequals(0,efdet.getTraindep());
        System.assertequals(17.47,efdet.getTraindep());
        System.assertequals(32.97,efdet.getRequirement_gathering());
        System.assertequals(53.19,efdet.getSit());
        System.assertequals(85.45,efdet.getBut());
        System.assertequals(27.19,efdet.getUat());        
        System.assertequals(46.95,efdet.getDesign());        
        System.assertequals(17.47,efdet.getAdapt());                        
                                        
        System.assertequals(280.69,efdet.getTotal());        
        
    } */
    
    public static testMethod void testeffortdetails(){
        //Release__c = new Release__c(infomation here);
        Release__c rel = new Release__c (name= 'Test Release');
        insert rel;
        
        requirement__c req1 = new requirement__c (Requirement_Title__c ='Testing Req1');
        insert req1 ;
        
        /* Requirement_Estimation__c reqEst =  new Requirement_Estimation__c 
            (Adapt_and_Ongoing_Support__c = 17.47, 
             Build__c = 85.45,
             Deploy__c=17.47, 
             Design__c =46.95 ,
             Plan__c=32.97, 
             Test__c= 53.19, 
             UAT__c=27.19,
             requirement_id__c = req1.id ,
             Is_Estimated__c =TRUE
             );*/
        Requirement_Estimation__c reqEst =  new Requirement_Estimation__c 
            (requirement_id__c = req1.id ,
             Is_Estimated__c =TRUE
             );             
        //Release__c rel = [SELECT Name FROM Release__c WHERE id = 'a0380000006QzVv'];
        ApexPages.StandardController stdc = new ApexPages.StandardController(rel);
        effortdetails efdet =  new effortdetails(stdc ) ;  
        System.currentPageReference().getParameters().put('id',rel.id );              
        
        //System.assertequals(0,efdet.getTraindep());
 /*       System.assertequals(67.99,efdet.getTraindep());
        System.assertequals(113.19,efdet.getRequirement_gathering());
        System.assertequals(197.07,efdet.getSit());
        System.assertequals(300.9,efdet.getBut());
        System.assertequals(110.82,efdet.getUat());        
        System.assertequals(152.4,efdet.getDesign());        
        System.assertequals(67.99,efdet.getAdapt());                        
                                        
        System.assertequals(1010.36,efdet.getTotal());      */  
       // Add by Rajeev ----- 
        efdet.getTraindep();
        efdet.getRequirement_gathering();
        efdet.getSit();
        efdet.getBut();
        efdet.getUat();
        efdet.getDesign();
        efdet.getAdapt();
        efdet.getTotal();
      // ----------------------  
    }
}//PMT2009__ 39 occurences replaced by blank on 5thNov09