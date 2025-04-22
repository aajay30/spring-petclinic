FROM openjdk:18
WORKDIR /app
COPY ./target/spring-petclinic-3.4.0-SNAPSHOT.jar /app
EXPOSE 8080
CMD ["java", "-jar", "spring-petclinic-3.4.0-SNAPSHOT.jar"]