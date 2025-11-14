FROM maven:3.9.11-eclipse-temurin-17 AS build
WORKDIR /build

# Copy the project directory (project's pom is inside SweetimalPetCare)
COPY SweetimalPetCare ./SweetimalPetCare

# Build WAR (skip tests)
RUN mvn -f SweetimalPetCare/pom.xml -DskipTests clean package

FROM tomcat:10.1-jdk17-temurin
WORKDIR /usr/local/tomcat

ENV PORT=8080
EXPOSE 8080

# Remove default webapps and copy built WAR as ROOT
RUN rm -rf webapps/*
COPY --from=build /build/SweetimalPetCare/target/*.war webapps/ROOT.war

# Copy and enable entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]