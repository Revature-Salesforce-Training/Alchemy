@isTest
public with sharing class ProductReviewTest {
    //testing values
    private static String testNumberStars='2';
    private static String testReviewContent='stupid watch';
    private static String testProductName='Beff Jezos';
    private static Integer testProductPrice=100;
    private static String testCustomerName='Steve Jobs Ex Wife';

    @TestSetup
    static void makeData(){

        List<BBTProduct_Review__c> reviewList= new List<BBTProduct_Review__c>();
        String testStars=testNumberStars;
        String testContent=testReviewContent;
        
        BBTProduct__c testProduct= new BBTProduct__c();
        testProduct.Name=testProductName;
        testProduct.Product_Price__c = testProductPrice;
        
        //these next values are not tested for but required for product insertion
        testProduct.Image_Alt_Tag__c='a';
        testProduct.Image_URL__c='a';
        testProduct.BBTProductDescription__c='a';

        insert testProduct;
 

        BBTCustomer__c testCustomer= new BBTCustomer__c();
        testCustomer.Name=testCustomerName;
        insert testCustomer;


        for(Integer i=0; i<5;i++){
            BBTProduct_Review__c rev=new BBTProduct_Review__c(); 
            rev.Review_Stars__c=testStars;
            rev.Review_Content__c=testContent;
            rev.BBT_Product__c=testProduct.Id;
            rev.BBTCustomer__c=testCustomer.Id;

            reviewList.add(rev);
        }

        insert reviewList;


    }

    @isTest
    static void getLimitedReviewsTest(){
        List<BBTProduct_Review__c> actualReviewList= new List<BBTProduct_Review__c>();
        BBTProduct__c product=new BBTProduct__c();
        product=[SELECT Id FROM BBTProduct__c WHERE NAME=:testProductName][0];
        actualReviewList=ProductReview.getLimitedReviews(product.Id);
        for(BBTProduct_Review__c review: actualReviewList){
            System.assertEquals(testNumberStars, review.Review_Stars__c);
            System.assertEquals(testCustomerName, review.Customer_Name__c);
            System.assertEquals(testReviewContent, review.Review_Content__c);
            System.assert(review.Id!=null, 'comprehensive testing amirite?');
        }

        try{
            List<BBTProduct_Review__c> intentionalFailure= ProductReview.getLimitedReviews('fakeID');
        }
        catch(Exception e){
            System.assert(e.getMessage() != null, 'Exception handled by class' );
        }



    }

}