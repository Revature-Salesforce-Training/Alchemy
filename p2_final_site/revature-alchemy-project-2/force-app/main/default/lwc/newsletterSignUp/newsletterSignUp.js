import { LightningElement, wire } from 'lwc';
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext,
    publish
} from 'lightning/messageService';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createCustomer from '@salesforce/apex/CreateCustomer.createCustomer';
import BigBrotherAppChannel from '@salesforce/messageChannel/BigBrotherAppChannel__c';





//Creating a Method that shows a popup/toast message when the fields are successfully created
export default class WebToLead extends LightningElement {

    // setup LMS variables
    subscription = null;
    @wire(MessageContext) messageContext;


    loggedInUserId;
    customerId;
    error;
    
    createCustomerJS(){

        // store our input values
        let fNameInput = this.template.querySelector('.fnameInput');
        let lNameInput = this.template.querySelector('.lnameInput');
        let emailInput = this.template.querySelector('.emailInput');

        // format the 2 names to one full name
        let fullName = fNameInput.value + " " + lNameInput.value;

        // pass the information to Apex and resolve promise
        createCustomer({inName: fullName, inEmail: emailInput.value})
        .then((response) => {

            // store the Id of the customer Made, and then publish to the LMS
            this.customerId = response;
            //console.log(this.customerId);
            this.error = undefined;

            const payload = {customerId:this.customerId};
            publish(this.messageContext,BigBrotherAppChannel,payload);

            fNameInput.value = "";
            lNameInput.value = "";
            emailInput.value = "";

            this.customerCreatedSuccessMessage(true);

        })
        .catch((error) => {
            this.error= error;
            //console.log(this.error);
            this.customerId = undefined;   
            
            
            this.customerCreatedSuccessMessage(false);
        }) 
     
    }


    // component must exist before you can subscribe
    connectedCallback()
    {
        this.subscribeToMsgChannel();
    }

    // subscribe to message channel and tell computer to run handleMessage every
    // time a message is sent
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

    handleMessage(msg){

        if(msg.userId)
        {
            this.loggedInUserId = msg.userId;
        }
    }

    createCustomerTest(){
        //console.log('hellooooooooo')
    }

    customerCreatedSuccessMessage(isSuccessful)
    {
        if (isSuccessful)
        {
            const evt = new ShowToastEvent({
                title: 'Welcome to BBTimepieces',
                message: 'Thank you for signing up!',
                variant: 'success'
            });
            this.dispatchEvent(evt);
        }
        else
        {
            const evt = new ShowToastEvent({
                title: 'Duplicate Email Address or Name',
                message: 'Please try again with different information.',
                variant: 'warning'
            });
            this.dispatchEvent(evt);
        }
    }


}