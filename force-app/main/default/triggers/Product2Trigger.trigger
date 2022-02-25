//only for after the checkout button is clicked
//triggers on every DML update on Product2
trigger Product2Trigger on Product2 (before update) {
for(Integer i=0;i<trigger.old.size() ;i++){  //for every record we are updating
    if(trigger.new[i].NumberLeft__c<0){ //check to make sure the number left is not a negative amount
            //trigger.new[i].NumberLeft__c.addError('Cannot have negative amount of product left');
            throw new DMLException('Cannot have negative amount of product left');
        }
    
}
}