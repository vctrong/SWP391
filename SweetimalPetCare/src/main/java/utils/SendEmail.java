package utils;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class SendEmail {

    public static boolean sendOTP(String recipientEmail, String otpCode) {
        final String fromEmail = "duc554337@gmail.com";
        final String appPassword = "rims ptaa zerc tnel"; // App password

        
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

       
        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, appPassword);
            }
        });

        try {
           
            MimeMessage message = new MimeMessage(session);
            // Bảo đảm hiển thị tiếng Việt có dấu chuẩn UTF-8
            try {
                message.setFrom(new InternetAddress(fromEmail, "Sweetimal Pet Care", "UTF-8"));
            } catch (java.io.UnsupportedEncodingException ex) {
                message.setFrom(new InternetAddress(fromEmail));
            }
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Mã xác nhận OTP - Sweetimal Pet Care", "UTF-8");

            String body = "Xin chào,\n\n" +
                    "Mã OTP của bạn là: " + otpCode + "\n\n" +
                    "Vui lòng không chia sẻ mã này cho bất kỳ ai.\n\n" +
                    "Trân trọng,\nSweetimal Pet Care Team";
            message.setContent(body, "text/plain; charset=UTF-8");

           
            Transport.send(message);
            System.out.println(" OTP đã được gửi đến: " + recipientEmail);
            return true;

        } catch (Exception e) {
            System.out.println(" Gửi email thất bại!");
            e.printStackTrace();
            return false;
        }
    }
}
