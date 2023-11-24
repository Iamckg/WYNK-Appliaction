@RestResource(urlMapping='/NameEmail/*')
global class NameEmailApi { 
    @HttpPost
    global static void completeProfile(String AccountId, String gender, String email,String firstname,  String lastname) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
           
                Customer__c newUserManager = [SELECT Id, Name, Email__c, Gender__c, Last_Name__c,Phone__c,OTP__c,IsVerify__c FROM Customer__c WHERE Id = :AccountId];
                
               
                    newUserManager.Name = firstname;
                    newUserManager.Last_Name__c = lastname;
                    newUserManager.Email__c = email; 
                    newUserManager.Gender__c = gender; 
                    update newUserManager;           
                    
                    response.put('Status', 'Success');
                    response.put('AccountId', newUserManager.Id);
                    response.put('firstname', newUserManager.Name);
                    response.put('lastname', newUserManager.Last_Name__c);
                    response.put('email', newUserManager.Email__c);
                    response.put('gender', newUserManager.Gender__c);
                    response.put('IsVerify', newUserManager.IsVerify__c);
                    response.put('message', 'Your Profile is Successfully Completed.');
                    Customer__c abc = [Select id,Step2__c,Phone__c from Customer__c Where Id = :AccountId ];
                    abc.Step2__c=True;
                    Update abc;
                    response.put('Step2', abc.Step2__c);
                   
             
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