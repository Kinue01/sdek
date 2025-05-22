FROM maven as build
COPY . /code
WORKDIR /code
RUN mvn clean package

FROM eclipse-temurin:21-jre
COPY --from=build /code/target/*.jar app.jar
ENTRYPOINT [ "java", "-jar", "/app.jar" ]