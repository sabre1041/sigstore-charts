

{{/*
Create the name of the service account to use
*/}}
{{- define "tsa.serviceAccountName" -}}
{{- if .Values.server.serviceAccount.create }}
{{- default (include "common.names.fullname" .) .Values.server.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.server.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the config
*/}}
{{- define "tsa.config" -}}
{{ include "common.names.fullnameSuffix" (dict "suffix" "config" "context" $) }}
{{- end }}
