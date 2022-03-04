import { api, LightningElement, wire } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import getArtisanName from '@salesforce/apex/ColorTestController.getArtisanName';

// Define fields used in LDS record create form
import ORDER_ITEM from '@salesforce/schema/OrderLineItem__c';
import QUANTITY from '@salesforce/schema/OrderLineItem__c.Quantity__c';
import PRODUCT_COLORS__C from '@salesforce/schema/OrderLineItem__c.ProductColor__c';
//import CUSTOMER_ORDER from '@salesforce/schema/OrderLineItem__c.Customer_Order__c';
import PRODUCT_ID from '@salesforce/schema/OrderLineItem__c.Product__c';

//Debounce delay
const DELAY = 200;

export default class ColorTest extends LightningElement {
    //Record Id of record on page
    @api recordId = '012000000000000AAA'

    // Variables for LDS wiring
    orderItemObject = ORDER_ITEM;
    orderItemFields = [QUANTITY, PRODUCT_COLORS__C, PRODUCT_ID]

    //Current Color Set
    @api currentColorValue = "Original"

    // Get picklist values defined by OrderItem types
    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: PRODUCT_COLORS__C }) colorValues;

    //Artist name pulled from selected color value
    @wire(getArtisanName, {colorType: "$currentColorValue"}) getArtisanName;

    // Callback to set color value from picklist and search for artist name, debounced
    setColorValue(e) {
        window.clearTimeout(this.delayTimeout);
        const colorKey = e.target.value;
        this.delayTimeout = setTimeout(() => {
            this.currentColorValue = colorKey;
        }, DELAY);
    }

}