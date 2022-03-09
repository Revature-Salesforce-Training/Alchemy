public with sharing class AddProductToCartController {

    String cartId;

    @AuraEnabled
    public static string addProductToCart(String productId, String cartId, Decimal quantity) 
    {
        try 
        {
            // create a new record for a junction object with its Master-Detail Lookups set accordingly
            OrderLineItem__c productLineItem = new OrderLineItem__c(ProductId__c=productId, OrderId__c=cartId, Quantity_c__c=quantity);

            insert productLineItem;         // try to insert the new junction record
            return productLineItem.Id;    // return back the id of the junction record
        } 
        catch (Exception e) 
        {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string createCart(String inUserId)
    {
        try 
        {
            // Create cart
            CustomerOrder__c cart = new CustomerOrder__c();

            // set the cart's lookup to User (you must be logged in to use the site currently, so we use this to track whose logged in)
            // there are no anonymous users here at Big Brother Watches... I mean Big Brother Timepieces
            cart.User_Id__c = inUserId;//UserInfo.getUserId();//inUserId;
            cart.Order_Status__c = 'In Progress';

            
            insert cart;        // try to insert our cart
            return cart.Id;     // return back the id of our order/cart
        } 
        catch (Exception e) 
        {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static Decimal getProductPrice(String productId) 
    {
        try
        {
            // create a list to store our products in
            List<BBTProduct__c> productList = new List<BBTProduct__c>();
    
            // select our products based off Id, should always return 1, but the code wants a List
            productList = [SELECT Id, Name, Product_Price__c FROM BBTProduct__c WHERE Id=:productId LIMIT 1];
    
            // as long as we have a product returned from our SOQL, send back the price
            if(productList.size() > 0)
            {
                return productList[0].Product_Price__c;
            }
            else 
            {
                throw new AuraHandledException('No matching records found with Id');
            }
        }
        catch(Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
}