import { LightningElement, wire } from 'lwc';
import {
    MessageContext,
    publish
} from 'lightning/messageService';
import BigBrotherAppChannel from '@salesforce/messageChannel/BigBrotherAppChannel__c';

export default class homePageFooter extends LightningElement {

    //publish appState to main container on button click
    subscription = null;
    @wire(MessageContext)
    messageContext;

    getCatalogue(event) {

        const payload = {
            appStateMain: event.target.value,
            searchKey: "" //send catalogue a search string
        }
        console.log(event.target.value)
        publish(this.messageContext, BigBrotherAppChannel, payload)
    }
}