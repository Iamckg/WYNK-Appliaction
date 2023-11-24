@isTest
public class OTPGeneratorTest {

    @isTest
    static void testGenerateOTP() {
        // Call the generateOTP method and get the result
        String generatedOTP = OTPGenerator.generateOTP();

        // Verify that the generated OTP is a 4-digit number
        System.assert(generatedOTP.length() == 4, 'Generated OTP should be 4 digits');
        System.assert(Integer.valueOf(generatedOTP) >= 1000 && Integer.valueOf(generatedOTP) <= 9999, 'Generated OTP should be in the range of 1000 to 9999');
        
        // Add additional assertions as needed
    }
}