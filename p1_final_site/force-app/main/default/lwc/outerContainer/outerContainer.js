import { LightningElement, api, wire } from 'lwc';

import {
    APPLICATION_SCOPE,
    createMessageContext,
    MessageContext,
    publish,
    releaseMessageContext,
    subscribe,
    unsubscribe,
} from 'lightning/messageService';
import REVO_SMALL_LOGO from '@salesforce/resourceUrl/RevoLogoLarge';
import appEventMessageChannel from '@salesforce/messageChannel/appEventMessageChannel__c';
export default class OuterContainer extends LightningElement {

    @api revoLogoUrl = REVO_SMALL_LOGO;

    @wire(MessageContext) messageContext;

    //App status properties
    @api currentRecordId = null;

    @api currentObjectId = null;

    @api appState = 'home';

    onAppStateChange(state) {
        const payload = {appStateChange: this.appState, recordIdChange: null, objectIdChange: null};
        publish(this.messageContext, appEventMessageChannel, payload);
    }

    handleMenuClick(e)
    {
        this.appState = e.target.value;
        this.onAppStateChange(this.appState);
    }

    handleCartClick(e)
    {
        this.appState = "cart";
        this.onAppStateChange("cart");
    }
}