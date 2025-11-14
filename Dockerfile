FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# copy maven files and build WAR
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM tomcat:9.0.85-jdk17-temurin
WORKDIR /usr/local/tomcat

# Render cung cấp biến PORT động; để an toàn, vẫn đặt mặc định 8080
ENV PORT=8080
EXPOSE 8080

# clear default webapps and copy built WAR as ROOT
RUN rm -rf webapps/*
COPY --from=build /app/target/*.war webapps/ROOT.war

# add entrypoint script that will patch server.xml to use $PORT
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]