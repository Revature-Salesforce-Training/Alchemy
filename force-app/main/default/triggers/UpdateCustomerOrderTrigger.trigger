trigger UpdateCustomerOrderTrigger on Customer_Order__c (before update, after update) {

    // helper class, create an instantiation of the class
    UpdateTriggerHelper trigHelp = new UpdateTriggerHelper();

    if (trigger.isBefore)
    {
        /*  send trigger.new to the method, which returns true if the
         *  "new order status" is within allowed values
         *  this will add an error if returned false (i.e. value is NOT a valid order status)
         */ 
        if(!trigHelp.isValidStatusVal(trigger.new))
        {
            // if it's not within a valid range of statuses, throw an error up
            trigger.new[0].Order_Status__c.addError('Invalid Order Status');
            throw new AuraHandledException('Invalid Order Status');
        }
        
    }

    if(trigger.isAfter)
    {
        // currently nothing necessary to be here
        //System.debug('After update: ');
    }
}