@isTest
public with sharing class CustomerTriggerTest {

    @isTest
    static void failCustomerTriggerTest() {

        String testName = 'Daffy Duck';
        String testMail = 'dd@yahoo.com';
        String userIdTest = UserInfo.getUserId();

        BBTCustomer__c test1 = new BBTCustomer__c();
        BBTCustomer__c test2 = new BBTCustomer__c();

        test1.Name = testName;
        test1.Customer_Email__c = testMail;
        test1.User_Id__c = userIdTest;

        test2.Name = testName;
        test2.Customer_Email__c = testMail;
        test2.User_Id__c = userIdTest;

        insert test1;
        try 
        {
            insert test2;
            System.assert(false, 'Trigger failed to detect duplicate');
        }
        catch (Exception e)
        {
            System.assert(e.getMessage()!=null, 'Error handled by Component');
        }
    }
    

}