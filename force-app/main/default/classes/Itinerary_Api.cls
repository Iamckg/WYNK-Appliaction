@RestResource(urlmapping='/Itinerary/*')
Global class Itinerary_Api {
    @HttpPost
    global static void createCalendar(String UserId, String StartDate, String MovingDate, String Location, Boolean isTentative, String Type) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            Date StartDate1 = Date.valueOf(StartDate);
            Date MovingDate1 = Date.valueOf(MovingDate);

                Calendar__c cal = new Calendar__c();
                cal.Start_Date__c = StartDate1;
                cal.Type__c = Type;
                cal.Moving_Date__c = MovingDate1;
                cal.Location__c = Location;
                cal.isTentative__c = isTentative;
                cal.Customer__c = UserId;
                insert cal;
            
                response.put('Type', cal.Type__c);
                response.put('UserId',cal.Customer__c);
                response.put('MovingDate', cal.Moving_Date__c);
                response.put('StartDate', cal.Start_Date__c);
                response.put('Location', cal.Location__c);
             //   response.put('CalenderId', cal.Id);
                response.put('message', 'Your Data is Successfully Saved');
                response.put('Status', 'Success');

        } catch (Exception ex) {
            response.put('Status', 'Failed');
            response.put('message', ex.getMessage());
        }

        String jsonResponse = JSON.serialize(response);

        // Return the JSON response
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(jsonResponse);
    }
}