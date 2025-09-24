# 🚀 Ejercicio 3: Service en Kubernetes

Un Service expone los Pods gestionados por un Deployment o ReplicaSet, ofreciendo **una IP estable y balanceo de carga**.

---

## 1️⃣ Crear el archivo del Service

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
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: NodePort
```

---

## 2️⃣ Aplicar el Service

```bash
kubectl apply -f service.yaml
kubectl get svc
```

---

## 3️⃣ Acceder al servicio

Con Minikube:

```bash
minikube service reactor-service
```

Con port-forward:

```bash
kubectl port-forward svc/reactor-service 8080:80
curl http://localhost:8080/reactor
```

---

## 4️⃣ Provocar un fallo con `/reactor/crash` a través del Service

```bash
curl -X POST http://localhost:8080/reactor/crash
```

La respuesta será:

```
OK: se romperá el reactor en 2 segundos
```

👉 Uno de los Pods del Deployment se cerrará.  
El Service detectará el cambio y seguirá redirigiendo tráfico a los Pods sanos automáticamente.

---

## 5️⃣ Eliminar

```bash
kubectl delete svc reactor-service
```
