@isTest
private class ChangePassword_ApiTest {

    @isTest
    static void testChangePassword_Success() {
        // Create a test user
        Customer__c testUser = new Customer__c();
        testUser.Name = 'Test User';
        testUser.Password__c = 'OldPassword'; // Initial password
        insert testUser;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties
        req.requestURI = '/services/apexrest/ChangePassword/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testUser.Id + '","currentPassword":"OldPassword","newPassword":"NewPassword","confirmPassword":"NewPassword"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        ChangePassword_Api.changePassword(testUser.Id, 'OldPassword', 'NewPassword', 'NewPassword');

        // Perform assertions
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status');
        System.assert(responseBody.contains('Password successfully changed.'), 'message');

        // Query the database to ensure that the password is updated
        Customer__c updatedUser = [SELECT Id, Password__c FROM Customer__c WHERE Id = :testUser.Id];
        System.assertEquals('NewPassword', updatedUser.Password__c, 'Password should be updated');

        // End the test
        Test.stopTest();
    }

    @isTest
    static void testChangePassword_CurrentPasswordIncorrect() {
        // Create a test user
        Customer__c testUser = new Customer__c();
        testUser.Name = 'Test User';
        testUser.Password__c = 'OldPassword'; // Initial password
        insert testUser;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties with an incorrect current password
        req.requestURI = '/services/apexrest/ChangePassword/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testUser.Id + '","currentPassword":"InvalidPassword","newPassword":"NewPassword","confirmPassword":"NewPassword"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        ChangePassword_Api.changePassword(testUser.Id, 'InvalidPassword', 'NewPassword', 'NewPassword');

        // Perform assertions for incorrect current password
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Failed'), 'Status');
        System.assert(responseBody.contains('Current password is incorrect.'), 'message');

        // Query the database to ensure that the password is not updated
        Customer__c updatedUser = [SELECT Id, Password__c FROM Customer__c WHERE Id = :testUser.Id];
        System.assertEquals('OldPassword', updatedUser.Password__c, 'Password should remain unchanged');

        // End the test
        Test.stopTest();
    }

    @isTest
    static void testChangePassword_NewPasswordMismatch() {
        // Create a test user
        Customer__c testUser = new Customer__c();
        testUser.Name = 'Test User';
        testUser.Password__c = 'OldPassword'; // Initial password
        insert testUser;

        // Set up the request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        // Set the request properties with a mismatched new password and confirm password
        req.requestURI = '/services/apexrest/ChangePassword/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"' + testUser.Id + '","currentPassword":"OldPassword","newPassword":"NewPassword","confirmPassword":"MismatchedPassword"}');

        // Start the test
        Test.startTest();

        // Invoke the API method
        ChangePassword_Api.changePassword(testUser.Id, 'OldPassword', 'NewPassword', 'MismatchedPassword');

        // Perform assertions for mismatched new password and confirm password
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Failed'), 'Status');
        System.assert(responseBody.contains('New password and confirm password do not match.'), 'message');

        // Query the database to ensure that the password is not updated
        Customer__c updatedUser = [SELECT Id, Password__c FROM Customer__c WHERE Id = :testUser.Id];
        System.assertEquals('OldPassword', updatedUser.Password__c, 'Password should remain unchanged');

        // End the test
        Test.stopTest();
    }

    @isTest
    static void testChangePassword_UserNotFound() {
        // Set up the request with an invalid AccountId
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/ChangePassword/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"AccountId":"invalidAccountId","currentPassword":"OldPassword","newPassword":"NewPassword","confirmPassword":"NewPassword"}');

        // Start the test
        Test.startTest();

        // Invoke the API method with an invalid AccountId
        ChangePassword_Api.changePassword('invalidAccountId', 'OldPassword', 'NewPassword', 'NewPassword');

        // Perform assertions for user not found
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Failed'), 'Status');
      //  System.assert(responseBody.contains('Current password is incorrect.'), 'message');

        // End the test
        Test.stopTest();
    }
    
    
    
}