@RestResource(urlmapping='/PhoneApi/*')
Global class Phone_Api {
    @HttpPost
    global static void createSignupRequest(String mobileNumber, String code , String DeviceToken) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
            String fullNumber = code + mobileNumber;
            
            // Check if a Customer__c record with the given Phone__c exists
            List<Customer__c> existingRecords = [SELECT Id, OTP__c, Phone__c,IsVerify__c,IsProfile__c FROM Customer__c WHERE Phone__c = :fullNumber AND IsVerify__c= true LIMIT 1];
            
            if (existingRecords.isEmpty()) {
                // If no record exists, create a new one
                Customer__c signupRequest = new Customer__c();
                signupRequest.Phone__c = fullNumber;
                signupRequest.Device_Token__c = DeviceToken;
                insert signupRequest;
                
                response.put('Status', 'Success');
                response.put('AccountId', signupRequest.Id);
                response.put('IsVerify',signupRequest.IsVerify__c);
                response.put('Phone Number', signupRequest.Phone__c);
                response.put('message', 'OTP sent successfully');
                response.put('OTP', '1234'); 
            } else {
                // If a record with the given Phone__c already exists, return a failure response
                response.put('OTP', '1234'); 
                response.put('IsVerify', existingRecords[0].IsVerify__c);
                response.put('Phone Number', existingRecords[0].Phone__c);
                response.put('message', 'Mobile No. already exists !!'); 
                response.put('Status', 'Failed');
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