public with sharing class CreateCustomer {
    @AuraEnabled
    public static String createCustomer(String inName, String inEmail) {

        // store the User ID to create a lookup field with
        String inUserId = userInfo.getUserId();

        try
        {
            // create a customer and set values as necessary
            BBTCustomer__c insertCustomer = new BBTCustomer__c();
            insertCustomer.Name = inName;
            insertCustomer.Customer_Email__c = inEmail;
            insertCustomer.User_Id__c = inUserId;

            
            insert insertCustomer;          // try to insert the new customer
            return (insertCustomer.ID);     // and if successful, return the ID
        }
        catch(Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }

    }
}