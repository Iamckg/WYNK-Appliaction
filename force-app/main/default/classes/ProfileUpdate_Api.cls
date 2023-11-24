@RestResource(urlMapping='/profileUpdate/*')
    global class ProfileUpdate_Api { 
    @HttpPost
    global static void completeProfile(String AccountId, String firstname, String lastname, String gender, String country, String state, String city, String dob, String ImageUrl) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
            // Convert the provided date string to a Date object
            Date dateofBirth = Date.valueOf(dob);
          
            System.debug('AccountId: ' + AccountId);
            // Query the Customer__c record based on the Phone__c (AccountId)
            Customer__c cust = [SELECT Id, Name, Last_Name__c, Date_of_Birth__c,Country__c,ImageUrl__c, State__c, City__c, Password__c ,Gender__c
                                 FROM Customer__c WHERE Id = :AccountId];
      
            System.debug('Query Result: ' + cust);
            // Check if the record exists
            if (cust != null) {
                cust.Name = firstname;
                cust.Last_Name__c = lastname;
                cust.Gender__c= gender;
                cust.Country__c = country;
                cust.State__c = state;
                cust.City__c = city;
                cust.Date_of_Birth__c = dateofBirth;
                cust.ImageUrl__c = ImageUrl;
                update cust;
                
                // Query the updated record
                Customer__c record = [SELECT Id, Name, Email__c, Gender__c, Last_Name__c, Phone__c,ImageUrl__c, OTP__c, Date_of_Birth__c, IsProfile__c, IsVerify__c, Country__c, 
                                             State__c, City__c, Password__c 
                                      FROM Customer__c WHERE Id = :AccountId ];
                
                response.put('ImageUrl', record.ImageUrl__c);
                response.put('city', record.City__c);
                response.put('state', record.State__c);
                response.put('country', record.Country__c);
                response.put('dob', record.Date_of_Birth__c); 
                response.put('phone', record.Phone__c);  
                response.put('email', record.Email__c);
                response.put('gender', record.Gender__c);
                response.put('lastname', record.Last_Name__c);
                response.put('firstname', record.Name);
                response.put('AccountId', record.Id);
                response.put('message', 'Your Profile is Successfully Completed.');
                response.put('Status', 'Success');
            } else {
                response.put('Status', 'Failed');
                response.put('message', 'Customer record not found for the provided Phone Number.');
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