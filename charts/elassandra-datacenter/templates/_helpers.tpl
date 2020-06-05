{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "elassandra.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "elassandra.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "elassandra.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "elassandra.datacenterName" -}}
{{ $length := len (split "-" .Release.Name) }}
{{- if eq $length 2 -}}
{{ (split "-" .Release.Name)._1 | lower }}
{{- end -}}
{{- if eq $length 3 -}}
{{ (split "-" .Release.Name)._2 | lower }}
{{- end -}}
{{- end -}}

{{- define "elassandra.clusterName" -}}
{{ $length := len (split "-" .Release.Name) }}
{{- if eq $length 2 -}}
{{ (split "-" .Release.Name)._0 | lower }}
{{- end -}}
{{- if eq $length 3 -}}
{{ (split "-" .Release.Name)._1 | lower }}
{{- end -}}
{{- end -}}

{{- define "elassandra.resourceName" -}}
elassandra-{{ template "elassandra.clusterName" . }}-{{ template "elassandra.datacenterName" . }}
{{- end -}}


{{- define "elassandra.serviceAccount" -}}
{{ .Release.Namespace }}-{{ template "elassandra.clusterName" . }}-{{ template "elassandra.datacenterName" . }}
{{- end -}}

{{/*
Compute the kibana version according to Elassandra image tag.
* elassandra datacenter template use the .Value.elasticsearch.kibana.tag if define
* otherwise, we extract the tag from the .Values.image.tag field, if the tag format
  doesn't match d+\.d+\.d+, the default value 6.8.4 is defined.
*/}}
{{- define "kibana.version" -}}
{{ $etag := len (regexFind "\\d+\\.\\d+\\.\\d+" .Values.image.tag ) }}
{{- if eq $etag 0 -}}
6.8.4
{{- else -}}
{{ regexFind "\\d+\\.\\d+\\.\\d+" .Values.image.tag }}
{{- end -}}
{{- end -}}