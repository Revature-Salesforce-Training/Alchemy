trigger OrderLineItemTrigger on OrderLineItem__c (before insert) {
    if (Trigger.isBefore) {
        OrderLineItem__c order = Trigger.New[0];
        Artisan__c artist = [SELECT Id, Name, CurrentlyAssigned__c FROM Artisan__c WHERE ColorFor__c = :order.ProductColor__c];

        if (artist.CurrentlyAssigned__c > 5) {
            order.addError('This artist is too busy, please select another design');

        } else {
            artist.CurrentlyAssigned__c++;
            update artist;
        }
    }
}