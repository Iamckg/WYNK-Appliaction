trigger CustomerOtpTrigger on Customer__c (before insert, after insert) {
    if(Trigger.isBefore){
        for(Customer__c customer : Trigger.new) {
        // Generate a 4-digit OTP using the static method
        String otp = OTPGenerator.generateOTP();
        // Assign the OTP to the OTP__c field
        customer.OTP__c = otp;
    }
    }
    if(Trigger.isAfter){
      for(Customer__c customer : Trigger.new) {
       WhatsAppIntegration.sendWhatsAppMessage(customer.Phone__c, customer.OTP__c);
      }  
    }

}