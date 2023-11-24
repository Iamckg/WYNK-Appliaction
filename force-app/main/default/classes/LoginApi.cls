@RestResource(urlMapping='/login/*')
global class LoginApi { 
    @HttpPost
    global static void login(String mobileNumber, String password , String DeviceToken) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
            // Query only the necessary fields
            Customer__c user = [SELECT Id, Name, Email__c, Gender__c, Last_Name__c, Phone__c, OTP__c, Date_of_Birth__c, IsProfile__c,IsVerify__c, Country__c, State__c, City__c,
                                Password__c, IsDeleted__c,ImageUrl__c,Device_Token__c FROM Customer__c 
                                WHERE Phone__c = :mobileNumber AND IsProfile__c = true  LIMIT 1];
            if(user.IsDeleted__c == true ){
                  response.put('message', 'Your account has been deleted.');
                response.put('Status', 'Failed');
                
            }else if (user != null && verifyPassword(password, user.Password__c))
            {  
                user.Device_Token__c=DeviceToken;
                Update user;
                // Do not expose whether the mobile number or password is incorrect
                response.put('message', 'Login successful.');
                response.put('Status', 'Success');
                
                // Add user details to the response
                response.put('city', user.City__c);
                response.put('state', user.State__c);
                response.put('country', user.Country__c);
                response.put('dob', user.Date_of_Birth__c); 
                response.put('phone', user.Phone__c);
                response.put('firstname', user.Name);
                response.put('lastname', user.Last_Name__c);
                response.put('email', user.Email__c);
                response.put('gender', user.Gender__c);
                response.put('AccountId', user.Id);
            } else {
                // Avoid exposing whether the mobile number or password is incorrect
                response.put('message', 'Login failed. Invalid credentials.');
                response.put('Status', 'Failed');
            }
        } catch (Exception ex) {
            response.put('Status', 'Failed');
            response.put('message', 'Login failed. Invalid credentials.');
        }
        
        String jsonResponse = JSON.serialize(response);
        
        // Return the JSON response
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonResponse);
    }

    // Helper method to verify the password
    private static Boolean verifyPassword(String inputPassword, String hashedPassword) {
        // Implement password verification logic here, using hashing and salting
        // Example using Salesforce Crypto class: Crypto.verifyPassword(inputPassword, hashedPassword);
        // Replace this with your actual implementation
        return inputPassword == hashedPassword;
    }
}