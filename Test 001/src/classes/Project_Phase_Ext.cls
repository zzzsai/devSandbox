public class Project_Phase_Ext {
   
    public Id Release;
    public Id Estimate;
    String Id;
    public Id selectedVal {get;set;}
    List<selectOption> optionList{get;set;} 
    public Project_Phase__c releaseObj = new Project_Phase__c();
    List<Release__c> editlstObjs=null;
    List<Release_Estimation__c> editEstimate=null;
    List<Release__c> lstObjs {get;set;}
    public String getRelease() { return this.Release; }
    public void setRelease(String s) { this.Release= s; }
    public String getEstimate() { return this.estimate; }
    public void setEstimate(String s) { this.Estimate= s; }

    public Project_Phase_Ext(ApexPages.standardController cont){
          
           Id=ApexPages.currentPage().getParameters().get('id');
           System.debug('Id---------------'+Id);
           releaseObj= (Project_Phase__c)cont.getRecord() ;
           if(Id!=null){
               List<Project_Phase__c> tmplst=[select Id,Focus_Area__c,Related_Estimate__c from Project_Phase__c where id= :id];
               Project_Phase__c tmpObj=tmplst.get(0);
               editlstObjs=[select Id,name from Release__c where Id = :tmpObj.Focus_Area__c];
               editEstimate=[select Id,name from Release_Estimation__c where Id = :tmpObj.Related_Estimate__c];
           }            
             lstObjs=[select Id,name from Release__c where id not in(select Focus_Area__c
                      from Project_Phase__c )];     
    }
     
     public List<SelectOption> getReleases(){
       List<SelectOption> optionList = new List<SelectOption>();
         if(editlstObjs!=null){
            for(Release__c editObj:editlstObjs){
              SelectOption editpopt=new SelectOption(editObj.id,editObj.name);
              optionList.add(editpopt);
            }
         }
         List<SelectOption> releaseSelect= new List<SelectOption>();
         optionList.add(new SelectOption('Select Release','Select Release'));
         if(lstObjs != NULL){
           for (Release__c rel : [select Id,name from Release__c where id not in(select Focus_Area__c from Project_Phase__c ) order by Name]){
              optionList.add(new SelectOption(rel.id,rel.name));
           }
         }
        return optionList;     
    }
    public List<SelectOption> getEstimates(){
       List<SelectOption> optionList = new List<SelectOption>();
       
       if(editEstimate!=null){
            for(Release_Estimation__c editEObj:editEstimate){
              SelectOption editpoptEstimate=new SelectOption(editEObj.id,editEObj.name);
              optionList.add(editpoptEstimate);
            }
         }
       optionList.add(new SelectOption('Select Estimate', 'Select Estimate')); 
       if(Release!= NULL){
          for (Release_Estimation__c estmat : [select name from Release_Estimation__c f where f.Release__c = :release]){
              optionList.add(new SelectOption(estmat.id,estmat.name));
          }
       }
      return optionList ;
    }
   public void setRelease(){
      releaseObj.Focus_Area__c= release;
    }
   public void setEstimate(){
      releaseObj.Related_Estimate__c= estimate;
    }
   
}