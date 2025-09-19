FROM eclipse-temurin:11-jdk
COPY target/sp-boot-for-k8s-1.0.0.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]