public without sharing class ProductCatalogue {

    // we only ever want to pull 12 records at a time
    // 4 columns wide, 3 rows tall, divides extremely well into the SLDS grid
    @TestVisible
    static final Integer RECORDS_TO_PULL = 12;

    // take in search string, and an offset
    // use Dynamic SOQL to search for specific item(s)
    @AuraEnabled
    public static List<BBTProduct__c> getProductCatalogueSearch(String inQuery, Integer inOffset)
    {
        // immediately do the basic sanitisation of our search query we're passed
        String sanSearch = String.escapeSingleQuotes(inQuery);
        List<BBTProduct__c> searchRecords = new List<BBTProduct__c>();
        List<String> searchTags = new List<String>(); // want to eventually delimit inQuery to parse all possible words as separate words to search with
                                                        // would use Name IN searchTags instead of Name LIKE sanSearch, which isn't efficinet and has no finesse
        String searchTagsDelimited = '(' + inQuery + ')'; // temporary, make method to delimit inQuery with commas

        try
        {
            // SOQL query on multipicklist field
            // WHERE picklistName INCLUDES (String, String, String)
            // comma for OR, Semicolon for AND (Semicolon follows 'aaa;bbb' in the SAME quotes for syntax)

            // construct dynamic SOQL query, structured like this for human readability
            String dynSearchQuery = 'SELECT Id, Name, Product_Style__c, Product_Price__c, Image_URL__c, Image_Alt_Tag__c ';
            dynSearchQuery +=       'FROM BBTProduct__c ';
            dynSearchQuery +=       'WHERE Name LIKE \'%'+sanSearch+'%\' ';
            //dynSearchQuery +=       'OR Product_Style__c INCLUDES ' + searchTagsDelimited + ' '; // space added for SOQL clauses to be separated
            /** this is currently unimplemented but would also search our multi-select picklist with styles like mens, womens, classic, antique, etc. */
            dynSearchQuery +=       'ORDER BY Name ';
            dynSearchQuery +=       'LIMIT ' + RECORDS_TO_PULL; // always limit to 12

            // only include the offset if we actually NEED to offset
            if(inOffset > 0)
                dynSearchQuery +=       'OFFSET ' + (inOffset*RECORDS_TO_PULL);

            // actually search our database with our constructed query
            searchRecords = Database.query(dynSearchQuery);

            if(searchRecords.size() > 0)
            {
                return searchRecords;
            }
            else 
            {
                throw new AuraHandledException('No Records found');
            }
        }
        catch (Exception e)
        {
            // if we get any errors, throw the error down to the LWC component to show toast (not implemented yet)
            throw new AuraHandledException(e.getMessage());
        }
    }

    // does nearly the exact same thing as the above, but does not filter with anything,
    // pulls the first 12 products it finds, read the above commenting if you need specifics please
    @AuraEnabled
    public static List<BBTProduct__c> getProductCatalogue(Integer inOffset)
    {
        List<BBTProduct__c> searchRecords = new List<BBTProduct__c>();
        String searchQuery =    'SELECT Id, Name, Product_Style__c, Product_Price__c, Image_URL__c, Image_Alt_Tag__c ';
        searchQuery +=          'FROM BBTProduct__c ';
        searchQuery +=          'ORDER BY Name ';
        searchQuery +=          'LIMIT ' + RECORDS_TO_PULL;
        
        if (inOffset > 0)
            searchQuery +=      'OFFSET ' + (inOffset*RECORDS_TO_PULL);

        try
        {
            searchRecords = Database.query(searchQuery);
            
            if(searchRecords.size() > 0)
            {
                return searchRecords;
            }
            else 
            {
                throw new AuraHandledException('No Records found');
            }
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}