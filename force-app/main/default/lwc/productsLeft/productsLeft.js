import { LightningElement } from 'lwc';
import getShoes from '@salesforce/apex/Products.getShoes';


export default class productsLeft extends LightningElement {

numberLeft;
productName;
productCode;
returned;
error;
displayForm=false;
    
    doProductSearch(){
        let searchCode="REVOAIR1";
        console.log(searchCode);

        //resolving a promise from apex
        getShoes({inCode : searchCode}) 
        .then((result) => {
            if(result.length>0){
                this.returned=result;
                this.error=undefined;
                this.displayProduct();
            }
            else{
                //display error
            }  
        })
        .catch((error) => {
            //also display error here
        })
    }

    displayProduct(searchedProducts){
        //hardcoding for one product for now
        // this.numberLeft = searchedProducts[0].NumberLeft__c;
        // this.productName = searchedProducts[0].Name;
        // this.productCode= searchedProducts[0].ProductCode;

        this.displayForm=true;
    }
}