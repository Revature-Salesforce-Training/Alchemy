import { LightningElement, api, track } from 'lwc';
import BigBrotherAppChannel from '@salesforce/messageChannel/BigBrotherAppChannel__c';
import { publish } from 'lightning/messageService';

const MESSAGING_DELAY = 1000

export default class AppHeartbeat extends LightningElement {


    // store all variables from the LMS
    // Application state variables
    @track appStateMain = undefined;
    @track appStateSide = undefined;

    // ID variables
    @track productId = undefined;   // individual product to display on side
    @track userId = undefined;      // user logged in to display name in hero tag
    @track customerId = undefined;  // customerID, currently not implemented
    @track orderId = undefined;     // CustomerOrder__c ID, what the cart ID is

    // catalogueDisplay will use this to search via SOQL
    @track searchQuery = undefined;

    // Items in customer cart
    @track customerCart = undefined;    // will be JS array of objects
    /**
     *      customerCart = {
     *          {Id: '123456789987654321', quantity: 1}.
     *          {Id: '123456789123456789', quantity: 2}
     *      };
     */
    
    

    timeout = undefined;
    subscription = undefined;


   heartbeat() {
       // If timeout defined, clear and create new
        if (this.timeout) {
            clearTimeout(this.timeout);
        }
        // republish entire app state/all variables
        const payload = {appStateMain: this.appStateMain, userId: this.userId, customerId: this.customerId, productId: this.recordId, searchQuery: this.searchQuery, orderId: this.orderId, appStateSide: this.appStateSide, customerCart: this.customerCart};
        publish(this.messageContext, appEventMessageChannel, payload);
        this.timeout = setTimeout(heartbeat, MESSAGING_DELAY);

    }

    connectedCallback() {
        this.timeout = setTimeout(heartbeat, MESSAGING_DELAY);
        this.subscribeToAppEventMessageChannel();

    }

    subscribeToAppEventMessageChannel() {
        this.messageContext = createMessageContext();
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                BigBrotherAppChannel,
                (message) => this.storeAppState(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    // save all variables every time an LMS publish happens
    storeAppstate(message) {
        if (message.appStateMain) {
            this.appStateMain = message.appStateMain
        }
        if (message.appStateSide) {            
            this.appStateSide = message.appStateSide
        }

        if (message.productId) {
            this.productId = message.productId
        }

        if (message.userId) {
            this.userId = message.userId
        }

        if (message.customerId) {
            this.customerId = message.customerId
        }

        if (message.searchQuery) {
            this.searchQuery = message.searchQuery
        }

        if (message.orderId) {
            this.orderId = message.orderId
        }

        if (message.customerCart) {
            // Items in customer cart
            this.customerCart = message.customerCart
        }
    }

}