@isTest
private class TestOngoing_Ext {

 static testMethod void testOngoing_Ext(){        
 
     Release__c release = new Release__c();
     release.Name='Demo';
     insert release;
    
     CapacityDetailEstimator__c capSetobj = new CapacityDetailEstimator__c();
     capSetobj.Release__c=release.id;
     insert capSetobj;
     
     RoleSetup__c role = new RoleSetup__c();
     role.Capacity__c=capSetobj.id;
     role.Name='developer';
     role.No_of_Resources__c=3;
     insert role;
     
     Project_Phase__c ph = new Project_Phase__c();
     ph.Focus_Area__c=Release.id;
     insert ph;
     
     Project_Assignment__c  pa = new Project_Assignment__c();
     pa.Project_Phase__c=ph.id;
     pa.Role__c=role.id;
     insert pa;
    
     Ongoing_Activity__c ongoing= new Ongoing_Activity__c();
     ongoing.Capacity__c=capSetobj.id;
     insert ongoing;
    
     Project_Phase__c pr = new Project_Phase__c();
     pr.Focus_Area__c=release.id;
     pr.Capacity__c=capSetobj.id;
     insert pr;
     
     Ongoing_Activity_Assignment__c onAssign =new Ongoing_Activity_Assignment__c();
     onAssign.RoleSetup__c = role.id;
     onAssign.Ongoing_Activity__c= ongoing.id;
     onAssign.Release_Assignment__c = pa.id;
     insert onAssign ;
     
     ApexPages.currentPage().getParameters().put('retUrl', '%2F'+role.Id); 
     ApexPages.currentPage().getParameters().put('id', onAssign.Id); 
     ApexPages.standardController cont=new ApexPages.standardController(onAssign);    
     Ongoing_Ext testOngoing = new Ongoing_Ext(cont);   
     testOngoing.getOngoing();
     testOngoing.getRoleDes();
     testOngoing.getReleaseAssgns(); 
     testOngoing.setOngoing();
     testOngoing.setRoleDes();
     testOngoing.setRelAssgn();    
     
     
 }
}