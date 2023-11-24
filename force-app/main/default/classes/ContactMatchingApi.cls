@RestResource(urlMapping='/ContactMatching/*')
global with sharing class ContactMatchingApi {

    @HttpPost
    global static void matchContacts(List<ContactData> ConactList) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            // Extract phone numbers from the request
            List<String> phoneNumbers = new List<String>();
            for (ContactData contact : ConactList) {
                phoneNumbers.add(contact.phoneNumber);
            }

            // Query records based on the extracted phone numbers
            List<Customer__c> matchedRecords = [SELECT Id, Name, Last_Name__c, Phone__c FROM Customer__c WHERE Phone__c IN :phoneNumbers AND IsDeleted__c=False];

            // Create a map to store phone numbers and their corresponding Customer__c Ids
            Map<String, Id> phoneNumberToIdMap = new Map<String, Id>();
            for (Customer__c record : matchedRecords) {
                phoneNumberToIdMap.put(record.Phone__c, record.Id);
            }

            // Create lists to store matched and unmatched contact data
            List<ContactDataWithId> matchedContacts = new List<ContactDataWithId>();
            List<ContactData> unmatchedContacts = new List<ContactData>();

            // Iterate through the request contacts and categorize them
            for (ContactData contact : ConactList) {
                if (phoneNumberToIdMap.containsKey(contact.phoneNumber)) {
                    Id UserId = phoneNumberToIdMap.get(contact.phoneNumber);
                    matchedContacts.add(new ContactDataWithId(contact.name, contact.phoneNumber, UserId));
                } else {
                    unmatchedContacts.add(contact);
                }
            }

            response.put('MatchedContacts', matchedContacts);
            response.put('UnmatchedContacts', unmatchedContacts);
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

    global class ContactData {
        public String name;
        public String phoneNumber;
    }

    global class ContactDataWithId {
        public String name;
        public String phoneNumber;
        public Id customerId;

        public ContactDataWithId(String name, String phoneNumber, Id customerId) {
            this.name = name;
            this.phoneNumber = phoneNumber;
            this.customerId = customerId;
        }
    }
}