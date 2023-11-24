@RestResource(urlMapping='/delete/*')
global class DeleteAccount_Api { 
    @HttpPost
    global static void deleteAccount(String AccountId) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
            // Check if the account record exists before attempting to delete it
            Customer__c getRecord = [SELECT Id,IsDeleted__c FROM Customer__c WHERE Id = :AccountId];
            if (getRecord != null) {
                getRecord.IsDeleted__c=true;
                update getRecord;
                response.put('message', 'Account deleted successfully.');
                response.put('Status', 'Success');
            } else {
                response.put('message', 'Account not found.');
                response.put('Status', 'Failed');
            }
    
        } catch (Exception ex) {
            // Handle other exceptions
            response.put('Status', 'Failed');
            response.put('message', ex.getMessage());
        }
        
        String jsonResponse = JSON.serialize(response);
        
        // Return the JSON response
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonResponse);
    }
}