# LibreTranslate Helm Chart

> **NEW REPO URL:** From now on, f3k.tech helm charts will be published via github pages: [https://f3k-tech.github.io/helm/](https://f3k-tech.github.io/helm/).
> Please change your deployment to the new URL.
> Old charts will be served from the new repo as well.

| Name       | Url                                                              |
|------------|------------------------------------------------------------------|
| Contribute | https://github.com/f3k-tech/helm/tree/main/charts/libretranslate |
| Issues     | https://github.com/f3k-tech/helm/issues                          |

## Arguments

You can add arguments like this:

```yaml
args:
  - --update-models
  - --load-only
  - en,de,fr,hu,nl,tr
```

## Autoscaling (HPA)

> **Important:** When using persistent storage make sure to deploy a single pod to download the language files. Once the language files have been downloaded you can deploy more pods. 

* Make sure to use ReadWriteMany (RWX) when using the autoscaler in combination with persistent storage. 
* If you experience problems with languages not showing or want to make sure to have the latest language files, use the ```--update-models``` flag.


## Readiness/liveness probes fail

If the webserver is not ready within 16 minutes, the default **readinessProbe** and **livenessProbe** will fail. This is most likely because downloading the language files took too long. Consider turning them off for the first run (with persistent storage) or adjust the values to accomodate your connection.
Here are some numbers to get you started:  
_You can use the same numbers for both readiness and liveliness._

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
