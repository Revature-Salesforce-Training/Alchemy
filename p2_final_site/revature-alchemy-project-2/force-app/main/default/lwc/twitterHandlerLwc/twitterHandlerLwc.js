/*
    ::LWC Feature - Social Media
    Description: Twitter Feed Page component to display a Twitter timeline. In the org, the timeline will display based on Twitter Handle field value, 
    or will use a default value if that field is not set.  
    ::Project 2::Michael Scott::03/05/2022::
*/

import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

// passed to array as list to use in getRecords, to limit fields returned
const TWITTER = ['Contact.Twitter_Handle__c'];


export default class twitterHandlerLwc extends LightningElement {

    // expose recordId field as public property
    @api recordId

    // assign a default company value for experience cloud site or users with no Twitter handle
    twitterHandler;

    // get url for twitter feed, use twitterHandle from wire service or default
    get fullUrl() {
        if (this.twitterHandler == null) {
            this.twitterHandler = 'salesforceorg'
        }

        //return `https://${window.location.hostname}/apex/TwitterFeedPage?twitterHandle=${this.twitterHandler}`

        // currently hardcoded due to CSP restrictions
        return 'https://resilient-impala-n8lfls-dev-ed.lightning.force.com/apex/TwitterFeedPage?twitterHandle=salesforceorg';

    }

    // use wire adapter to invoke 'getRecord' and assign Twitter Handle value from the users Contact record
    @wire(getRecord, { recordId: '$recordId', fields: TWITTER })
    wiredRecord({ error, data }) {
        if (data) {
            this.twitterHandler = data.fields.Twitter_Handle__c.value //assign Twitter Handle field value from Contact object
        }
        if (error) {
            console.error(error)
        }
    }
}