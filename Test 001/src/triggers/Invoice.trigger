trigger Invoice on Invoice__c (after insert, after update, after delete, after undelete) {

//    List<Opportunity> tmpOpp = new List<Opportunity>();
    
//    List<Sobject> lInv = trigger.new;
    
//   Map<ID, Invoice_Amount> m;
 
//    List<SObject> Inv = [Select OpportunityID from Contact
//                        where Invoiceid in :Trigger.new];

    SET<ID> InvIds = new Set<Id>();

    for (Invoice__c Inv : Trigger.new) {

        if(!InvIds.contains(Inv.Opportunity__c)) {
           InvIds.add(Inv.Opportunity__c);
        }
    }
    
    List<Invoice__c> lInv = [Select Opportunity__c, Invoice_amount__c from Invoice__c where Opportunity__c in : InvIds];
    List<Opportunity> lOpp = [Select ID, Total_Invoice_amount__c from Opportunity where ID in : InvIds ];

    Double cInvoiceAmount = 0;

    for(Opportunity opp : lopp)    {
    
        cInvoiceAmount = 0;
        for(Invoice__c Inv : lInv)    {
        
            if(Inv.Opportunity__c==opp.id) {
                cInvoiceAmount = Inv.Invoice_amount__c + cInvoiceAmount;
            }        
        }
        opp.Total_Invoice_amount__c = cInvoiceAmount ;
        update opp;
    }
}