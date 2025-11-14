# ===============================
# BUILD STAGE
# ===============================
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy đúng đường dẫn đến pom.xml và src trong thư mục SweetimalPetCare
COPY SweetimalPetCare/pom.xml .
COPY SweetimalPetCare/src ./src

# Build WAR file
RUN mvn clean package -DskipTests

# ===============================
# RUN STAGE
# ===============================
FROM tomcat:9.0.85-jdk17-temurin
WORKDIR /usr/local/tomcat

ENV PORT=8080
EXPOSE 8080

# Clear default apps
RUN rm -rf webapps/*

# Copy WAR file đã build
COPY --from=build /app/target/*.war webapps/ROOT.war

CMD ["catalina.sh", "run"]
