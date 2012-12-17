trigger Setter on Account (before update ) {

    
//   for (Account a : Trigger.new) {
    
//        str=a.AccountNumber;
//        List<Contact> maContact= new List<Contact>();
//        Contacts[] cons = [select lastname from contacts
//                          where accountid in :str ];    

        List<Contact> maContact= [Select Dumb__c from Contact
                                    where accountid in :Trigger.new];
//        Savepoint mokkaiSavour = Database.setSavepoint();
        for(Contact c: maContact){
            c.Dumb__c = true;
        }
        update maContact;
        
        
    //}
 }