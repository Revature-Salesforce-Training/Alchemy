trigger AccountTrigger on Account (before insert, before update) {

    //Creates a for loop when if the checkbox is checked the Billing Address info is set to Shipping Address
    for(Account account:Trigger.New){
        if(account.Match_Billing_Address__c == true){
            account.ShippingStreet = account.BillingStreet;
            account.ShippingCity = account.BillingCity;
            account.ShippingState = account.BillingState;
            account.ShippingPostalCode = account.BillingPostalCode;
            account.ShippingCountry = account.BillingCountry;
            
        }
    }

}