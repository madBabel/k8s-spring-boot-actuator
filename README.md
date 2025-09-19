# k8s-spring-boot-actuator

# Spring Boot Actuator Example

Este es un ejemplo mínimo de aplicación **Spring Boot** con **Actuator** habilitado, listo para integrarse con **Kubernetes** usando probes de *liveness* y *readiness*.

## 📦 Requisitos

- Java 17+
- Maven 3.8+
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
   FROM eclipse-temurin:17-jdk
   COPY target/demo-0.0.1-SNAPSHOT.jar app.jar
   ENTRYPOINT ["java","-jar","/app.jar"]
   ```

3. Construir y ejecutar:
   ```bash
   docker build -t spring-boot-actuator-example .
   docker run -p 8080:8080 spring-boot-actuator-example
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

---

✅ Con este ejemplo puedes probar cómo Spring Boot Actuator facilita la integración con Kubernetes.
