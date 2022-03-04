@isTest
public with sharing class AccountTriggerTest {

    @isTest
    public static void testAccountTrigger(){

        String mockName= 'qwe';
        String mockStreet= '45123 california street';
        String mockCity= 'Los Angeles';
        String mockState= 'CA';
        String mockZip= '95678';
        String mockCountry= 'USA';


        Account testAccount = new Account(Name = mockName);
        testAccount.BillingStreet = mockStreet ;
        testAccount.BillingCity = mockCity ;
        testAccount.BillingState = mockState;
        testAccount.BillingPostalCode = mockZip;
        testAccount.BillingCountry = mockCountry;

        testAccount.Match_Billing_Address__c = true;        

        
        insert testAccount;


        testAccount = [SELECT Name, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry 
                        FROM Account WHERE Name=:mockName];

        
        System.assertEquals(mockStreet,testAccount.ShippingStreet);
        System.assertEquals(mockCity,testAccount.ShippingCity);
        System.assertEquals(mockState,testAccount.ShippingState);
        System.assertEquals(mockZip,testAccount.ShippingPostalCode);
        System.assertEquals(mockCountry,testAccount.ShippingCountry);
       
        
        
        delete testAccount;

    }
    
    
}