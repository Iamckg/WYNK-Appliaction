@RestResource(urlMapping='/completeProfile/*')
global class Complete_Profile_Api { 
    @HttpPost
    global static void completeProfile(String AccountId, String password, String confirmPassword) {
        Map<String, Object> response = new Map<String, Object>();
        List<String> NotificationIds = New List<String>();
        try {
            // Check if the provided password and confirm password match
            if (password != confirmPassword) {
                response.put('Status', 'Failed');
                response.put('message', 'Password and Confirm Password do not match.');
            }
            else {
                Customer__c newUserManager = [SELECT Id, Name, Email__c, Password__c,IsProfile__c,IsVerify__c FROM Customer__c WHERE Id = :AccountId];
                
                    newUserManager.IsProfile__c = true;
                    newUserManager.IsVerify__c = true;
                    newUserManager.Password__c = password; 
                  
                    update newUserManager;           
                    
                    response.put('Status', 'Success');
                    response.put('AccountId', newUserManager.Id);
                    response.put('firstaname', newUserManager.Name);
                    response.put('IsVerify', newUserManager.IsVerify__c);
                    response.put('IsProfile', newUserManager.IsProfile__c);
                    response.put('email', newUserManager.Email__c);
                    response.put('password', newUserManager.Password__c);
                    response.put('confirm password', newUserManager.Password__c);
                    response.put('message', 'Your Profile is Successfully Completed.');
                
                    User_Notification__c UserNotification = New User_Notification__c();
                    UserNotification.Customer__c=newUserManager.Id;
                    UserNotification.Name='Congratulations!'+newUserManager.Name;
                    UserNotification.Message__c= 'Dear ' + newUserManager.Name + ' ! You have completed your profile. Thanks for providing your information. Your profile is now fully set up.';
                    Insert UserNotification ;  
                    NotificationIds.Add(UserNotification.Id);
                
               
                   response.put('NotificationIds',NotificationIds) ;          
            }
        } catch (Exception ex) {
            response.put('Status', 'Failed');
            response.put('message', ex.getMessage());
        }
        
        String jsonResponse = JSON.serialize(response);
        
        // Return the JSON response
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonResponse);
    }
}