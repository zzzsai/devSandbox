@isTest
private class detailestimatorTestClass
{
   /* public detailestimatorTestClass()
    {
    
    }
   */
    public static testMethod void testDE()
    {
        detailestimator detEst = new detailestimator();
        integer fvalue =0;
        integer displaynum =10;
        integer reqlistsize = 0;
        Boolean ifnextLink = false;
        Boolean ifpreviousLink = false;
        Boolean addrequirement;

        List <detailestimator.reqWrapper> Wr ;
        Boolean check = false;
        integer countinDatabase = [SELECT count() from Requirement__c where Is_Selected__c != true];    
        if (countinDatabase >10)
            check =true;
        Wr  = detEst.getSearchreq();
        System.assertEquals(countinDatabase , Wr.size());
        
        Release_Estimation__c tstRelEst = new Release_Estimation__c(name='Unit Test Estimate');
        insert tstRelEst ;
        detEst.estId= tstRelEst.id;
        detEst.IsInsert ='false';      
        detEst.IsDetails='false';
        
        
        // getEstReqDetail() 
        System.assertequals(0 , detEst.getEstReqDetail().size()); 
        
        detEst.IsInsert ='true';
        
        //getEstimateName()               
        System.assertequals('Unit Test Estimate', detEst.getEstimateName().name);
        System.assertequals(tstRelEst.name, detEst.getEstimateDetails().name);
        
        //getTotalValList  
        Release_Estimation__c actstRelEst = detEst.getTotalValList();
        System.assertequals(0, actstRelEst.Total_Contigency__c);
        
        
        // addReq() 
        pageReference pg1 = detEst.addReq() ;        
        System.assertequals(tstRelEst.id, pg1.getParameters().get('id'));
        System.assertequals('true', pg1.getParameters().get('IsInsert'));
        System.assertequals('false', pg1.getParameters().get('IsDetails'));
        System.assertequals(true, pg1.getURL().contains('RequirementDetail'));
        
        //editEst()  
        pg1 = detEst.editEst() ;        
        System.assertequals(tstRelEst.id, pg1.getParameters().get('id'));        
        System.assertequals('false', pg1.getParameters().get('IsInsert'));
        System.assertequals('true', pg1.getParameters().get('IsDetails'));        
        
        //gototab() 
        pg1 = detEst.gototab();
        System.assertequals(true, pg1.getURL().contains('/a0L/o'));
            
                
        List<Requirement_Estimation__c> reqEstToInsert = new List<Requirement_Estimation__c>();
        
        //config component
        
        Requirement_Estimation__c reqEst01 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Config_complex__c='Simple', contingency__c='1', Config_Component__c=1);
        Estimate_factor__c Fac01 = new Estimate_factor__c(Component_Name__c='Configuration Ratings',Requirement_Gathering_Simple__c=1, Design_Simple__c =1, Build_Unit_Test_Simple__c=1,SIT_Simple__c=1, UAT_Simple__c=1,Deploy_Train_Simple__c=1,Stabilize_New__c=1,Requirement_Gathering_Medium__c=1, Design_Medium__c =1, Build_Unit_Test_Medium__c=1,SIT_Medium__c=1, UAT_Medium__c=1,Deploy_Train_Medium__c=1,Stabilize_Medium__c=1,Requirement_Gathering_Complex__c=1, Design_Complex__c =1, Build_Unit_Test_Complex__c=1,SIT_Complex__c=1, UAT_Complex__c=1,Deploy_Train_Complex__c=1,Stabilize_Complex__c=1);
        reqEstToInsert.add(reqEst01 );        
       
