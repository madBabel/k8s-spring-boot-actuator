# 🚀 Ejercicio 1: ReplicaSet en Kubernetes

En este ejercicio aprenderás a desplegar y gestionar un **ReplicaSet** en Kubernetes, y luego a provocar un fallo intencionado en uno de los Pods.

---

## 1️⃣ Crear el archivo del ReplicaSet

Archivo: **`replicaset.yaml`**

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: reactor-replicaset
  labels:
    app: reactor
spec:
  replicas: 3   # número de réplicas deseadas
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

## 2️⃣ Aplicar y comprobar

```bash
kubectl apply -f replicaset.yaml
kubectl get rs
kubectl get pods -l app=reactor
```

---

## 3️⃣ Acceder a un Pod del ReplicaSet

Haz port-forward a uno de los Pods:

```bash
kubectl port-forward <nombre-del-pod> 8080:8080
```

Y comprueba que el endpoint funciona:

```bash
curl http://localhost:8080/reactor
```

---

## 4️⃣ Provocar un fallo con `/reactor/crash`

Haz la llamada al endpoint de crash:

```bash
curl http://localhost:8080/reactor/crash
```

La respuesta será inmediata:

```
OK: se romperá el reactor en 2 segundos
```

👉 Tras 2 segundos, el Pod se cerrará (saldrá con código 1).  

---

## 5️⃣ Observar el ReplicaSet

Lista los Pods otra vez:

```bash
kubectl get pods -l app=reactor
```

Notarás que el Pod que falló desaparece, y Kubernetes crea uno nuevo automáticamente para mantener las réplicas.  
¡Esa es la magia del ReplicaSet! 💡

---

## 6️⃣ Escalar el ReplicaSet

```bash
kubectl scale rs reactor-replicaset --replicas=5
kubectl get pods -l app=reactor
```

---

## 7️⃣ Eliminar el ReplicaSet

```bash
kubectl delete rs reactor-replicaset
```
