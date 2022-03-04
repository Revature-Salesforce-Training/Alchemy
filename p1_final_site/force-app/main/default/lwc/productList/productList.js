import { LightningElement, wire } from 'lwc';
import NAME_FIELD from '@salesforce/schema/RevoProduct__c.Name';
import DESCRIPTION_FIELD from '@salesforce/schema/RevoProduct__c.ProductName__c';
import getProducts from '@salesforce/apex/ProductController.getProducts';
const COLUMNS = [
    { label: 'Product Name', fieldName: NAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Product Description', fieldName: DESCRIPTION_FIELD.fieldApiName, type: 'text area' },
    
];
//Using wire method to call Apex code from another Apex class
export default class ProductList extends LightningElement {
    columns = COLUMNS;
    @wire(getProducts)
    products;
}