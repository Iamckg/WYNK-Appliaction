({
    doInit: function(component, event, helper) {
        helper.getUserCount(component);
        helper.getBannerCount(component);
        helper.getEmailCount(component);
        helper.getNotificationCount(component);
    }
})