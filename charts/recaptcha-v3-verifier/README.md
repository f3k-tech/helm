# reCAPTCHA v3 Verifier — Helm Chart

This Helm chart deploys a lightweight service that securely validates Google reCAPTCHA v3 tokens server-side and returns an allow/challenge/deny decision based on configurable score thresholds.

Important: Do not expose this service publicly (e.g., via Ingress). It should only be reachable from your backend and never directly from the internet or frontend clients.

## Features

- 🔒 Secure reCAPTCHA v3 token verification
- ☸️ Kubernetes Helm chart (ClusterIP by default)
- 🛡️ Hardened container image (distroless base, minimal attack surface)
- 🏥 Health and readiness probes
- 📊 Horizontal Pod Autoscaling
- 🔐 Non-root container execution
- 🚀 Production-ready with security best practices

## API Endpoints

### POST /verify
Verify a reCAPTCHA v3 token and return a decision.

**Request:**
```json
{
  "token": "recaptcha_token_here",
  "action": "optional_action_name"
}
```

**Response (examples):**

Allow
```json
{
  "success": true,
  "decision": "allow",
  "allow": true,
  "challenge": false,
  "deny": false,
  "score": 0.9,
  "action": "submit",
  "thresholds": { "allow": 0.6, "challenge": 0.3 },
  "challenge_ts": "2025-12-12T10:00:00Z",
  "hostname": "yourdomain.com"
}
```

Challenge
```json
{
  "success": true,
  "decision": "challenge",
  "allow": false,
  "challenge": true,
  "deny": false,
  "score": 0.42,
  "action": "submit",
  "thresholds": { "allow": 0.6, "challenge": 0.3 },
  "challenge_ts": "2025-12-12T10:00:00Z",
  "hostname": "yourdomain.com"
}
```

Deny
```json
{
  "success": true,
  "decision": "deny",
  "allow": false,
  "challenge": false,
  "deny": true,
  "score": 0.12,
  "action": "submit",
  "thresholds": { "allow": 0.6, "challenge": 0.3 },
  "challenge_ts": "2025-12-12T10:00:00Z",
  "hostname": "yourdomain.com"
}
```

### GET /health
Health check endpoint for liveness probe.

### GET /ready
Readiness check endpoint.

## Test From Cluster

Because this service is internal-only, test it from inside the cluster using a curl pod:

```bash
NAMESPACE=recaptcha
RELEASE=recaptcha
SERVICE="${RELEASE}-recaptcha-v3-verifier" # chart fullname

kubectl run -it --rm curl -n "$NAMESPACE" --image=curlimages/curl:8.10.1 --restart=Never -- \
  sh -c "curl -s -X POST http://${SERVICE}.${NAMESPACE}.svc.cluster.local:3000/verify \
    -H 'Content-Type: application/json' -d '{\"token\":\"test_token\"}' | sed -e 's/{/\n{/g'"
```

## Install

Add the Helm repo and install the chart. Replace the secret value with your reCAPTCHA v3 secret key.

```bash
helm repo add f3k https://f3k-tech.github.io/helm
helm repo update

# install (recommended: set secret via values override file or --set)
helm upgrade --install recaptcha f3k/recaptcha-v3-verifier \
  --namespace recaptcha --create-namespace \
  --set secrets.app.RECAPTCHA_SECRET_KEY="<your-recaptcha-secret-key>"
```

Upgrade with a values file:

```bash
cat > values.override.yaml <<'YAML'
secrets:
  app:
    RECAPTCHA_SECRET_KEY: "<your-recaptcha-secret-key>"

# Optional: additional environment variables
env:
  - name: ALLOWED_ORIGINS
    value: "https://example.com,https://app.example.com"
  - name: ALLOW_SCORE
    value: "0.6"
  - name: CHALLENGE_SCORE
    value: "0.3"
YAML

helm upgrade --install recaptcha f3k/recaptcha-v3-verifier \
  -n recaptcha -f values.override.yaml
```

## Configuration

### Values

- `image.registry`: Container registry host (default `docker.io`).
- `image.repository`: Image repository (default `f3ktech/recaptcha-v3-verifier`).
- `image.tag`: Image tag (defaults to chart `appVersion` when empty).
- `image.digest`: Optional sha256 digest (without prefix); when set, digest is used instead of tag.
- `service.type`: Service type (default `ClusterIP`).
- `service.port`: Container port (default `3000`).
- `ingress.enabled`: Should remain `false` for security; do not expose publicly.
- `env`: List of additional environment variables.
- `secrets.app.RECAPTCHA_SECRET_KEY`: Required reCAPTCHA secret; creates a Kubernetes Secret and is injected into the pod.

### Environment Variables (runtime)

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `RECAPTCHA_SECRET_KEY` | Google reCAPTCHA secret key | - | Yes |
| `ALLOWED_ORIGINS` | Comma-separated CORS origins | `*` | No |
| `ALLOW_SCORE` | Score to automatically allow (0.0-1.0) | `0.6` | No |
| `CHALLENGE_SCORE` | Score to challenge (0.0-1.0). Requests below this are denied. | `0.3` | No |

### Decision Logic

- `allow` when `score >= ALLOW_SCORE`
- `challenge` when `CHALLENGE_SCORE <= score < ALLOW_SCORE`
- `deny` when `score < CHALLENGE_SCORE`

## Security & Exposure

- Do not expose this service publicly. Keep `ingress.enabled: false` and the `Service` as `ClusterIP`.
- Call this service only from trusted backend services within the cluster or via an internal network path.
- Ensure `ALLOWED_ORIGINS` is set to only the domains that will access your backend.

## Security Features

- ✅ Non-root user execution
- ✅ Read-only root filesystem
- ✅ Dropped capabilities
- ✅ Security headers via Helmet.js
- ✅ CORS protection
- ✅ Secret management via Kubernetes Helm Chart and Secrets
- ✅ Resource limits and requests

## Monitoring

### Metrics
The service logs verification events with:
- Timestamp
- Score
- Action
- Decision (allow/challenge/deny)
- Hostname

## Troubleshooting

### Image pull errors
- Ensure the image tag exists for your cluster architecture (e.g., `amd64`/`arm64`).
- Optionally set `image.digest` to pin an immutable digest for your platform.

### CORS errors
Update `ALLOWED_ORIGINS` via values (see examples) to include your frontend domain(s).

## License

MIT
