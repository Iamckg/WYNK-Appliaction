@RestResource(urlMapping='/ChangePassword/*')
global class ChangePassword_Api {
    @HttpPost
    global static void changePassword(String AccountId, String currentPassword, String newPassword, String confirmPassword) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            // Retrieve the user record based on the provided AccountId
            Customer__c userRecord = [SELECT Id, Password__c FROM Customer__c WHERE Id = :AccountId];

            // Check if the provided current password matches the stored password
            if (userRecord != null && userRecord.Password__c == currentPassword) {
                // Check if the new password matches the confirm password
                if (newPassword == confirmPassword) {
                    // Update the user's password with the new one
                    userRecord.Password__c = newPassword;
                    update userRecord;

                    // Populate the response with a success message
                    response.put('Status', 'Success');
                    response.put('message', 'Password successfully changed.');
                } else {
                    response.put('Status', 'Failed');
                    response.put('message', 'New password and confirm password do not match.');
                }
            } else {
                response.put('Status', 'Failed');
                response.put('message', 'Current password is incorrect.');
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