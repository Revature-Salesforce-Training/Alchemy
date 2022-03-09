trigger productTrigger on BBTProduct_Review__c (before insert) {
    //if the user puts a review of 2 or 1 stars, require the content field to be filled
    for( BBTProduct_Review__c ProductReview: trigger.new ){
    
        if (ProductReview.Review_Stars__c == '1' || ProductReview.Review_Stars__c=='2'){
            if(ProductReview.Review_Content__c==null || ProductReview.Review_Content__c==''){  //checks if empty string or null
                ProductReview.addError('Please tell us why your experience was bad');
            }//end inner if statement
        }//end outer if statement
    }
    }