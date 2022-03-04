@isTest
public with sharing class ProductsLeftTest {
    //for every version of the test and every method of the test
    static final String mockName='Jordans';
    static final String mockCode='DEF';
    static final Integer MockNumLeft=20;

    @TestSetup
    public static void makeMockData(){ //create a list of shoes
        List<Product2> mockShoes=new List<Product2>();
        for (Integer i=0; i<5; i++){   //make 5 records to check
            Product2 myShoe= new Product2();
            myShoe.Name=mockName+i;
            myShoe.ProductCode=mockCode+i+i+i;
            myShoe.NumberLeft__c=MockNumLeft;

            mockShoes.add(myShoe);  //then add to the list
            System.debug(myShoe);
        }

    insert mockShoes;  //puts temporarily in the data

    }

    @isTest
    public static void getShoesTest(){
        Product2 expectedShoe= new Product2();
        expectedShoe.Name=mockName+1;
        expectedShoe.ProductCode=mockCode+111;

        List<Product2> actualShoes=Products.getShoes(expectedShoe.ProductCode);  //passes the name of the expected shoe

        System.assertEquals(expectedShoe.Name, actualShoes[0].Name);

    }

}