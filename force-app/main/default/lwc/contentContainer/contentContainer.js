import { LightningElement, api, wire, track } from 'lwc';
import FRONTPAGESPLASH from '@salesforce/resourceUrl/RunningShoes';
import {
    APPLICATION_SCOPE,
    createMessageContext,
    MessageContext,
    publish,
    releaseMessageContext,
    subscribe,
    unsubscribe,
} from 'lightning/messageService';

import appEventMessageChannel from '@salesforce/messageChannel/appEventMessageChannel__c';

export default class ContentContainer extends LightningElement {


    @api runningShoes = FRONTPAGESPLASH;
    messageContext = createMessageContext();
    subscription = null;

    @track appState="home";

    get isHomePage() {
        if (this.appState == "home") {
            return true;
        }
        return false;
    }

    get isProductsPage() {
        if (this.appState == "products") {
            return true;
        }
        return false;
    }
    
    get isContactPage() {
        if (this.appState == "contact") {
            return true;
        }
        return false;
    }
    
    get isOrderPage() {
        if (this.appState == "orders") {
            return true;
        }
        return false;
    }

    get isCartDetail() {
        if (this.appState == "cart") {
            return true;
        }
        return false;
    }

    get isLoginPage() {
        if (this.appState == "login")
        {
            return true;
        }
        return false;
    }

    get isServicePage() {
        if (this.appState == "service")
        {
            return true;
        }
        return false;
    }

    //Subscribe to app events, mainly app state changes
    subscribeToAppEventMessageChannel() {
        this.messageContext = createMessageContext();
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                appEventMessageChannel,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    handleMessage(message) {
        this.appState = message.appStateChange;
    }

    connectedCallback() {
        this.subscribeToAppEventMessageChannel();
    }

}