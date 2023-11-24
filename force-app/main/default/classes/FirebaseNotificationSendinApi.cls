@RestResource(urlMapping='/pushnotification1/*')
global class FirebaseNotificationSendinApi {
    @HttpPost
    global static Void sendFCMNotifications(List<String> NotificationIds) {
        // Replace with your FCM server key
        String serverKey = 'AAAAPeLnvKY:APA91bFFcjgAqx1b-UpLP9D4EvfGhEtzYJzkfC5LoBD9wj9NcJD5l_csOxwsispbUMo1BgFhsktjfQxnEoyCiy1gKyVPXF-5ruAPRiuUU6QkLMup1-H0ajUyOwvnW8_nVH3JNzg5bAgh';
        String endpoint = 'https://fcm.googleapis.com/fcm/send';

        List<User_Notification__c> notifications = [SELECT Id, Name, Message__c, Customer__c, Customer__r.Device_Token__c FROM User_Notification__c WHERE Id IN :NotificationIds];

        Map<String, Object> responses = new Map<String, Object>();

        for (User_Notification__c nt : notifications) {
            String deviceToken = nt.Customer__r.Device_Token__c;
            String message = nt.Message__c;
            String title = nt.Name;

            // Create the request
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization', 'Key=' + serverKey);

            // Set the body as a JSON object
            String notificationPayload = '{"to":"' + deviceToken + '", "notification":{"body":"' + message + '", "title":"' + title + '"} }';
            request.setBody(notificationPayload);

            try {
                // Send the request
                HttpResponse response = http.send(request);

                // Check the response status code
                Integer statusCode = response.getStatusCode();
                String responseBody = response.getBody();

                if (statusCode == 200) {
                    responses.put('Message', 'Notifications has sent to  User Successfully');
                    responses.put('Status', 'Success');
                } else {
                    responses.put('Status', 'Failed');
                    responses.put('Message', 'FCM notification failed. Status Code: ' + statusCode + '. Response: ' + responseBody);
                }
            } catch (Exception ex) {
                responses.put('Status', 'Failed');
                responses.put('Message', ex.getMessage());
            }
        }

        String jsonResponse = JSON.serialize(responses);

        // Return the JSON response
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonResponse);
    }
}