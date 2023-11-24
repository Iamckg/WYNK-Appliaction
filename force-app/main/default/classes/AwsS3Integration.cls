/******************************************************************************
* Author: Chandan Gupta
* Date: Oct 30, 2023
* Descpription: AWS Service for uploading and fetching files & buckets Data

*/
public WITH SHARING class AwsS3Integration {
    
    private static String awsKey {get;set;}
    private static String awsSecret {get;set;}
    private static String bucketName {get;set;}
    private static String methodName {get;set;}
    private static String hostName = 's3.amazonaws.com';
    private static String algorithm='AWS4-HMAC-SHA256';
    private static String service='s3';
    Private static String regionName {get;set;}
    Private static List<String> buckets=new List<String>();
    Private static List<String> Files=new List<String>();
    
   
    /*
@description => This method is use to create Auth header to fetch the Buckets and files
*/
    
/*    
    private static string CreateAuthHeader(String type,String formattedDateString,String longDate,String dateStamp )
    {
        String canonicalRequest;
        if(type=='Buckets'){
            canonicalRequest = methodName +'\n' + '/'+'\n\n'+'date:'+ longDate + '\n' +'host:'+'s3'+'.'+regionName+'.amazonaws.com' + '\n' +'x-amz-content-sha256:UNSIGNED-PAYLOAD'+'\n'+'x-amz-date:'+formattedDateString +'\n\n'+'date;host;x-amz-content-sha256;x-amz-date'+'\n'+'UNSIGNED-PAYLOAD';
        }
        if(type=='Files'){
            canonicalRequest = methodName +'\n' + '/'+ '\n\n'+'date:'+ longDate + '\n' +'host:'+ bucketName+'.s3'+'.'+RegionName+'.amazonaws.com' + '\n' +'x-amz-content-sha256:UNSIGNED-PAYLOAD'+'\n'+'x-amz-date:'+formattedDateString +'\n\n'+'date;host;x-amz-content-sha256;x-amz-date'+'\n'+'UNSIGNED-PAYLOAD';
        }
        system.debug(canonicalRequest);
        
        Blob canonicalHash = Crypto.generateDigest('SHA-256', Blob.valueof(canonicalRequest));
        String canonicalHashString = EncodingUtil.convertToHex(canonicalHash);
        
        String stringToSign = algorithm + '\n' + formattedDateString + '\n' + dateStamp + '/' + regionName + '/'+ service + '/aws4_request\n' + canonicalHashString;
        
        String kSecret = 'AWS4' + awsSecret;
        Blob kDate = Crypto.generateMac('HmacSHA256', Blob.valueOf(dateStamp), Blob.valueOf(kSecret));
        Blob kRegion = Crypto.generateMac('HmacSHA256', Blob.valueOf(regionName), kDate);
        Blob kService = Crypto.generateMac('HmacSHA256', Blob.valueOf(service), kRegion);
        Blob kSigning = Crypto.generateMac('HmacSHA256', Blob.valueOf('aws4_request'), kService);
        Blob blobSignature  = Crypto.generateMac('HmacSHA256', Blob.valueOf(stringToSign), kSigning);
        
        string signature=EncodingUtil.convertToHex(blobSignature );
        string headersInSignature='date;host;x-amz-content-sha256;x-amz-date';
        return (algorithm + ' Credential=' + awsKey + '/' + dateStamp + '/' + regionName + '/' + service + '/aws4_request, SignedHeaders='+headersInSignature+', Signature=' + signature);
    }
    
 */   

    
    /*
@description => This method is use to create Auth header to upload data 
*/
    Private static string CreateAuthHeaderForPUT(String contentType,String filename, String formattedDateString,String longDate,string fileExtension,blob content,String dateStamp )
    {
        Blob  contentHash = Crypto.generateDigest('SHA-256', content);
        String hashedPaylod = EncodingUtil.convertToHex(contentHash);
        String canonicalRequest = methodName + '\n/' + filename.toLowerCase() + '.' + fileExtension.toLowerCase() +'\n\n'+'date:'+ longDate + '\n' +'host:'+ bucketName+'.s3'+'.'+RegionName+'.amazonaws.com' + '\n' +'x-amz-content-sha256:'+hashedPaylod+'\n'+'x-amz-date:'+formattedDateString +'\n\n'+'date;host;x-amz-content-sha256;x-amz-date'+'\n'+hashedPaylod;
        
        Blob canonicalHash = Crypto.generateDigest('SHA-256', Blob.valueof(canonicalRequest));
        String canonicalHashString = EncodingUtil.convertToHex(canonicalHash);        
        String stringToSign = algorithm + '\n' + formattedDateString + '\n' + dateStamp + '/' + regionName + '/' + service + '/aws4_request\n' + canonicalHashString;
        
        String kSecret = 'AWS4' + awsSecret;
        Blob kDate = Crypto.generateMac('HmacSHA256', Blob.valueOf(dateStamp), Blob.valueOf(kSecret));
        Blob kRegion = Crypto.generateMac('HmacSHA256', Blob.valueOf(regionName), kDate);
        Blob kService = Crypto.generateMac('HmacSHA256', Blob.valueOf(service), kRegion);
        Blob kSigning = Crypto.generateMac('HmacSHA256', Blob.valueOf('aws4_request'), kService);
        Blob blobSignature  = Crypto.generateMac('HmacSHA256', Blob.valueOf(stringToSign), kSigning);
        
        string signature=EncodingUtil.convertToHex(blobSignature );
        string headersInSignature='date;host;x-amz-content-sha256;x-amz-date';                     
        
        return (algorithm + ' Credential=' + awsKey + '/' + dateStamp + '/' + regionName + '/' + service + '/aws4_request, SignedHeaders='+headersInSignature+', Signature=' + signature);
    }
    

    /*
@description => This method is use to upload files to s3 account
*/
    public static String filePUT(String fileName, string accessKey, String secretKey,String awsRegion, String bucket,blob zipData) {
      
        String remoteSiteSettingName = 'upload File';
        awsKey = accessKey;
        awsSecret = secretKey;
        regionName = awsRegion;
        bucketName = bucket;
        methodName = 'PUT';
        
        String messageToReturn;
        try
        {
            
            String attachmentBody = EncodingUtil.base64Encode(zipData);
            String longDate = Datetime.now().formatGMT('E, dd MMM yyyy HH:mm:ss z');  
            String formattedDateString = Datetime.now().formatGMT('yyyyMMdd\'T\'HHmmss\'Z\'');
            String dateStamp = Datetime.now().formatGMT('yyyyMMdd');
     
            string fileUrl='https://' + bucketName + '.' + hostName + '/' + filename.toLowerCase()+ '.'+'jpeg';
       
         //   MetadataCreation.createRemoteSiteSetting(remoteSiteSettingName,fileUrl);
          
            HttpRequest req = new HttpRequest();
            req.setMethod(methodName);
            req.setEndpoint(fileurl);
           
            
            req.setHeader('host', bucketName+'.s3'+'.'+regionName+'.amazonaws.com');
            req.setHeader('Content-Length', String.valueOf(attachmentBody.length()));                
            req.setHeader('Content-Encoding', 'UTF-8');
            req.setHeader('Content-type', 'image/jpeg');
            req.setHeader('Connection', 'keep-alive');
            req.setHeader('date', longDate);
            req.setHeader('x-amz-date', formattedDateString);
            
            Blob pdfBlob = EncodingUtil.base64Decode(attachmentBody);
            req.setBodyAsBlob(pdfBlob); 
            
            String contentHash = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', pdfBlob));
            req.setHeader('x-amz-content-sha256',contentHash);
            req.setHeader('Authorization',CreateAuthHeaderForPUT('image/jpeg', filename, formattedDateString,longDate,'jpeg',pdfBlob,dateStamp));
         
            Http http = new Http();      
            HTTPResponse res = http.send(req);
            system.debug('res'+res);
            system.debug('response body'+res.getBody());
            if (res.getStatusCode() == 200 || res.getStatusCode()==201) 
            {
                messageToReturn = 'success';
            }
            else{
                messageToReturn = 'Error With Code '+res.getStatusCode();
            }
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage()+' at '+ex.getLineNumber());
            messageToReturn = 'Exception in Code : '+ex.getMessage()+' at '+ex.getLineNumber();
        }
  
      //   MetadataCreation.deleteRemoteSiteSetting(remoteSiteSettingName); 
        return messageToReturn;
    }
 	}