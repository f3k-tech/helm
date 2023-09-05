# LibreTranslate Helm Chart

| Name       | Url                                                              |
|------------|------------------------------------------------------------------|
| Contribute | https://github.com/f3k-tech/helm/tree/main/charts/libretranslate |
| Issues     | https://github.com/f3k-tech/helm/issues                          |

## Downloading languages may take a long time

The LibreTranslate webserver will only become available after downloading the languages. This can take up to 10 minutes. Maybe even more with a slow connection.

To speed up downloading I recommend to limit the amount of languages by adding the ```--load-only``` argument:

```yaml
args:
  - --load-only
  - en,de,fr,hu,nl,tr
```

## Readiness/liveliness probes fail

If the webserver is not ready within 15 minutes, the readiness and liveliness probes will fail. This is most likely because downloading the language files took too long. Please raise in issue or create a pull request if 15 minutes is too short. 
