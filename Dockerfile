# Giai đoạn 1: BUILD (Sử dụng Maven để build dự án thành file .war)
# Đã sửa lỗi: Dùng image Maven/JDK 17 phổ biến và ổn định hơn.
FROM maven:3.9.5-jdk-17-slim AS build 
WORKDIR /app

# Sao chép file pom.xml và mã nguồn vào container build
COPY pom.xml .
COPY src ./src

# Lệnh build Maven, tạo ra file WAR trong thư mục target/
# Tên file WAR sẽ là: SweetimalPetCare-1.0-SNAPSHOT.war
RUN mvn clean package -DskipTests

# ----------------------------------------------------------------------------------

# Giai đoạn 2: RUN (Chạy ứng dụng bằng Apache Tomcat)
# Sử dụng image Tomcat 9 với Java 17 JRE.
FROM tomcat:9.0-jdk17-temurin-alpine 
WORKDIR /usr/local/tomcat

# Thiết lập cổng nghe (Phải khớp với cổng 8080 bạn đặt trên Render)
ENV PORT 8080 
EXPOSE 8080

# Xóa ứng dụng mặc định của Tomcat
RUN rm -rf webapps/*

# Sao chép file WAR đã build từ Giai đoạn 1 vào thư mục ROOT của Tomcat
# Điều này giúp ứng dụng của bạn chạy ở URL gốc (ví dụ: https://<domain-cua-ban> /)
COPY --from=build /app/target/SweetimalPetCare-1.0-SNAPSHOT.war webapps/ROOT.war

# Lệnh khởi chạy Tomcat. (Sử dụng lệnh mặc định của image)
CMD ["catalina.sh", "run"]
