// Creating a getProducts() method that creates a list of products by querying the Product object.
public with sharing class ProductController {
    @AuraEnabled(cacheable=true)
    public static List<RevoProduct__c> getProducts() {
        return [
            SELECT Name, ProductName__c, Price__c
            //API name for Product object is Product2
            FROM RevoProduct__c
            WITH SECURITY_ENFORCED
            ORDER BY Name Asc
        ];
    }
}