@isTest
private class BannerList_ApiTest {

    @isTest
    static void testGetBannerList() {
        // Create a test Banner record
        Banner__c banner = new Banner__c( Name = 'Test Banner', Status__c = 'Active' );
        insert banner;

        // Create a test ContentDocument
        ContentVersion content = new ContentVersion(Title = 'Test Banner',  PathOnClient = 'test-banner.png', VersionData = Blob.valueOf('Test Image Content'));
        insert content;
        
        // Link the ContentVersion to a ContentDocument
        ContentDocumentLink cdl = new ContentDocumentLink(ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :content.Id].ContentDocumentId, LinkedEntityId = banner.Id,
                                                          ShareType = 'V', Visibility = 'AllUsers');
        insert cdl;

        Test.startTest();

        // Call the API to get the banner list
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/Banners/';
        req.httpMethod = 'GET';

        BannerList_Api.getBannerList();

        Test.stopTest();

        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
        System.assert(responseBody.contains('Success'), 'Status should be Success');

        // Verify that the banner data is included in the response
        System.assert(responseBody.contains('base64Image'), 'Response should contain base64Image');
        System.assert(responseBody.contains('Name'), 'Response should contain Name');
        System.assert(responseBody.contains('BannerId'), 'Response should contain BannerId');
    }
    @isTest
    static void testGetBannerListException() {
        // Simulate an exception scenario where no banners are found
        Test.startTest();

        // No banner records created

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;

        req.requestURI = '/services/apexrest/Banners/';
        req.httpMethod = 'GET';

        BannerList_Api.getBannerList();

        Test.stopTest();

       
        System.assertEquals('application/json', RestContext.response.headers.get('Content-Type'), 'Expected Content-Type header');

        String responseBody = res.responseBody.toString();
  
    }
}