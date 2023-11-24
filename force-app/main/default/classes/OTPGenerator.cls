public class OTPGenerator {
    public static String generateOTP() {
        // Generate a random 4-digit OTP
        Integer otpValue = (Integer)Math.floor(Math.random() * 9000) + 1000;
        return String.valueOf(otpValue);
    }
}