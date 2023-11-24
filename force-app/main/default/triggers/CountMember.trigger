trigger CountMember on Group_Member__c (after insert, after update, after delete, after undelete) {
 // Create a set to store unique Groupc record IDs that need to be updated
    Set<Id> groupIdsToUpdate = new Set<Id>();

    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUnDelete) {
        for (Group_Member__c member : Trigger.new) {
            groupIdsToUpdate.add(member.Group__c);
        }
    }

    if (Trigger.isDelete) {
        for (Group_Member__c member : Trigger.old) {
            groupIdsToUpdate.add(member.Group__c);
        }
    }

    // Query and update the Groupc records
    List<Group__c> groupsToUpdate = [SELECT Id FROM Group__c WHERE Id IN :groupIdsToUpdate];

    for (Group__c gp : groupsToUpdate) {
        gp.Total_Members__c = String.valueOf([SELECT COUNT() FROM Group_Member__c WHERE Group__c = :gp.Id]);
    }

    // Update the Group__c records with the calculated total
    update groupsToUpdate;
}