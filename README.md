# Spring Boot Actuator Example (Java 11)

Este es un ejemplo mínimo de aplicación **Spring Boot** con **Actuator** habilitado, listo para integrarse con **Kubernetes** usando probes de *liveness* y *readiness*.  
Compatible con **Java 11** gracias a Spring Boot **2.7.x**.

## 📦 Requisitos

- Java 11
- Maven 3.6+
- Docker (opcional, para contenedores)
- Kubernetes (opcional, para probar probes)

## 🚀 Ejecutar la aplicación

```bash
mvn spring-boot:run
```

La aplicación se levantará en [http://localhost:8080](http://localhost:8080).

## 🔍 Endpoints disponibles

Gracias a **Spring Boot Actuator**, se exponen:

- `http://localhost:8080/actuator/health` → estado global
- `http://localhost:8080/actuator/health/liveness` → liveness probe
- `http://localhost:8080/actuator/health/readiness` → readiness probe
- `http://localhost:8080/actuator/info` → información de la app (se puede enriquecer con metadatos en `application.yml`)

## ⚙️ Configuración relevante (`application.yml`)

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health, info
  endpoint:
    health:
      probes:
        enabled: true
  health:
    livenessState:
      enabled: true
    readinessState:
      enabled: true
```

## 🐳 Ejecutar en Docker

1. Crear JAR:
   ```bash
   mvn clean package -DskipTests
   ```

2. Crear `Dockerfile` (ejemplo):
   ```dockerfile
   FROM eclipse-temurin:11-jdk
   COPY target/sp-boot-for-k8s-1.0.0.jar app.jar
   ENTRYPOINT ["java","-jar","/app.jar"]
   ```

3. Construir y ejecutar:
   ```bash
   docker build -t sp-boot-for-k8s-1.0:1.0 .
   docker run -d -p 8080:8080 --name app1 sp-boot-for-k8s-1.0:1.0 
   ```

## ☸️ Uso en Kubernetes

Ejemplo de configuración de probes en un Deployment:

```yaml
livenessProbe:
  httpGet:
    path: /actuator/health/liveness
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /actuator/health/readiness
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 5
```
