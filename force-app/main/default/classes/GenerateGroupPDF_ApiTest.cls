@isTest(SeeAllData=false)
public class GenerateGroupPDF_ApiTest {

    @isTest
    static void testGenerateGroupPDF() {
        Customer__c UserI = new Customer__c(Name = 'firstCustomer',Last_Name__c = 'LastnameCustomer');
        insert UserI;
       
        Customer__c testCustomer = new Customer__c(Name = 'Friend First Name',Last_Name__c = 'Friend Last Name');
        insert testCustomer;
      
        // Create a Group record
        Group__c testGroup = new Group__c(Name = 'Test Group', Customer__c=UserI.Id);
        insert testGroup;
         
        Group_Member__c gm= new Group_Member__c(Name=testCustomer.Name, LastName__c =testCustomer.Last_Name__c , Group__c = testGroup.Id);
        Insert gm;
        
        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/GenerateGroupPDF';
        request.httpMethod = 'POST';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('GroupId', testGroup.Id);
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        GenerateGroupPDF_Api.generateGroupPDF(testGroup.Id);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
        System.assertNotEquals(null, result.get('base64PDF'));

        // Clean up test data (if needed)
        delete testGroup; // You may need to delete the Group__c record if you don't need it
    }

    @isTest
    static void testApiErrorHandling() {
        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/GenerateGroupPDF';
        request.httpMethod = 'POST';

        // Missing GroupId in request body
        Map<String, String> requestBody = new Map<String, String>();
        // Comment out or remove the next line to simulate missing GroupId
        // requestBody.put('GroupId', 'testGroupId');
        String requestBodyJSON = JSON.serialize(requestBody);
        request.requestBody = Blob.valueOf(requestBodyJSON);

        Test.startTest();

        // Call the API method
        GenerateGroupPDF_Api.generateGroupPDF(null);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        System.assertEquals('Success', result.get('Status'));
    }
}