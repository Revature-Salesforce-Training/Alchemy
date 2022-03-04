@isTest
public with sharing class ProductControllerTest {

    @TestSetup
    static void makeMockData(){
        
        List<Product2> testRecords = new List<Product2>();

        String mockProductName = 'Shoe';
        String mockProductDescription = 'Goes on your feet';
        String mockProductCode = 'ERT';

        for(Integer i = 0; i < 5; i++){

            Product2 p = new Product2();
            p.Name = mockProductName+i;
            p.Description = mockProductDescription;
            p.ProductCode = mockProductCode+i+i+i;
            testRecords.add(p);

        }

            insert testRecords;

    }

    @isTest
    static void getProductsTest(){

        List<Product2> expectedRecords = new List<Product2>();

        String mockProductName = 'Shoe';
        String mockProductDescription = 'Goes on your feet';
        

        for(Integer i = 0; i < 5; i++){

            Product2 p = new Product2();
            p.Name = mockProductName+i;
            p.Description = mockProductDescription;
            expectedRecords.add(p);

        }

        List<RevoProduct__c> testList = ProductController.getProducts();

        for (Integer i = 0; i < expectedRecords.size(); i++) {
            
            System.debug(expectedRecords[i]);
            System.debug(testList[i]);

            System.assertEquals(expectedRecords[i].Description, testList[i].ProductName__c);
            System.assertEquals(expectedRecords[i].Name, testList[i].Name);
           
            
        }

    
    }
    

 }