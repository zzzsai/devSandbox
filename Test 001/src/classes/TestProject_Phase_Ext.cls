@isTest
private class TestProject_Phase_Ext {
 static testMethod void testProject_Phase_Ext(){
 CapacityDetailEstimator__c pro = new CapacityDetailEstimator__c();
 pro.Name='SFDC'; 
 insert pro;  
 
 Release__c rel =new Release__c();
 rel.name='wave1';    
 insert rel; 
 
 Release_Estimation__c re_lEstimate = new Release_Estimation__c(); 
 re_lEstimate.Name='Demo Estimate'; 
 insert re_lEstimate;
      
 Project_Phase__c pp =new Project_Phase__c();
 pp.Capacity__c=pro.id;
 pp.Focus_Area__c=rel.id;
 pp.Related_Estimate__c=re_lEstimate.id;
 insert pp;  
     
 ApexPages.currentPage().getParameters().put('id', pp.Id);
 ApexPages.standardController cont=new ApexPages.standardController(pp);  
 Project_Phase_Ext proPhase = new Project_Phase_Ext(cont);
 
 
 proPhase.getReleases();
 proPhase.getEstimates();  
 proPhase.setRelease();
 proPhase.setEstimate();
 proPhase.getRelease();
 proPhase.getEstimate();
 proPhase.setRelease();
 }
}