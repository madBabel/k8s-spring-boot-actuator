 FROM eclipse-temurin:11-jdk
   COPY target/nuclear-control-panel-1.0.0.jar app.jar
   ENTRYPOINT ["java","-jar","/app.jar"]