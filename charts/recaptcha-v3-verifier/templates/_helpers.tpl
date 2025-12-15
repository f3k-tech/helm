{{/*
Expand the name of the chart.
*/}}
{{- define "recaptcha-v3-verifier.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "recaptcha-v3-verifier.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "recaptcha-v3-verifier.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "recaptcha-v3-verifier.labels" -}}
helm.sh/chart: {{ include "recaptcha-v3-verifier.chart" . }}
{{ include "recaptcha-v3-verifier.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "recaptcha-v3-verifier.selectorLabels" -}}
app.kubernetes.io/name: {{ include "recaptcha-v3-verifier.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "recaptcha-v3-verifier.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "recaptcha-v3-verifier.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Build full image reference from registry/repository and tag or digest.
If .Values.image.digest is set (sha256 without prefix), use @sha256:digest; otherwise use :tag (defaulting to Chart.AppVersion).
*/}}
{{- define "recaptcha-v3-verifier.image" -}}
{{- $registry := default "docker.io" .Values.image.registry -}}
{{- $repository := required "image.repository is required" .Values.image.repository -}}
{{- $digest := .Values.image.digest | default "" -}}
{{- if $digest -}}
{{- printf "%s/%s@%s" $registry $repository (printf "sha256:%s" $digest) -}}
{{- else -}}
{{- $tag := default .Chart.AppVersion .Values.image.tag -}}
{{- printf "%s/%s:%s" $registry $repository $tag -}}
{{- end -}}
{{- end }}
