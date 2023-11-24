@RestResource(urlMapping='/s3fileupload/*')
global with sharing class S3FileUploadService {

    @HttpPost
    global static Map<String, String> uploadFile(String fileName, String fileBody) {
        Map<String, String> responseMap = new Map<String, String>();
        try {
            // Convert the base64 file body to a Blob
            Blob fileBlob = EncodingUtil.base64Decode(fileBody);
            String accessKey='AKIAXHA23FMK7QMDAILJ';
            String secretKey='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';
            String awsRegion='us-east-1';
            String bucketName='b2btobacco';
            // Call the S3 integration method to upload the file
            String response = AwsS3Integration.filePUT(fileName, accessKey, secretKey, awsRegion, bucketName, fileBlob);
           
            if (response == 'success') {
              //  string fileUrl='https://' + bucketName + '.s3.amazonaws.com/' + filename.toLowerCase()+ '.'+'jpeg';
                responseMap.put('status', 'File uploaded successfully to S3');
                responseMap.put('fileurl', 'https://' + bucketName + '.s3.amazonaws.com/' + filename.toLowerCase()+ '.'+'jpeg');
            } else {
                // Return an error response
                responseMap.put('status', 'File upload failed: ' + response);
            }
        } catch (Exception e) {
            // Handle exceptions appropriately
         //   responseMap.put('status', 'An error occurred: ' + e.getMessage());
        }

        return responseMap;
    }
}