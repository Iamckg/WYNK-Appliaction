@RestResource(urlmapping='/resendOtp/*')
global class ResendOtp {
   
    @HttpPost
    global static void resendOTP(String mobileNumber) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            // Check if a signup request exists for the given mobile number
            List<Customer__c> signupRequests = [SELECT Id, Phone__c, OTP__c FROM Customer__c WHERE Phone__c = :mobileNumber LIMIT 1];

            if (!signupRequests.isEmpty()) {
                Customer__c signupRequest = signupRequests[0];
                String newOTP = generateNewOTP(); // Generate a new OTP

                // Update the OTP field with the new OTP
                signupRequest.OTP__c = newOTP;
                update signupRequest;

                response.put('Status', 'Success');
                response.put('Phone Number', signupRequest.Phone__c);
                response.put('message', 'OTP resent successfully.');
                response.put('OTP', '1234'); // Send the newly generated OTP
            } else {
                response.put('Status', 'Failed');
                response.put('message', 'Signup request not found for the given mobile number.');
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

    // Helper method to generate a new OTP
    private static String generateNewOTP() {
        // Implement your logic to generate a new OTP here
        // For example, you can use a random number generator to create a 6-digit OTP
        // Ensure the generated OTP is a string of 6 digits
        // Example: '123456'
        return '1234'; // Replace this with your actual generated OTP
    }
}