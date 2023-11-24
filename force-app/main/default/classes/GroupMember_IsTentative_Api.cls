@RestResource(urlMapping='/GroupMemberIsTentative/*')
global class GroupMember_IsTentative_Api {
    @HttpPost
    global static void MarkAsTentative(String GroupId, String MemberId) {
        Map<String, Object> response = new Map<String, Object>();

        try {
            Group_Member__c memberToUpdate = [SELECT Id, Name, MemberId__c, IsJoined__c,Attend__c, isTentative__c, Pending__c, Declined__c, Group__c, Group__r.Name, Group__r.Customer__c
                FROM Group_Member__c WHERE MemberId__c = :MemberId AND Group__c = :GroupId];

            if (memberToUpdate != null) {
                memberToUpdate.isTentative__c = true;
                memberToUpdate.Attend__c = false;
                Update memberToUpdate;

                response.put('message', 'You have marked as tentative successfully.');
                response.put('Status', 'Success');
            } else {
                response.put('message', 'Group Member record not found.');
                response.put('Status', 'Failed');
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