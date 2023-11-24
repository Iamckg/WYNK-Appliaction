@isTest
public class Phone_ApiTest {

    @isTest
    static void testCreateSignupRequestSuccess() {
        // Set the request context
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/PhoneApi';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('mobileNumber', '1234567890');
        requestBody.put('code', '+1'); // Set the appropriate country code
        requestBody.put('DeviceToken', 'sampleDeviceToken');
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        Phone_Api.createSignupRequest('1234567890', '+1', 'sampleDeviceToken');

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
        System.assertEquals(true, result.containsKey('AccountId'));
        System.assertEquals(true, result.containsKey('IsVerify'));
        System.assertEquals(true, result.containsKey('Phone Number'));
        System.assertEquals('OTP sent successfully', result.get('message'));
        System.assertEquals('1234', result.get('OTP'));

        // Verify that a new Customer__c record is created
        Id accountId = (Id)result.get('AccountId');
        Customer__c createdRecord = [SELECT Id, Phone__c, Device_Token__c FROM Customer__c WHERE Id = :accountId];
        System.assertEquals('+11234567890', createdRecord.Phone__c);
        System.assertEquals('sampleDeviceToken', createdRecord.Device_Token__c);

        // Clean up test data
        delete createdRecord;
    }

    @isTest
    static void testCreateSignupRequestExistingRecord() {
        // Create test data - an existing record with IsVerify__c=true
        Customer__c existingRecord = new Customer__c(Phone__c = '+11234567890', Device_Token__c = 'existingDeviceToken', IsVerify__c = true);
        insert existingRecord;

        // Set the request context
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/PhoneApi';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('mobileNumber', '1234567890');
        requestBody.put('code', '+1');
        requestBody.put('DeviceToken', 'newDeviceToken');
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        Phone_Api.createSignupRequest('1234567890', '+1', 'newDeviceToken');

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Failed', result.get('Status'));
        System.assertEquals(true, result.containsKey('OTP'));
        System.assertEquals(true, result.containsKey('IsVerify'));
        System.assertEquals(true, result.containsKey('Phone Number'));
        System.assertEquals('Mobile No. already exists !!', result.get('message'));

        // Verify that no new Customer__c record is created
        List<Customer__c> records = [SELECT Id FROM Customer__c WHERE Phone__c = '+11234567890'];
        System.assertEquals(1, records.size());

        // Clean up test data
        delete existingRecord;
    }
}