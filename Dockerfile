# Dockerfile (multi-stage): build bằng Maven (JDK17) rồi copy WAR vào Tomcat 10 runtime
FROM maven:3.9.11-eclipse-temurin-17 AS build
WORKDIR /build
COPY .mvn .mvn
COPY pom.xml .
# copy source
COPY SweetimalPetCare ./SweetimalPetCare
# build WAR (skip tests)
RUN mvn -f SweetimalPetCare/pom.xml -DskipTests clean package

FROM tomcat:10.1-jdk17-temurin
WORKDIR /usr/local/tomcat

ENV PORT=8080
EXPOSE 8080

# Clean default webapps and copy built WAR as ROOT
RUN rm -rf webapps/*
COPY --from=build /build/SweetimalPetCare/target/*.war webapps/ROOT.war

# Copy and enable entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]