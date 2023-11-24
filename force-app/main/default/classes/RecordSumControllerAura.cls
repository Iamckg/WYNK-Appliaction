public with sharing class RecordSumControllerAura {
    @AuraEnabled
    public static Integer getUserCount() {
        return [SELECT COUNT() FROM Customer__c Where IsProfile__c = true AND IsDeleted__c= false];
    }

    @AuraEnabled
    public static Integer getBannerCount() {
        return [SELECT COUNT() FROM Banner__c];
    }

    @AuraEnabled
    public static Integer getEmailCount() {
        return [SELECT COUNT() FROM Email_Template__c];
    }

    @AuraEnabled
    public static Integer getNotificationCount() {
        return [SELECT COUNT() FROM Notification__c];
    }
}