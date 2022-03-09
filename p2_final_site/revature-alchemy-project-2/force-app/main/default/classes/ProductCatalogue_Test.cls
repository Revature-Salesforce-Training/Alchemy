@isTest
public with sharing class ProductCatalogue_Test {

    static final String  testProductName  = 'Kazuha Ultima';
    static final String  testProductAlt   = 'Kazuha Ultima Watch';
    static final String  testProductURL   = 'imgur.com/fakeLink';
    static final String  testProductStyle = 'mens;men';
    static final Integer testProductPrice = 120;

    // these will be multplied by 12 in tested method.
    static final Integer noOffset         = 0;
    static final Integer offsetOne        = 1;
    static final Integer intentionalFail  = 5; // we're only making 13, so an offset of 5*12=60 should return an error or a list of 0 products
    static final String intentionFailName = 'NotAName';
    
    @TestSetup
    static void makeProducts()
    {
        List<BBTProduct__c> prodList = new List<BBTProduct__c>();
        
        // create 13, since we want to test LIMIT 12 and OFFSET 12
        for(Integer i = 0; i < 13; i++)
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
    static void searchCatalogueTest()
    {
        List<BBTProduct__c> actualList = new List<BBTProduct__c>();
        actualList = ProductCatalogue.getProductCatalogueSearch(testProductName, noOffset);

        System.assert(actualList.size() == 12);

        for(BBTProduct__c prod : actualList)
        {
            System.assertEquals(testProductName, prod.Name);
            System.assertEquals(testProductAlt, prod.Image_Alt_Tag__c);
            System.assertEquals(testProductURL, prod.Image_URL__c);
            System.assertEquals(testProductPrice, prod.Product_Price__c);
        }

        actualList = ProductCatalogue.getProductCatalogueSearch(testProductName, offsetOne);
        System.assert(actualList.size() == 1);
        
        
        try
        {
            actualList = ProductCatalogue.getProductCatalogueSearch(intentionFailName, noOffset);
        }
        catch (Exception e)
        {
            System.assert(e.getMessage()!= null, 'error handled by component');
        }

        try 
        {
            actualList = ProductCatalogue.getProductCatalogueSearch(testProductName, intentionalFail);
            System.assert(actualList.size() == 0);
        }
        catch (Exception e)
        {
            System.assert(e.getMessage()!= null, 'error handled by component');
        }


    }

    @isTest
    static void noSearchCatalogueTest()
    {
        List<BBTProduct__c> actualList = new List<BBTProduct__c>();
        actualList = ProductCatalogue.getProductCatalogue(noOffset);

        System.assert(actualList.size() == 12);
        for(BBTProduct__c prod : actualList)
        {
            System.assertEquals(testProductName, prod.Name);
            System.assertEquals(testProductAlt, prod.Image_Alt_Tag__c);
            System.assertEquals(testProductURL, prod.Image_URL__c);
            System.assertEquals(testProductStyle, prod.Product_Style__c);
            System.assertEquals(testProductPrice, prod.Product_Price__c);
        }

        actualList = ProductCatalogue.getProductCatalogue(offsetOne);
        System.assert(actualList.size() == 1);
        
        try 
        {
            actualList = ProductCatalogue.getProductCatalogue(intentionalFail);
            System.assert(actualList.size() == 0);
        }
        catch (Exception e)
        {
            System.assert(e.getMessage()!= null, 'error handled by component');
        }
    }

    @isTest 
    static void variablesTest()
    {
        System.assertEquals(12, ProductCatalogue.RECORDS_TO_PULL); 
    }
}