@isTest
public with sharing class CreateCustomerTest {

    static final String mockName = 'Donald Duck";"';
    static final String mockEmail = 'dd@yahoo.com';


    @isTest
    static void getCustomersTest()
    {
        try 
        {
            String custId = CreateCustomer.createCustomer(mockName, mockEmail);
            System.assert(custId!=null, 'create customer succeeded');
        } 
        catch (Exception e) 
        {
            System.assert(false, 'create customer failed');
        }

        try 
        {
            CreateCustomer.createCustomer(mockName, mockEmail);
            CreateCustomer.createCustomer(mockName, mockEmail);
            System.assert(false, 'Trigger failed to detect duplicate');
        }
        catch (Exception e)
        {
            System.assert(e.getMessage()!= null, 'Error handled by Component');
        }
    }
}




