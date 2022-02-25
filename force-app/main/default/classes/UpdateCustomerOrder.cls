public without sharing class UpdateCustomerOrder {
    public UpdateCustomerOrder() {

    } 
    
    /**
     * take in the full name, the order number ON-{00000000}, and the 
     * new order status. there is a trigger to verify order status is valid
     */
    @AuraEnabled
    public static void updateOrderByNumAndFullName(String custFullName, String custOrdNum, String newStatus)
    {
        try 
        {
            // take in and store as separate value for future dynamic possibility
            String searchName = custFullName;
            String searchNum = '%'+custOrdNum;

            // searchName should be exact as its sent from a variable storing data
            // from a previous SOQL query, same for searchNum
            List<Customer_Order__c> orderToUpdate = [
                SELECT  Order_Status__c, Customer_Full__c, Name, ID 
                FROM Customer_Order__c 
                    WHERE Customer_Full__c = :searchName
                    AND Name LIKE :searchNum];	

            // update the status to the new one sent as parameter
            orderToUpdate[0].Order_Status__c = newStatus;
            update orderToUpdate;
            // there is a trigger to perform validation

        } 
        catch (DmlException e) 
        {
            // code bricking safety currently unused as not production code
        }
        catch (Exception e) 
        {
            throw new AuraHandledException(e.getMessage());
            // code bricking safety currently unused as not production code
        }
    }
}