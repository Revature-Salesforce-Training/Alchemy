@isTest 
public class ResourceController_Test {

    // this is a premade User in the org, explicitly so that with our trigger,
    // which sets a default when creating a new User
    // if User.Twitter_Handle__c == null set Twitter_Handle__c to 'BBTimepieces'
    // so we created a record to fulfill our code's testing
    // (see line 13 of ResourceController.cls)
    static String testingUsername = 'nullTwitterHandle@gmail.com';

    static testMethod void ResourceController_Test() {
        
        //validate query results
        System.assertEquals('BBTimepieces', ResourceController.twitterHandle);
        
        User testUser = [SELECT id FROM User Where UserName = :testingUsername];

        System.runAs(testUser){
            System.assertEquals('BBTimepieces', ResourceController.twitterHandle);
        }
    }
}