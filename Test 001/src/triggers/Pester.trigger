trigger Pester on Account (after insert) {

    Contact cNew = new Contact();
    List<Sobject> a = trigger.new;

    cNew.LastName = 'Kiran';
    cNew.Accountid= a[0].id;
    insert cNew;

 }