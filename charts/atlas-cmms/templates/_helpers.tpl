{{/*
Expand the name of the chart.
*/}}
{{- define "atlas-cmms.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "atlas-cmms.fullname" -}}
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
Component-specific full name helper: frontend
*/}}
{{- define "atlas-cmms.fullname-frontend" -}}
{{- printf "%s-frontend" (include "atlas-cmms.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Component-specific full name helper: backend
*/}}
{{- define "atlas-cmms.fullname-backend" -}}
{{- printf "%s-backend" (include "atlas-cmms.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Component-specific full name helper: postgres
*/}}
{{- define "atlas-cmms.fullname-postgres" -}}
{{- printf "%s-postgres" (include "atlas-cmms.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Component-specific full name helper: minio
*/}}
{{- define "atlas-cmms.fullname-minio" -}}
{{- printf "%s-minio" (include "atlas-cmms.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "atlas-cmms.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "atlas-cmms.labels" -}}
helm.sh/chart: {{ include "atlas-cmms.chart" . }}
{{ include "atlas-cmms.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "atlas-cmms.selectorLabels" -}}
app.kubernetes.io/name: {{ include "atlas-cmms.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "atlas-cmms.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "atlas-cmms.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Frontend service account */}}
{{- define "atlas-cmms.serviceAccountName-frontend" -}}
{{- default (printf "%s-frontend" (include "atlas-cmms.fullname" .)) .Values.frontend.serviceAccount.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Backend service account */}}
{{- define "atlas-cmms.serviceAccountName-backend" -}}
{{- default (printf "%s-backend" (include "atlas-cmms.fullname" .)) .Values.backend.serviceAccount.name | trunc 63 | trimSuffix "-" }}
{{- end }}