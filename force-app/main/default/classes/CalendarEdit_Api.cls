@RestResource(urlmapping='/CalendarEdit/*')
global class CalendarEdit_Api {
    @HttpPost
    global static void createCalendar(String CalendarId, String StartDate, String MovingDate, String Location, Boolean isTentative, String Type) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            Date StartDate1 = Date.valueOf(StartDate);
            Date MovingDate1 = Date.valueOf(MovingDate);
            
            // Correct the typo in your SOQL query
            Calendar__c record = [SELECT Id, Name, Start_Date__c, Type__c, Moving_Date__c, Location__c, Customer__c, isTentative__c FROM Calendar__c WHERE Id = :CalendarId LIMIT 1];
           
            if (record != null) {
                record.Start_Date__c = StartDate1;
                record.Type__c = Type;
                record.Moving_Date__c = MovingDate1;
                record.Location__c = Location;
                record.isTentative__c = isTentative;

                update record;
            
                response.put('Type', record.Type__c);
                response.put('UserId', record.Id);
                response.put('IsTentative', record.isTentative__c);
                response.put('UserId', record.Customer__c);
                response.put('MovingDate', record.Moving_Date__c);
                response.put('StartDate', record.Start_Date__c);
                response.put('Location', record.Location__c);
 
                response.put('message', 'Your data is successfully saved');
                response.put('Status', 'Success');
            } else {
                response.put('Status', 'Failed');
                response.put('message', 'Record with the specified CalendarId not found.');
            }
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