@isTest
public class VerifyOtp_ApiTest {

    @isTest
    static void testVerifyOTPSuccess() {
        // Create test data
        Customer__c testCustomer = new Customer__c(Phone__c = '1234567890', OTP__c = '1234', IsVerify__c = true);
        insert testCustomer;

        // Set the request context
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/verify';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('mobileNumber', testCustomer.Phone__c);
        requestBody.put('otp', testCustomer.OTP__c);
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        VerifyOtp_Api.verifyOTP(testCustomer.Phone__c, testCustomer.OTP__c);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
        System.assertEquals(testCustomer.Phone__c, result.get('Phone Number'));
        System.assertEquals(false, result.get('IsVerify'));
        System.assertEquals('OTP verification successful.', result.get('message'));

        // Verify that the customer record is updated
        Customer__c updatedCustomer = [SELECT IsVerify__c FROM Customer__c WHERE Id = :testCustomer.Id];
        System.assertEquals(false, updatedCustomer.IsVerify__c);
        
        // Clean up test data
        delete testCustomer;
    }

    @isTest
    static void testVerifyOTPInvalidOTP() {
        // Create test data
        Customer__c testCustomer = new Customer__c(Phone__c = '1234567890', OTP__c = '1234', IsVerify__c = true);
        insert testCustomer;

        // Set the request context
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/verify';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('mobileNumber', testCustomer.Phone__c);
        requestBody.put('otp', '5678'); // Invalid OTP
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        VerifyOtp_Api.verifyOTP(testCustomer.Phone__c, '5678'); // Invalid OTP

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Failed', result.get('Status'));
        System.assertEquals('Invalid OTP.', result.get('message'));

        // Verify that the customer record is not updated
        Customer__c unchangedCustomer = [SELECT IsVerify__c FROM Customer__c WHERE Id = :testCustomer.Id];
        System.assertEquals(true, unchangedCustomer.IsVerify__c);
        
        // Clean up test data
        delete testCustomer;
    }

    @isTest
    static void testVerifyOTPNotFound() {
        // Set the request context
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/verify';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('mobileNumber', '9876543210'); // Non-existent mobile number
        requestBody.put('otp', '1234');
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        VerifyOtp_Api.verifyOTP('9876543210', '1234'); // Non-existent mobile number

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Failed', result.get('Status'));
        System.assertEquals('Signup request not found for the given mobile number.', result.get('message'));
    }
}