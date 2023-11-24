@isTest
public class ContactMatchingApiTest {
    
    @isTest
    static void testMatchContacts() {
        // Create test data for Customer__c
        Customer__c customer = new Customer__c();
        customer.Name = 'John Doe';
        customer.Phone__c = '1234567890';
        customer.IsDeleted__c = false;
        insert customer;

        // Prepare the input data
        List<ContactMatchingApi.ContactData> contactList = new List<ContactMatchingApi.ContactData>();
        ContactMatchingApi.ContactData contact1 = new ContactMatchingApi.ContactData();
        contact1.name = 'John Doe';
        contact1.phoneNumber = '1234567890';
        contactList.add(contact1);

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/ContactMatchingApi';
        request.httpMethod = 'POST';

        String requestBody = JSON.serialize(contactList);
        request.requestBody = Blob.valueOf(requestBody);

        Test.startTest();

        // Call the API method
        ContactMatchingApi.matchContacts(contactList);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        // Assert your expected results here
        System.assertEquals('Success', result.get('Status'));

        List<Object> matchedContacts = (List<Object>) result.get('MatchedContacts');
        System.assertEquals(1, matchedContacts.size());

        // Clean up test data
        delete customer;
    }
     @isTest
    static void testUnMatchContacts() {
 

        // Prepare the input data
        List<ContactMatchingApi.ContactData> contactList = new List<ContactMatchingApi.ContactData>();
        ContactMatchingApi.ContactData contact1 = new ContactMatchingApi.ContactData();
        contact1.name = 'John Doe';
        contact1.phoneNumber = '1234567890';
        contactList.add(contact1);

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/ContactMatchingApi';
        request.httpMethod = 'POST';

        String requestBody = JSON.serialize(contactList);
        request.requestBody = Blob.valueOf(requestBody);

        Test.startTest();

        // Call the API method
        ContactMatchingApi.matchContacts(contactList);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        // Assert your expected results here
        System.assertEquals('Success', result.get('Status'));
    }
    
     @isTest
    static void testCatch() {
        // Create test data for Customer__c
        Customer__c customer = new Customer__c();
        customer.Name = 'John Doe';
        customer.Phone__c = 'test';
        insert customer;

        // Prepare the input data
        List<ContactMatchingApi.ContactData> contactList = new List<ContactMatchingApi.ContactData>();
        ContactMatchingApi.ContactData contact1 = new ContactMatchingApi.ContactData();
        contact1.name = 'John Doe';
        contact1.phoneNumber = 'test';
       

        // Set the request and response contexts
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        request.requestURI = '/services/apexrest/ContactMatchingApi';
        request.httpMethod = 'POST';
         contactList.add(contact1);
        String requestBody = JSON.serialize(contactList);
        request.requestBody = Blob.valueOf(requestBody);

        Test.startTest();

        // Call the API method
        ContactMatchingApi.matchContacts(contactList);

        Test.stopTest();

        // Verify the response
        String responseBody = response.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

        // Clean up test data
        delete customer;
    }
}