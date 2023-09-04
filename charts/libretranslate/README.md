# LibreTranslate Helm Chart

## Known Issues

### It takes very long for the webserver to become available

The LibreTranslate webserver will only become available after downloading the languages. This can take up to 10 minutes. Maybe even more with a slow connection

### Ingress or Certificate Manager Not Included

You'll need to bring your own ingress controller and certificate manager.

Here is an example to create an ingress:

#### With TLS:

```sh
kubectl create ingress libretranslate \
  --rule="libretranslate.example.com/*=libretranslate:5000,tls=libretranslate.example.com-secret"
```


#### Without TLS:

```sh
kubectl create ingress libretranslate \
  --rule="libretranslate.example.com/*=libretranslate:5000"
```

### Persistance Not Included

There's no perstistance included. That's why LibreOffice needs to download the language files every time.
I'm planning to include this in the future. Feel free to contribute.