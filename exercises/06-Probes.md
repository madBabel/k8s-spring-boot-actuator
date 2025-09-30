# 🚦 Ejercicio: Liveness, Readiness & Startup Probes en Kubernetes

En este ejercicio aprenderás a configurar **liveness**, **readiness** y **startup probes** en un Pod de **Spring Boot** con Actuator habilitado.  
Además, usaremos un **traffic generator** para observar cómo Kubernetes maneja el enrutamiento durante fallos o demoras en el arranque.

---

## 1️⃣ Requisitos previos

- Aplicación Spring Boot con Actuator habilitado y los endpoints:
  - `/actuator/health/liveness`
  - `/actuator/health/readiness`
- Imagen construida: `nuclear-control-panel:1.0`
- Traffic generator (ejemplo: `busybox` con `wget` en un loop)

---

## 2️⃣ Deployment con probes

Archivo: **`deployment-probes.yaml`**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: reactor-probes
spec:
  replicas: 1
  selector:
    matchLabels:
      app: reactor
  template:
    metadata:
      labels:
        app: reactor
    spec:
      containers:
        - name: reactor
          image: nuclear-control-panel:1.0
          ports:
            - containerPort: 8080
          env:
            - name: REACTOR_NAME
              value: "8080"
            - name: REACTOR_NAME 
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name  
          livenessProbe:
            httpGet:
              path: /actuator/health/liveness
              port: 8080
            initialDelaySeconds: 20
            periodSeconds: 10
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /actuator/health/readiness
              port: 8080
            initialDelaySeconds: 10
            periodSeconds: 5
            failureThreshold: 2
          startupProbe:
            httpGet:
              path: /actuator/health
              port: 8080
            failureThreshold: 30
            periodSeconds: 5
```

---

## 3️⃣ Traffic Generator

Archivo: **`traffic-gen.yaml`**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: traffic-gen
spec:
  containers:
    - name: traffic
      image: busybox
      command: ["/bin/sh", "-c"]
      args:
        - >
          while true;
          do wget -qO- http://reactor-service:80/reactor || echo "fallo";
          sleep 2;
          done
```

---

## 4️⃣ Service para exponer el reactor

Archivo: **`service.yaml`**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: reactor-service
spec:
  selector:
    app: reactor
  ports:
    - port: 80
      targetPort: 8080
```

---

## 5️⃣ Aplicar todo

```bash
kubectl apply -f service.yaml
kubectl apply -f deployment-probes.yaml
kubectl apply -f traffic-gen.yaml
```

---

## 6️⃣ Probar fallos

1. Accede al traffic generator:
   ```bash
   kubectl logs -f traffic-gen
   ```

   Verás llamadas periódicas a `/reactor`.

2. Simula un fallo en el reactor:
   ```bash
   kubectl exec -it <nombre-del-pod-reactor> -- curl -X POST http://localhost:8080/reactor/crash
   ```

   - La **liveness probe** detectará que el contenedor murió y lo reiniciará.  
   - Durante el fallo, la **readiness probe** marcará el Pod como `NotReady`, y el Service dejará de enviarle tráfico.  
   - Si tu app tarda en arrancar, la **startup probe** evita reinicios en bucle durante arranques lentos.

---

## 7️⃣ Limpiar

```bash
kubectl delete deployment reactor-probes
kubectl delete pod traffic-gen
kubectl delete svc reactor-service
```

---

## 📝 Reflexión

- **Liveness probe** reinicia contenedores atascados.  
- **Readiness probe** controla si el Pod recibe tráfico.  
- **Startup probe** evita reinicios en bucle durante arranques lentos.  
- Con un traffic generator puedes ver cómo Kubernetes protege a los usuarios de los fallos.
