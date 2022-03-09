//written by Patrick Sepnio, reviewed by Eli Couture
public with sharing class ProductReview {
    static final Integer RECORDS_TO_RETURN=3; //limit of reviews to return to LWC

    @AuraEnabled
    public static List<BBTProduct_Review__c> getLimitedReviews(String inProductId){

        // create a list to store our reviews in
        List<BBTProduct_Review__c> returnReviews = new List<BBTProduct_Review__c>();

        try
        {
            // select our relevant information, filtering by the product ID sent in as parameters
            // always only return 3.
            returnReviews=[SELECT ID, Review_Stars__c,Customer_Name__c ,Review_Content__c
                            FROM BBTProduct_Review__c
                            WHERE BBT_Product__c = :inProductId
                            LIMIT :RECORDS_TO_RETURN];
                            
            // as long as we HAVE a review, send the list back
            if (returnReviews.size()>0) 
            {
                return returnReviews;
            }
            else
            {
                throw new AuraHandledException('No reviews found for product.');
            }
        }   
        catch(Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
}