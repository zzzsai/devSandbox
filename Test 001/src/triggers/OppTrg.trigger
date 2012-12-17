/*
Name of the Trigger    :        OppTrg 
Trigger on Object      :        Opportunity (after insert, after update, after delete, after undelete)
Author                 :        Kiran kumar A
Date of Creation       :        2008-Nov-02
Description            :        When ever a new invoice is created or updated or deleted or undeleted, the
                                Invoice amount need to be rolled up and summed into its respective Opportunity
                                its belonged to.
*/

Trigger OppTrg on Opportunity (after insert, after update, before delete, after undelete) {

    //Collect all the opportunities of the affected invoices
    SET<ID> AccIds = new Set<Id>();

    if(Trigger.isDelete == True)       {

        for (Opportunity Opp : Trigger.old) {
            //Only collect Accounts of affected Opportunities that are refered
            if(Opp.accountid != Null ) {
               AccIds.add(Opp.accountid);
            }
        }   
    }
    else    {
        for (Opportunity Opp : Trigger.new) {
    
            //Only collect Accounts of affected Opportunities that are refered
            if(Opp.accountid != Null ) {
               AccIds.add(Opp.accountid);
            }
        }
    }

    //List of all the invoices of the collected opportunity
    List<Opportunity> lOpp = [Select accountid, Total_Invoice_amount__c from Opportunity where accountid in : accIds Limit 1000];

    //List of all the collected Opportunity for the purpose of updation
    List<Account> lacc = [Select ID, Total_Invoice_amount__c from Account where ID in : AccIds];   
    
    //Map for collecting the Accounts and the sum of Opportunity amounts
    Map<id,Double>  mpAccOppTIA = new Map<id,Double>();
    
    //A temporary variable for the purpose of assignation
    Double tempTot;

    //Loop in all the invoices to get the total amount of all the concerned opportunities
    for(Opportunity Opp : lOpp)    {    

        //Get the sum of invoice amount for the concerend opportunity id
        tempTot = mpAccOppTIA.get(Opp.accountid);

        //Check if the sum of invoice amount is null
        if(tempTot == NULL)    {
            //If it is Null, then the account is not available in the map
            //So, assign the invoice amount to the tempTot
            tempTot = Opp.Total_Invoice_amount__c;
        }
        else    {
            //If it is a new Opportunity, the total amount is Null,
            //Set the tempTot to 0
            if (Opp.Total_Invoice_amount__c == Null ) {
                tempTot = tempTot +0;
            }
            else    {
                tempTot = tempTot + Opp.Total_Invoice_amount__c;
            }
        }
        
        //Assign the Accounts with the new sum
        mpAccOppTIA.put(Opp.accountid,tempTot);
    }
    
    //Loop in all the Accounts
    for(Account acc : lacc)    {
    
        //Change the values of all the invoice amounts
        acc.Total_Invoice_amount__c = mpAccOppTIA.get(acc.ID);

     }
     //Update the list
     update lacc;
}