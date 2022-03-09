@isTest
public with sharing class OrderLineItemTrigger_Test {
    
    static final Integer testQuantity = 1;
    static final Integer failQuantity = 0;
   
    static final String  testProductName  = 'Kazuha Ultima';
    static final String  testProductAlt   = 'Kazuha Ultima Watch';
    static final String  testProductURL   = 'imgur.com/fakeLink';
    static final String  testProductStyle = 'mens;men';
    static final Integer testProductPrice = 120;

    static final String testCustomerName = 'Maryland';
    static final String testOrderStatus = 'In Progress';

    @TestSetup
    static void makeData(){
        BBTProduct__c testProd = new BBTProduct__c();
        BBTCustomer__c testCust = new BBTCustomer__c();
        CustomerOrder__c testOrd = new CustomerOrder__c();
        
        testProd.Name = testProductName;
        testProd.Image_Alt_Tag__c = testProductAlt;
        testProd.Image_URL__c = testProductURL;
        testProd.Product_Style__c = testProductStyle;
        testProd.Product_Price__c = testProductPrice;
        insert testProd;

        testCust.Name = testCustomerName;
        insert testCust;

        testOrd.Order_Status__c = testOrderStatus;
        testOrd.BBTCustomerId__c = testCust.Id;
        insert testOrd;

    }

    @isTest 
    static void negativeQuantityTest()
    {
        BBTProduct__c testProd = new BBTProduct__c();
        BBTCustomer__c testCust = new BBTCustomer__c();
        CustomerOrder__c testOrd = new CustomerOrder__c();

        testProd = [SELECT Id FROM BBTProduct__c WHERE Name = :testProductName][0];
        testCust = [SELECT Id FROM BBTCustomer__c WHERE Name = :testCustomerName][0];
        testOrd = [SELECT Id FROM CustomerOrder__c WHERE BBTCustomerId__c = :testCust.Id][0];

        OrderLineItem__c testItem = new OrderLineItem__c();
        testItem.ProductId__c = testProd.Id;
        testItem.OrderId__c = testOrd.Id;
        testItem.Quantity_c__c = testQuantity;

        OrderLineItem__c testItemFail = new OrderLineItem__c();
        testItemFail.ProductId__c = testProd.Id;
        testItemFail.OrderId__c = testOrd.Id;
        testItemFail.Quantity_c__c = failQuantity;

        try 
        {
            insert testItem;
            System.assert(testItem.Id != null, 'Test Line Item successfully inserted');
        }
        catch (Exception e)
        {
            System.assert(false, 'Invalid Insert');
        }

        try 
        {
            insert testItemFail;
        }
        catch (Exception e)
        {
            System.assert(e.getMessage()!= null, 'Trigger responded with error of negative value');
        }

    }
    
}