FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /build

# Copy only the project subfolder that contains pom.xml and source
COPY SweetimalPetCare/pom.xml /build/pom.xml
COPY SweetimalPetCare/src /build/src

# Build WAR using the pom in the subfolder
RUN mvn -f /build/pom.xml clean package -DskipTests

FROM tomcat:9.0.85-jdk17-temurin
WORKDIR /usr/local/tomcat

ENV PORT=8080
EXPOSE 8080

# Clear default webapps and copy built WAR as ROOT
RUN rm -rf webapps/*
COPY --from=build /build/target/*.war webapps/ROOT.war

# Entrypoint patches server.xml to use $PORT (keeps your docker-entrypoint.sh)
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]
