import { LightningElement, wire, track } from 'lwc';
import {
    subscribe,
    APPLICATION_SCOPE,
    MessageContext,
    publish
} from 'lightning/messageService';

// import the LMS message Channel
import BigBrotherAppChannel from '@salesforce/messageChannel/BigBrotherAppChannel__c';

// import the 2 methods from the Product Catalogue class
// getProductCatalogueSearch takes 2 inputs, a Search String, and a SOQL Query Offset (think pagination, so we send 1, it multiplies by 12)
// getProductCatalogue only takes the pagination offset
import getProductCatalogueSearch from '@salesforce/apex/ProductCatalogue.getProductCatalogueSearch';
import getProductCatalogue from '@salesforce/apex/ProductCatalogue.getProductCatalogue';

export default class CatalogueDisplay extends LightningElement {

    // set up LMS variables
    subscription = null;
    @wire(MessageContext)
    messageContext;

    productBoxId = 1;

    // product Catalogue will be sent as a list from Apex,
    // so it will store as a JS array. to reactively render it,
    // it must use @track. the error is as well, but its unlikely to be displayed
    // unless toasts are implemented
    @track productCatalogue;
    @track catalogueError;

    // one time use variable upon component connection, allows component to immediately call Apex
    // and get list of products, but if was not automatically set to false it woudl continuously
    // render over and over and over in an infinite loop.
    // there is probably a smarter way to go about this, but this was 3 lines of code, and works fantastically.
    rerenderCatalogue = true;

    searchQuery = "";   // We will store an LMS message variable in here to then search with Apex
    customerOrderID;    // We will store an LMS variable in here in case we need it, currently unimplemented
    queryOffset = 0;    // pagination value, page 1 is 0, page 2 is 1. sent to Apex, multiply by 12 to change the OFFSET BY in SOQL
                        //                  currently unmplmented

    // test button, delete
    btnClick()
    {
        //const payload = {customerIdChange: "123456789987654321"};
        //publish(this.messageContext, BigBrotherAppChannel, payload);
        this.getCatalogue(true);
    }

    // this method runs every time the LMS publishes
    handleMessage(msg)
    {
        //console.log(msg);
        //console.log('searchKey is: ' + msg.searchKey);

        // if LMS published a search key (otherwise will be null)
        if(msg.searchKey || msg.searchKey === "")
        {
            this.searchQuery = msg.searchKey;   // set search key to our published value
            this.getCatalogue(false);           // call getCatalogue(searchWithoutQuery = false)

            //console.log('Inside of if(msg.searchKey){}');
            //console.log('this.searchQuery is: ' + this.searchQuery);
        }

        //this.customerOrderID = msg.orderIdChange; // unused variable currently
    }

    // call Apex to produce a list of 12 (guaranteed always 12) BBTProduct__c records
    // we use 12 because we want to display 4 products wide, 3 products tall
    // take in a boolean value to change between calling with the method that
    // filters output or just grabs the first 12
    getCatalogue(searchWithoutQuery)
    {
        this.rerenderCatalogue = false; // set false here to guarantee it doesn't infini-loop while rendering products

        // this is verbose because i got confused. as long as searchWithoutQuery is true, or searchQuery is a falsy value, don't search, just get products
        if(this.searchQuery == undefined || this.searchQuery == null || this.searchQuery === "" || searchWithoutQuery)
        {
            //console.log('getProductCatalogue firing');
            // call Apex method getProductCatalogue with our pagination value
            getProductCatalogue({inOffset : this.queryOffset})
            .then((result) => {

                // if we get returned a 0 length array, we don't want to use undefined values
                if(result.length > 0)
                {
                    //console.log('result is: ');
                    //console.log(result);
                    this.productCatalogue = result;     // store the actual value of what was returned in our @tracked field
                    this.catalogueError = undefined;    // for the template iterator directive to display all 12 products returned
                }
                else
                {
                    // otherwise display an error
                    console.log('Returned 0 length array');
                    console.log('error was: ');
                    console.log(result);
                    // IMPLEMENT TOAST HERE
                }
            })
            .catch((error) => {
                this.productCatalogue = undefined;
                this.catalogueError = error;
                // IMPLEMENT TOAST HERE
            })
        }
        else
        {
            //console.log('getCatalogueBySearch Firing');
            // if searchWithoutQuery is TRUE, or searchQuery is a string with data (i.e. not a falsy empty string)
            // call apex method, but pass it the search query as well as our pagination
            getProductCatalogueSearch({inQuery : this.searchQuery, inOffset : this.queryOffset})
            .then((result) => {
        
                // if there are no matching results to our search string, we don't want to 
                // store any data. so simply call this method again, but without a search string
                if(result.length > 0)
                {
                    //console.log('result is: ');
                    //console.log(result);
                    this.productCatalogue = result;
                    this.catalogueError = undefined;
                }
                else
                {
                    //console.log('Returned 0 length array');
                    //console.log('error was: ');
                    //console.log(result);
                    this.getCatalogue(true); // recursive call to refresh with no string
                    // IMPLEMENT TOAST HERE
                }
            })
            .catch((error) => {
                this.productCatalogue = undefined;
                this.catalogueError = error;
                //console.log(error);
                // IMPLEMENT TOAST HERE
            })

        }
        
    }

    bringUpIndvProduct(event)
    {
        //console.log(event.target.value);
        const payload = {
            productId : event.target.value,
            appStateSide : "ProductDisplay"
        }
        //console.log(payload);

        publish(this.messageContext, BigBrotherAppChannel, payload)

    }

    // subscribes to the message channel, passes handleMessage method from this class
    // to be called every time a message is published
    subscribeToMsgChannel()
    {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                BigBrotherAppChannel,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }

    }

    // might've wanted to put this in connected callback, but i was having
    // a unique error, and renderedCallback fixed that (possible error is gone now too)
    // we simply use a boolean value to only call it once, inside of getCatalogue
    // we set rerenderCatalogue to false, so it doesn't constantly infini-loop
    renderedCallback()
    {
        if(this.rerenderCatalogue)
            this.getCatalogue(true);
    }

    // we can only subscribe to LMS if our component exists
    connectedCallback()
    {
        this.subscribeToMsgChannel();
    }
}