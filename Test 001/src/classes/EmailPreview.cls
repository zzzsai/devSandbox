public class EmailPreview {

    public List<Opportunity> opp;
    
/*  private String accId = '';*/

    public id accid{get;set;}
            
    public EmailPreview(){
        
        
    }   
/*  
    public void setaccid(String accid)      {

    
        
    }
    
    
    public String getaccid()
    {
        return accid;
    }
    
    */
    public List<Opportunity> getOppData() {
        /*this.accid = accid;*/
        opp = new list<Opportunity>();
        opp = [Select Name, CloseDate, StageName from Opportunity where AccountId = :AccId order by closeDate desc];
        return opp;
    }
    

}