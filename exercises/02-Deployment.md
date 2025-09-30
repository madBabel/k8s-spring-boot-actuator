# 🚀 Ejercicio 2: Deployment en Kubernetes

Un Deployment usa ReplicaSets internamente, y añade capacidades como **rolling updates** y **rollback**.

---

## 1️⃣ Crear el archivo del Deployment

Archivo: **`deployment.yaml`**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: reactor-deployment
  labels:
    app: reactor
spec:
  replicas: 3
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
```

---

## 2️⃣ Aplicar y verificar

```bash
kubectl apply -f deployment.yaml
kubectl get deployments
kubectl get rs
kubectl get pods -l app=reactor
```

---

## 3️⃣ Acceder a un Pod

```bash
kubectl port-forward <nombre-del-pod> 8080:8080
curl http://localhost:8080/reactor
```

---

## 4️⃣ Provocar un fallo con `/reactor/crash`

```bash
curl -X POST http://localhost:8080/reactor/crash
```

La respuesta será inmediata:

```
OK: se romperá el reactor en 2 segundos
```

Notarás que el Pod que falló se reinicia de forma automatica.
¡Esa es la magia de Kubernetes! 💡

---

## 5️⃣ Actualizar imagen

genera una nueva imagen: nuclear-control-panel:2.0 y publicarla en docker hub

Edita `deployment.yaml`:

```yaml
image: nuclear-control-panel:2.0
```

Y aplica:

```bash
kubectl apply -f deployment.yaml
kubectl rollout status deployment reactor-deployment
```
haz un port-forward sobre uno de los pods:

```bash
kubectl port-forward $(kubectl get pods -o jsonpath='{.items[0].metadata.name}') 8080:8080
```

comprueba la version en 
http://localhost:8080/actuator/info

cierra el port-forward con CTRL+C

Si el info no devuelve la version, comprobarla con el comando describe pod de kubectl

---

## 6️⃣ Rollback

```bash
kubectl rollout undo deployment reactor-deployment

```


```bash
kubectl port-forward $(kubectl get pods -o jsonpath='{.items[0].metadata.name}') 8080:8080
```

comprueba la version en 
http://localhost:8080/actuator/info

cierra el port-forward con CTRL+C

Si el info no devuelve la version, comprobarla con el comando describe pod de kubectl


---

## 7️⃣ Eliminar

```bash
kubectl delete deployment reactor-deployment
```
