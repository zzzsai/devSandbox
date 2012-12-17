public class Holiday_Ext{
public String releaseAssignment{set; get;}
public id roleDescription{set; get;}
public Holiday_Assignment__c HoliDayObj = new Holiday_Assignment__c();
List<Holiday_Details__c> holObj {get;set;}
List<RoleSetup__c> roleObjs {get;set;}
List<Project_Assignment__c> relObjs =null;
List<Holiday_Details__c> editholObj =null;
List<Project_Assignment__c> editRelObjs =null;
//List<Holiday_Assignment__c> editRelObjs =null;
List<RoleSetup__c> editRoleObjs =null;
String Id;
String rel_ass;
public List<selectOption> optionList;
public Id selectedVal {get;set;}

public Holiday_Ext(ApexPages.standardController cont){
    
      id=ApexPages.currentPage().getParameters().get('id');
      rel_ass = ApexPages.currentPage().getParameters().get('retUrl');
      if(rel_ass !=null || Id !=null)
      {
        rel_ass  =rel_ass.substring(1);
        List<Holiday_Assignment__c> tmplst=[select Id,holiday__c,RoleSetup__c, RoleSetup__r.Capacity__c,Release_Assignment__c from Holiday_Assignment__c where id =:rel_ass or id =:id];
        if(tmplst.size() >0){
        Holiday_Assignment__c tmpObj=tmplst.get(0);
        editholObj=[select Id,name from Holiday_Details__c where Id = :tmpObj.holiday__c or id =:tmpObj.id]; 
        editRoleObjs=[select Id,name from RoleSetup__c where id=:rel_ass or Id =:tmpObj.RoleSetup__c];
        //editRelObjs=[select id,name, Role__c from Project_Assignment__c where id=:rel_ass or id=:tmpObj.Release_Assignment__c or Role__c=:rel_ass];
        editRelObjs=[select id,Project_Phase__r.Focus_Area__r.Name, Role__c from Project_Assignment__c where Role__c=:tmpObj.RoleSetup__c]; 
        }
     }
     roleObjs=[Select id,name from RoleSetup__c where id in (select Role__c  from project_Assignment__c  where id =:rel_ass or Role__c =:rel_ass )];
     
     List<Project_Assignment__c> lstProjAss = [select id,name,Role__c,Project_Phase__c from Project_Assignment__c where id=:rel_ass or Role__c=:rel_ass];
     List<RoleSetup__c> lstRole= [select id,name,Capacity__c from RoleSetup__c where id=:rel_ass];   
         if(lstProjAss.size() >0)
         {
           List<Project_Phase__c> projRel =[select id,Capacity__c from Project_Phase__c where id=:lstProjAss[0].Project_Phase__c];  
           HoliDayObj = (Holiday_Assignment__c)cont.getRecord() ;   
           holObj = new List<Holiday_Details__c>();
           if(projRel != null)         
           holObj =[Select id,name,Capacity_Setup__c, Capacity_Setup__r.Name from Holiday_Details__c  where Capacity_Setup__c =:projRel[0].Capacity__c order by Name];
           if(lstRole!= null && lstRole.size()>0)         
           holObj =[Select id,name,Capacity_Setup__c, Capacity_Setup__r.Name from Holiday_Details__c  where Capacity_Setup__c =:lstRole[0].Capacity__c order by Name];
         }
   } 
         

    public List<selectOption> getHoliday(){
     optionList = new List<selectOption>();
      if(editholObj!=null){
          for(Holiday_Details__c editObj:editholObj){
              SelectOption editpopt=new SelectOption(editObj.id,editObj.name);   
              optionList.add(editpopt);
          }
      }
    SelectOption opt1=new SelectOption('','Select Holiday Type');
    optionList.add(opt1);
          if(holObj != NULL){
              for(Holiday_Details__c nextObj:holObj){
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
   public void setHoliday(){
   HoliDayObj.holiday__c = selectedVal;
   }
   
   public void setRoleDes(){
   System.debug('roleDescription---------------'+roleDescription);
   HoliDayObj.RoleSetup__c = roleDescription;
   } 
   public void setRelAssgn(){
   HoliDayObj.Release_Assignment__c = releaseAssignment;
   }
}