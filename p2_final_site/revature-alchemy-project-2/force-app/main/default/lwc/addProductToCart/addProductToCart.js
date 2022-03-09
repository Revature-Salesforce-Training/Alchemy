import { LightningElement, api, wire, track} from 'lwc';
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext,
    publish
} from 'lightning/messageService';

// Create Cart will create a cart from user input
import createCart from '@salesforce/apex/AddProductToCartController.createCart'

// will get the price of product based on passed product ID
import getProductPrice from '@salesforce/apex/AddProductToCartController.getProductPrice'

// will create OrderLineItem__c record with master-detail lookups to BBCProduct__c and CustomerOrder__c
import addProductToCart from '@salesforce/apex/AddProductToCartController.addProductToCart'

// our LMS channel
import BigBrotherAppChannel from '@salesforce/messageChannel/BigBrotherAppChannel__c';

import fetchUser from '@salesforce/apex/currentUserInfoController.fetchUser';

export default class AddProductToCart extends LightningElement {

    // left as api more for legacy protection than necessity since we have the @api method
    @api productId = '';
    @api userId = '';
    @api cartId = undefined
    @api customerCart = undefined;


    quantity = 1;           // we want a default quantity of 1 because how many times are you gonna order more than 1 watch?
    orderCart = undefined;  // i'm very sorry if you get confused between cartId CustomerOrder, orderCart, etc. I did too
    totalcost = 0;          // initialise at 0, will be replaced immediately
    error;          // stores Apex errors

    // establish LMS publishing capabilities
    @wire(MessageContext) messageContext;
    

    // this method essentially replaces connectedCallback as it is @api called
    // by the parent object in a method inside of [parent's] own connectedCallback() (its also called every time a new product is selected)
    // initialises variables as necessary
    @api initVariablesFromParent(inProdInfo, inCustInfo)
    {
    
        //console.log('productId before: ' + this.productId);
        this.productId = inProdInfo.Id;                         // set the product Id from the sent in JS object
        this.onQuantityChange(null);                            // call the method to immediately set the visible price
        //console.log('productId after: ' + this.productId);

        //console.log('User ID from child: ' + this.userId +
        //        "\nUser ID from parent: " + inCustInfo.userId);
        this.userId = inCustInfo.userId;

        if(!this.cartId)    // only if we aren't already storing a cartId, change it
        {
            this.cartId = inCustInfo.orderId;
        }

        if(!this.customerCart)  // only if we don't already have a cart, change it
        {
            this.customerCart = inCustInfo.customerCart;
        }
    }

    createAndAddProductLineItemToCart (event) 
    {

        // If an order does not exist, create new one
        if (!this.cartId) 
        {

            console.log("Creating cart")
            //console.log(this.userId);
            // call Apex to create cart passing it a userId for the lookup value
            createCart({inUserId: this.userId})
            .then((result) => {

                console.log('NEW cart ID: ');
                console.log(result)

                // the Apex call of createCart() will return a Cart ID back, save it
                this.cartId = result;
                this.error = null

                
                // publish that there is a cart ID via calling the method that publishes
                this.sendCartIdChange(this.cartId);

            }).then(() => { // this is chaining a promise to the Apex call of createCart, because we HAVE to have a cartId
                            // before we can start working with making junction objects between product and the order

                //console.log("Adding product to cart")

                // call the apex to create a new junction record based off of a product, a customer order
                addProductToCart({productId: this.productId, cartId: this.cartId, quantity: this.quantity})
                .then((result) => {

                    // store the resulting lineItem record ID
                    this.orderLineItemId = result;

                }).catch((error)=>{

                    console.log(error)
                    // INSERT TOAST HERE
                })
            });
        
        } 
        else // If we already HAVE a cart/cartID, just add a product to the cart by calling the apex method
        {
            //console.log("Adding product to cart")
            addProductToCart({productId: this.productId, cartId: this.cartId, quantity: this.quantity})
            .then((result) => {

                this.orderLineItemId = result;

            })
            .catch((error)=>{

                console.log(error)
                //INSERT TOAST HERE
            })           
        }

    }

    // when the Add Quantity Button is pushed, add one to the quantity
    // currently no checking for stock as that's not been implemented
    // on the back end
    addQuantity(event) 
    {
        this.quantity += 1;

        // after changing the quantity, update the display
        this.onQuantityChange(null)
    }

    // When the Minus Quantity Button is pushed, subtract one from the quantity
    // validate to make sure we don't get 0, negative numbers, etc.
    subtractQuantity(event) 
    {
        if (this.quantity >= 2) 
        {
            this.quantity -= 1;

            // after changing the quantity, update the display
            this.onQuantityChange(null)
        }
    }

    onQuantityChange(event) 
    {
        // call Apex method to retrieve product's unit price and store it, formatted
        getProductPrice({productId: this.productId})
        .then((result)=> {

            this.totalcost = "$" + this.quantity * parseInt(result);

        })
        .catch((error)=> 
        {
            console.log("error was: ");
            console.log(error);

            // INSERT TOAST
        })

        // console.log("Quantity changed");
    }    

    // this is Eli commenting Matthew's code. honestly not sure.
    onComponentAdded() 
    {
        this.onQuantityChange(null)
    }
    
    // publish that a cartId has been made or otherwise changed, to the LMS
    sendCartIdChange (cartId) 
    {
        console.log('publishing cart id ');
        const payload = {orderId: cartId}
        console.log(payload);
        publish(this.messageContext, BigBrotherAppChannel, payload);
    }

    connectedCallback()
    {
        fetchUser()
        .then((result) =>{
            this.userId = result.Id;
        })
        .catch((error) => {
            console.log('error recieved from fetchUser');
            console.log(error);
        })
    }
}