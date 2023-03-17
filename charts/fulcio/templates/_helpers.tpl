{{/*
Create a fully qualified createcerts name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fulcio.createcerts.fullname" -}}
{{- if .Values.createcerts.fullnameOverride -}}
{{- .Values.createcerts.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.createcerts.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.createcerts.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the createcerts component
*/}}
{{- define "fulcio.serviceAccountName.createcerts" -}}
{{- if .Values.createcerts.serviceAccount.create -}}
    {{ default (include "fulcio.createcerts.fullname" .) .Values.createcerts.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.createcerts.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Create the name of the service account to use
*/}}
{{- define "fulcio.serviceAccountName" -}}
{{- if .Values.server.serviceAccount.create }}
{{- default (include "common.names.fullname" .) .Values.server.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.server.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the config
*/}}
{{- define "fulcio.config" -}}
{{ include "common.names.fullnameSuffix" (dict "suffix" "config" "context" $) }}
{{- end }}

{{/*
Create the name of the secret operator
*/}}
{{- define "fulcio.grpc" -}}
{{ include "common.names.fullnameSuffix" (dict "suffix" "grpc" "context" $) }}
{{- end }}

{{/*
Create the name of the secret operator
*/}}
{{- define "fulcio.secret-operator" -}}
{{ include "common.names.fullnameSuffix" (dict "suffix" "secret-operator" "context" $) }}
{{- end }}

{{/*
Return the grpc set of labels
*/}}
{{- define "fulcio.grpc.labels" -}}
{{- include "common.names.labelsNameSuffix" (dict "labels" (include "common.labels.labels" $) "suffix" "grpc") }}
{{- end }}

{{/*
Return the grpc set of selector labels
*/}}
{{- define "fulcio.grpc.selectorLabels" -}}
{{- include "common.names.labelsNameSuffix" (dict "labels" (include "common.labels.selectorLabels" $) "suffix" "grpc") }}
{{- end }}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "fulcio.server.ingress.backend" -}}
{{- $root := index . 0 -}}
{{- $local := index . 1 -}}
{{- $servicePort := index . 2 -}}
service:
  name: {{ (default (include "common.names.fullname" $root) $local.service_name) }}
  port:
    number: {{ $servicePort | int }}
{{- end -}}

{{/*
Return the contents for fulcio config.
*/}}
{{- define "fulcio.configmap.contents" -}}
{{- if .Values.config.contents -}}
{{- toPrettyJson .Values.config.contents }}
{{- else -}}
{
  "OIDCIssuers": {
    "https://kubernetes.default.svc": {
      "IssuerURL": "https://kubernetes.default.svc",
      "ClientID": "sigstore",
      "Type": "kubernetes"
    }
  },
  "MetaIssuers": {
    "https://kubernetes.*.svc": {
      "ClientID": "sigstore",
      "Type": "kubernetes"
    }
  }
}
{{- end -}}
{{- end -}}
