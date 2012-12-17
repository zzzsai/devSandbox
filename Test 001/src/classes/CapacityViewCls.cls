public class CapacityViewCls {
    Capacity__c VarCapacity ;
    Capacity__c VarCapacity1; 
    List<Requirements_Selected__c> VarRequirement ; 
    public String capacityID=ApexPages.currentPage().getParameters().get('id');
    List <Requirement_Estimation__c> ReqEstlist = new List <Requirement_Estimation__c>();
    Requirement_Estimation__c ReqEst ;
    String CapacityName = null;
    Release_Capacity__c availableCap ;    
    Boolean CapAvailable = false;
    Double TotalPlan = 0.0;
    Double TotalDesign = 0.0;    
    Double TotalBuild = 0.0;
    Double TotalTest = 0.0;
    Double TotalUAT = 0.0;
    Double TotalDeploy = 0.0;
    Double TotalAdapt = 0.0;
    Double TotalTotal = 0.0;    
    Datetime ddmmyy;//for start date and end date;

    Boolean blncalculated=false;
    String releaseType ;
    String strTotalPur = null;
    String resFactorId=null;
    Double totalAvailPlan=0;     
    Double totalAvailDesign=0;
    Double totalAvailBuild=0;
    Double totalAvailTest=0;
    Double totalAvailUAT=0;
    Double totalAvailDeploy=0;
    Double totalAvailAdapt =0; 
    Double Total =0;   
    Double TotalOfTotal = 0.0;     
    Integer TotalResources=0; 
    capacityCalculation availableCapClass ;
    List <capacityCalculation> lsAvailableCap ;   
    List <Release_Capacity__c> lsAvailableCapCheck ; 
    List <Resource_Factor__c> lsResourceFactor = new List <Resource_Factor__c>();         
    Release_Cycle_Plan__c lsRelObj = new Release_Cycle_Plan__c();    

    public ID RID;
    List<Resource_Factor__c> VarResourceFactor;
    public String ResourceFactorMasterName;

    public CapacityViewCls(ApexPages.StandardController controller) 
    {
        VarRequirement = new List<Requirements_Selected__c>();  
        //availableCap = new List<Release_Capacity__c> ();
        VarCapacity=[SELECT Id, Name, Resourse_Factor_Name__c, Start_Date__c, End_Date__c, Release_Type__c, Capacity_Type__c, No_of_Days__c, Release_Name__r.Name FROM Capacity__c WHERE ID =: CapacityID ];  
                
//p.Resource_Type_New__c, Added
        /*
        ** Shraddanand: Included a new List variable of type Release_Capacity__c
        **              "tempAvailableCap " to capture the query results and assign only the first one in "availableCap" 
                        variable.
        ** Changed on : 10 Sep 2009
        */
        List<Release_Capacity__c> tempAvailableCap = new List<Release_Capacity__c>();
        tempAvailableCap  =[SELECT p.Id, p.Name, p.Adapt_and_Ongoing_Support__c,p.Resource_Type_New__c, p.Build__c, p.Capacity_Id__c, p.Deploy__c, p.Design__c, p.Plan__c,p.SIT__c, p.UAT__c FROM Release_Capacity__c p WHERE Capacity_Id__c = :capacityId Limit 1]; 
        if(tempAvailableCap .size()>0){
          availableCap = tempAvailableCap[0];
        }
        VarRequirement=[SELECT Id, Name, Requirement_Id__r.Id, Requirement_Id__r.Name, Requirement_Id__r.Plan__c, Requirement_Id__r.Design__c, Requirement_Id__r.Build__c, Requirement_Id__r.Test__c, Requirement_Id__r.UAT__c, Requirement_Id__r.Deploy__c, Requirement_Id__r.Adapt_and_Ongoing_Support__c,  Requirement_id__r.Requirement_id__r.Requirement_Title__c, Requirement_Id__r.Row_Total__c FROM Requirements_Selected__c where Capacity_Id__r.Id =:CapacityID];                    
        if (VarRequirement.size() > 0 )
            CapAvailable = true;   
        else
            CapAvailable = false;  

        resFactorId=   VarCapacity.Resourse_Factor_Name__c;            
        releaseType = VarCapacity.Release_Type__c;            
        List<Release_Cycle_Plan__c> tempLsRel = new List<Release_Cycle_Plan__c>();
        tempLsRel= [Select Id, p.Name, p.Adapt_and_Ongoing_Support__c, p.Build__c, p.Deploy__c, p.Design__c, p.Plan__c, p.Test__c, p.UAT__c FROM Release_Cycle_Plan__c p WHERE Name = :releaseType ];                 
        if(tempLsRel.size()>0){
          lsRelObj = tempLsRel[0];
        }
        //System.debug('Resource Fator Mastr Id '+VarCapacity.Resourse_Factor_Name__c);
/*Resource_Type_New__c, Added*/
        VarResourceFactor=[SELECT Id, Capacity_Type__c,Resource_Type_New__c, Plan_Factor__c, Design_Factor__c, Build_Factor__c, SIT_Factor__c, UAT_Factor__c, Deploy_Factor__c, Adapt_Factor__c, Resourse_Factor_Master__r.Name FROM Resource_Factor__c Where Resourse_Factor_Master__c= :VarCapacity.Resourse_Factor_Name__c];
        //System.debug('VarResourceFactor '  +VarResourceFactor);
        RID=VarCapacity.Resourse_Factor_Name__c;
        ResourceFactorMasterName= [SELECT name  FROM Resource_Factor_Master__c  WHERE Id=:VarCapacity.Resourse_Factor_Name__c].Name;
        //System.debug('ResourceFactorMasterName '  +ResourceFactorMasterName);
    }
    
    public pagereference availCapPage()
    {
        PageReference pgf = new PageReference('/apex/availableCapacityPage?id='+capacityId );
        pgf.setredirect(true);
        return pgf ;         
    }
    
    public pageReference establishScope()
    {
        Pagereference pgRef= new PageReference('/apex/EstablishScopeTabPage?id='+capacityId );
        pgRef.setredirect(true);
        return pgRef;         
    }     
    
    public void calculateAvailableCapacity(){
        System.debug('releaseType selected' +releaseType );
        totalAvailPlan=0;     
        totalAvailDesign=0;
        totalAvailBuild=0;
        totalAvailTest=0;
        totalAvailUAT=0;
        totalAvailDeploy=0;
        totalAvailAdapt =0;       
        TotalResources=0;
        TotalTotal=0; 
        strTotalPur ='Available Capacity';
        Map <String, Release_Capacity__c> lsCapMap = new Map <String, Release_Capacity__c>();
        
        if (releaseType == null){
            return;
        }
        else{
        }
        
        lsAvailableCap = new List <capacityCalculation>();

        lsRelObj= [Select Id, p.Name, p.Adapt_and_Ongoing_Support__c, p.Build__c, p.Deploy__c, p.Design__c, p.Plan__c, p.Test__c, p.UAT__c FROM Release_Cycle_Plan__c p WHERE Name = :releaseType ];                
/*p.Resource_Type_New__c, Added */       
        lsResourceFactor = [SELECT p.Adapt_Factor__c,p.Resource_Type_New__c, p.Build_Factor__c, p.Capacity_Type__c, p.Deploy_Factor__c, p.Design_Factor__c, p.No_Of_Resources__c, p.Plan_Factor__c,  p.SIT_Factor__c, p.UAT_Factor__c, Resourse_Factor_Master__r.Name  FROM Resource_Factor__c p WHERE  Resourse_Factor_Master__c= :resFactorId ];
/*p.Resource_Type_New__c, Added */       
        lsAvailableCapCheck = [SELECT p.Id, p.Name, p.Adapt_and_Ongoing_Support__c,p.Resource_Type_New__c, p.Build__c, p.Capacity_Id__c, p.Deploy__c, p.Design__c, p.Plan__c, p.SIT__c, p.UAT__c FROM Release_Capacity__c p WHERE Capacity_Id__c = :capacityID];
        String rstype =null;
        for(Release_Capacity__c rcp : lsAvailableCapCheck ) {
            rstype = rcp.Resource_Type_New__c;     //Changed to new picklist on 10th sep
            lsCapMap.put(rcp.Resource_Type_New__c,rcp );
        }       
              
        lsAvailableCap = new List <capacityCalculation>();
        List <Release_Capacity__c> lsInsertAvailableCap = new List <Release_Capacity__c>();
        List <Release_Capacity__c> lsUpdatevailableCap = new List <Release_Capacity__c>();        
        for(integer j=0;j<lsResourceFactor.size();j++ )
        {
            lsAvailableCapCheck =null;
            lsAvailableCapCheck  = new List <Release_Capacity__c>();
            
// Resource_Type_New__c Added on 10th sep
           
            if(lsCapMap.get(lsResourceFactor[j].Resource_Type_New__c)!=null)
                lsAvailableCapCheck.add(lsCapMap.get(lsResourceFactor[j].Resource_Type_New__c));
          

            availableCap = new Release_Capacity__c();
            availableCapClass = new capacityCalculation();

//Sagar: Changed 10th sep 09 as per Picklist requirement 
            availableCapClass.setResourceType(lsResourceFactor[j].Resource_Type_New__c)  ;   
            availableCapClass.setCapacityType(lsResourceFactor[j].Capacity_Type__c);   
            availableCapClass.setNoOfRes(lsResourceFactor[j].No_Of_Resources__c) ;    
            
            if(lsAvailableCapCheck.size()>0 ){
                if(lsResourceFactor[j].Capacity_Type__c =='Non-Capacity' ){
                    lsAvailableCapCheck[0].Plan__c=0;
                    lsAvailableCapCheck[0].Design__c =0;
                    lsAvailableCapCheck[0].Build__c = 0;
                    lsAvailableCapCheck[0].SIT__c = 0;
                    lsAvailableCapCheck[0].UAT__c = 0;
                    lsAvailableCapCheck[0].Deploy__c = 0;
                    lsAvailableCapCheck[0].Adapt_and_Ongoing_Support__c = 0;
                }
                else{                
                    lsAvailableCapCheck[0].Plan__c=lsResourceFactor[j].Plan_Factor__c * lsRelObj.Plan__c  * lsResourceFactor[j].No_Of_Resources__c ;
                    totalAvailPlan = totalAvailPlan+lsAvailableCapCheck[0].Plan__c;
                    availableCapClass.setPlan(lsAvailableCapCheck[0].Plan__c);
                    
                    lsAvailableCapCheck[0].Design__c =lsResourceFactor[j].Design_Factor__c * lsRelObj.Design__c  * lsResourceFactor[j].No_Of_Resources__c ;
                    totalAvailDesign=totalAvailDesign+ lsAvailableCapCheck[0].Design__c;
                    availableCapClass.setDesign(lsAvailableCapCheck[0].Design__c);
                    
                    lsAvailableCapCheck[0].Build__c = lsResourceFactor[j].Build_Factor__c * lsRelObj.Build__c * lsResourceFactor[j].No_Of_Resources__c ;
                    totalAvailBuild=totalAvailBuild+lsAvailableCapCheck[0].Build__c;
                    availableCapClass.setBuild(lsAvailableCapCheck[0].Build__c);
                    
                    lsAvailableCapCheck[0].SIT__c = lsResourceFactor[j].SIT_Factor__c * lsRelObj.Test__c * lsResourceFactor[j].No_Of_Resources__c ;
                    totalAvailTest=totalAvailTest+lsAvailableCapCheck[0].SIT__c;
                    availableCapClass.setTest(lsAvailableCapCheck[0].SIT__c);
                    
                    lsAvailableCapCheck[0].UAT__c = lsResourceFactor[j].UAT_Factor__c * lsRelObj.UAT__c * lsResourceFactor[j].No_Of_Resources__c ;
                    totalAvailUAT=totalAvailUAT+lsAvailableCapCheck[0].UAT__c;
                    availableCapClass.setUAT(lsAvailableCapCheck[0].UAT__c);
                    
                    lsAvailableCapCheck[0].Deploy__c = lsResourceFactor[j].Deploy_Factor__c * lsRelObj.Deploy__c * lsResourceFactor[j].No_Of_Resources__c ;
                    totalAvailDeploy=totalAvailDeploy+lsAvailableCapCheck[0].Deploy__c;
                    availableCapClass.setDeploy(lsAvailableCapCheck[0].Deploy__c);
                    
                    lsAvailableCapCheck[0].Adapt_and_Ongoing_Support__c = lsResourceFactor[j].Adapt_Factor__c * lsRelObj.Adapt_and_Ongoing_Support__c * lsResourceFactor[j].No_Of_Resources__c ;
                    totalAvailAdapt =totalAvailAdapt  + lsAvailableCapCheck[0].Adapt_and_Ongoing_Support__c;
                    availableCapClass.setAdapt(lsAvailableCapCheck[0].Adapt_and_Ongoing_Support__c);

                }
                
                Total = availableCapClass.Plan + availableCapClass.Design + availableCapClass.Build + availableCapClass.Test + availableCapClass.UAT + availableCapClass.Deploy + availableCapClass.Total;
                availableCapClass.setTotal(Total);
                
                TotalResources = TotalResources + availableCapClass.NoOfRes ;

                lsAvailableCap.add(availableCapClass);
                //update lsAvailableCapCheck[0];
                lsUpdatevailableCap.add(lsAvailableCapCheck[0]);
            }   
            else{ 
                availableCap.Resource_Type_New__c =  lsResourceFactor[j].Resource_Type_New__c;
                availableCap.Capacity_Id__c = capacityId ;                
                                
                if(lsResourceFactor[j].Capacity_Type__c =='Non-Capacity' ){
                    availableCap.Plan__c= 0 ;
                    availableCap.Design__c =0 ;
                    availableCap.Build__c = 0 ;
                    availableCap.SIT__c = 0 ;
                    availableCap.UAT__c = 0 ;
                    availableCap.Deploy__c = 0 ;
                    availableCap.Adapt_and_Ongoing_Support__c = 0 ;                    
                }
                else{       
                    availableCap.Plan__c=lsResourceFactor[j].Plan_Factor__c * lsRelObj.Plan__c  * lsResourceFactor[j].No_Of_Resources__c ;
                    availableCapClass.setPlan(availableCap.Plan__c);                    
                    totalAvailPlan = totalAvailPlan + availableCap.Plan__c;   
                                     
                    availableCap.Design__c =lsResourceFactor[j].Design_Factor__c * lsRelObj.Design__c  * lsResourceFactor[j].No_Of_Resources__c ;
                    availableCapClass.setDesign(availableCap.Design__c);
                    totalAvailDesign=totalAvailDesign+ availableCap.Design__c;
                    
                    availableCap.Build__c = lsResourceFactor[j].Build_Factor__c * lsRelObj.Build__c * lsResourceFactor[j].No_Of_Resources__c ;
                    availableCapClass.setBuild(availableCap.Build__c);
                    totalAvailBuild=totalAvailBuild + availableCap.Build__c;
                    
                    availableCap.SIT__c = lsResourceFactor[j].SIT_Factor__c * lsRelObj.Test__c * lsResourceFactor[j].No_Of_Resources__c ;
                    availableCapClass.setTest(availableCap.SIT__c);
                    totalAvailTest=totalAvailTest+ availableCap.SIT__c;
                    
                    availableCap.UAT__c = lsResourceFactor[j].UAT_Factor__c * lsRelObj.UAT__c * lsResourceFactor[j].No_Of_Resources__c ;
                    availableCapClass.setUAT(availableCap.UAT__c);
                    totalAvailUAT=totalAvailUAT+ availableCap.UAT__c;
                    
                    availableCap.Deploy__c = lsResourceFactor[j].Deploy_Factor__c * lsRelObj.Deploy__c * lsResourceFactor[j].No_Of_Resources__c ;
                    availableCapClass.setDeploy(availableCap.Deploy__c);
                    totalAvailDeploy=totalAvailDeploy+ availableCap.Deploy__c;
                    
                    availableCap.Adapt_and_Ongoing_Support__c = lsResourceFactor[j].Adapt_Factor__c * lsRelObj.Adapt_and_Ongoing_Support__c * lsResourceFactor[j].No_Of_Resources__c ;    
                    availableCapClass.setAdapt(availableCap.Adapt_and_Ongoing_Support__c);
                    totalAvailAdapt =totalAvailAdapt  + availableCap.Adapt_and_Ongoing_Support__c;
                }   

                Total = availableCapClass.Plan + availableCapClass.Design + availableCapClass.Build + availableCapClass.Test + availableCapClass.UAT + availableCapClass.Deploy + availableCapClass.Total;
                availableCapClass.setTotal(Total);
                TotalResources = TotalResources + availableCapClass.NoOfRes ;                             

                lsAvailableCap.add(availableCapClass);
                //insert availableCap;                             
                lsInsertAvailableCap.add(availableCap);
            }
            TotalOfTotal = totalAvailPlan + totalAvailDesign + totalAvailBuild + totalAvailTest + totalAvailUAT + totalAvailDeploy + totalAvailAdapt ;
            System.debug('j:' + j + ':    ' + availableCap);      
                        
            availableCap =null;
            availableCapClass=null;
            lsAvailableCapCheck =null;
        }      
        System.debug('lsAvailableCap is Sagar Check '+ lsAvailableCap);
        if(lsUpdatevailableCap.size()>0){
            System.debug('$$lsUpdatevailableCap'+ lsUpdatevailableCap);
            Map<Id,Release_Capacity__c > templsUpdatevailableCap = new Map<Id,Release_Capacity__c >();
            for(Release_Capacity__c obj: lsUpdatevailableCap){
                templsUpdatevailableCap.put(obj.Id,obj); 
            }
            List<Release_Capacity__c> lstToUpdate = new List<Release_Capacity__c>();
            lstToUpdate = templsUpdatevailableCap.values();
            update lstToUpdate ;//For Some Already Created Capacity like https://na6.salesforce.com/a0Q80000000dXig showing error
        }
        if(lsInsertAvailableCap.size()>0)  
          insert lsInsertAvailableCap;
        
        
        System.debug('lsAvailableCap is '+ lsAvailableCap);
        blncalculated =true;
    }   
    public Release_Cycle_Plan__c getlsRelObj(){
        return lsRelObj ;
    }     
    public List <capacityCalculation> getAvailCapList(){
        return lsAvailableCap;  
    }  
    public Integer getTotalResources (){
        return TotalResources ;
    }   
    public String getPlanTotal (){
        return String.valueOf(totalAvailPlan );
    }
    
    public String getDesignTotal (){
        return String.valueOf(totalAvailDesign);
    }    
    
    public String getBuildTotal(){
        return String.valueOf(totalAvailBuild);
    }
    
    public String getTestTotal(){
        return String.valueOf(totalAvailTest);   
    }
    
    public String getUATtotal(){
        return String.valueOf(totalAvailUAT);    
    }
    
    public String getDeployTotal(){
        return String.valueOf(totalAvailDeploy);
    }
    
    public String getAdaptTotal(){
        return String.valueOf(totalAvailAdapt );
    }   
    public Double getTotalOfTotal (){
        return TotalOfTotal ;
    }     
         

   public List<Requirements_Selected__c> getVarRequirement()
    {        
        return VarRequirement;
    }

    Public Capacity__c getVarCapacity()
    {
        // VarCapacity=[SELECT Id, Name, Start_Date__c, End_Date__c, Release_Type__c, Capacity_Type__c, No_of_Days__c FROM Capacity__c WHERE ID =: CapacityID ];  
        //VarCapacity=[SELECT Id, Name, Start_Date__c, End_Date__c, Release_Type__c, Capacity_Type__c, No_of_Days__c, Release_Name__r.Name FROM Capacity__c WHERE ID =: CapacityID ];          
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
        Date myDT =VarCapacity.Start_Date__c;
        Datetime myDate = Datetime.newInstance(myDT.year(),myDT.month(),myDT.day(),0,0,0);                
        return myDate.format('MM/dd/yyyy');        
    }

    public String getEndTime(){
        Date myDT =VarCapacity.End_Date__c;
        Datetime myDate = Datetime.newInstance(myDT.year(),myDT.month(),myDT.day(),0,0,0);                
        return myDate.format('MM/dd/yyyy');        
    }      

    public Boolean getCapAvailable(){
        return CapAvailable;
    }
    
    public String getoutputStr(){
        return 'Scope to be Determined';
    }
    
    public List<Resource_Factor__c> getVarResourceFactor()
    {
        return VarResourceFactor;
    }
    public void setVarResourceFactor(List<Resource_Factor__c> res)
    {
        this.VarResourceFactor = res;
    } 
    public ID getRID()
    {        
        return RID;
    }       
    public String getResourceFactorMasterName(){
        return ResourceFactorMasterName;
    }   
    
    

    class capacityCalculation{
        Double Plan=0;
        Double Design=0;
        Double Build=0;
        Double Test=0;
        Double UAT=0;
        Double Deploy=0;
        Double Adapt=0;
        Double Total=0;
        
        String ResourceType;
        String CapacityType;
        
        Integer NoOfRes=0;
        
        public Double getPlan(){
            return Plan;
        }
        
        void setPlan(Double Plan){
            this.Plan=Plan;
        }
        
        public Double getDesign(){
            return Design;
        }
        
        void setDesign(Double Design){
            this.Design=Design;
        }
                
        public Double getBuild(){
            return Build;        
        }
        
        void setBuild(Double Build){
            this.Build=Build;
        }
        
        public Double getTest(){
            return Test;
        }
        
        void setTest(Double Test){
            this.Test = Test;
        }
        
        public Double getUAT(){
            return UAT;
        }
        
        void setUAT(Double UAT){
            this.UAT=UAT;
        }
        
        public Double getDeploy(){
            return Deploy;
        }
        
        void setDeploy(Double Deploy){
            this.Deploy=Deploy;
        }
        
        public Double getAdapt(){
            return Adapt;
        }
        
        void SetAdapt(Double Adapt){
            this.Adapt=Adapt;
        }
        
        public Double getTotal(){
            return (Plan+Design+Build+Test+UAT+Deploy+Adapt);
        }
        void setTotal(Double Total){
            this.Total=Total;
        }
        
//Changed on 10th sep
        public String getResourceType(){
            return ResourceType;
        }
        void setResourceType(String ResourceType){
            this.ResourceType=ResourceType;
        }
        
        public String getCapacityType(){
            return CapacityType;
        }
        void setCapacityType(String CapacityType){
            this.CapacityType=CapacityType;
        }
        
        public Integer getNoOfRes(){
            return NoOfRes;
        }
        public void setNoOfRes(Double NoOfRes){
            if(NoOfRes != null){
               this.NoOfRes =NoOfRes.intValue();
            }
            
        }
        
    }
    
    public static testMethod void testCapacityViewCls()
    {   
        Release__c Rel =new Release__c(Name='Test Release', Release_Actual_End_Date__c = System.today(), Release_Planned_End_Date__c = System.today(), Release_Start_Date__c = System.today()-8, Release__c = 1.0, Status__c = 'Green' );
        insert Rel;
        
        Resource_Factor_Master__c resFactMaster = new Resource_Factor_Master__c(Name ='Test Factor Master', Release_Type__c = 'Minor' );
        insert  resFactMaster ;
        Resource_Factor__c resFact = new Resource_Factor__c(Resource_Type_New__c = 'Business Analyst', Capacity_Type__c = 'Capacity', Plan_Factor__c = 7.0, Design_Factor__c = 10.0, Build_Factor__c =10.0, SIT_Factor__c = 10.0, UAT_Factor__c= 8.0, Deploy_Factor__c = 10.0, Adapt_Factor__c =10.0 ,Resourse_Factor_Master__c=resFactMaster.id);
        insert resFact;
        Capacity__c capacityObj = new Capacity__c(Start_Date__c=System.today(), End_Date__c=System.today()+8,Capacity_Type__c= 'Known Resource-Mix', Release_Name__c =Rel.id, Resourse_Factor_Name__c =resFactMaster .Id );
        insert capacityObj;
        
        Release_Cycle_Plan__c rcp = new Release_Cycle_Plan__c(Name ='Minor',
            Adapt_and_Ongoing_Support__c=5, Build__c=5, 
            Deploy__c=5, Design__c=5 , Plan__c=5, 
            Test__c=5, UAT__c=5 );
        insert  rcp ;      
        
        
        ApexPages.CurrentPage().getParameters().put('id', capacityObj.id);
        ApexPages.StandardController stdc = new ApexPages.StandardController(capacityObj);
        CapacityViewCls capView = new CapacityViewCls(stdc );

        capView.availCapPage();
        capView.establishScope();
        capView.calculateAvailableCapacity();
        capView.getlsRelObj();
        capView.getAvailCapList();
        capView.getTotalResources();
        capView.getTotalPlan();
        capView.getTotalDesign();
        capView.getTotalBuild();
        capView.getTotalTest();
        capView.getTotalUAT();
        capView.getTotalDeploy();
        capView.getTotalAdapt();
        capView.getTotalTotal();
        capView.getCapacityID();
        capView.getCapacityName();
        capView.getStartTime();
        capView.getEndTime();
        capView.getCapAvailable();
        capView.getoutputStr();
        capView.getRID();
        capView.getResourceFactorMasterName();
        capView.getVarResourceFactor();
        capView.getVarRequirement();
        capView.getPlanTotal ();
        capView.getDesignTotal ();
        capView.getBuildTotal ();
        capView.getTestTotal ();
        capView.getUATTotal ();
        capView.getDeployTotal ();
        capView.getAdaptTotal ();
        capView.getTotalOfTotal ();
        
        capacityCalculation capCal = new capacityCalculation ();
        capCal.setPlan(12.0);
        System.assertEquals(12.0,capCal.getPlan());
        capCal.setDesign(12.0);
        System.assertEquals(12.0,capCal.getDesign());
        capCal.setBuild(12.0);
        System.assertEquals(12.0,capCal.getBuild());
        capCal.setTest(12.0);
        System.assertEquals(12.0,capCal.getTest());
        capCal.setUAT(12.0);
        System.assertEquals(12.0,capCal.getUAT());
        capCal.setDeploy(12.0);
        System.assertEquals(12.0,capCal.getDeploy());
        capCal.setAdapt(12.0);
        System.assertEquals(12.0,capCal.getAdapt());
        capCal.setTotal(12.0);
        System.assertEquals(84.0,capCal.getTotal());
        capCal.setResourceType('Business Analyst');
        System.assertEquals('Business Analyst',capCal.getResourceType());
        capCal.setCapacityType('Known Resource-Mix');
        System.assertEquals('Known Resource-Mix',capCal.getCapacityType());
        capCal.setNoOfRes(2.0);
        System.assertEquals(2.0,capCal.getNoOfRes());
        
       
       }

}//PMT2009__ replaced by blank on 5thNov09 for 284 occurences