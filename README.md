# Helm Charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/f3k-tech)](https://artifacthub.io/packages/search?repo=f3k-tech)

## Usage

**Add repository**

```
helm repo add f3k-tech https://f3k-tech.github.io/helm/
helm repo update
```

**Available charts**

- libretranslate — Machine translation service
- akaunting — Akaunting web app
- recaptcha-v3-verifier — reCAPTCHA verification microservice

**Install a chart**

```
# Generic pattern
helm install <release-name> f3k-tech/<chart-name> [--namespace <ns>] [--create-namespace] [--values values.yaml]

# Examples
helm install my-libretranslate f3k-tech/libretranslate
helm install my-akaunting f3k-tech/akaunting
helm install my-recaptcha f3k-tech/recaptcha-v3-verifier --namespace recaptcha --create-namespace \
	--set secrets.app.RECAPTCHA_SECRET_KEY="<your-recaptcha-secret-key>"
```

> `my-<release-name>` corresponds to your chosen release identifier. Supply any chart-specific values with `--set` or `-f values.yaml`.