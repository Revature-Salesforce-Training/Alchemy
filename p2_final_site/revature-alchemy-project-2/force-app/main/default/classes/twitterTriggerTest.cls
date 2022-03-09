@isTest
public class twitterTriggerTest {
    
    static testMethod void defaultTwitterTest(){
        //insert new user   
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User usr = new User(LastName = 'Scotty',
                            FirstName='M.',
                            Alias = 'mascott',
                            Email = 'm.livestrong@asdf.com',
                            Username = 'm.livestrong@example.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           );
        //insert new User
        
        Test.startTest();
        insert usr;
        //retrieve the new User
        usr = [SELECT Name, Twitter_Handle__c FROM User WHERE Name='M. Scotty'];
        Test.stopTest();
        System.debug(usr.Twitter_Handle__c);
        //test that the trigger correctly updated the Twitter handle        
        System.assertEquals('BBTimepieces', usr.Twitter_Handle__c);
    }
}