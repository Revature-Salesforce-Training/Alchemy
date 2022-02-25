public with sharing class CancelTriggerHelper {
    public CancelTriggerHelper() {

    }

    public Set<String> getCancelVals()
    {
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
        System.debug('Records Received: ');
        System.debug(inRecs);
		System.debug('Compare Received Status to Picklist Vals');
		System.debug(getCancelVals().contains(inRecs[0].Order_Status__c));
        
        return (getCancelVals().contains(inRecs[0].Order_Status__c));
    }
}