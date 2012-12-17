/*
Name of the Trigger    :        InvTrigger
Trigger on Object      :        Invoice__c (after insert, after update, after delete, after undelete)
Author                 :        Kiran kumar A
Date of Creation       :        2008-Nov-02
Description            :        When ever a new invoice is created or updated or deleted or undeleted, the
                                Invoice amount need to be rolled up and summed into its respective Opportunity
                                its belonged to.
*/

Trigger InvTrigger on Invoice__c (after insert, after update, after delete, after undelete) {

    //Collect all the opportunities of the affected invoices
    SET<ID> OppIds = new Set<Id>();

    if(Trigger.isDelete == True)       {
        for (Invoice__c Inv : Trigger.old) {
            //Only collect opportunities of affected invoices that are refered
            if(Inv.Opportunity__c != Null ) {
               OppIds.add(Inv.Opportunity__c);
            }
        }   
    }
    else    {
        for (Invoice__c Inv : Trigger.new) {
    
            //Only collect opportunities of affected invoices that are refered
            if(Inv.Opportunity__c != Null ) {
               OppIds.add(Inv.Opportunity__c);
            }
        }
    }

    //List of all the invoices of the collected opportunity
    List<Invoice__c> lInv = [Select Opportunity__c, Invoice_amount__c from Invoice__c where Opportunity__c in : OppIds Limit 1000];

    //List of all the collected Opportunity for the purpose of updation
    List<Opportunity> lOpp = [Select ID, Total_Invoice_amount__c from Opportunity where ID in : OppIds ];

    //Loop in all the opportunities 
    for(Opportunity opp : lopp)    {
    
        Double cInvoiceAmount = 0;
        //Sum the amounts of all the invoices of the contained opportunity
        for(Invoice__c Inv : lInv)    {
        
            if(Inv.Opportunity__c==opp.id) {
                cInvoiceAmount = Inv.Invoice_amount__c + cInvoiceAmount;
            }        
        }
        //Change the Total invoice amount of the opportunity contained
        opp.Total_Invoice_amount__c = cInvoiceAmount ;
     }
     //Update the list
     update lopp;
}