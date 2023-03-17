{{/*
Return the configured storage system
*/}}
{{- define "trillian.storageSystem" -}}
{{- default "mysql" .Values.storageSystem.driver }}
{{- end -}}

{{/*
Return the configured quota system
*/}}
{{- define "trillian.quotaSystem" -}}
{{- default "mysql" .Values.quotaSystem.driver }}
{{- end -}}

{{/*
Return the hostname for mysql
*/}}
{{- define "mysql.hostname" -}}
{{- default (include "trillian.mysql.fullname" .) .Values.mysql.hostname }}
{{- end -}}

{{/*
Return the database for mysql
*/}}
{{- define "mysql.database" -}}
{{- default (include "common.names.fullname" .) .Values.mysql.database }}
{{- end -}}

{{/*
Create a fully qualified Mysql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "trillian.mysql.fullname" -}}
{{- if .Values.mysql.fullnameOverride -}}
{{- .Values.mysql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.mysql.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.mysql.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified createdb job name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "trillian.createdb.fullname" -}}
{{- if .Values.createdb.fullnameOverride -}}
{{- .Values.createdb.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.createdb.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.createdb.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Create a fully qualified Log Server name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "trillian.logServer.fullname" -}}
{{- if .Values.logServer.fullnameOverride -}}
{{- .Values.logServer.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.logServer.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.logServer.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified Log Signer name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "trillian.logSigner.fullname" -}}
{{- if .Values.logSigner.fullnameOverride -}}
{{- .Values.logSigner.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.logSigner.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.logSigner.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Create the name of the service account to use for the mysql component
*/}}
{{- define "trillian.serviceAccountName.mysql" -}}
{{- if .Values.mysql.serviceAccount.create -}}
    {{ default (include "trillian.mysql.fullname" .) .Values.mysql.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.mysql.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the Trillian createdb job.
*/}}
{{- define "trillian.serviceAccountName.createdb" -}}
{{- if .Values.createdb.serviceAccount.create -}}
    {{ default (include "trillian.createdb.fullname" .) .Values.createdb.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.createdb.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the Trillian Log Signer component
*/}}
{{- define "trillian.serviceAccountName.logSigner" -}}
{{- if .Values.logSigner.serviceAccount.create -}}
    {{ default (include "trillian.logSigner.fullname" .) .Values.logSigner.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.logSigner.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the Trillian Log Signer component
*/}}
{{- define "trillian.serviceAccountName.logServer" -}}
{{- if .Values.logServer.serviceAccount.create -}}
    {{ default (include "trillian.logServer.fullname" .) .Values.logServer.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.logServer.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Log Server Arguments
*/}}
{{- define "trillian.logServer.args" -}}
- {{ printf "--storage_system=%s" (include "trillian.storageSystem" .) | quote }}
- {{ printf "--quota_system=%s" (include "trillian.quotaSystem" .) | quote }}
{{- if eq (include "trillian.storageSystem" .) "mysql" }}
- "--mysql_uri=$(MYSQL_USER):$(MYSQL_PASSWORD)@tcp($(MYSQL_HOSTNAME):$(MYSQL_PORT))/$(MYSQL_DATABASE)"
{{- end }}
- {{ printf "--rpc_endpoint=0.0.0.0:%d" (.Values.logServer.portRPC | int) | quote }}
- {{ printf "--http_endpoint=0.0.0.0:%d" (.Values.logServer.portHTTP | int) | quote }}
- "--alsologtostderr"
{{-  range .Values.logServer.extraArgs }}
- {{ . | quote }}
{{ end }}
{{- end -}}

{{/*
Log Signer Arguments
*/}}
{{- define "trillian.logSigner.args" -}}
- {{ printf "--storage_system=%s" (include "trillian.storageSystem" .) | quote }}
- {{ printf "--quota_system=%s" (include "trillian.quotaSystem" .) | quote }}
{{- if eq (include "trillian.storageSystem" .) "mysql" }}
- "--mysql_uri=$(MYSQL_USER):$(MYSQL_PASSWORD)@tcp($(MYSQL_HOSTNAME):$(MYSQL_PORT))/$(MYSQL_DATABASE)"
{{- end }}
- {{ printf "--rpc_endpoint=0.0.0.0:%d" (.Values.logSigner.portRPC | int) | quote }}
- {{ printf "--http_endpoint=0.0.0.0:%d" (.Values.logSigner.portHTTP | int) | quote }}
- {{ printf "--force_master=%t" (default true .Values.logSigner.forceMaster) | quote }}
- "--alsologtostderr"
{{-  range .Values.logSigner.extraArgs }}
- {{ . | quote }}
{{ end }}
{{- end -}}


