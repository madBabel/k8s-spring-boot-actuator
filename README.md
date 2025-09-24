# ⚛️ Nuclear Control Panel (Spring Boot Actuator Example, Java 11)

Este es un ejemplo mínimo de aplicación **Spring Boot** con **Actuator** habilitado, listo para integrarse con **Kubernetes** usando probes de *liveness* y *readiness*.  
Además incluye un **simulador de reactor nuclear** con endpoints REST para integrarlo en un cuadro de mando.  
Compatible con **Java 11** gracias a Spring Boot **2.7.x**.

---

## 📦 Requisitos

- Java 11
- Maven 3.6+
- Docker (opcional, para contenedores)
- Kubernetes (opcional, para probar probes)

---

## 🚀 Ejecutar la aplicación

```bash
mvn spring-boot:run
```

La aplicación se levantará en [http://localhost:8080](http://localhost:8080).

---

## 🔍 Endpoints disponibles

### Endpoints Actuator

- `http://localhost:8080/actuator/health` → estado global
- `http://localhost:8080/actuator/health/liveness` → liveness probe
- `http://localhost:8080/actuator/health/readiness` → readiness probe
- `http://localhost:8080/actuator/info` → información de la app (puede enriquecerse con metadatos en `application.yml`)

### Endpoints Reactor

- `GET /reactor`  
  Devuelve un JSON con la información básica del reactor:
  ```json
  {
    "reactor": "Springfield-Reactor",
    "port": "8080"
  }
  ```

- `POST /reactor/crash`  
  Simula una **falla catastrófica**.  
  Responde inmediatamente:
  ```text
  OK: se romperá el reactor en 2 segundos
  ```
  y tras 2 segundos finaliza el proceso (`System.exit(1)`), provocando que Docker/Kubernetes reinicie el contenedor.

---

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

---

## 🐳 Ejecutar en Docker

1. Crear JAR:
   ```bash
   mvn clean package -DskipTests
   ```

2. Crear `Dockerfile` (ejemplo):
   ```dockerfile
   FROM eclipse-temurin:11-jdk
   COPY target/nuclear-control-panel-1.0.0.jar app.jar
   ENTRYPOINT ["java","-jar","/app.jar"]
   ```

3. Construir y ejecutar:
   ```bash
   docker build -t nuclear-control-panel:1.0 .
   docker run -d -p 8080:8080 --name app1 nuclear-control-panel:1.0 
   ```

---

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

## 📘 Ejercicios de Kubernetes

Puedes practicar con ejemplos de **ReplicaSets, Deployments y Services** en Kubernetes siguiendo estos ejercicios: 
Consideraciones::

   - Es necesario ejecutar minikube start para arrancar el cluster
   - Kubernetes, por defecto, intenta buscar esa imagen en un registry público (Docker Hub). si no existe ahi, falla al hacer pull. Habría que hacer un push antes ;)

   

👉 [ReplicaSet](./exercises/01-ReplicaSet.md)
👉 [Deployment](./exercises/02-Deployment.md)
👉 [Service](./exercises/03-Service.md)
