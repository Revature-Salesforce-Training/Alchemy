/********************************************
* Author: Matthew Jeffery
* Created: 3/6/2022
* Purpose: Apex Controller for cartList
* Aura component
*
*********************************************/
public without sharing class CartListController {

    //Get list of products for an order
    // Requires string input of the orderId
    @AuraEnabled
    public static CustomerOrder__c getOrder(String orderId)
    {
        try 
        {
            // Gets cart info for each item in the current cart id for display
            List<CustomerOrder__c> customerOrders = [SELECT Id, 
                                                        (SELECT ProductId__c, ProductId__r.Name, ProductId__r.Image_URL__c,ProductId__r.Image_Alt_Tag__c, ProductId__r.Product_Price__c, Quantity_c__c 
                                                            FROM OrderLineItems__r) 
                                                    FROM CustomerOrder__c 
                                                    WHERE Id=:orderId];
            if (customerOrders.size() > 0)
            {
                return customerOrders[0];
            }
            else 
            {
                throw new AuraHandledException('No Matching Records Found');
            }
        }
        catch (Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
    /*
    @AuraEnabled
    public static Boolean submitOrder(String orderId)
    {
        try 
        {
            CustomerOrder__c currentOrder = [SELECT Id, Name, Order_Status__c FROM CustomerOrder__c WHERE id=:orderId];
            currentOrder.Order_Status__c = 'Submitted';
            update currentOrder;
            return true;
        } 
        catch (Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }*/

    @AuraEnabled
    public static String getUserIdPlease()
    {
        return userInfo.getUserId();
    }
}
