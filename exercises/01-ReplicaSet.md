# 🚀 Ejercicio 1: ReplicaSet en Kubernetes

En este ejercicio aprenderás a desplegar y gestionar un **ReplicaSet** en Kubernetes.

---

## 1️⃣ Crear el archivo del ReplicaSet

Archivo: **`replicaset.yaml`**

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replicaset
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.25
          ports:
            - containerPort: 80
```

## 2️⃣ Aplicar y comprobar

```bash
kubectl apply -f replicaset.yaml
kubectl get rs
kubectl get pods -l app=nginx
```

## 3️⃣ Escalar

```bash
kubectl scale rs nginx-replicaset --replicas=5
kubectl get pods -l app=nginx
```

## 4️⃣ Eliminar

```bash
kubectl delete rs nginx-replicaset
```
