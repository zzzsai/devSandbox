@isTest
// This class is bound to API version 16.0 by Version Settings 
    
private class InvTester
{  
    static testMethod void TestInvoice()
    {
    
        
        Account aIns = new Account(name='Test Account');

        insert aIns;
                
        Opportunity OppIns = new Opportunity() ;
        OppIns.Name='Test';
        OppIns.CloseDate=date.newInstance(2009, 10, 24);
        OppIns.StageName='Needs Analysis';
        OppIns.accountid = aIns.id;
        insert OppIns;

        Invoice__c InvIns= new Invoice__c() ;
        InvIns.Invoice_amount__c=2500;
        InvIns.Opportunity__c = OppIns.id;
        
        insert InvIns;
        
        Invoice__c InvIns1= new Invoice__c() ;
        InvIns1.Invoice_amount__c=1800;
        InvIns1.Opportunity__c = OppIns.id;
        
        insert InvIns1;
                
        Opportunity OppIns1 = new Opportunity() ;
        OppIns1.Name='Test1';
        OppIns1.CloseDate=date.newInstance(2009, 10, 10);
        OppIns1.StageName='Perception Analysis';
        OppIns1.accountid = aIns.id;
        insert OppIns1;
        
        Opportunity OppIns2 = new Opportunity() ;
        OppIns2.Name='Test2';
        OppIns2.CloseDate=date.newInstance(2010, 01, 05);
        OppIns2.StageName='Qualification';
        OppIns2.accountid = aIns.id;
        insert OppIns2;

        Invoice__c InvIns2= new Invoice__c() ;
        InvIns2.Invoice_amount__c=8800;
        InvIns2.Opportunity__c = OppIns2.id;
        
        insert InvIns2;

        
        InvIns = [SELECT Invoice_amount__c FROM Invoice__c WHERE Id =:InvIns.id];
        System.assertEquals(2500, InvIns.Invoice_amount__c);

        delete InvIns1 ;
        delete InvIns ;
        delete InvIns2 ;
                
        delete OppIns ;
        delete OppIns1 ;
        delete OppIns2 ;
        
        delete aIns ;

    }
}