trigger defaultTwitterTrigger on User (before insert, before update) {

    Trigger.new[0].Twitter_Handle__c = 'BBTimepieces';
    System.debug(Trigger.new[0].Twitter_Handle__c);

}