import { LightningElement, wire, track } from 'lwc';
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext,
    publish
} from 'lightning/messageService';

import BigBrotherAppChannel from '@salesforce/messageChannel/BigBrotherAppChannel__c';
import getProduct from '@salesforce/apex/GetIndvProductInfo.getProduct';

export default class IndvProduct extends LightningElement {

    // LMS service setup
    subscription = null;
    @wire(MessageContext)
    messageContext;

    // store information about the currently displayed product
    // @track to dynamicalyl rerender the display if it gets changed (must be @track since LWC 
    //          does not automatically track JS Objects/Arrays)
    @track productInfo = {
        Id: undefined, //  Id will track the Salesforce record ID
        Name: "", //  Name will track the Product Name (like 'Kazuha Apollo')
        Price: undefined, //  Price will track the product price 
        imageURL: "", //  imageURL will break CSP guidelines and script load an img src={field}, working on proper rules
        imageAlt: "" //  imageAlt will track the Image Alt Tag (stored in record) to dynamically load into image alt=""
    };

    // store information about the customer viewing the page, and their cart
    // @track to make sure its accurate any time its displayed (not currently displayed anywhere, but still)
    @track customerInfo = {

        userId: "", // userId tracks the logged in User's ID
        orderId: "", // orderID tracks the cart/CustomerOrder__c ID
        customerCart: [], // customerCart will be an array of JS objects (see line 38 for example)

        customerId: "",
        userId: "", // userId tracks the logged in User's ID
        orderId: "", // orderID tracks the cart/CustomerOrder__c ID
        customerCart: [] // customerCart will be an array of JS objects (see line 38 for example)

    };
    /**
     * customerCart = [
     *      {recordId: 'a018c00000TneoRAAR', quantity: 1},
     *      {recordId: 'a018c00000Tneoapjg', quantity: 1}
     * ]
     * 
     * this will be passed down to the AddToCart button via API methods, along with the productId
     * so the Button component can see proper price and add new item to cart
     */

    // calls Apex to search for the item by (Salesforce) Id
    displayProductInfo() {
        getProduct({ inRecordId: this.productInfo.Id })
            .then((result) => {
                //console.log('result recieved in indvProduct,')
                //console.log('result received was: ');
                //console.log(result);

                // if its a positive result, store all the information we get back (size 0 array check in Apex)
                //      meaning if no Id matches, Apex will throw event and call .catch() automatically. not necessary to check here
                this.productInfo = {
                    Id: result.Id,
                    Name: result.Name,
                    Price: result.Product_Price__c,
                    imageURL: result.Image_URL__c,
                    imageAlt: result.Image_Alt_Tag__c
                };

                //console.log(this.productInfo);
            })
            .catch((error) => {
                // should only ever be a DML error or an AuraHandledException with the message
                // 'No Records Found with matching ID'
                console.log('error recieved in indvProduct,');
                console.log('error was: ');
                console.log(error);

                // need to throw toast or react in some way
            })
    }

    // this message is fired every time something is published on the LMS channel
    handleMessage(msg) {
        // if each variable IS NOT NULL, IS NOT UNDEFINED, or an empty string/etc.
        // and we don't have the same value ALREADY, then change it to the new value
        // since we initialise to empty values, we should always be storing something new
        

        if (msg.orderId && msg.orderId != this.customerInfo.orderId) {
            this.customerInfo.orderId = msg.orderId;
        }

        if (msg.customerCart && msg.customerCart != this.customerInfo.customerCart) {
            this.customerInfo.customerCart = msg.customerCart;
        }

        if (msg.customerId && msg.customerId != this.customerInfo.customerId) {
            this.customerInfo.customerId = msg.customerId;
        }

        // any time the productId changes, it means we're now looking at a different product
        // we should probably change what's displayed, huh?
        if (msg.productId && msg.productId != this.productInfo.Id) {
            this.productInfo.Id = msg.productId;
            this.displayProductInfo();
            this.template.querySelector("c-product-review").setProductId(this.productInfo.Id);

            this.template.querySelector("c-add-product-to-cart")
            .initVariablesFromParent(this.productInfo, this.customerInfo);
        }  

        //console.log('message handled: ');
        //console.log(msg);
    }

    // does the actual subscribing to the message channel
    subscribeToChannel() {
        // dont do this if we already HAVE  subscription
        if (!this.subscription) {
            this.subscription = subscribe( // store the subscription in our field
                this.messageContext, // @wire'd field for messageContext
                BigBrotherAppChannel, // name of channel we're using (using an import statement from the beginning)
                (message) => this.handleMessage(message), // give it a method to call every time a messgae is received
                { scope: APPLICATION_SCOPE } // we're publishing on an application wide scope to communicate to many objects
            );
        }

    }

    // connected Callback only runs when the component is first initialised, and never again
    // unless the component is COMPLETELY derendered (i.e. disconnected) and then rendered again
    connectedCallback() {
        this.subscribeToChannel(); // we CAN'T subscribe to the LMS until our component actually exists
        // so we put our subscription in a method, and call the method in the connectedCallback



        // this is explicitly for testing, and is used to automatically render a testing
        // product into this component instead of having to repeatedly do many
        // steps to start the testing
        /*const testingMessage = {
            userId : "",
            orderId: "",
            customerCart: [],
            productId: 'a018c00000TneoEAAR' // THIS IS TEMPORARY AND ONLY FOR TESTING PURPOSES
        };

        this.handleMessage(testingMessage); // testing to bring up display automatically, only for testing.
*/
    }
}