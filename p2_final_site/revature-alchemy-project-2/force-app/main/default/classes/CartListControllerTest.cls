/********************************************
* Author: Matthew Jeffery
* Created: 3/6/2022
* Purpose: Apex Controller Test for CartListController
* This test should ensure that the list controller returns
* the list of all order line items on the class
*
*********************************************/
@IsTest
public with sharing class CartListControllerTest {

    public static final String fakeid = 'totallyFakeIdNeverUseThisThisIsWrongAndPatentlyFalseWorseThanBigFoot';
    public static final Integer mockQuant = 1;

    @TestSetup
    static void makeData()
    {
        CustomerOrder__c testOrd = new CustomerOrder__c();
        insert testOrd;
        
        OrderLineItem__c testOli = new OrderLineItem__c();
        testOli.Quantity_c__c = mockQuant;
        testOli.OrderId__c = testOrd.Id;
        insert testOli;
    }

    @IsTest
    static void testGetOrder()
    {
        try 
        {
            //Load first known order from list of imported orders
            CustomerOrder__c ordertotest = [SELECT Id FROM CustomerOrder__c LIMIT 1][0];
            String orderToTestId = ordertotest.Id;

            // Give tested method that id and see if it pulls it in
            CustomerOrder__c returnorder = CartListController.getOrder(ordertotest.Id);
            
            //Check if orders are equal
            System.assert(orderToTestId == returnorder.Id, 'Test of order pulling');
        } 
        catch(AuraHandledException e) 
        {
            //Exception is thrown, so good
            System.assert(false, 'Orders did not match');
        }

        try 
        {
            //Test bad id for handling exception
            CartListController.getOrder(fakeid);
        }
        catch (Exception e)
        {
            System.assert(e.getMessage()!= null, 'Error handled by Component');
        }

    }

    @isTest 
    static void testGetUserId()
    {
        System.assert(CartListController.getUserIdPlease()!= null, 'returned User Id');
    }
}
