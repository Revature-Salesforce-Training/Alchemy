Public class ResourceController {


public static String twitterHandle {
        get 
        {
            // select the current user's twitter handle
            List<User> temp = [SELECT Twitter_Handle__c FROM User WHERE Name =: UserInfo.getName()];
            if(temp.size() > 0)
            {
                twitterHandle = temp[0].Twitter_Handle__c;
            }
            // this is solely a backup. there is a trigger
            // that should entirely replace this line.
            // still put it in as a backup tho.
            if(temp[0].Twitter_Handle__c == null)
            {
                twitterHandle = 'BBTimepieces';
            }
            
            return twitterHandle;
        }
        private set;    // unused
    }
}