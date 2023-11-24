@RestResource(urlMapping='/PersonalInfo/*')
global class PersonalInformationApi { 
    @HttpPost
    global static void completeProfile(String AccountId) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
            // Query the Customer__c record
            List<Customer__c> records = [SELECT Id, Name, Gender__c, Email__c, Last_Name__c, Phone__c, OTP__c,ImageUrl__c, Date_of_Birth__c, IsProfile__c, IsVerify__c, Country__c, 
                                          State__c, City__c, Password__c FROM Customer__c WHERE Id = :AccountId];
            
            if (records != null && !records.isEmpty()) {
                // Create a list to store filtered customer data
                    List<Map<String, Object>> friendsList = new List<Map<String, Object>>();
                    // Iterate through filtered records and add them to the list
                    for (Customer__c record : records) {
                        Map<String, Object> customerData = new Map<String, Object>();
                        
                        customerData.put('ImageUrl', record.ImageUrl__c);
                        customerData.put('city', record.City__c);
                        customerData.put('state', record.State__c);
                        customerData.put('country', record.Country__c);
                        customerData.put('dob', record.Date_of_Birth__c); 
                        customerData.put('phone', record.Phone__c);
                        customerData.put('firstname', record.Name);
                        customerData.put('lastname', record.Last_Name__c);
                        customerData.put('email', record.Email__c);
                        customerData.put('gender', record.Gender__c);
                        customerData.put('AccountId', record.Id);
                        customerData.put('message', 'Your Profile is Successfully Completed.');
                        customerData.put('Status', 'Success');

                        friendsList.add(customerData);
                    }

                    // Add the list of filtered customer data to the response
                    response.put('ProfileInfo', friendsList);
                    response.put('Status', 'Success');
                    response.put('message', 'Your Profile is Successfully Completed.');

            } else {
                response.put('Status', 'Failed');
                response.put('message', 'Customer not found.');
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