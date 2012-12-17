@isTest
private class TestVacation_Ext {

 static testMethod void testVacation_Ext(){        
     Vacation_Overview__c vac= new Vacation_Overview__c();
     vac.Name='Fever';
     insert vac;
  
     RoleSetup__c role = new RoleSetup__c();
     role.Name='developer';
     role.No_of_Resources__c=3;
     insert role;
  
     Release__c release = new Release__c();
     release.Name='Demo';
     insert release;
    
     Project_Phase__c pr = new Project_Phase__c();
     pr.Focus_Area__c=release.id;
     insert pr ;
     
     Vacation_Assignment__c va=new Vacation_Assignment__c();
     va.Vacation__c= vac.id;
     va.RoleSetup__c = role.id;
     va.Release_Assignment__c = pr.Focus_Area__r.name;
     insert va;
     ApexPages.currentPage().getParameters().put('retUrl', '%2F'+role.Id); 
     ApexPages.currentPage().getParameters().put('id', va.Id); 
     ApexPages.standardController cont=new ApexPages.standardController(va);    
     Vacation_Ext testVac = new Vacation_Ext(cont);   
     testVac.getVacations();
     testVac.getRoleDes();
     testVac.getReleaseAssgns(); 
     testVac.setVacation();
     testVac.setRoleDes();
     testVac.setRelAssgn();    
     
     
 }
}