{{/*
Create labels for trillian components
*/}}
{{- define "trillian.mysql.labels" -}}
{{ include "trillian.labels.componentLabels" (dict "context" . "component" .Values.mysql.name) }}
{{- end -}}

{{- define "trillian.mysql.selectorLabels" -}}
{{ include "trillian.labels.componentSelectorLabels" (dict "context" . "component" .Values.mysql.name) }}
{{- end -}}

{{- define "trillian.logServer.labels" -}}
{{ include "trillian.labels.componentLabels" (dict "context" . "component" .Values.logServer.name) }}
{{- end -}}

{{- define "trillian.logServer.selectorLabels" -}}
{{ include "trillian.labels.componentSelectorLabels" (dict "context" . "component" .Values.logServer.name) }}
{{- end -}}

{{- define "trillian.logSigner.labels" -}}
{{ include "trillian.labels.componentLabels" (dict "context" . "component" .Values.logSigner.name) }}
{{- end -}}

{{- define "trillian.logSigner.selectorLabels" -}}
{{ include "trillian.labels.componentSelectorLabels" (dict "context" . "component" .Values.logSigner.name) }}
{{- end -}}

{{/*
Move to Common Chart!
*/}}
{{- define "trillian.labels.componentLabels" -}}
{{ include "common.labels.labels" .context }}
app.kubernetes.io/component: {{ .component | quote }}
{{- end -}}

{{- define "trillian.labels.componentSelectorLabels" -}}
{{ include "common.labels.selectorLabels" .context }}
app.kubernetes.io/component: {{ .component | quote }}
{{- end -}}


{{/*
Create the name of the service account to use
*/}}
{{- define "trillian.serviceAccountName" -}}
{{- if .Values.server.serviceAccount.create }}
{{- default (include "trillian.fullname" .) .Values.server.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.server.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the secret with MySQL credentials
*/}}
{{- define "mysql.secretName" -}}
    {{- if .Values.mysql.auth.existingSecret -}}
        {{- printf "%s" .Values.mysql.auth.existingSecret -}}
    {{- else -}}
        {{- printf "%s" (include "trillian.mysql.fullname" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Return a random Secret value or the value of an exising Secret key value
*/}}
{{- define "trillian.randomSecret" -}}
{{- $randomSecret := (randAlphaNum 10) }}
{{- $secret := (lookup "v1" "Secret" .context.Release.Namespace .secretName) }}
{{- if $secret }}
{{- if hasKey $secret.data .key }}
{{- print (index $secret.data .key) | b64dec }}
{{- else }}
{{- print $randomSecret }}
{{- end }}
{{- else }}
{{- print $randomSecret }}
{{- end }}
{{- end -}}

{{/*
Place default environment credentials setup
*/}}
{{- define "trillian.storageSystem.envCredentials" -}}
{{- if .Values.storageSystem.envCredentials }}
{{ toYaml .Values.storageSystem.envCredentials }}
{{- else }}
- name: MYSQL_USER
  valueFrom:
    secretKeyRef:
        name: {{ template "mysql.secretName" . }}
        key: mysql-user
- name: MYSQL_PASSWORD
  valueFrom:
    secretKeyRef:
        name: {{ template "mysql.secretName" . }}
        key: mysql-password
- name: MYSQL_DATABASE
  valueFrom:
    secretKeyRef:
        name: {{ template "mysql.secretName" . }}
        key: mysql-database
- name: MYSQL_HOSTNAME
  value: {{ template "mysql.hostname" . }}
- name: MYSQL_PORT
  value: {{ .Values.mysql.port | quote }}
{{- end }}
{{- end -}}