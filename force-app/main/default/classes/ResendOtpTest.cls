@isTest
private class ResendOtpTest {

    @isTest
    static void testResendOTP_Success() {
        // Create test data
        String mobileNumber = '1234567890';

        // Create a test Customer__c record with the given mobile number
        Customer__c testCustomer = new Customer__c(Phone__c = mobileNumber, OTP__c = '5678');
        insert testCustomer;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/resendOtp/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"mobileNumber":"' + mobileNumber + '"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        ResendOtp.resendOTP(mobileNumber);

        // Perform assertions
     //   System.assertEquals(200, res.statusCode, 'Expected HTTP 200 status code');
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Expected success response');
        System.assert(responseBody.contains('OTP resent successfully.'), 'Expected "OTP resent successfully" message');

        // Clean up test data if necessary (rollback changes in a test context)
        delete testCustomer;

        // End the test
        Test.stopTest();
    }

    @isTest
    static void testResendOTP_Failure() {
        // Create test data
        String mobileNumber = '14567890';

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/resendOtp/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"mobileNumber":"1231231234"}'); // Mobile number that does not exist

        // Start the test
        Test.startTest();

        // Invoke the API method
        ResendOtp.resendOTP(mobileNumber);

        // Perform assertions
     //   System.assertEquals(200, res.statusCode, 'Expected HTTP 200 status code');
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Failed'), 'Expected failed response');
        System.assert(responseBody.contains('Signup request not found for the given mobile number.'), 'Expected "Signup request not found" message');

        // End the test
        Test.stopTest();
    }
    
    
    @isTest
    static void testResendOTP_Catch() {
        // Create test data
     

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/resendOtp/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"mobileumber":"1231231234"}'); // Mobile number that does not exist

        // Start the test
        Test.startTest();
        String mobileumber = '14567890';
        // Invoke the API method
       

        // Perform assertions
     //   System.assertEquals(200, res.statusCode, 'Expected HTTP 200 status code');
     //   System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');
         ResendOtp.resendOTP(mobileumber);  
        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Failed'), 'Expected failed response');
        System.assert(responseBody.contains('Signup request not found for the given mobile number.'), 'Expected "Signup request not found" message');

        // End the test
        Test.stopTest();
    }
}