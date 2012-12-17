public class Search{
    public String Id;
    public Double resourceCnt;
    public Double contactCnt;
    public String skill;
    public Integer count=0;
    Public List<Contact> searchResult= new List<Contact>();
    public List<cContact> conSkillList=new List<cContact>();
    List<RoleSetup__c> rolset= new List<RoleSetup__c>();
    Public String error='';
    Boolean isError=false;
    List<Project_Assignment__c> editRelObjs =null;
    public List<selectOption> optionList;
    public String releaseAssignment{set; get;}
    public Project_Assignment__c proObj = new Project_Assignment__c();
    public String cellcolor ='';
    
    public Search(ApexPages.StandardController controller){
    Id=ApexPages.currentPage().getParameters().get('id');
    System.debug('ID----------------------'+id);
    contactsearch();
    //Added by Vineet
        RoleSetup__c roleInfo=[Select Id,No_of_Resources__c,Count__c from RoleSetup__c where Id=:Id];
        resourceCnt=roleInfo.No_of_Resources__c;
        contactCnt=roleInfo.Count__c;
        /** It is used to selection of Role for the Release 
        */ 
        //proObj = (Project_Assignment__c)controller.getRecord() ; 
        editRelObjs=[select id,name,Role__c,Project_Phase__r.Focus_Area__r.Name FROM Project_Assignment__c where Role__c=:id order by Project_Phase__r.Focus_Area__r.Name ASC ]; 
        System.debug('editRelObjs---------'+editRelObjs);
       }
   public List<selectOption> getReleaseAssgns(){
     optionList = new List<selectOption>();
      if(editRelObjs !=null){
      SelectOption opt1=new SelectOption('','---None---');
      optionList.add(opt1);
            for(Project_Assignment__c editObj:editRelObjs){
              SelectOption editpopt=new SelectOption(editObj.Id,editObj.Project_Phase__r.Focus_Area__r.Name);   
              optionList.add(editpopt);
          }
      }
    return optionList;
   }
  
  public String rid;
   public void setRelAssgn( ){
   proObj.Project_Phase__c =releaseAssignment;
   }
    
    public void contactSearch(){ 
        RoleSetup__c roleset = [select Expert_Skills__c,Secondary_Skills__c from RoleSetup__c where id= :Id];   
        String ExpertSkill= roleset.Expert_Skills__c;
        String SecondarySkill= roleset.Secondary_Skills__c;
        /*
        String[] ExpertSkills;
        String[] SecondarySkills;
        String str1 = ExpertSkill.replaceAll(';',',') ;
        String str2 = SecondarySkill.replaceAll(';',',') ;
        ExpertSkills= ExpertSkill.split(';');
        SecondarySkills = SecondarySkill.split(';');
        */
        if(ExpertSkill !=null && SecondarySkill !=null){
            for(Contact c :[SELECT Name,Expert_Skills__c,Secondary_Skills__c,Offshore_Onshore__c FROM Contact where Expert_Skills__c includes(:ExpertSkill ) or Expert_Skills__c includes(:SecondarySkill) or Secondary_Skills__c includes(:ExpertSkill ) or Secondary_Skills__c includes(:SecondarySkill)]){
              conSkillList.add(new cContact(c,Id));
            }
        }      
    }
   
   public List<RoleSetup__c> getRolsetup(){
   return rolset;
   }  
    public PageReference resource(){
        insert rolset;
        PageReference res_search=new PageReference('/apex/ResourceSearch?id='+id+'');
        res_search.setRedirect(true);
        return res_search;
    }
    public PageReference cancel(){
        PageReference res_search=new PageReference('/'+id+'');
        res_search.setRedirect(true);
        return res_search;
    }

   public List<cContact> getresults()
   {
     return conSkillList;
   }
   
   public void setError(String errorMesg){
       error=errorMesg;
   }
   public String getError(){
       return error;
   }
    public class cContact
    {
         public Contact con {get; set;}
         public Boolean selected {get; set;}
         public Contact_Assignment__c  cAssn {get; set;}
         public String programName{get; set;}
         public String cellcolor {get; set;}
         public String sp {get; set;}
         public String fontcolor {get; set;}
         List<Contact_Assignment__c> cAssnList =new List<Contact_Assignment__c>();
         List<Contact_Assignment__c> conAssgn1=new List<Contact_Assignment__c>();
        
         public cContact(Contact c, String roleId)
         {
             con = c;
             selected = false;
             cellcolor ='#FFFFFF';
             programName = ''; 
             retrieveRoleDetails(roleId,c);
         }
        public void retrieveRoleDetails(String roleId,Contact c){
                            
               System.debug('CONTACT----------'+c.id);
               System.debug('cellcolor  ----------'+cellcolor);
            
                List<Contact_Assignment__c> conAssgn1=[select Id,Program__c,Contact__c,End_Date__c,Start_Date__c, Release_Assignment__r.Role__r.SDate__c FROM  Contact_Assignment__c where Contact__c =:c.Id];
                    system.debug('TEST-'+c.id+':'+conAssgn1.size());
                    if(conAssgn1==null || conAssgn1.size()==0){
                       System.debug('GREEN--'+c.Id);
                       cellcolor  = '#007A29;color:#007A29';
                       sp='.'; 
                       System.debug('Inside Green----------'+cellcolor);
                    }
                    else{
                      for(Contact_Assignment__c pCon:conAssgn1){       
                         If(pCon!=null && pCon.Release_Assignment__r.Role__r.SDate__c != null){
                           Date temp =pCon.Release_Assignment__r.Role__r.SDate__c.addDays(14);
                            if((pCon.Start_Date__c == pCon.End_Date__c) || (pCon.End_Date__c == temp) ||((pCon.Start_Date__c < pCon.End_Date__c)&&(pCon.End_Date__c <  temp))){
                               cellcolor  = '#FFF333;color:#FFF333'; // Yellow 
                               sp='.'; 
                            }
                            else{                        
                                cellcolor ='#CC2900;color:#CC2900';    // RED  
                                sp='.';
                                System.debug('color is'+cellcolor);
                             } 
                          }
                        if(!programName.contains(pCon.Program__c)){    
                            programName=programName+pCon.Program__c+',';
                        }
                    }//end of for
                     programName=programName.substring(0,programName.length()-1);
                   }               
              }               
          }            
    
    public PageReference add()
    {
      List<Contact> selectedContacts = new List<Contact>();
      Database.SaveResult[] result; 
      
      system.debug('Contact cnt:'+contactCnt);
      system.debug('Resource Cnt:'+resourceCnt);
      if(conSkillList!= null)
       {
         for(cContact cCon : conSkillList)
         {
             if((cCon.selected == true)&& (cCon.cellcolor !='#CC2900;color:#CC2900'))
             {
             selectedContacts.add(cCon.con);
             count++;
             }
             else if((cCon.selected == true) && cCon.cellcolor =='#CC2900;color:#CC2900'){
                 setError('This Resource has been Assigned allready, Please choose other Resource');
                 isError=true;
                 return null;
                 
             }
         }
         system.debug('Selected Contacts:'+selectedContacts);
      } 
        contactCnt=contactCnt+count;
        system.debug('contactCntContacts-----------:'+contactCnt);
       if(contactCnt>resourceCnt){
          setError('Contacts for this Role Summary cannot be greater than '+resourceCnt);
          isError=true;
          count=0;
          return null;
      }
      
      if(!isError){           
          List<Contact_Assignment__c> conAssignArr=new List<Contact_Assignment__c>();
          for(Contact c:selectedContacts){
              Contact_Assignment__c conAssign = new Contact_Assignment__c();
              conAssign.Contact__c=c.Id;
              conAssign.Role_Summary__c=Id;
              conAssign.Release_Assignment__c=releaseAssignment;
              conAssignArr.add(conAssign);
          } 
          result=Database.insert(conAssignArr);
            PageReference res_search=new PageReference('/'+Id+'');
            res_search.setRedirect(true);
            return res_search;
      }
      else{
       return null;
      }
  }
}