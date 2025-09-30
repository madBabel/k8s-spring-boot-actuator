# 📦 Ejercicio: Volúmenes con ConfigMaps y Secrets (Reactor App)

Este ejercicio muestra cómo montar un **ConfigMap** y un **Secret** en un Pod que ejecuta la aplicación nuclear (`nuclear-control-panel:1.0`).

---

## 1️⃣ Crear un ConfigMap con configuración del reactor

Archivo: **`reactor-configmap.yaml`**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: reactor-config
data:
  application.properties: |
    server.port=8080
    reactor.name=Springfield-Reactor
```

---

## 2️⃣ Crear un Secret con credenciales

Archivo: **`reactor-secret.yaml`**

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: reactor-secret
type: Opaque
data:
  operator.password: c2VjcmV0MTIz   # "secret123" en base64
```

---

## 3️⃣ Crear un Deployment que use ConfigMap y Secret

Archivo: **`reactor-deployment.yaml`**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: reactor-app
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
          volumeMounts:
            - name: reactor-config-vol
              mountPath: /config/application.properties
              subPath: application.properties
          env:
            - name: OPERATOR_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: reactor-secret
                  key: operator.password
      volumes:
        - name: reactor-config-vol
          configMap:
            name: reactor-config
```

---

## 4️⃣ Probar el ejercicio

1. Aplica los recursos:
   ```bash
   kubectl apply -f reactor-configmap.yaml
   kubectl apply -f reactor-secret.yaml
   kubectl apply -f reactor-deployment.yaml
   ```

2. Verifica que el archivo se montó en el Pod:
   ```bash
   kubectl exec -it <pod-reactor> -- cat /config/application.properties
   ```

3. Verifica la variable de entorno:
   ```bash
   kubectl exec -it <pod-reactor> -- printenv | grep OPERATOR_PASSWORD
   ```

4. Haz port-forward y prueba la app:
   ```bash
   kubectl port-forward deployment/reactor-app 8080:8080
   curl http://localhost:8080/reactor
   ```

---

## 5️⃣ Limpiar

```bash
kubectl delete deployment reactor-app
kubectl delete configmap reactor-config
kubectl delete secret reactor-secret
```

---

## 📝 Reflexión

- El **ConfigMap** se montó como archivo (`application.properties`) en el contenedor.  
- El **Secret** se inyectó como variable de entorno.  
- Esto permite separar la configuración de la imagen de la aplicación.
