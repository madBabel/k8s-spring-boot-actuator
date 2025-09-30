# 🏷️ Ejercicio: Labels, Selectors y Anotaciones en Kubernetes

En este ejercicio aprenderás a usar **labels**, **selectors** y **annotations** para organizar y filtrar objetos en Kubernetes.

---

## 1️⃣ Crear un Pod con labels y annotations

Archivo: **`pod.yaml`**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: reactor-pod
  labels:
    app: reactor
    env: dev
    tier: backend
  annotations:
    description: "Pod que simula un reactor nuclear para pruebas"
    owner: "homersimpson@example.com"
spec:
  containers:
    - name: reactor
      image: nuclear-control-panel:1.0
      ports:
        - containerPort: 8080
```

Aplica el Pod:
```bash
kubectl apply -f pod.yaml
```

---

## 2️⃣ Listar y filtrar por labels

Ver todos los Pods:
```bash
kubectl get pods --show-labels
```

Filtrar solo los Pods de `app=reactor`:
```bash
kubectl get pods -l app=reactor
```

Filtrar los que estén en `env=dev`:
```bash
kubectl get pods -l env=dev
```

Filtrar por múltiples labels:
```bash
kubectl get pods -l app=reactor,tier=backend
```

---

## 3️⃣ Ver las anotaciones

Describe el Pod:
```bash
kubectl describe pod reactor-pod
```

👉 En la sección **Annotations** verás lo que definimos.

---

## 4️⃣ Crear un Service que seleccione por label

Archivo: **`service-with-selector.yaml`**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: reactor-service
spec:
  selector:
    app: reactor   # 🔥 el Service usará este label
    env: dev       # opcional: más específico
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: ClusterIP
```

Aplica el Service:
```bash
kubectl apply -f service-with-selector.yaml
kubectl get svc reactor-service
```

---

## 5️⃣ Añadir y modificar labels dinámicamente

Agregar un label nuevo al Pod:
```bash
kubectl label pod reactor-pod version=1.0
```

Actualizar un label existente:
```bash
kubectl label pod reactor-pod env=prod --overwrite
```

Ver los cambios:
```bash
kubectl get pods --show-labels
```

---

## 6️⃣ Limpiar

```bash
kubectl delete pod reactor-pod
kubectl delete svc reactor-service
```

---

## 📝 Reflexión

- Los **labels** permiten organizar y seleccionar objetos dinámicamente.  
- Los **selectors** hacen que recursos como Services, ReplicaSets y Deployments elijan qué Pods controlar.  
- Las **annotations** son metadatos útiles para documentar, pero no se usan en selectores.
