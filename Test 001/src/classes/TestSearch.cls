@isTest
private class TestSearch {
 static testMethod void testSearch(){             
  CapacityDetailEstimator__c program =new CapacityDetailEstimator__c();
  program.Name='SFDC Test'; 
  insert program; 
     
  RoleSetup__c role =new RoleSetup__c();
  role.Name='Developer';
  role.Capacity__c=program.id;
  role.No_of_Resources__c=5;
  role.Expert_Skills__c='Java';
  role.Secondary_Skills__c='SFDC';
  role.Onshore_Offshore__c='Onshore';
  insert role;
  
  Contact contact= new Contact();
  contact.LastName='Kumar';
  contact.FirstName='Rajeev';
  contact.Expert_Skills__c='Java';
  contact.Secondary_Skills__c='SFDC';
  contact.Offshore_Onshore__c='Onshore';
  insert contact;
  
  Release__c rel = new Release__c();
  rel.Name='Developer-10';
  insert rel;
  
  Project_Phase__c ph = new Project_Phase__c();
  ph.Focus_Area__c=rel.id;
  insert ph;
  
  Project_Assignment__c proAssign = new Project_Assignment__c();
  proAssign.Project_Phase__c=ph.id;
  proAssign.Role__c=role.id;
  insert proAssign;
  
  
  Contact_Assignment__c cAssign = new Contact_Assignment__c();
  cAssign.Role_Summary__c=role.id;
  cAssign.Release_Assignment__c=proAssign.id;
  insert cAssign;
 
  ApexPages.currentPage().getParameters().put('id',role.id); 
  ApexPages.standardController cont=new ApexPages.standardController(role);  
     Search search = new Search(cont);
     ApexPages.currentPage().getParameters().put('Error',search.Error);
     //ApexPages.currentPage().getParameters().put('selectOption','search.selectOption');
     //ApexPages.currentPage().getParameters().put('cellcolor',search.cellcolor);
     Search.cContact inSearch  = new Search.cContact(new Contact(LastName = 'asdf'), 'asdf'); 
     search.getReleaseAssgns();
     search.setRelAssgn( ); 
     search.getRolsetup();
     search.resource();
     search.cancel(); 
     search.getresults();
     search.getError();
     search.setError('s');
     search.add();
     
 }
}