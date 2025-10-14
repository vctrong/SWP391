package utils;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailUtility {

    // For demo: set your Gmail and App Password here or load from web.xml via context-param
    private static final String SMTP_HOST = firstNonEmpty(
            System.getProperty("MAIL_HOST"),
            System.getenv("MAIL_HOST"),
            "smtp.gmail.com"
    );
    private static final int SMTP_PORT = parseInt(firstNonEmpty(
            System.getProperty("MAIL_PORT"),
            System.getenv("MAIL_PORT"),
            "587"
    ), 587);
    private static final boolean SMTP_SSL = Boolean.parseBoolean(firstNonEmpty(
            System.getProperty("MAIL_SSL"),
            System.getenv("MAIL_SSL"),
            "false"
    ));
    private static final String SMTP_USERNAME = firstNonEmpty(
            System.getProperty("MAIL_USER"),
            System.getenv("MAIL_USER"),
            "yourgmail@gmail.com"
    );
    private static final String SMTP_PASSWORD = firstNonEmpty(
            System.getProperty("MAIL_PASS"),
            System.getenv("MAIL_PASS"),
            "your-app-password"
    );

    public static void sendEmail(String toEmail, String subject, String content) throws MessagingException {
        sendEmailWithAuth(toEmail, subject, content, SMTP_USERNAME, SMTP_PASSWORD);
    }

    public static void sendEmailWithAuth(String toEmail, String subject, String content, String username, String password) throws MessagingException {
        // Java 7 requires variables referenced in anonymous inner classes to be final
        final String _user = username;
        final String _pass = password;
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", String.valueOf(SMTP_PORT));
        props.put("mail.smtp.ssl.trust", SMTP_HOST);
        props.put("mail.smtp.user", _user);
        props.put("mail.smtp.password", _pass);
        props.put("mail.mime.charset", "UTF-8");
        props.put("mail.mime.allowutf8", "true");
        if (SMTP_SSL) {
            // SMTPS on 465
            props.put("mail.smtp.ssl.enable", "true");
            props.put("mail.smtp.starttls.enable", "false");
        } else {
            // STARTTLS on 587
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        }

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(_user, _pass);
            }
        });

        // session.setDebug(true); // uncomment for detailed SMTP logs
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(_user));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        // Encode subject with UTF-8 (MimeMessage handles RFC2047 encoding)
        message.setSubject(subject, "UTF-8");
        // Plain text with UTF-8 to preserve Vietnamese accents
        message.setText(content, "UTF-8");

        Transport.send(message);
    }

    private static String firstNonEmpty(String... values) {
        if (values == null) {
            return null;
        }
        for (String v : values) {
            if (v != null && !v.trim().isEmpty()) {
                return v;
            }
        }
        return null;
    }

    private static int parseInt(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }
}
