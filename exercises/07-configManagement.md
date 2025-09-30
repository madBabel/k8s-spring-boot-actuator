# 🔑 Ejercicio: ConfigMaps y Secrets en Kubernetes

En este ejercicio aprenderás a usar **ConfigMaps** y **Secrets** para pasar configuración y credenciales a los Pods.

---

## 1️⃣ Crear un ConfigMap

Archivo: **`configmap.yaml`**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: reactor-config
data:
  SERVER_PORT: "8081"
  REACTOR_NAME: "Springfield-Reactor"
```

👉 Aquí definimos el puerto y el nombre del reactor.

Aplica el ConfigMap:
```bash
kubectl apply -f configmap.yaml
```

---

## 2️⃣ Crear un Secret

Archivo: **`secret.yaml`**

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: reactor-secret
type: Opaque
data:
  username: b3BlcmFkb3I=       # "operador" en base64
  password: c2VjcmV0MTIz       # "secret123" en base64
```

Aplica el Secret:
```bash
kubectl apply -f secret.yaml
```

---

## 3️⃣ Crear un Deployment que use ConfigMap y Secret

Archivo: **`deployment-with-config.yaml`**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: reactor-config-secret
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
            - containerPort: 8081
          envFrom:
            - configMapRef:
                name: reactor-config
            - secretRef:
                name: reactor-secret
```
Aplicar el deployment

```bash      
kubectl apply -f deployment-with-config.yaml
```
---

## 4️⃣ Verificar el Pod

Comprueba que las variables están cargadas:
```bash
kubectl exec -it <nombre-del-pod> -- printenv | grep -E "SERVER_PORT|REACTOR_NAME|username|password"
```

Deberías ver:
```
SERVER_PORT=8081
REACTOR_NAME=Springfield-Reactor
username=operador
password=secret123
```

---

## 5️⃣ Acceder a la app

Haz port-forward al Pod:
```bash
kubectl port-forward deployment/reactor-config-secret 8081:8081
```

Y prueba el endpoint:
```bash
curl http://localhost:8081/reactor
```

---

## 6️⃣ Limpiar

```bash
kubectl delete deployment reactor-config-secret
kubectl delete configmap reactor-config
kubectl delete secret reactor-secret
```

---

## 📝 Reflexión

- Los **ConfigMaps** son ideales para configuración no sensible (ej: puertos, nombres, rutas).  
- Los **Secrets** se usan para información sensible (ej: credenciales, tokens, certificados).  
- Ambos se pueden inyectar como variables de entorno o como ficheros montados en volúmenes.
