/*
Name of the Trigger    :        InvTrgT
Trigger on Object      :        Invoice__c (after insert, after update, after delete, after undelete)
Author                 :        Kiran kumar A
Date of Creation       :        2008-Nov-02
Description            :        When ever a new invoice is created or updated or deleted or undeleted, the
                                Invoice amount need to be rolled up and summed into its respective Opportunity
                                its belonged to.
*/

Trigger InvTrgT on Invoice__c (after insert, after update, after delete, after undelete) {

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
    
    //Map for collecting the opportunities and the sum of invoice amounts
    Map<id,Double>  mpOppInvTIA = new Map<id,Double>();
    
    //A temporary variable for the purpose of assignation
    Double tempTot;

    //Loop in all the invoices to get the total amount of all the concerned opportunities
    for(Invoice__c Inv : lInv)    {    

        //Check if the opportunity already exists
        if(mpOppInvTIA.containsKey(Inv.Opportunity__c))    {

            //The opportunity exists, so get the sum and add it
            tempTot = mpOppInvTIA.get(Inv.Opportunity__c) + Inv.Invoice_amount__c;

        }
        else    {
            
            //The opportunity does noes not exist, so get the sum
            tempTot = Inv.Invoice_amount__c;
        }
        
        //Assign the opportunity with the new sum
        mpOppInvTIA.put(Inv.Opportunity__c,tempTot);
    }
    
    //Loop in all the opportunities 
    for(Opportunity opp : lopp)    {
    
        //Change the values of all the invoice amounts
        opp.Total_Invoice_amount__c = mpOppInvTIA.get(opp.ID);

     }
     //Update the list
     update lopp;
}