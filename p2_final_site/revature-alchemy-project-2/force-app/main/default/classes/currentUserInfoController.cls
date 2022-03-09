//get User Id via System namespace method
public class currentUserInfoController {

    // search for the active user's name and information to store in the Hero Tag component
    // based off of currently logged in user
    @AuraEnabled 
     public static user fetchUser(){
        User userId = [SELECT Id, Name from User WHERE Id =: userInfo.getUserId()];
        return userId;
     }
 }