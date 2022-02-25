/**
 * Order Search Apex Class
 * made by Eli Couture as part of Revature P1
 * 
 * takes in 3 arguments from the HTML from in the LWC,
 * formats them lightly for a SOQL search
 * 
 * returns the order found (left as NOT limited for future scalability)
 * 
 * last edited 2/21/22 by Eli Couture
 */

public without sharing class OrderSearch {

    public OrderSearch() {

    }
    /**
     *   take in a First Name, a Last Name, and the Order Number, 
     *      format First and Last into '%First%Last%' as there should be a space in between when
     *      comparing to Customer_Full__c
     * 
     *   format the order number to be 8 digits long, consisting of their order number
     *      preceded by the proper amount of '_' wildcards. (currently not implemented)
     *          (using simple % due to lack of data and to start with)
     * 
     *   return the found order List (left as list, no limit 1, for possible future scalability)
     */

    @AuraEnabled
    public static List<Customer_Order__c> getOrderBySearch(String custFirst, String custLast, Integer custOrdNum)
    {
        try {
            String searchName = '%' + custFirst + '%' + custLast + '%';
            String searchNum = OrderSearch.formatOrdNum(custOrdNum);

            // Select the First Name, Last Name, Full Name, Order Status, and the Auto-Number Name field, which represents the
            //                                                                                                  Order Number

            // compare both full name AND order number for accuracy, can be edited to allow for partial/multiple returns in the future
            List<Customer_Order__c> orderList = [
                SELECT ID, Customer_First__c, Customer_Last__c, Customer_Full__c, Name, Order_Status__c 
                FROM Customer_Order__c 
                    WHERE Customer_Full__c 
                        LIKE :searchName 
                    AND Name 
                        LIKE :searchNum];

            return orderList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // changes order number sent from the HTML form into the expected 8 digit order number with _ wildcard
    
    public static String formatOrdNum(Integer ordNum)
    {
        // retrieve and store the length of the order number. expected 1-8
        Integer ORD_NUM_FIELD_LN = 8;
        Integer ordNumLength = (ordNum + '').length();
        String tempStr = '';

        for(Integer i = 0; i < (ORD_NUM_FIELD_LN-ordNumLength); i++)
        {
            tempStr += '_';
        }

        return ('ON-' + tempStr + ordNum);
    }
}