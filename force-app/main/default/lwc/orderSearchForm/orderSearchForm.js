/*

    Order Search Component for Revature P1
    made by Eli Couture in Platform LWC and Apex

    last edited: 2/21/2022 by Eli Couture

    take in First Name, Last Name, Order Number via HTML form
    query database via Apex,

            (Apex) return order that matches ALL THREE. (currently no partial/multiple search)

    display returned order, offer a cancellation button,
    use Apex and Apex trigger to update order as cancelled


*/

import getOrderBySearch from '@salesforce/apex/OrderSearch.getOrderBySearch';
import updateOrderByNumAndFullName from '@salesforce/apex/UpdateCustomerOrder.updateOrderByNumAndFullName'

import { LightningElement, track} from 'lwc';



export default class OrderSearchForm extends LightningElement {

    searchFirst = '';           // These first three will be edited and passed to Apex call
    searchLast = '';            // as parameters
    searchNum = '';


    displayForm = true;         // if the search Form should be displayed
    displayOrderForm = false;   // If the returned results from the search should be displayed

    @track
    ordersReturned;             // orders returned from apex call
    error;                      // error returned from apex call


    /*
    on search button click, call this method
    grab the input values for First Name, Last Name, and the Order Number

    set the reactive fields equal to the gotten information

    call the handleSearch() method, which actually calls the Apex
    */
    searchForOrder()
    {
        // clear the error message for 2 reasons,
        // 1) if search is successsful, 2) so it goes away AND COMES BACK, if an error happens. visual change on page
        this.removeSearchError();

        let cFirstName = this.template.querySelector(".firstNameInput").value;  // find and store inputs and values from form
        let cLastName = this.template.querySelector(".lastNameInput").value;
        let cOrdNum = this.template.querySelector(".orderNumberInput").value;
        this.searchFirst = cFirstName;                                          // store the values inside of the reactive
        this.searchLast = cLastName;                                            // fields
        this.searchNum = cOrdNum;

        this.handleSearch();
        /*
        * logic inside of this.handleSearch()
        *   if there was a successful return, orderReturned will contain information, and will be truthy
        *   and the error field will be undefined, and falsy.
        *       -> run displayOrder() which lets the order display show up, showing results & cancel button
        * 
        * if it was an unsuccessful apex call, orderReturned will be undefined/falsy, and
        *   error field will have information and will be truthy
        *       -> display the error
        */


    }

   /*
    *  call Apex method getOrderBySearch, requires String, String, Integer for parameters.
    *     method args are exactly as named by properties as well for easy understanding between the two
    * 
    *  when the Apex returns, resolve its promise and store the information returned, either error or the data
    *     in the respective fields. ordersReturned for the order found by the SOQL query, and error field for
    *     the error. otherwise fill with undefined for a "defined"  falsy value.
    */
    handleSearch()
    {
        getOrderBySearch({custFirst : this.searchFirst, custLast : this.searchLast, custOrdNum : this.searchNum})
        .then((result) => {
            this.ordersReturned = result;
            this.error = undefined;

            if (this.ordersReturned.length > 0)
                this.displayOrder();
            else
                this.displayOrdSearchError('No records found matching search data');
        })
        .catch((error) => {
            this.error = error;
            this.ordersReturned = undefined;
            this.displayOrdSearchError(error);
        })        
    }

    handleSearchPostCancel()
    {
            let cFirstName = this.template.querySelector(".firstNameInput").value;  // find and store inputs and values from form
            let cLastName = this.template.querySelector(".lastNameInput").value;
            let cOrdNum = this.template.querySelector(".orderNumberInput").value;
            let localOrdersReturned;
            let localError;
            let returnVals;

            getOrderBySearch({custFirst : cFirstName, custLast : cLastName, custOrdNum : cOrdNum})
            .then((result) => {
                localOrdersReturned = result;
                localError = undefined;

                console.log('post cancel returned info');
                console.log(result)

                /*returnVals = {
                    "orderReturned" : localOrdersReturned,
                    "errorReturned" : localError
                }
                //console.log(tempOb);   

                return returnVals;*/
            })
            .catch((error) => {
                localError = error;
                localOrdersReturned = undefined;   

                console.log('Post Cancel Update error info')
                returnVals = {
                    "orderReturned" : localOrdersReturned,
                    "errorReturned" : localError
                }
                //console.log(tempOb);   

                return returnVals;
            })

    }

    /*
        change displayOrderForm to true, so that the returned results may display

            this is a separate method because of debugging reasons
            and also to force a page re-render
    */
    displayOrder()
    {
        //console.log(this.ordersReturned[0].Name);
        this.displayOrderForm = true;
    }


    displayOrdSearchError()
    {
        //console.log('manual error triggered: Unexpected error Occured');
        let errorMsg;
        if (this.error)                                 // if error field has content (returned from Apex) use that error
            errorMsg = this.error.body.message;
        else                                            // if error field has no content, use default/standard error message
             errorMsg = 'Unexpected Error Occured';

        this.displayOrdSearchError(errorMsg);           // send the error message to the overloaded method to actually print
        

    }

    displayOrdSearchError(inErrorMsg)
    {
        this.clearForm();                                                   // clear the display of any possible data

        let errorMsg = inErrorMsg;                                          // take in error message
        const errorLabel = this.template.querySelector("label.errorMsg")    // find error Label and store
        errorLabel.innerHTML = errorMsg;                                    // set the text of the label to the error
    }                                                                       // css color of text is red already (via class)

    removeSearchError()
    {
        const errorLabel = this.template.querySelector("label.errorMsg")    // find error label and store
        errorLabel.innerHTML = "";                                          // remove text from label via replace with empty string
    }

    clearForm()
    {
        this.ordersReturned = undefined;                                // remove stored records
        this.displayOrderForm = false;                                  // remove the order display from render
        this.removeSearchError();                                       // this shouldn't have to be done, but just in case

        this.template.querySelector(".firstNameInput").value = "";      // find and replace all form input values
        this.template.querySelector(".lastNameInput").value = "";       // with empty strings to empty them out
        this.template.querySelector(".orderNumberInput").value = "";
        this.searchFirst  = "";                                         // remove stored information from reactive fields
        this.searchLast  = "";
        this.searchNum  = "";
        
        //console.log(this.ordersReturned);
        //console.log(this.ordersReturned[0].Name);

    }

    cancelOrderJS()
    {

        console.log(this.ordersReturned[0].Customer_Full__c);
        console.log(this.ordersReturned[0].Name);
            

        updateOrderByNumAndFullName({
                custFullName : this.ordersReturned[0].Customer_Full__c, 
                custOrdNum : this.ordersReturned[0].Name,
                newStatus : 'Cancelled'
            })
        .then((result) => {
            console.log('successful update');
            console.log(result);
            this.handleSearchPostCancel();
        })
        .catch((error) => {
            console.log(error);
            console.log('error received');
        })
        
    }
}