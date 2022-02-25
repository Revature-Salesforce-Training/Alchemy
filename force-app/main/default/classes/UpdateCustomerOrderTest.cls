@isTest 
public class UpdateCustomerOrderTest {

    // mock names and status to be inserted
    final private static String mockFirstName = 'Jimothy';
    final private static String mockLastName = 'Jenkins';
    final private static String mockOrderStatus = 'Pending';

    // this is what we'll update the order status to be for testing
    final private static String newTestOrderStatus = 'Cancelled';

    @TestSetup
    static void makeData(){

        // make 5 orders, and store them in mockedOrders
        Integer numOrders = 5;
        List<Customer_Order__c> mockedOrders = new List<Customer_Order__c>();

        for(Integer i=1; i <= numOrders; i++)
        {
            // use standard dummy data as defined in static variables
            Customer_Order__c o = new Customer_Order__c();
            o.Customer_First__c = mockFirstName;
            o.Customer_Last__c = mockLastName;
            o.Order_Status__c = mockOrderStatus;

            //System.debug('i = ' + i);
            //System.debug(o);
            //System.debug('O\'s (API)Name/(Label)Order Number is : ');
            //System.debug(o.Name);
            mockedOrders.add(o);
        }

        insert mockedOrders;
    }

    @isTest
    public static void updaterTest()
    {
        // use the static variables to make sure the name is accurate
        // using Wildcards just in case, and to use LIKE to obtain all 5 mocked orders
        String searchName = '%' + mockFirstName + ' ' + mockLastName + '%';

        // our mock name is Jimothy Jenkins, so our List is all 5 of our Jimothies.
        // using an unrealistic name on purpose
        List<Customer_Order__c> jimothies = [SELECT id, Name, Customer_Full__c, Order_Status__c 
                                                FROM Customer_Order__c 
                                                WHERE Customer_Full__c
                                                    LIKE :searchName];

        // for every Jimothy Jenkins in our List, try to update
        // the order status to 'Cancelled' using the static test variable
        for (Customer_Order__c jimmy : jimothies) 
        {
            UpdateCustomerOrder.updateOrderByNumAndFullName(jimmy.Customer_Full__c, jimmy.Name, newTestOrderStatus);
        }

        // collect the updated Jimothy Jenkins
        List<Customer_Order__c> updatedJimothies =  [SELECT id, Name, Customer_Full__c, Order_Status__c 
                                                    FROM Customer_Order__c 
                                                    WHERE Customer_Full__c
                                                        LIKE :searchName];

        // for every updated Jimothy Jenkins, assert their order status is correct
        for (Customer_Order__c newJimmy : updatedJimothies) 
        {
            System.AssertEquals(newTestOrderStatus, newJimmy.Order_Status__c);
        }
    }
}