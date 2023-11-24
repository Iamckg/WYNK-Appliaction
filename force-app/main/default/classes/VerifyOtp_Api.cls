@RestResource(urlmapping='/verify/*')
global class VerifyOtp_Api {
    @HttpPost
    global static void verifyOTP(String mobileNumber, String otp) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            // Query the Customer__c record for the provided mobile number
            List<Customer__c> signupRequests = [SELECT Id, Phone__c, OTP__c FROM Customer__c WHERE Phone__c = :mobileNumber LIMIT 1];

            if (signupRequests.isEmpty()) {
                response.put('Status', 'Failed');
                response.put('message', 'Signup request not found for the given mobile number.');
            } else {
                Customer__c signupRequest = signupRequests[0];

                // Check if the provided OTP matches the stored OTP
                String storedOTP = '1234'; // Replace with actual stored OTP
                String providedOTP = String.valueOf(otp);

                if (storedOTP == providedOTP) {
                    signupRequest.IsVerify__c = false;
                    update signupRequest;
                    response.put('Status', 'Success');
                    response.put('Phone Number', signupRequest.Phone__c);
                    response.put('message', 'OTP verification successful.');
                    response.put('IsVerify', signupRequest.IsVerify__c);
                } else {
                    response.put('Status', 'Failed');
                    response.put('message', 'Invalid OTP.');
                }
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