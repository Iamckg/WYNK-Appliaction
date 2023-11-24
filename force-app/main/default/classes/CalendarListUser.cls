@RestResource(urlMapping='/CalendarUsersList/*')
global class CalendarListUser {
    @HttpGet
    global static void getCalendarList() {
        Map<String, Object> response = new Map<String, Object>();
       
        try {
            // Create a list to store calendar data
            List<Map<String, Object>> calendarList = new List<Map<String, Object>>();

            // Query Calendar__c records
            List<Calendar__c> calendars = [SELECT Id, Start_Date__c, SaveDate__c, Title__c, Customer__r.Id, Moving_Date__c FROM Calendar__c];

            for (Calendar__c cal : calendars) {
                Map<String, Object> calendarData = new Map<String, Object>();
                calendarData.put('MovingDate', cal.Moving_Date__c);
                calendarData.put('Title', cal.Title__c);
                calendarData.put('SaveDate', cal.SaveDate__c);
                calendarData.put('StartDate', cal.Start_Date__c);
                calendarData.put('calendarId', cal.Id);
                calendarData.put('UserId', cal.Customer__r.Id);

                // Query Friend__c records for the customer
                List<Friend__c> friendList = [SELECT Id, Name ,ImageUrl__c,CountyFlag__c FROM Friend__c WHERE Customer__c = :cal.Customer__r.Id];

                // Create a list to store customer data
                List<Map<String, Object>> customerList = new List<Map<String, Object>>();

                for (Friend__c friend : friendList) {
                    // Query Customer__c records for the friend
                    List<Customer__c> customers = [SELECT Id, Name, Last_Name__c,ImageUrl__c,CountyFlag__c, Label__r.Name FROM Customer__c  WHERE Id = :friend.Name];
                    for (Customer__c customer : customers) {
                        Map<String, Object> customerData = new Map<String, Object>();
                        customerData.put('Label', customer.Label__r.Name);
                        customerData.put('LastName', customer.Last_Name__c);
                        customerData.put('ImageUrl', customer.ImageUrl__c);
                        customerData.put('CountyFlag', customer.CountyFlag__c);
                        customerData.put('FirstName', customer.Name);
                        customerData.put('AccountId', customer.Id);
                        customerList.add(customerData);
                    }

                } 
                calendarData.put('Friends', customerList);
                calendarList.add(calendarData);
            }
            response.put('CalendarList', calendarList);
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