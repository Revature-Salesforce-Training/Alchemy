public with sharing class ColorTestController {

    @AuraEnabled(cacheable=true)
    public static string getArtisanName(string colorType){
        Artisan__c artisanName;
        try {
            artisanName = [SELECT Name, Artist_Name__c FROM Artisan__C where ColorFor__c = :colorType];
            System.debug(artisanName.Artist_Name__c);
            return artisanName.Artist_Name__c;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}