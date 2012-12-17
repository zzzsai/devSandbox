/*

Name of the Class      :        clsListPermissions 
Author                 :        Kiran kumar A
Date of Creation       :        2010-Jun-14
Description            :        This class will be used to list all the profiles for the business
                                and using those profiles bring and store data of the respective profile's permission
 
*/

//The class that will bring in all the profies and permissions for the profiles
public class clsListPermissions {
    
    //The entire list of profiles
    public List<Profile> lstAllProfiles {get; set;} 
    
    //The profile that is selected
    String[] strProfile;
    
    //A large dump of the table
    public String strExport {get; set;}
    
    //The constructor
    public clsListPermissions() {
    
        //All the profiles that are available in the org.s
        lstAllProfiles = [SELECT
                            id,
                            Name
                        FROM
                            PROFILE
                        LIMIT
                            1000];
    }

    //Populate the profile permission details into the page
    public List<SelectOption> getProfList() {
    
        try {
            //The options that need to be selected by the user
            List<SelectOption> options = new List<SelectOption>();
            
            //Collect all the Ids and the Product Names
            for(Profile tmpProf : lstAllProfiles) { 
                options.add(new SelectOption(tmpProf.id,tmpProf.Name));
            }
            
            //Return the populus
            return options;
        }
        catch(Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL,'Error is '+e.getMessage()));
            return null;            
        }
    }
    //Set the selected profile
    public void setSelProf(String[] strProfiles) {
        
        //Profile's ID is assinged into the Profile
        this.strProfile = strProfiles;
    }

    //Get the selected profile
    public List<String> getSelProf() {
        
        //Profile's ID is assinged into the Profile
        return strProfile;
    }
    
    public PageReference fpgTurn() {
        
            PageReference prExportPage = new PageReference('/apex/pgExportPage');
            prExportPage.setRedirect(false);
            
            return prExportpage;
        
    }
    
    static testMethod void testThisClass(){
        
        //Start the test
        Test.startTest();
        
        //Create an instance of the class
        clsListPermissions clsTestPermissions = new clsListPermissions();       
        String[] strTest = new  String[]{'Test', 'Test1', 'Test2'};
        
        //No Assertion because the below are non-business definition(s)
        clsTestPermissions.getProfList();
        clsTestPermissions.setSelProf(strTest);
        clsTestPermissions.getSelProf();
        clsTestPermissions.fpgTurn();
        
        //Stop the test
        Test.stopTest();    
        
        
    }
        
}