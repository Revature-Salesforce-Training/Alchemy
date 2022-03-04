/**
 *      Rev P1 Apex Testing Stretch Goal
 *      Created by Eli Couture
 * 
 *      Last Modified 2/23/2022 by Eli Couture
 *        
 *      Tests the OrderSearch.cls Apex class, with its two methods:
 * 
 *          List<Customer_Order__c>     getOrderBySearch(String, String, Integer)
 *                           String     formatOrdNum(Integer)
 */

@isTest
public class OrderSearchTest {
    
    @TestSetup
    static void makeTestData()
    {
        // number of orders to create. arbitrarily 5. we are testing for #5, but want to
        // add several mocks in front of it to make sure our Auto-Number field populates correctly
        Integer numOrders = 5;

        // We'll give all of our fake data the same name, since we're only testing the final one
        String mockFirstName = 'Jimmy';
        String mockLastName = 'Jenkins';

        // We will store our new Jimmy Jenkins here to be read by our test
        List<Customer_Order__c> mockedOrders = new List<Customer_Order__c>();

        // create new orders, from 1 to numOrders inclusive.
        for(Integer i=1; i <= numOrders; i++)
        {
            // create a new Customer Order, give it both names. add it to our mock order list
            Customer_Order__c o = new Customer_Order__c();
            o.Customer_First__c = mockFirstName;
            o.Customer_Last__c = mockLastName;

            //System.debug('i = ' + i);
            //System.debug(o);
            //System.debug('O\'s (API)Name/(Label)Order Number is : ');
            //System.debug(o.Name);
            mockedOrders.add(o);
        }

        // obviously we must insert the data to test with, since we also need to 
        // test the auto-number it generates
        insert mockedOrders;

        //List<Customer_Order__c> debugOrders = [SELECT id, name, Customer_Full__c FROM Customer_Order__c WHERE Customer_Full__c = 'Jimmy Jenkins'];
        //System.debug(debugOrders);
    }

    @IsTest
    static void testOrderSearch(){
        
        // create a new Jimmmy Jenkins, give it the name Jimmy Jenkins.
        Customer_Order__c jimmyJenkins1 = new Customer_Order__c();


        Integer jimmyOrdNum = 5; // TODO: find a way to make this dynamic, if we make 5 records, we're testing #5 of the new ones.
                                // but we already have 3 records inserted, so the last one is actually order number 8.

        jimmyJenkins1.Customer_First__c = 'Jimmy';
        jimmyJenkins1.Customer_Last__c = 'Jenkins';

        // use our tested method to search, it takes a FirstName, a LastName, and an Integer for the order number.
        // the order number we pass will be formatted inside of the method to be a SOQL queryable string,
        // with wildcards applied to the beginning.
        List<Customer_Order__c> testJimmy = OrderSearch.getOrderBySearch(jimmyJenkins1.Customer_First__c, jimmyJenkins1.Customer_Last__c, jimmyOrdNum);

        // assert that the Order Number is as we expect. TODO - find a way to make this dynamic
        system.assertEquals('ON-0010000'+jimmyOrdNum, testJimmy[0].Name);
        // of note, i'm not sure why the order number is 001??, it should be incrementing
        // 00000004 -> 00000005, but all test data increments with the 1 in the 3rd spot.
        // this is why its currently hardcoded
        
    }

    @IsTest 
    static void testOrderNumberFormat(){

        // Order Number is in an 8 digit pattern. ON-{00000000}
        // test one number per digit length 1-8
        List<Integer> testNumbers = new List<Integer>{  1, 
                                                        25, 
                                                        345, 
                                                        4444, 
                                                        67543, 
                                                        987654, 
                                                        1234567, 
                                                        88888888};

        // method being tested should return the ON- prefix, along with the number sent,
        // preceded by 8-n underscore wildcards to be sent as part of a SOQL query for the
        // Order Number (API - Name), a One(1) digit Order Number should have Seven(7) underscores ahead of it,
        // a Seven(7) digit Order Number should have One(1) underscore ahead of it.
        List<String> expectedResults = new List<String>{'ON-_______1', 
                                                        'ON-______25', 
                                                        'ON-_____345', 
                                                        'ON-____4444', 
                                                        'ON-___67543', 
                                                        'ON-__987654', 
                                                        'ON-_1234567', 
                                                        'ON-88888888'};

        // for every single test Number, assert that what we sent testNumbers[i]
        // returns as the correct adjusted string
        for(Integer i = 0; i < testNumbers.size(); i++)
        {
            String testStr = OrderSearch.formatOrdNum(testNumbers[i]);
            System.assertEquals(expectedResults[i], testStr);
        }
    }

}