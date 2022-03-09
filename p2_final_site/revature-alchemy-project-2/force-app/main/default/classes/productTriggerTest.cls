@isTest
public with sharing class productTriggerTest {
    

    @isTest
    public static void triggerTest(){
        //show the Review number, customer name, stars, and content for test case

        BBTProduct_Review__c review = new BBTProduct_Review__c();
        BBTProduct_Review__c review2 = new BBTProduct_Review__c();
        
        //intentionally create a review that triggers the trigger
        //trigger triggers on empty content and 1 or 2 stars, asks customer to leave their feedback
        review.Review_Content__c='';
        review.Review_Stars__c='1';


        review2.Review_Content__c='';
        review2.Review_Stars__c='2';

        
        try{
            insert review; 
            //System.assert(true);
        }
        catch(Exception e){
            //System.debug(e.getMessage());
            System.assert(e.getMessage()!=null, 'error handled by class');
        }

        try{
            insert review2; 
            //System.assert(true);
        }
        catch(Exception e){
            //System.debug(e.getMessage());
            System.assert(e.getMessage()!=null, 'error handled by class');
        }

    }  //end test method
}//end class