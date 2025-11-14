# ===============================
# GIAI ĐOẠN 1: BUILD (Maven)
# ===============================
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy Maven files
COPY pom.xml .
COPY src ./src

# Build WAR
RUN mvn clean package -DskipTests


# ===============================
# GIAI ĐOẠN 2: RUN (Tomcat)
# ===============================
FROM tomcat:9.0.85-jdk17-temurin
WORKDIR /usr/local/tomcat

# Render uses PORT env
ENV PORT 8080
EXPOSE 8080

# Xóa webapps mặc định
RUN rm -rf webapps/*

# Copy WAR build sang Tomcat và đặt làm ROOT.war
COPY --from=build /app/target/SweetimalPetCare-1.0-SNAPSHOT.war webapps/ROOT.war

# Start Tomcat
CMD ["catalina.sh", "run"]
