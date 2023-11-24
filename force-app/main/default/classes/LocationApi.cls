@RestResource(urlMapping='/Loaction/*')
global class LocationApi { 
    @HttpPost
    global static void completeProfile(String AccountId, String country, String state,String city , String CountyFlag) {
        Map<String, Object> response = new Map<String, Object>();
        
        try {
           
                Customer__c newUserManager = [SELECT Id, Name, Email__c, Gender__c, Last_Name__c,Phone__c,OTP__c,Country__c,City__c ,State__c,CountyFlag__c,IsVerify__c
                                              FROM Customer__c WHERE Id = :AccountId];
                
               
                    newUserManager.Country__c = country;
                    newUserManager.State__c = state;
                    newUserManager.City__c = city;
                    newUserManager.CountyFlag__c = CountyFlag;
                    update newUserManager;           
                    
                    response.put('Status', 'Success');
                    response.put('AccountId', newUserManager.Id);
                    response.put('Isverify',newuserManager.IsVerify__c);
                    response.put('country', newUserManager.Country__c);
                    response.put('state', newUserManager.State__c);
                    response.put('city', newUserManager.City__c);
                    response.put('CountyFlag', newUserManager.CountyFlag__c);
                    response.put('message', 'Your Profile is Successfully Completed.');
                    Customer__c abc = [Select Id,Step3__c,Phone__c from Customer__c Where Id = :AccountId ];
                    abc.Step3__c=True;
                    Update abc;
                    response.put('Step3', abc.Step3__c);
                   
             
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