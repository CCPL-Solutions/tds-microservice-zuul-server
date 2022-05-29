FROM openjdk:11
VOLUME [ "/tmp" ]
EXPOSE 8090
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} zuul-server.jar
ENTRYPOINT [ "java", "-jar", "/zuul-server.jar" ]