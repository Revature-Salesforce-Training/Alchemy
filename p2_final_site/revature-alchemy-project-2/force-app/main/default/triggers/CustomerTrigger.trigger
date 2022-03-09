trigger CustomerTrigger on BBTCustomer__c (before insert) {


    List<BBTCustomer__c> custList = [SELECT id, Name, Customer_Email__c FROM BBTCustomer__c];
    Set<String> custNames = new Set<String>();
    Set<String> custEmails = new Set<String>();

    for(BBTCustomer__c c : custList)
    {
        custNames.add(c.Name);
        custEmails.add(c.Customer_Email__c);
    }


    for(BBTCustomer__c curCust : Trigger.new){

        if(custNames.contains(curCust.Name) || custEmails.contains(curCust.Customer_Email__c))
        {
            curCust.addError('Duplicate User Found. Please Try Again');
        }
    }
}