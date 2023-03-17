{{/*
Create the name of the service account to use
*/}}
{{- define "tuf.serviceAccountName" -}}
{{- if .Values.server.serviceAccount.create }}
{{- default (include "common.names.fullname" .) .Values.server.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.server.serviceAccount.name }}
{{- end }}
{{- end }}