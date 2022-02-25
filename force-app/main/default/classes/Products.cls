public with sharing class Products {

   //make the NumbersLeft field update after a customer puts down an order

    @AuraEnabled 
    public static List<Product2> getShoes (String inCode){  
        try{
            List<Product2> searchedShoes=new List<Product2>();
            String searchCode='%'+inCode+'%';

            //Looks for product through the product code
            searchedShoes=[SELECT Name, ID, NumberLeft__c, ProductCode
                            FROM Product2
                            WHERE ProductCode
                                LIKE :searchCode];

            return searchedShoes;       
        }
        catch (Exception e){
            throw new AuraHandledException(e.getMessage());
        }       
    }

}