# LibreTranslate Helm Chart

## Table of Contents

- [Repository](#repository)
- [Arguments](#arguments)
- [Autoscaling and Persistent Storage](#autoscaling-and-persistent-storage)
  - [Sticky Sessions and Persistent Volumes](#sticky-sessions-and-persistent-volumes)
    - [Option 1: Sticky Sessions](#option-1-sticky-sessions)
    - [Option 2: Persistent Volume](#option-2-persistent-volume)
- [Health Checks](#health-checks)
  - [Sample Probe Configurations](#sample-probe-configurations)

## Repository

| Name       | Url                                                              |
|------------|------------------------------------------------------------------|
| Contribute | https://github.com/f3k-tech/helm/tree/main/charts/libretranslate |
| Issues     | https://github.com/f3k-tech/helm/issues                          |




## Arguments

You can add arguments like this:

```yaml
args:
  - --ssl
  - --update-models
  - --load-only
  - en,de,fr,hu,nl,tr
```

## Autoscaling and Persistent Storage

> **Important:** When using HPA with persistent storage, it's recommended to deploy a single pod to download the initial language files. Once the language files have been downloaded you can deploy more pods. 

* Make sure to use ReadWriteMany (RWX) when using the autoscaler in combination with persistent storage. 
* If you experience problems with languages not showing or want to make sure to have the latest language files, use the ```--update-models``` flag.

### Sticky Sessions and Persistent Volumes

To manage translated files stored in `/tmp/libretranslate-files-translate`, you can use sticky sessions or mount a persistent volume. This is crucial for maintaining access to temporary files generated during file translation.

>Sticky sessions provide an easier, straightforward solution for maintaining user session consistency, especially for stateful applications. However, they can constrain the flexibility and efficiency of autoscaling by tying sessions to specific pods, potentially leading to uneven load distribution and reduced fault tolerance. For scenarios requiring optimal autoscaling and resilience, leveraging shared persistent storage might be a more suitable approach, despite its greater complexity.

#### Option 1: Sticky Sessions

Enable sticky sessions to route requests from the same client to the same pod, ensuring consistent access to temporary stateful data across requests. 

- **Traefik:** Add to `service.annotations` in values:

```yaml
service:
  annotations:
    traefik.ingress.kubernetes.io/service.sticky.cookie: "true"
```

- **Nginx:** Add to `ingress.annotations` in values:

```yaml
ingress:
  annotations:
    nginx.ingress.kubernetes.io/affinity: "cookie"
    nginx.ingress.kubernetes.io/session-cookie-name: "libretranslate-session"
    nginx.ingress.kubernetes.io/session-cookie-expires: "172800"
    nginx.ingress.kubernetes.io/session-cookie-max-age: "172800"
```

#### Option 2: Persistent Volume

For applications using Horizontal Pod Autoscaling (HPA), attach a Persistent Volume with ReadWriteMany (RWX) access to your pods. This allows all pods to share language files, facilitating consistent translations and quick scaling.

To ensure new pods have immediate access to language files, enable `persistence.filesTranslate`:

```yml
persistence:
  filesTranslate:
    enabled: true
    accessMode: ReadWriteMany
```

## Health Checks

If language file downloads extend beyond the initial startup, readiness and liveness probes may fail. Adjust probe settings according to your network speed or disable them temporarily during the first deployment with persistent storage.

### Sample Probe Configurations

#### 10Mb/s

```yml
  initialDelaySeconds: 60
  periodSeconds: 30
  failureThreshold: 600
  successThreshold: 1
  timeoutSeconds: 5
```

#### 100Mb/s

```yml
  initialDelaySeconds: 60
  periodSeconds: 30
  failureThreshold: 60
  successThreshold: 1
  timeoutSeconds: 5
```

#### 1000Mb/s

```yml
  initialDelaySeconds: 60
  periodSeconds: 15
  failureThreshold: 12
  successThreshold: 1
  timeoutSeconds: 5
```
