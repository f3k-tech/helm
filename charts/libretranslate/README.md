# LibreTranslate Helm Chart

> **NEW REPO URL:** From now on, f3k.tech helm charts will be published via github pages: [https://f3k-tech.github.io/helm/](https://f3k-tech.github.io/helm/).
> Please change your deployment to the new URL.
> Old charts will be served from the new repo as well.

| Name       | Url                                                              |
|------------|------------------------------------------------------------------|
| Contribute | https://github.com/f3k-tech/helm/tree/main/charts/libretranslate |
| Issues     | https://github.com/f3k-tech/helm/issues                          |

## Downloading languages may take a long time

The LibreTranslate webserver will only become available after downloading the languages. This can take up to 10 minutes. Maybe even more with a slow connection.

To speed up downloading you can limit the amount of languages by adding the ```--load-only``` argument:

```yaml
args:
  - --load-only
  - en,de,fr,hu,nl,tr
```

## Readiness/liveliness probes fail

If the webserver is not ready within 16 minutes, the readinessProbe and livelinessProbe will fail. This is most likely because downloading the language files took too long. Please adjust the values to accomodate your connection. Don't set the initalDelaySeconds to if you use persistent storage as it won't download the language files everytime.

Here are some numbers to get you started:
_You can use the same numbers for both readiness and liveliness._

### 10Mb/s

```yml
  initialDelaySeconds: 60
  periodSeconds: 30
  failureThreshold: 600
  successThreshold: 1
  timeoutSeconds: 5
```

### 100Mb/s

```yml
  initialDelaySeconds: 60
  periodSeconds: 30
  failureThreshold: 60
  successThreshold: 1
  timeoutSeconds: 5
```

### 1000Mb/s

```yml
  initialDelaySeconds: 60
  periodSeconds: 15
  failureThreshold: 12
  successThreshold: 1
  timeoutSeconds: 5
```