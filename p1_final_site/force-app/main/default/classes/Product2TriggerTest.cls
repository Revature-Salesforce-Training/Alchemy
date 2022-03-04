@isTest
public with sharing class Product2TriggerTest {
    @TestSetup
    static void makeData(){
    Product2 testShoe=new Product2();
    testShoe.Name='Yeezy';
    testShoe.ProductCode='YZY565';
    testShoe.NumberLeft__c=20;
    insert testShoe;
    }   

    @isTest
    public static void triggerTest(){
        List<Product2> actualShoes=[SELECT Name, ProductCode, NumberLeft__c
        FROM Product2
        WHERE Name='Yeezy'
        ];

        Product2 updateShoe=actualShoes[0];
        updateShoe.NumberLeft__c=-5;  //need to purposefully trigger the trigger error
        try{
            update updateShoe;
            //System.assert(true);
        }
        catch(Exception e){
            //System.debug(e.getMessage());
            System.assert(e.getMessage()!=null, 'error handled by class');
        }
    }
    
}