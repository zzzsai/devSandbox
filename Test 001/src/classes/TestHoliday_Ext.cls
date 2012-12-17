@isTest
private class TestHoliday_Ext {

 static testMethod void testHoliday_Ext(){        
     Holiday_Details__c holi= new Holiday_Details__c();
     holi.Name='Dewali';
     insert holi;
  
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
     
     Holiday_Assignment__c ho =new Holiday_Assignment__c();
     ho.Holiday__c= holi.id;
     ho.RoleSetup__c = role.id;
     ho.Release_Assignment__c = pr.Focus_Area__r.name;
     insert ho;
     ApexPages.currentPage().getParameters().put('retUrl', '%2F'+role.Id); 
     ApexPages.currentPage().getParameters().put('id', ho.Id); 
     ApexPages.standardController cont=new ApexPages.standardController(ho);    
     Holiday_Ext testHoli = new Holiday_Ext(cont);   
     testHoli.getHoliday();
     testHoli.getRoleDes();
     testHoli.getReleaseAssgns(); 
     testHoli.setHoliday();
     testHoli.setRoleDes();
     testHoli.setRelAssgn();    
     
     
 }
}