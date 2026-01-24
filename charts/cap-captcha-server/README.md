## Cap Captcha Server Helm Chart

A Helm chart to deploy the CAP Captcha Server (standalone) on Kubernetes.

This chart wraps the container image defined in `values.yaml` (default: `docker.io/tiago2/cap`) and exposes configuration via Helm values for environment variables, secrets, persistence, ingress, and autoscaling.

## Project Links

| Resource                | Link                                                                                                    |
|-------------------------|---------------------------------------------------------------------------------------------------------|
| Helm Repository (index) | [https://f3k-tech.github.io/helm](https://f3k-tech.github.io/helm)                                      |
| Helm Issues             | [Open issues](https://github.com/f3k-tech/helm/issues)                                                  |

## Quick Start

Add the repo and install:

```bash
helm repo add f3k-tech https://f3k-tech.github.io/helm
helm repo update

# Replace <release-name> and optionally pin a version with --version
helm install <release-name> f3k-tech/cap-captcha-server \
	--set secrets.app.ADMIN_KEY="your_secret_password"
```

To render locally from the repo:

```bash
helm template cap-test ./charts/cap-captcha-server
```

## Configuration

Key values you may want to set:

- env: additional environment variables (array of name/value pairs).
- secrets.app.ADMIN_KEY: required admin key (stored as a Secret and injected via `ADMIN_KEY`).
- ingress.enabled: create an Ingress; configure hosts/paths and annotations.
- persistence.data.enabled: enable PVC for data at `/usr/src/app/.data`.
	- persistence.data.size, accessMode, storageClass, existingClaim.

## Environment Variables

- ADMIN_KEY: Injected from Secret `secrets.app.ADMIN_KEY`. Required for admin operations.
- Additional variables can be provided via the `env` list in values, for example:

```yaml
env:
	- name: CORS_ORIGIN
		value: "domain1.tld,domain2.tld"
	- name: ENABLE_ASSETS_SERVER
		value: "true"
```

### Custom DB URLs

If you would like to use a different database, set `DB_URL` to the desired database URL.

- Recommended default (SQLite): `sqlite://./.data/db.sqlite`
- Other databases supported by Bun SQL may work (not officially supported by this chart):
	- Postgres: `postgres://user:pass@localhost:5432/mydb`
	- MySQL: `mysql://user:password@localhost:3306/database`

Example values:

```yaml
env:
  - name: DB_URL
    value: "sqlite://./.data/db.sqlite"
```

## Persistence

- Enable persistence to store data at `/usr/src/app/.data`.
- By default, persistence is disabled (`persistence.data.enabled=false`).
- When enabled and `existingClaim` is not set, this chart creates a PVC named `<release>-cap-captcha-server-data`.
- Set `existingClaim` to use a pre-created PVC instead of creating one.

Examples:

Enable and let the chart create a PVC:

```bash
helm install cap f3k-tech/cap-captcha-server \
	--set secrets.app.ADMIN_KEY="your_secret_password" \
	--set persistence.data.enabled=true \
	--set persistence.data.size=1Gi
```

Use an existing PVC:

```bash
helm install cap f3k-tech/cap-captcha-server \
	--set secrets.app.ADMIN_KEY="your_secret_password" \
	--set persistence.data.enabled=true \
	--set persistence.data.existingClaim=my-precreated-pvc
```

## Ingress

Enable and configure hosts/paths:

```bash
helm install cap f3k-tech/cap-captcha-server \
	--set secrets.app.ADMIN_KEY="your_secret_password" \
	--set ingress.enabled=true \
	--set ingress.hosts[0].host=cap.example.com \
	--set ingress.hosts[0].paths[0].path=/ \
	--set ingress.hosts[0].paths[0].pathType=ImplementationSpecific
```

## HTTPRoute (Gateway API)

Alternatively, use Gateway API HTTPRoute:

```bash
helm install cap f3k-tech/cap-captcha-server \
	--set secrets.app.ADMIN_KEY="your_secret_password" \
	--set httpRoute.enabled=true \
	--set httpRoute.parentRefs[0].name=gateway \
	--set httpRoute.hostnames[0]=cap.example.com
```

## Upgrade

```bash
helm upgrade <release-name> f3k-tech/cap-captcha-server \
	--reuse-values \
	-f your-values.yaml
```

## Uninstall

```bash
helm uninstall <release-name>
```

## Links

- Chart index: https://f3k-tech.github.io/helm
- Issues: https://github.com/f3k-tech/helm/issues