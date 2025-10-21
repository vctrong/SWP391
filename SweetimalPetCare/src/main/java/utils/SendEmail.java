package Utils;

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
           
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, "Sweetimal Pet Care"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Mã xác nhận OTP - Sweetimal Pet Care");

         
            message.setHeader("Content-Type", "text/plain; charset=UTF-8");
            message.setText(
                "Xin chào,\n\nMã OTP của bạn là: " + otpCode +
                "\n\nVui lòng không chia sẻ mã này cho bất kỳ ai.\n\nTrân trọng,\nSweetimal Pet Care Team"
            );

           
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
