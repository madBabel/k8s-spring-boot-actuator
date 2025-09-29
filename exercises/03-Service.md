# 🚀 Ejercicio 3: Service en Kubernetes

Un Service expone los Pods gestionados por un Deployment o ReplicaSet, ofreciendo **una IP estable y balanceo de carga**.

---

## 1 Crear el archivo del Service

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

## 2 Aplicar el Service

```bash
kubectl apply -f service.yaml
kubectl get svc
```

---

## 3 Acceder al servicio

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


## 4 Construir y publicar la imagen del Traffic Generator

acceder al directorio del traffic-generator y ejecutar:

```bash
docker build -t <tuusuario>/traffic-generator:latest .
docker push <tuusuario>/traffic-generator:latest
```

⚠️ Recuerda haber hecho docker login previamente al registry que uses (Docker Hub, GHCR, etc.).
---


## 5 applicar el pod

modificar el fichero traffic-gen-pod.yaml para añadir tu usuario y aplicar la config.

```bash
kubectl apply -f traffic-gen-pod.yaml
```

## 6 ver logs del pod
```bash
kubectl logs -f traffic-generator
```

Deberías ver respuestas coloreadas según el reactor que responda.



## 7 Comprobar tolerancia a fallos

En otra terminal, lista y elimina un Pod del reactor:

```bash
kubectl get pods
kubectl delete pod <nombre-del-pod>
```

👉 Verás en los logs del traffic-generator que el servicio sigue respondiendo, balanceando a los Pods restantes.

## 8  Limpieza
```bash
kubectl delete pod traffic-generator
kubectl delete svc reactor-service
```

