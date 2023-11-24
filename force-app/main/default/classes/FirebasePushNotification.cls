@RestResource(urlMapping='/pushnotification/*')
global with sharing class FirebasePushNotification {
    
    @HttpPost
    global static String SendFCMNotification(String deviceToken,String msg,String title) {
      
        // Replace with your FCM server key
        String serverKey = 'AAAAPeLnvKY:APA91bFFcjgAqx1b-UpLP9D4EvfGhEtzYJzkfC5LoBD9wj9NcJD5l_csOxwsispbUMo1BgFhsktjfQxnEoyCiy1gKyVPXF-5ruAPRiuUU6QkLMup1-H0ajUyOwvnW8_nVH3JNzg5bAgh';

        // Set the FCM endpoint
        String endpoint = 'https://fcm.googleapis.com/fcm/send';

        // Create the request
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Key=' + serverKey);

        // Set the body as a JSON object
        String notificationPayload = '{"to":"' + deviceToken + '", "notification":{"body":"' + msg + '", "title":"' + title + '"} }';
        request.setBody(notificationPayload);

        // Send the request
        HttpResponse response = http.send(request);

        // Check the response status code
        Integer statusCode = response.getStatusCode();
        String responseBody = response.getBody();

        if (statusCode == 200) {
            // Notification sent successfully
            return 'FCM notification sent successfully. Response: ' + responseBody;
        } else {
            // Handle errors
            String errorMessage = 'FCM notification failed. Status Code: ' + statusCode + '. Response: ' + responseBody;
            System.debug(errorMessage);
            return errorMessage;
        }
    }
}