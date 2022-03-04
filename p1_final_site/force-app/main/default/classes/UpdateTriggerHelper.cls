public without sharing class UpdateTriggerHelper {
    public UpdateTriggerHelper() {

    }

    // TODO: make this dynamic
    public Set<String> getStatusVals()
    {
        // create set of String values of expected and valid
        // picklist values, return them
        // using set due to .contains() method
        Set<String> validVals = new Set<String>();

        validVals.add('Cancelled');
        validVals.add('Delivered');
        validVals.add('Out For Delivery');
        validVals.add('Packaging');
        validVals.add('Pending');

        return validVals;
    }

    public Boolean isValidStatusVal(List<Customer_Order__c> inRecs)
    {
        // receive list of Customer Orders, return true if the (new) order
        // status is within valid values
        // currently only accesses the first (and only) Order in the List,
        // but left as list for future scalability
        return (getStatusVals().contains(inRecs[0].Order_Status__c));
    }
}