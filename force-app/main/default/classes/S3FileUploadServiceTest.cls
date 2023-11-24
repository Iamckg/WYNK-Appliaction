@isTest
public class S3FileUploadServiceTest {
    @isTest
    static void testUploadFileSuccess() {
        // Create a test file name and content
        String fileName = 'testfile.jpeg';
        String fileBody = EncodingUtil.base64Encode(Blob.valueOf('Test file content'));
        Test.startTest();
        Map<String, String> responseMap = S3FileUploadService.uploadFile(fileName, fileBody);
        Test.stopTest();
    }
     @isTest
    static void testcatch() {
        // Create a test file name and content
     //   String fileName = 'testfile.jpeg';
     //   String fileBody = EncodingUtil.base64Decode.valueOf('Test file content');
        Test.startTest();
        Map<String, String> responseMap = S3FileUploadService.uploadFile('', '');
        Test.stopTest();
    }
    @isTest
    static void testUploadFileFailure() {
        // Create a test file name and content
        String fileName = 'testfile.jpeg';
        String fileBody = EncodingUtil.base64Encode(Blob.valueOf('Test file content'));
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new S3FileUploadServiceTestMockFailure());
        Map<String, String> responseMap = S3FileUploadService.uploadFile(fileName, fileBody);
        Test.stopTest();
    }
    // Mock class for HttpCalloutMock to simulate a failure
    public class S3FileUploadServiceTestMockFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('Mocked failure response');
            res.setStatusCode(500);
            return res;
        }
    }
}