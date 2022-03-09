trigger OrderLineItemTrigger on OrderLineItem__c (before insert) 
{

    for (OrderLineItem__c o : trigger.new)
    {
        if(o.Quantity_c__c <= 0)
        {
            o.Quantity_c__c.addError('No Negative or Zero Values Allowed In Purchase Quantity');
        }
    }
}