public with sharing class GetIndvProductInfo {
    
    // @AuraEnabled decorator means we can import and call it from LWC/Aura components
    @AuraEnabled
    public static BBTProduct__c getProduct(String inRecordId)
    {
        // this will store our records returned by our SOQL query,
        // using a list because it will work with 1 record, 0 records, or multiple
        // instead of one, which an be finicky
        List<BBTProduct__c> searchList = new List<BBTProduct__c>();

        // Query exceptions and a manually thrown AuraHandledException can come up
        // so make sure its in try/catch to then throw the AuraHandledExpression down to 
        // the LWC/Aura component to handle
        try 
        {
            // we get passed in a Salesforce Record ID of a product,
            // and we only want that ONE specifici product
            searchList =   [SELECT Id, Name, Image_Alt_Tag__c, Image_URL__c, Product_Price__c
                            FROM BBTProduct__c
                            WHERE Id = :inRecordId];

            // in case there is no product with that ID (there should always be considering it's
            // dynamically pulled/sourced, but yknow, still)
            // we check if the SOQL query returned ANY records at all   
            if(searchList.size() > 0)
            {
                return searchList[0];   // and we return the first one. there should only BE one, but even if 
                                        // there were multiple, we do not care about the others.
                                        // we are explicitly returning ONE product.
            }
            else 
            {
                // if we do not find any records that match our record ID,
                // throw an error with a specific message
                throw new AuraHandledException('No Records Found with matching ID');
            }
        } 
        catch (Exception e) 
        {
            // catch any errors and throw them down into the LWC/Aura component to handle
            throw new AuraHandledException(e.getMessage());
        }

    }
}