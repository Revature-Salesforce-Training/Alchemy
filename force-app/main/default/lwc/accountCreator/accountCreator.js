import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//Importing Our Target Object
import ACCOUNT_OBJECT from '@salesforce/schema/Account';

//Importing the Target Fields from Account Object
import NAME_FIELD from '@salesforce/schema/Account.Name';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import BILLING_ADDRESS_FIELD from '@salesforce/schema/Account.BillingAddress';
import SHIPPING_ADDRESS_FIELD from '@salesforce/schema/Account.ShippingAddress'
import MATCH_BILLING_ADDRESS_FIELD from '@salesforce/schema/Account.Match_Billing_Address__c'


//Creating a Method that shows a popup/toast message when the fields are successfully created
export default class AccountCreator extends LightningElement {
    objectApiName = ACCOUNT_OBJECT;
    fields = [NAME_FIELD, PHONE_FIELD, BILLING_ADDRESS_FIELD, SHIPPING_ADDRESS_FIELD, MATCH_BILLING_ADDRESS_FIELD  ];
    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "Account created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
    }
}