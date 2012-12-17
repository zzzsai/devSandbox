global class SpecialAccounts {

  global class AccountInfo {WebService String AcctName;
     WebService Integer AcctNumber;
  }WebService static Account createAccount(AccountInfo info) {Account acct = new Account();
    acct.Name = info.AcctName;
    acct.AccountNumber = String.valueOf(info.AcctNumber);
    insert acct;
    return acct;
  }WebService static Id [] createAccounts(Account parent, 
       Account child, Account grandChild) {

        insert parent;
        child.parentId = parent.Id;
        insert child;
        grandChild.parentId = child.Id;
        insert grandChild;

        Id [] results = new Id[3];
        results[0] = parent.Id;
        results[1] = child.Id;
        results[2] = grandChild.Id;
        return results;
    }TestMethod static void testAccountCreate() {AccountInfo info = new AccountInfo();
    info.AcctName = 'Manoj Cheenath';
    info.AcctNumber = 12345;
    Account acct = SpecialAccounts.createAccount(info);
    System.assert(acct != null);
  }
}