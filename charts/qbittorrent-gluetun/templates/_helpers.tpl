{{/*
Create a default fully qualified name.
*/}}
{{- define "qbittorrent-gluetun.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" $name .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end }}

{{/*
Create a name, preferring the nameOverride if provided.
*/}}
{{- define "qbittorrent-gluetun.name" -}}
{{- if .Values.nameOverride -}}
{{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end }}

{{/*
Create a chart name with version.
*/}}
{{- define "qbittorrent-gluetun.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version }}
{{- end }}

{{/*
Create PVC names for various components.
*/}}
{{- define "qbittorrent-gluetun.gluetunConfigPVC" -}}
{{ include "qbittorrent-gluetun.fullname" . }}-gluetun-config
{{- end }}

{{- define "qbittorrent-gluetun.qbittorrentConfigPVC" -}}
{{ include "qbittorrent-gluetun.fullname" . }}-qbittorrent-config
{{- end }}

{{- define "qbittorrent-gluetun.downloadsPVC" -}}
{{ include "qbittorrent-gluetun.fullname" . }}-downloads
{{- end }}
