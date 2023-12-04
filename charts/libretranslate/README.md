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

## Readiness/liveness probes

The Readiness and Liveness probes are disabled by default. This is because the initial download takes very long and most likely make them fail. I suggest to enable them after you've downloaded the language files (with persistent storage).
