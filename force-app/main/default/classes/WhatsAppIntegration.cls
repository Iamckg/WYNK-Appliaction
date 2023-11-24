public class WhatsAppIntegration {
    @future(callout=true)
    public static void sendWhatsAppMessage(String phoneNumber, String otp) {
        String apiUrl = 'https://graph.facebook.com/v17.0/167173533149052/messages';
        String apiToken = 'EAAKQZCHxi78cBOZByXfAp2E3Szq2qrlaw2bDj0anI1CTRSqJHGZCpovwPOJylHEZAPR7ZB7GXe6gflZCeyDVGgW92k94evv32zM9pkd9LY8jZBYyzZBJugXNOVwho2GFdONyLfDGsBY6Iv9ihgMfX9kyjtJZAfiAjbk82DdJZAxBDPPZCIiu3bj5ZAZB5SRcXfKJnOHI4';

        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiUrl);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + apiToken);

        // Set the request body using JSON.serialize
        Map<String, Object> requestBodyMap = new Map<String, Object>{
            'messaging_product' => 'whatsapp',
            'recipient_type' => 'individual',
            'to' => phoneNumber,
            'type' => 'template',
            'template' => new Map<String, Object>{
                'name' => 'wynk_welcome',
                'language' => new Map<String, Object>{
                    'code' => 'en_US'
                },
                'components' => new List<Map<String, Object>>{
                    new Map<String, Object>{
                        'type' => 'body',
                        'parameters' => new List<Map<String, Object>>{
                            new Map<String, Object>{
                                'type' => 'text',
                                'text' => otp
                            }
                        }
                    }
                }
            }
        };

        request.setBody(JSON.serialize(requestBodyMap));

        // Send the request
        Http http = new Http();
        HttpResponse response = http.send(request);

        // Check the response
        if (response.getStatusCode() == 200) {
            System.debug('Message sent successfully');
        } else {
            System.debug('Failed to send message. Status code: ' + response.getStatusCode() + ', Response: ' + response.getBody());
        }
    }
}