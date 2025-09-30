# 🧩 Ejercicio: Namespaces, ResourceQuotas y Limits en Kubernetes

En este ejercicio aprenderás a usar **namespaces**, **ResourceQuota**, **requests** y **limits** para controlar el consumo de recursos en Kubernetes.

---

## 1️⃣ Crear un Namespace

Archivo: **`namespace.yaml`**

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: reactor-lab
```

Aplica el namespace:

```bash
kubectl apply -f namespace.yaml
kubectl get ns
```

---

## 2️⃣ Definir un ResourceQuota

Archivo: **`resource-quota.yaml`**

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: reactor-quota
  namespace: reactor-lab
spec:
  hard:
    pods: "5"             # máximo 5 pods en este namespace
    requests.cpu: "500m"  # máximo 0.5 CPU total en requests
    requests.memory: "256Mi" # máximo 256Mi en requests
    limits.cpu: "1"       # máximo 1 CPU total en limits
    limits.memory: "512Mi" # máximo 512Mi en limits
```

Aplica la quota:

```bash
kubectl apply -f resource-quota.yaml
kubectl describe quota -n reactor-lab
```

---

## 3️⃣ Definir un LimitRange (requests/limits por defecto)

Archivo: **`limit-range.yaml`**

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: reactor-limits
  namespace: reactor-lab
spec:
  limits:
    - default:
        cpu: 200m
        memory: 128Mi
      defaultRequest:
        cpu: 100m
        memory: 64Mi
      type: Container
```

Aplica el LimitRange:

```bash
kubectl apply -f limit-range.yaml
```

---

## 4️⃣ Crear un Pod válido

Archivo: **`pod-ok-with-resources.yaml`**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: reactor-ok
  namespace: reactor-lab
  labels:
    app: reactor
spec:
  containers:
    - name: reactor
      image: nuclear-control-panel:1.0
      resources:
        requests:
          cpu: 100m
          memory: 64Mi
        limits:
          cpu: 200m
          memory: 128Mi
```

Aplica el Pod:

```bash
kubectl apply -f pod-ok-with-resources.yaml
kubectl get pods -n reactor-lab
```

👉 Este Pod debería arrancar sin problemas.

---

## 5️⃣ Intentar crear un Pod que exceda la quota

Archivo: **`pod-fail-with-resources.yaml`**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: reactor-fail
  namespace: reactor-lab
spec:
  containers:
    - name: reactor
      image: nuclear-control-panel:1.0
      resources:
        requests:
          cpu: 600m        # supera el máximo 500m en requests
          memory: 300Mi    # supera el máximo 256Mi en requests
        limits:
          cpu: 2           # supera el máximo 1 CPU en limits
          memory: 1Gi      # supera el máximo 512Mi en limits
```

Intenta aplicarlo:

```bash
kubectl apply -f pod-fail-with-resources.yaml
```

👉 Verás un error similar a:

```
Error from server (Forbidden): pods "reactor-fail" is forbidden: 
exceeded quota: reactor-quota, requested: requests.cpu=600m, requests.memory=300Mi, 
used: requests.cpu=100m, requests.memory=64Mi, limited: requests.cpu=500m, requests.memory=256Mi
```

---

## 6️⃣ Limpiar

```bash
kubectl delete ns reactor-lab
```

Esto eliminará el namespace y todos los recursos dentro de él.

---

## 📝 Reflexión

- Los **namespaces** permiten aislar entornos (ej: dev, qa, prod).  
- Las **quotas** limitan el uso total de recursos por namespace.  
- Los **limitRanges** definen requests/limits por defecto en los contenedores.  
- Si un Pod intenta pedir más recursos de los permitidos, Kubernetes **rechaza su creación**.
