{{- define "maven-hello-world.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "maven-hello-world.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "maven-hello-world.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "maven-hello-world.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/name: {{ include "maven-hello-world.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "maven-hello-world.selectorLabels" -}}
app.kubernetes.io/name: {{ include "maven-hello-world.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}