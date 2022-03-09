@isTest 
public class currentUserInfoController_Test {
    
    static testMethod void validateUserInfo() {
        
        // Fetch user Id
        User userID = currentUserInfoController.fetchUser();

        
        // Validate query results
        System.assertEquals(System.UserInfo.getName(), userId.Name);
    }
}