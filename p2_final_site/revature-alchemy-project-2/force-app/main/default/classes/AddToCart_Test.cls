@isTest
public with sharing class AddToCart_Test {
   
    static final String  testProductName  = 'Kazuha Ultima';
    static final String  testProductAlt   = 'Kazuha Ultima Watch';
    static final String  testProductURL   = 'imgur.com/fakeLink';
    static final String  testProductStyle = 'mens;men';
    static final Integer testProductPrice = 120;

    static final Integer testQuantity = 1;

    static final String testCustomerName = 'Maryland';
    static final String testOrderStatus = 'In Progress';

    // designed explicitly for testing purposes, it's "okay" to hardcode this UserName
    static final String testUserName = 'nullTwitterHandle@gmail.com';


    static final String failProdId = 'notRealId';
    static final String failUserId = 'notRealId';


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
    static void createCartTest()
    {
        User testUser = [SELECT Id FROM User WHERE UserName = :testUserName][0];

        String testReturn = AddProductToCartController.createCart(testUser.Id);
        System.assert(testReturn != null, 'Cart Created');

        try 
        {
            testReturn = AddProductToCartController.createCart(failUserId);
        }
        catch (Exception e)
        {
            System.assert(e.getMessage()!= null, 'Error handled by Component');
        }
    }

     @isTest 
    static void appProductToCartTest()
    {
        BBTProduct__c testProd = new BBTProduct__c();
        BBTCustomer__c testCust = new BBTCustomer__c();
        CustomerOrder__c testOrd = new CustomerOrder__c();

        testProd = [SELECT Id FROM BBTProduct__c WHERE Name = :testProductName][0];
        testCust = [SELECT Id FROM BBTCustomer__c WHERE Name = :testCustomerName][0];
        testOrd = [SELECT Id FROM CustomerOrder__c WHERE BBTCustomerId__c = :testCust.Id][0];

        String testCartId = AddProductToCartController.addProductToCart(testProd.Id, testOrd.Id, testQuantity);
        System.assert(testCartId != null, 'Item Inserted Into Cart');

        try 
        {
            AddProductToCartController.addProductToCart(failProdId, testCust.Id, testQuantity);
        }
        catch (Exception e)
        {
            System.assert(e.getMessage()!= null, 'error handled by component');
        }

    }

     @isTest 
    static void getProductPriceTest()
    {
        BBTProduct__c testProd = new BBTProduct__c();
        testProd = [SELECT Id FROM BBTProduct__c WHERE Name = :testProductName][0];

        Decimal testReturn = AddProductToCartController.getProductPrice(testProd.Id);
        System.assertEquals((Decimal) testProductPrice, testReturn);

        try 
        {
            testReturn = AddProductToCartController.getProductPrice(failProdId);
        }
        catch (Exception e)
        {
            System.assert(e.getMessage()!= null, 'Error handled by component');
        }
    }
}