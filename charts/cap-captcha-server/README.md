## Cap Captcha Server Helm Chart

A Helm chart to deploy the CAP Captcha Server (standalone) on Kubernetes.

This chart wraps the container image defined in `values.yaml` (default: `docker.io/tiago2/cap`) and exposes configuration via Helm values for environment variables, secrets, persistence, ingress, and autoscaling.

## Project Links

| Resource                | Link                                                               |
|-------------------------|--------------------------------------------------------------------|
| Helm Repository (index) | [https://f3k-tech.github.io/helm](https://f3k-tech.github.io/helm) |
| Helm Issues             | [Open issues](https://github.com/f3k-tech/helm/issues)             |

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

### SQLite Init Container

This chart can run an init container to prepare the SQLite database when persistence is enabled.

- Name: `init-sqlite-db`
- Purpose: creates `/usr/src/app/.data` and pre-creates `db.sqlite`, fixing permissions so the app user can write.
- Activation: only runs when `persistence.data.enabled=true` and `persistence.data.initSqliteDB.enabled=true`.
- After initial run: you can disable it (set `persistence.data.initSqliteDB.enabled=false`) once the file and directory exist.
- Safety: it does not overwrite an existing database; it only creates the file if missing and adjusts permissions, so it’s safe to leave enabled.

Example enabling it:

```bash
helm upgrade --install cap f3k-tech/cap-captcha-server \
	--set secrets.app.ADMIN_KEY="your_secret_password" \
	--set persistence.data.enabled=true \
	--set persistence.data.initSqliteDB.enabled=true
```

### Recommended Rate Limit IP Header

Set the IP header used for rate limiting to match your ingress/proxy setup:

```yaml
env:
  - name: RATELIMIT_IP_HEADER
    value: "x-forwarded-for" # or "cf-connecting-ip" when behind Cloudflare
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