import { LightningElement, api, track } from 'lwc';
import getLimitedReviews from '@salesforce/apex/ProductReview.getLimitedReviews';

export default class ProductReview extends LightningElement {
    
    // @track so that the field is reactively updated and used by the iterator template
    @track reviewList=[];
    error;
    @api searchProductId='';

    connectedCallback(){
        
    }

    // replaces connectedCallback as this is called by parent upon loading, and passed the id
    // of the product we want to search for
    @api setProductId(setId)
    {
        // store the product id
        this.searchProductId = setId;
        
        // call the apex method, passing it our product Id
        getLimitedReviews({inProductId: this.searchProductId})

        //resolving a promise from apex for positive and negative methods
        .then((result)  => {
            // store the information (0 size array checking is done in Apex, not necessary here)
            this.reviewList=result;
            this.error= undefined;
            //console.log('list of reveiws receieved from getLimitedReviews');
            //console.log(result);
        }) 
        .catch((error) => {
            this.reviewList=undefined;
            this.error= error;

            console.log('Error received in getLimitedReviews');
            console.log('Error was: ');
            console.log(error);
            // INSERT TOAST
        }) 
    }

}