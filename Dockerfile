FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /build

# copy the project folder that contains pom.xml and source
COPY SweetimalPetCare /build

# build the WAR
RUN mvn -f /build/pom.xml clean package -DskipTests

FROM tomcat:10.1-jdk17-temurin
WORKDIR /usr/local/tomcat

# Render provides dynamic PORT; default to 8080
ENV PORT=8080
EXPOSE 8080

# clear default webapps and copy built WAR as ROOT
RUN rm -rf webapps/*
COPY --from=build /build/target/*.war webapps/ROOT.war

# add entrypoint script that will patch server.xml to use $PORT
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]
