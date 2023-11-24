@RestResource(urlMapping='/LabelList/*')
global class LabelList_Api {
    @HttpPost
    global static void getLabelList(String UserId) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            // Query all Label__c records
            List<Label__c> labelRecords = [SELECT Id, Name, Customer__c FROM Label__c WHERE Customer__c = :UserId];

            // Create a list to store label data
            List<Map<String, Object>> labels = new List<Map<String, Object>>();

            // Iterate through label records and add them to the list
            for (Label__c labelRecord : labelRecords) {
                // Query the total count of Friend records for the current label
                Integer friendCount = [SELECT COUNT() FROM Friend__c WHERE Label__c = :labelRecord.Id AND Customer__c = :UserId];

                Map<String, Object> labelData = new Map<String, Object>();
                labelData.put('FriendCount', friendCount); // Include the friend count in the response
                labelData.put('Name', labelRecord.Name);
                labelData.put('AccountId', labelRecord.Id);
                labels.add(labelData);
            }

            // Add the list of labels to the response
            response.put('LabelList', labels);
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