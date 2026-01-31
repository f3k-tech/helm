

## IMPORTANT: Cluster-wide Prerequisites

This chart depends on two operators being installed cluster-wide before you deploy:

1. MinIO Operator (installs CRDs and controller)
2. CloudNativePG (CNPG) Operator (installs CRDs and controller)

### CNPG Cluster-wide Watch Example

To ensure CNPG reconciles clusters across all namespaces, install it with a values file that enables cluster-wide watching:


```bash
helm repo add cnpg https://cloudnative-pg.github.io/charts
helm repo update
helm upgrade --install cnpg cnpg/cloudnative-pg \
  --namespace cnpg-system \
  --create-namespace \
  --set serviceAccount.create=true \
  --set serviceAccount.name=cnpg-operator \
  --set-string watchNamespaces[0]="*"
```

### MinIO Operator Cluster-wide Watch Example

To ensure the MinIO Operator watches all namespaces, set `WATCHED_NAMESPACE` to an empty string:

```bash
helm repo add minio https://operator.min.io/
helm repo update
helm upgrade --install minio-operator minio/operator \
  --namespace minio-operator \
  --create-namespace \
  --set-string operator.env[0].name=WATCHED_NAMESPACE \
  --set-string operator.env[0].value=""
```

# Atlas CMMS Helm Chart

This chart is designed to do a lot of heavy lifting for you. It wires together frontend, backend, PostgreSQL, and MinIO with sensible defaults so you don’t need to set many values to get a working deployment.

We encourage starting with the minimal example below and only adding functionality as needed. For production or stricter security setups, we also recommend setting the MinIO and PostgreSQL secrets manually rather than relying on auto-generation.

## Recommended Minimal Values 

```yaml
secrets:
  postgres:
    auth:
      username: "atlas"
      password: "" # If empty, auto-generated

  minio:
    root:
      accessKey: "minio"
      secretKey: "" # If empty, auto-generated

frontend:
  ingress:
    enabled: true
    className: ""
    annotations: {}
    hosts:
      - host: example.com
        paths:
          - path: /
            pathType: Prefix
    tls:
      - secretName: example.com-tls
        hosts:
          - example.com

backend:
  ingress:
    enabled: true
    className: ""
    annotations: {}
    hosts:
      - host: api.example.com
        paths:
          - path: /
            pathType: ImplementationSpecific
    tls:
      - secretName: api.example.com-tls
        hosts:
          - api.example.com

postgresql:
  enabled: true
  storage:
    enabled: true
    size: 2Gi
    storageClass: ""

minio:
  enabled: true
  tenant:
    pools:
      - name: "pool-0"
        servers: 1
        volumesPerServer: 1
        size: 2Gi
        storageClassName: ""

  ingress:
    api:
      enabled: true
      ingressClassName: ""
      host: "api.minio.example.com"
      path: /
      annotations: {}
      tls:
        - secretName: api.minio.example.com-tls
          hosts:
            - api.minio.example.com
    console:
      enabled: true
      ingressclassName: ""
      host: "minio.example.com"
      path: /
      annotations: {}
      tls:
        - secretName: minio.example.com-tls
          hosts:
            - minio.example.com

```