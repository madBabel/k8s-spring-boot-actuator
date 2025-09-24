# 🚀 Ejercicio 2: Deployment en Kubernetes

Un Deployment usa ReplicaSets internamente, y añade capacidades como **rolling updates** y **rollback**.

---

## 1️⃣ Crear el archivo del Deployment

Archivo: **`deployment.yaml`**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
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

## 2️⃣ Aplicar y verificar

```bash
kubectl apply -f deployment.yaml
kubectl get deployments
kubectl get rs
kubectl get pods -l app=nginx
```

## 3️⃣ Actualizar imagen

Edita `deployment.yaml`:

```yaml
image: nginx:1.26
```

Y aplica:

```bash
kubectl apply -f deployment.yaml
kubectl rollout status deployment nginx-deployment
```

## 4️⃣ Rollback

```bash
kubectl rollout undo deployment nginx-deployment
```

## 5️⃣ Eliminar

```bash
kubectl delete deployment nginx-deployment
```
