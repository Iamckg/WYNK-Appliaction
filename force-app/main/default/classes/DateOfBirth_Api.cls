@RestResource(urlMapping='/dob/*')
global class DateOfBirth_Api { 
    @HttpPost
    global static void completeProfile(String AccountId, String dob) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
            // Convert the provided date string to a Date object
            Date dateofBirth = Date.valueOf(dob);
            
            // Retrieve the customer record based on the provided AccountId
            Customer__c customerRecord = [SELECT Id, Name, Last_Name__c, Email__c, Password__c, Date_of_Birth__c, Country__c ,IsVerify__c
                                          FROM Customer__c WHERE Id = :AccountId];
            
            // Update the Date of Birth field with the new date
            customerRecord.Date_of_Birth__c = dateofBirth;
            update customerRecord;
            
            // Populate the response with updated customer information
            response.put('dob', customerRecord.Date_of_Birth__c);
            response.put('IsVerify',customerRecord.IsVerify__c);
            response.put('country', customerRecord.Country__c);
            response.put('Email', customerRecord.Email__c);
            response.put('lastname', customerRecord.Last_Name__c);
            response.put('firstname', customerRecord.Name);
            response.put('AccountId', customerRecord.Id);
            response.put('message', 'Your Profile is Successfully Completed.');
            response.put('Status', 'Success');
            Customer__c abc = [Select id,Step4__c,Phone__c from Customer__c Where Id = :AccountId ];
            abc.Step4__c=True;
            Update abc;
            response.put('Step4', abc.Step4__c);
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