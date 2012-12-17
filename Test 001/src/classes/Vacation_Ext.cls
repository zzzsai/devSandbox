public class Vacation_Ext{
public String releaseAssignment{set; get;}
public id roleDescription{set; get;}
public Vacation_Assignment__c vacObj = new Vacation_Assignment__c();
List<Vacation_Overview__c> VacationObj {get;set;}
List<RoleSetup__c> roleObjs {get;set;}
List<Project_Assignment__c> relObjs =null;
List<Vacation_Overview__c> editVacationObj =null;
List<Project_Assignment__c> editRelObjs =null;
List<RoleSetup__c> editRoleObjs =null;
String Id;
String rel_ass;
public List<selectOption> optionList;
public String selectedVal {get;set;}
public Vacation_Ext(ApexPages.standardController cont){
    
      
      id=ApexPages.currentPage().getParameters().get('id');
      rel_ass = ApexPages.currentPage().getParameters().get('retUrl');
      system.debug('rel_ass'+rel_ass);
      if(rel_ass !=null || Id !=null)
      {
        rel_ass  =rel_ass.substring(1);
        List<Vacation_Assignment__c> tmplst=[select Id,Vacation__c,RoleSetup__c, RoleSetup__r.Capacity__c,Release_Assignment__c from Vacation_Assignment__c where id =:rel_ass or id =:id];
        system.debug('templst'+tmplst);
        if(tmplst.size() >0){
        Vacation_Assignment__c tmpObj=tmplst.get(0);
        editVacationObj=[select Id,name from Vacation_Overview__c where Id = :tmpObj.Vacation__c or id =:tmpObj.id]; 
        editRoleObjs=[select Id,name from RoleSetup__c where id=:rel_ass or Id =:tmpObj.RoleSetup__c];
        editRelObjs=[select name, Project_Phase__r.Focus_Area__r.Name,Role__c from Project_Assignment__c where Role__c=:tmpObj.RoleSetup__c]; 
        }
     }
     roleObjs=[Select id,name from RoleSetup__c where id in (select Role__c  from project_Assignment__c  where id =:rel_ass or Role__c =:rel_ass )];
     
     List<Project_Assignment__c> lstProjAss = [select id,name,Role__c,Project_Phase__c from Project_Assignment__c where id=:rel_ass or Role__c=:rel_ass];
     List<RoleSetup__c> lstRole= [select id,name,Capacity__c from RoleSetup__c where id=:rel_ass or id=:rel_ass];   
         if(lstProjAss.size() >0)
         {
           List<Project_Phase__c> projRel =[select id,Capacity__c from Project_Phase__c where id=:lstProjAss[0].Project_Phase__c];  
           vacObj = (Vacation_Assignment__c)cont.getRecord() ;   
           VacationObj = new List<Vacation_Overview__c>();
           if(projRel != null)         
           VacationObj =[Select id,name,Capacity_Setup__c, Capacity_Setup__r.Name from Vacation_Overview__c  where Capacity_Setup__c =:projRel[0].Capacity__c order by Name];
           if(lstRole!= null && lstRole.size()>0)         
           VacationObj =[Select id,name,Capacity_Setup__c, Capacity_Setup__r.Name from Vacation_Overview__c  where Capacity_Setup__c =:lstRole[0].Capacity__c order by Name];
         }
   } 
         

    public List<selectOption> getVacations(){
     optionList = new List<selectOption>();
      if(editVacationObj!=null){
          for(Vacation_Overview__c editObj:editVacationObj){
              SelectOption editpopt=new SelectOption(editObj.id,editObj.name);   
              optionList.add(editpopt);
          }
      }
    SelectOption opt1=new SelectOption('Select Vacation Type','Select Vacation Type');
    optionList.add(opt1);
          if(VacationObj != NULL){
              for(Vacation_Overview__c nextObj:VacationObj){
                  SelectOption opt=new SelectOption(nextObj.id,nextObj.name);   
                  optionList.add(opt);
              }
          }     
         return optionList;
   }
   
   public List<selectOption> getRoleDes(){
     optionList = new List<selectOption>();
      if(editRoleObjs!=null){
          for(RoleSetup__c editObj:editRoleObjs){
              SelectOption editpopt=new SelectOption(editObj.id,editObj.name);   
              optionList.add(editpopt);
          }
      }
  SelectOption opt1=new SelectOption('','--None--');
  optionList.add(opt1);
          if(roleObjs != NULL){
              for(RoleSetup__c nextObj:roleObjs){
                  SelectOption opt=new SelectOption(nextObj.id,nextObj.name);   
                  optionList.add(opt);
              }
          }
        return optionList;
   }
   
   public List<selectOption> getReleaseAssgns(){
     optionList = new List<selectOption>();
      if(editRelObjs !=null){
            for(Project_Assignment__c editObj:editRelObjs){
              SelectOption editpopt=new SelectOption(editObj.Id,editObj.Project_Phase__r.Focus_Area__r.Name);   
              optionList.add(editpopt);
          }
      }
   SelectOption opt1=new SelectOption('','---None--');
   optionList.add(opt1);
          if(roleObjs != NULL){
              for(Project_Assignment__c nextObj:[Select id,Project_Phase__r.Focus_Area__r.name from Project_Assignment__c where id=:rel_ass or Role__c =:rel_ass]){
                  SelectOption opt=new SelectOption(nextObj.id,nextObj.Project_Phase__r.Focus_Area__r.name);   
                  optionList.add(opt);
              }
          }
        return optionList;
   }
   public void setVacation(){
   vacObj.Vacation__c = selectedVal;
   }
   
   public void setRoleDes(){
   vacObj.RoleSetup__c = roleDescription;
   } 
   public void setRelAssgn(){
   vacObj.Release_Assignment__c = releaseAssignment;
   }
   
}