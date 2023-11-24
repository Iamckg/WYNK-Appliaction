({
    getUserCount: function(component) {
        var action = component.get("c.getUserCount");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.userCount", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    getBannerCount: function(component) {
        var action = component.get("c.getBannerCount");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.bannerCount", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    getEmailCount: function(component) {
        var action = component.get("c.getEmailCount");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.emailCount", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    getNotificationCount: function(component) {
        var action = component.get("c.getNotificationCount");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.notificationCount", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})