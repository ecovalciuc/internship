###___Build Stage___###
FROM maven:3.8.1-jdk-8 AS build_app

COPY src /usr/src/app/src
COPY pom.xml /usr/src/app

LABEL project="ecovalciuc-petclinic"
ARG LOGIN_TOKEN

# shows env variable
RUN "printenv"

RUN mvn -f /usr/src/app/pom.xml clean package

###___SonarQube Scanning___###
WORKDIR /usr/src/app
RUN mvn sonar:sonar \
    -Dsonar.projectKey=java_maven_project \
    -Dsonar.projectName=ecovalciuc-Pet_Clinic \
    -Dsonar.host.url=https://sonar.trydevops.com \
    -Dsonar.login=${LOGIN_TOKEN}

###___Package___###
FROM openjdk:8
COPY --from=build_app /usr/src/app/target/*.jar /usr/local/lib/pet_test.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/local/lib/pet_test.jar"]
