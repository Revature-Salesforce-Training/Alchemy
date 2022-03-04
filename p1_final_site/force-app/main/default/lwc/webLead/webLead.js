import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//Importing Our Target Object
import LEAD_OBJECT from '@salesforce/schema/Lead';

//Importing the Target Fields from Lead Object
import NAME_FIELD from '@salesforce/schema/Lead.Name';
import PHONE_FIELD from '@salesforce/schema/Lead.Phone';
import ADDRESS_FIELD from '@salesforce/schema/Lead.Address';
import EMAIL_FIELD from '@salesforce/schema/Lead.Email';
import MESSAGE_FIELD from '@salesforce/schema/Lead.Message__c';




//Creating a Method that shows a popup/toast message when the fields are successfully created
export default class WebLead extends LightningElement {
    objectApiName = LEAD_OBJECT;
    fields = [NAME_FIELD, PHONE_FIELD, ADDRESS_FIELD, EMAIL_FIELD, MESSAGE_FIELD  ];
    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "Lead created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
    }
}