        Requirement_Estimation__c reqEst02 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Config_complex__c='Medium', contingency__c='1',Config_Component__c=1);
        reqEstToInsert.add(reqEst02);        
       
        Requirement_Estimation__c reqEst03 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Config_complex__c='Complex', contingency__c='1',Config_Component__c=1);
        reqEstToInsert.add(reqEst03);
                
        //workflow component
        
        Requirement_Estimation__c reqEst04 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Workflow_Complex__c='Simple', contingency__c='1',Workflow_Component__c=1);
        Estimate_factor__c Fac02 = new Estimate_factor__c(Component_Name__c='Workflow and Approval Ratings',Requirement_Gathering_Simple__c=1, Design_Simple__c =1, Build_Unit_Test_Simple__c=1,SIT_Simple__c=1, UAT_Simple__c=1,Deploy_Train_Simple__c=1,Stabilize_New__c=1,Requirement_Gathering_Medium__c=1, Design_Medium__c =1, Build_Unit_Test_Medium__c=1,SIT_Medium__c=1, UAT_Medium__c=1,Deploy_Train_Medium__c=1,Stabilize_Medium__c=1,Requirement_Gathering_Complex__c=1, Design_Complex__c =1, Build_Unit_Test_Complex__c=1,SIT_Complex__c=1, UAT_Complex__c=1,Deploy_Train_Complex__c=1,Stabilize_Complex__c=1);
        reqEstToInsert.add(reqEst04);
         
        Requirement_Estimation__c reqEst05 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Workflow_Complex__c='Medium', contingency__c='1',Workflow_Component__c=1);
        reqEstToInsert.add(reqEst05); 
        
        Requirement_Estimation__c reqEst06 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Workflow_Complex__c='Complex', contingency__c='1',Workflow_Component__c=1);
        reqEstToInsert.add(reqEst06); 
        
        //User Administration component
        
        Requirement_Estimation__c reqEst07 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, User_complexity__c='Simple', contingency__c='1',User_Comp__c=1, Config_Component__c=1);
        Estimate_factor__c Fac03 = new Estimate_factor__c(Component_Name__c='User Administration Ratings',Requirement_Gathering_Simple__c=1, Design_Simple__c =1, Build_Unit_Test_Simple__c=1,SIT_Simple__c=1, UAT_Simple__c=1,Deploy_Train_Simple__c=1,Stabilize_New__c=1,Requirement_Gathering_Medium__c=1, Design_Medium__c =1, Build_Unit_Test_Medium__c=1,SIT_Medium__c=1, UAT_Medium__c=1,Deploy_Train_Medium__c=1,Stabilize_Medium__c=1,Requirement_Gathering_Complex__c=1, Design_Complex__c =1, Build_Unit_Test_Complex__c=1,SIT_Complex__c=1, UAT_Complex__c=1,Deploy_Train_Complex__c=1,Stabilize_Complex__c=1);
        reqEstToInsert.add(reqEst07);
         
        Requirement_Estimation__c reqEst08 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, User_complexity__c='Medium', contingency__c='1',User_Comp__c=1,Config_Component__c=1);
        reqEstToInsert.add(reqEst08); 
        
        Requirement_Estimation__c reqEst09 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, User_complexity__c='Complex', contingency__c='1',User_Comp__c=1, Config_Component__c=1);
        reqEstToInsert.add(reqEst09);
        
        //Report component
        
        Requirement_Estimation__c reqEst001 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Report_Complexity__c='Simple', contingency__c='1',Report_Component__c=1);
        Estimate_factor__c Fac04 = new Estimate_factor__c(Component_Name__c='Report & Dashboard',Requirement_Gathering_Simple__c=1, Design_Simple__c =1, Build_Unit_Test_Simple__c=1,SIT_Simple__c=1, UAT_Simple__c=1,Deploy_Train_Simple__c=1,Stabilize_New__c=1,Requirement_Gathering_Medium__c=1, Design_Medium__c =1, Build_Unit_Test_Medium__c=1,SIT_Medium__c=1, UAT_Medium__c=1,Deploy_Train_Medium__c=1,Stabilize_Medium__c=1,Requirement_Gathering_Complex__c=1, Design_Complex__c =1, Build_Unit_Test_Complex__c=1,SIT_Complex__c=1, UAT_Complex__c=1,Deploy_Train_Complex__c=1,Stabilize_Complex__c=1);
        reqEstToInsert.add(reqEst001);
         
        Requirement_Estimation__c reqEst002 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Report_Complexity__c='Medium', contingency__c='1',Report_Component__c=1);
        reqEstToInsert.add(reqEst002); 
        
        Requirement_Estimation__c reqEst003 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Report_Complexity__c='Complex', contingency__c='1',Report_Component__c=1);
        reqEstToInsert.add(reqEst003);
        
        //Customization  component
        
        Requirement_Estimation__c reqEst004 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Custom_Complexity__c='Simple', contingency__c='1',Custom_Component__c=1);
        Estimate_factor__c Fac05 = new Estimate_factor__c(Component_Name__c='Customization',Requirement_Gathering_Simple__c=1, Design_Simple__c =1, Build_Unit_Test_Simple__c=1,SIT_Simple__c=1, UAT_Simple__c=1,Deploy_Train_Simple__c=1,Stabilize_New__c=1,Requirement_Gathering_Medium__c=1, Design_Medium__c =1, Build_Unit_Test_Medium__c=1,SIT_Medium__c=1, UAT_Medium__c=1,Deploy_Train_Medium__c=1,Stabilize_Medium__c=1,Requirement_Gathering_Complex__c=1, Design_Complex__c =1, Build_Unit_Test_Complex__c=1,SIT_Complex__c=1, UAT_Complex__c=1,Deploy_Train_Complex__c=1,Stabilize_Complex__c=1);
        reqEstToInsert.add(reqEst004);
         
        Requirement_Estimation__c reqEst005 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Custom_Complexity__c='Medium', contingency__c='1',Custom_Component__c=1);
        reqEstToInsert.add(reqEst005); 
        
        Requirement_Estimation__c reqEst006 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Custom_Complexity__c='Complex', contingency__c='1',Custom_Component__c=1);
        reqEstToInsert.add(reqEst006); 
        
        //Data Migration component
        
        Requirement_Estimation__c reqEst007 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Data_Complex__c='Simple', contingency__c='1',Data_comp__c=1);
        Estimate_factor__c Fac06 = new Estimate_factor__c(Component_Name__c='Data Migration',Requirement_Gathering_Simple__c=1, Design_Simple__c =1, Build_Unit_Test_Simple__c=1,SIT_Simple__c=1, UAT_Simple__c=1,Deploy_Train_Simple__c=1,Stabilize_New__c=1,Requirement_Gathering_Medium__c=1, Design_Medium__c =1, Build_Unit_Test_Medium__c=1,SIT_Medium__c=1, UAT_Medium__c=1,Deploy_Train_Medium__c=1,Stabilize_Medium__c=1,Requirement_Gathering_Complex__c=1, Design_Complex__c =1, Build_Unit_Test_Complex__c=1,SIT_Complex__c=1, UAT_Complex__c=1,Deploy_Train_Complex__c=1,Stabilize_Complex__c=1);
        reqEstToInsert.add(reqEst007);
         
        Requirement_Estimation__c reqEst008 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Data_Complex__c='Medium', contingency__c='1',Data_comp__c=1);
        reqEstToInsert.add(reqEst008); 
        
        Requirement_Estimation__c reqEst009 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Data_Complex__c='Complex', contingency__c='1',Data_comp__c=1);
        reqEstToInsert.add(reqEst009); 
        
        //Integration Batch Components
        
        Requirement_Estimation__c reqEst10 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id,Batch_Complex__c='Simple', contingency__c='1',Batch_comp__c=1);
        Estimate_factor__c Fac07 = new Estimate_factor__c(Component_Name__c='Integration (Batch)',Requirement_Gathering_Simple__c=1, Design_Simple__c =1, Build_Unit_Test_Simple__c=1,SIT_Simple__c=1, UAT_Simple__c=1,Deploy_Train_Simple__c=1,Stabilize_New__c=1,Requirement_Gathering_Medium__c=1, Design_Medium__c =1, Build_Unit_Test_Medium__c=1,SIT_Medium__c=1, UAT_Medium__c=1,Deploy_Train_Medium__c=1,Stabilize_Medium__c=1,Requirement_Gathering_Complex__c=1, Design_Complex__c =1, Build_Unit_Test_Complex__c=1,SIT_Complex__c=1, UAT_Complex__c=1,Deploy_Train_Complex__c=1,Stabilize_Complex__c=1);
        reqEstToInsert.add(reqEst10);
         
        Requirement_Estimation__c reqEst11 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Batch_Complex__c='Medium', contingency__c='1',Batch_comp__c=1);
        reqEstToInsert.add(reqEst11); 
        
        Requirement_Estimation__c reqEst12 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Batch_Complex__c='Complex', contingency__c='1',Batch_comp__c=1);
        reqEstToInsert.add(reqEst12); 
        
        //Integration Real-time Components
        
        Requirement_Estimation__c reqEst13 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Real_Complex__c='Simple', contingency__c='1',Real_Comp__c=1);
        Estimate_factor__c Fac08 = new Estimate_factor__c(Component_Name__c='Integration (Real Time)',Requirement_Gathering_Simple__c=1, Design_Simple__c =1, Build_Unit_Test_Simple__c=1,SIT_Simple__c=1, UAT_Simple__c=1,Deploy_Train_Simple__c=1,Stabilize_New__c=1,Requirement_Gathering_Medium__c=1, Design_Medium__c =1, Build_Unit_Test_Medium__c=1,SIT_Medium__c=1, UAT_Medium__c=1,Deploy_Train_Medium__c=1,Stabilize_Medium__c=1,Requirement_Gathering_Complex__c=1, Design_Complex__c =1, Build_Unit_Test_Complex__c=1,SIT_Complex__c=1, UAT_Complex__c=1,Deploy_Train_Complex__c=1,Stabilize_Complex__c=1);
        reqEstToInsert.add(reqEst13);
         
        Requirement_Estimation__c reqEst14 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Real_Complex__c='Medium', contingency__c='1',Real_Comp__c=1);
        reqEstToInsert.add(reqEst14); 
        
        Requirement_Estimation__c reqEst15 = new Requirement_Estimation__c(ReleaseEstimation__c= tstRelEst.id, Real_Complex__c='Complex', contingency__c='1',Real_Comp__c=1);
        reqEstToInsert.add(reqEst15); 
        
        insert reqEstToInsert;
                
        // getEstReqDetail() 
        System.assertequals(24 , detEst.getEstReqDetail().size()); 
        
        //Save         
        //System.assertequals('/apex/PMT2009__Details_Estimation_RO?id='+detEst.estId, detEst.saveEstimate().getURL()); 
        System.assertequals('/apex/CapacityToolkit__Details_Estimation_RO?id='+detEst.estId, detEst.saveEstimate().getURL()); 
        
        //search()      
       
        Release__c rel01 = new Release__c(name ='test release');
        insert rel01;
        Work_Assignment__c workasgn01 = new Work_Assignment__c();
        workasgn01.Assignment__c = 'Estimate';
        workasgn01.Progress__c ='Complete';
        Requirement__c reqt01= new Requirement__c();
        reqt01.Requirement_Title__c = 'Add';
        reqt01.Request_Type__c  = 'Configuration';
        reqt01.System_Impacted__c = 'Salesforce.com';  
        reqt01.Status__c ='Release: Build';  
        reqt01.Release__c = rel01.id;    
        detEst.setRequirement01(reqt01);
        detEst.setWorkassign01(workasgn01);
        
        System.assertequals(workasgn01,detEst.getWorkassign01());
        System.assertequals(reqt01 ,detEst.getrequirement01());    
            
        integer rcount =  [ SELECT count() from Requirement__c where Is_Selected__c != true and Requirement_Title__c like 'Add%'  and Request_Type__c =  'Configuration' and System_Impacted__c = 'Salesforce.com' and Status__c ='Release: Build'] ;
        detEst.search();       
        System.assertequals(0, detEst.getSearchreq().size());     
            
        integer rcount1 = [SELECT count() from Requirement_Estimation__c where ReleaseEstimation__c=: tstRelEst.id];
        System.assertequals(24, rcount1 );         
           
        System.assertequals(24, detEst.getEstDetail().size());          
        System.assertequals(0,detEst.getreqlist().size());
        System.assertequals(false,detEst.getIsEstVal());
        //System.assertequals('/apex/PMT2009__Details_Estimation_RO?id='+detEst.estId, detEst.gotoPreviousPage().getURL());
        System.assertequals('/apex/CapacityToolkit__Details_Estimation_RO?id='+detEst.estId, detEst.gotoPreviousPage().getURL());
        System.assertequals(10,detEst.getRequirementgatherconfig());
        System.assertequals(12,detEst.getDesignconfig());
        System.assertequals(25,detEst.getBuildUnitconfig());
        System.assertequals(20,detEst.getSITconfig());
        System.assertequals(10,detEst.getUATconfig());
        System.assertequals(5,detEst.getDeployTrainconfig());
        System.assertequals(5,detEst.getStabilizeconfig());
        System.assertequals(0,detEst.getTotal());  
              
        detEst.OnClickPrevious();
        detEst.OnClickNext();      
          
        System.assertequals(10,detEst.getdisplaynum());
        System.assertequals(0,detEst.getnextvalue());
        System.assertequals(false,detEst.getifpreviousLink());
        System.assertequals(false,detEst.getifnextLink());
        System.assertequals(false,detEst.getIsDelReq());
        System.assertequals(null,detEst.addRows());
        //System.assertequals(35,detEst.getReq().size());
        detEst.getReq();
        //System.assertequals(36,detEst.getReq().size());
        System.assertequals(null,detEst.estimateSelected());
        System.assertequals(null,detEst.DelReq());
        System.assertequals(true,detEst.getAddrequirement());
        
        
    }
    
     
    







}//PMT2009__ 168 occurences replaced by blank