@isTest
public with sharing class GetIndvProductInfo_Test {
   
    
    static final String  testProductName  = 'Kazuha Ultima';
    static final String  testProductAlt   = 'Kazuha Ultima Watch';
    static final String  testProductURL   = 'imgur.com/fakeLink';
    static final String  testProductStyle = 'mens;men';
    static final Integer testProductPrice = 120;
    static final String  intentionalFail  = 'intentionalFailureId';

    static final Integer RECORDS_TO_MAKE = 5;

    @TestSetup
    static void makeData()
    {
        List<BBTProduct__c> prodList = new List<BBTProduct__c>();
        
        // create 13, since we want to test LIMIT 12 and OFFSET 12
        for(Integer i = 0; i < RECORDS_TO_MAKE; i++)
        {
            BBTProduct__c prod = new BBTProduct__c();
            prod.Name = testProductName;
            prod.Image_Alt_Tag__c = testProductAlt;
            prod.Image_URL__c = testProductURL;
            prod.Product_Style__c = testProductStyle;
            prod.Product_Price__c = testProductPrice;

            prodList.add(prod);
        }

        insert prodList;
    }

    @isTest
    static void getProductTest()
    {
        List<BBTProduct__c> actualProducts = new List<BBTProduct__c>();
        List<BBTProduct__c> testProducts = new List<BBTProduct__c>();

        while(testProducts.size() <= RECORDS_TO_MAKE)
        {
            List<BBTProduct__c> tempProd = new List<BBTProduct__c>();
            Integer offset = 0;
            String dynQuery = 'SELECT Id FROM BBTProduct__c LIMIT 1';

            if(offset > 0)
            {
                tempProd = Database.query(dynQuery);
                testProducts.add(tempProd[0]);
            }
            else 
            {
                dynQuery += ' OFFSET ' + offset;
                tempProd = Database.query(dynQuery);
                testProducts.add(tempProd[0]);
            }
        }

        for(BBTProduct__c prod : testProducts)
        {
            actualProducts.add(GetIndvProductInfo.getProduct(prod.Id));
        }

        for(BBTProduct__c prod : actualProducts)
        {
            System.assertEquals(testProductName, prod.Name);
            System.assertEquals(testProductAlt, prod.Image_Alt_Tag__c);
            System.assertEquals(testProductURL, prod.Image_URL__c);
            System.assertEquals(testProductPrice, prod.Product_Price__c);
        }

        try
        {
            BBTProduct__c failProd = GetIndvProductInfo.getProduct(intentionalFail);
        }
        catch (Exception e)
        {
            System.assert(e.getMessage()!= null, 'error handled by component');
        }

    }
}