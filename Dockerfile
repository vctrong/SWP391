# Giai đoạn 1: BUILD (Sử dụng image Maven để build dự án)
# Dùng Maven với Java 17 (do bạn dùng Jakarta EE 10.0.0, nên dùng Java 17 trở lên là tốt nhất, 
# mặc dù pom.xml ghi target 1.8, ta sẽ dùng 17 để tương thích thư viện mới hơn).
FROM maven:3.9.5-amazoncorretto-17-alpine AS build
WORKDIR /app

# Sao chép file pom.xml và các file khác cần thiết cho quá trình build
COPY pom.xml .
COPY src ./src

# Chạy lệnh build Maven để tạo ra file .war
# Lệnh 'package' sẽ tạo ra file WAR trong thư mục target/
RUN mvn clean package -DskipTests

# Tên file WAR sẽ là: SweetimalPetCare-1.0-SNAPSHOT.war 
# (Lấy từ <artifactId>-<version>.war trong pom.xml)

# ----------------------------------------------------------------------------------

# Giai đoạn 2: RUN (Chạy ứng dụng bằng Tomcat)
# Sử dụng image Apache Tomcat nhẹ nhàng. Dùng Java 17 JRE.
FROM tomcat:9.0-jre17-temurin-alpine

# Thiết lập biến môi trường để Tomcat biết cổng nào nên nghe
ENV PORT 8080 
EXPOSE 8080

# Xóa ứng dụng mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Sao chép file WAR đã build từ Giai đoạn 1 vào thư mục ROOT của Tomcat
# Điều này giúp ứng dụng của bạn chạy ở URL gốc (ví dụ: https://<domain-cua-ban> / )
COPY --from=build /app/target/SweetimalPetCare-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Lệnh khởi chạy Tomcat
# CMD ["catalina.sh", "run"] # Lệnh mặc định của tomcat image thường là thế này, bạn có thể bỏ qua nếu muốn dùng lệnh mặc định.