# rekor

[Rekor](https://docs.sigstore.dev/rekor/overview/) provides a restful API based server for validation and a transparency log for storage.

The following components are also included as either direct components or through chart dependencies:

* [MySQL](https://www.mysql.com)
* [Redis](https://redis.io)
* [Trillian Log Server](https://github.com/google/trillian)
* [Trillian Log Signer](https://github.com/google/trillian)

## Quick Installation

```shell
helm dependency update .
helm install [RELEASE_NAME] .
```

This command deploys the default configuration for the rekor chart. The [Parameters] section describes the various ways in which the chart can be configured.

## Uninstallation

```shell
helm uninstall [RELEASE_NAME]
```

The previous command removes the previously installed chart.

## Parameters

The following table lists the configurable parameters of the Rekor chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| createtree.image.pullPolicy | string | `"IfNotPresent"` |  |
| createtree.image.registry | string | `"ghcr.io"` |  |
| createtree.image.repository | string | `"vaikas/createtree"` |  |
| createtree.image.version | string | `"sha256:030ac4741bb73255c2b45e2b26c7350f4ce64992b74995854f92d8f617864a58"` |  |
| createtree.name | string | `"createtree"` |  |
| createtree.serviceAccount.annotations | object | `{}` |  |
| createtree.serviceAccount.create | bool | `true` |  |
| createtree.serviceAccount.name | string | `""` |  |
| forceNamespace | string | `""` |  |
| imagePullSecrets | string | `nil` |  |
| initContainerImage.curl.imagePullPolicy | string | `"IfNotPresent"` |  |
| initContainerImage.curl.registry | string | `"docker.io"` |  |
| initContainerImage.curl.repository | string | `"curlimages/curl"` |  |
| initContainerImage.curl.version | string | `"sha256:faaba66e89c87fd3fb51336857142ee6ce78fa8d8f023a5713d2bf4957f1aca8"` | 7.81.0 |
| namespace.create | bool | `false` |  |
| namespace.name | string | `"rekor-system"` |  |
| redis.args[0] | string | `"--bind"` |  |
| redis.args[1] | string | `"0.0.0.0"` |  |
| redis.args[2] | string | `"--appendonly"` |  |
| redis.args[3] | string | `"yes"` |  |
| redis.enabled | bool | `true` |  |
| redis.hostname | string | `""` |  |
| redis.image.pullPolicy | string | `"IfNotPresent"` |  |
| redis.image.registry | string | `"docker.io"` |  |
| redis.image.repository | string | `"redis"` |  |
| redis.image.version | string | `"sha256:0a0d563fd6fe5361316dd53f7f0a244656675054302567230e85eb114f683db4"` | 5.0.10 |
| redis.name | string | `"redis"` |  |
| redis.port | int | `6379` |  |
| redis.readinessProbe.exec.command[0] | string | `"/bin/sh"` |  |
| redis.readinessProbe.exec.command[1] | string | `"-i"` |  |
| redis.readinessProbe.exec.command[2] | string | `"-c"` |  |
| redis.readinessProbe.exec.command[3] | string | `"test \"$(redis-cli -h 127.0.0.1 ping)\" = \"PONG\""` |  |
| redis.readinessProbe.failureThreshold | int | `3` |  |
| redis.readinessProbe.initialDelaySeconds | int | `5` |  |
| redis.readinessProbe.periodSeconds | int | `10` |  |
| redis.readinessProbe.successThreshold | int | `1` |  |
| redis.readinessProbe.timeoutSeconds | int | `1` |  |
| redis.replicaCount | int | `1` |  |
| redis.resources | object | `{}` |  |
| redis.service.ports[0].name | string | `"6379-tcp"` |  |
| redis.service.ports[0].port | int | `6379` |  |
| redis.service.ports[0].protocol | string | `"TCP"` |  |
| redis.service.ports[0].targetPort | int | `6379` |  |
| redis.service.type | string | `"ClusterIP"` |  |
| redis.serviceAccount.annotations | object | `{}` |  |
| redis.serviceAccount.create | bool | `true` |  |
| redis.serviceAccount.name | string | `""` |  |
| server.attestation_storage.bucket | string | `"file:///var/run/attestations"` |  |
| server.attestation_storage.enabled | bool | `true` |  |
| server.attestation_storage.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| server.attestation_storage.persistence.annotations | object | `{}` |  |
| server.attestation_storage.persistence.enabled | bool | `true` |  |
| server.attestation_storage.persistence.existingClaim | string | `""` |  |
| server.attestation_storage.persistence.mountPath | string | `"/var/lib/mysql"` |  |
| server.attestation_storage.persistence.size | string | `"5Gi"` |  |
| server.attestation_storage.persistence.storageClass | string | `nil` |  |
| server.attestation_storage.persistence.subPath | string | `""` |  |
| server.config.key | string | `"treeID"` |  |
| server.deploymentAnnotations."prometheus.io/path" | string | `"/metrics"` |  |
| server.deploymentAnnotations."prometheus.io/port" | string | `"2112"` |  |
| server.deploymentAnnotations."prometheus.io/scrape" | string | `"true"` |  |
| server.enabled | bool | `true` |  |
| server.extraArgs | list | `[]` |  |
| server.image.pullPolicy | string | `"IfNotPresent"` |  |
| server.image.registry | string | `"gcr.io"` |  |
| server.image.repository | string | `"projectsigstore/rekor-server"` |  |
| server.image.version | string | `"sha256:516651575db19412c94d4260349a84a9c30b37b5d2635232fba669262c5cbfa6"` | v0.5.0 |
| server.ingress.annotations | object | `{}` |  |
| server.ingress.enabled | bool | `true` |  |
| server.ingress.path | string | `"/"` |  |
| server.ingress.tls | object | `{}` |  |
| server.livenessProbe.failureThreshold | int | `3` |  |
| server.livenessProbe.httpGet.path | string | `"/ping"` |  |
| server.livenessProbe.httpGet.port | int | `3000` |  |
| server.livenessProbe.initialDelaySeconds | int | `30` |  |
| server.livenessProbe.periodSeconds | int | `10` |  |
| server.livenessProbe.successThreshold | int | `1` |  |
| server.livenessProbe.timeoutSeconds | int | `1` |  |
| server.logging.production | bool | `false` |  |
| server.name | string | `"server"` |  |
| server.port | int | `3000` |  |
| server.readinessProbe.failureThreshold | int | `3` |  |
| server.readinessProbe.httpGet.path | string | `"/ping"` |  |
| server.readinessProbe.httpGet.port | int | `3000` |  |
| server.readinessProbe.initialDelaySeconds | int | `10` |  |
| server.readinessProbe.periodSeconds | int | `10` |  |
| server.readinessProbe.successThreshold | int | `1` |  |
| server.readinessProbe.timeoutSeconds | int | `1` |  |
| server.replicaCount | int | `1` |  |
| server.resources | object | `{}` |  |
| server.retrieve_api.enabled | bool | `true` |  |
| server.service.ports[0].name | string | `"3000-tcp"` |  |
| server.service.ports[0].port | int | `80` |  |
| server.service.ports[0].protocol | string | `"TCP"` |  |
| server.service.ports[0].targetPort | int | `3000` |  |
| server.service.ports[1].name | string | `"2112-tcp"` |  |
| server.service.ports[1].port | int | `2112` |  |
| server.service.ports[1].protocol | string | `"TCP"` |  |
| server.service.ports[1].targetPort | int | `2112` |  |
| server.service.type | string | `"ClusterIP"` |  |
| server.serviceAccount.annotations | object | `{}` |  |
| server.serviceAccount.create | bool | `true` |  |
| server.serviceAccount.name | string | `""` |  |
| trillian.createtree.fullnameOverride | string | `"trillian-checktree"` |  |
| trillian.enabled | bool | `true` |  |
| trillian.forceNamespace | string | `"trillian-system"` |  |
| trillian.fullnameOverride | string | `"trillian"` |  |
| trillian.logServer.fullnameOverride | string | `"trillian-logserver"` |  |
| trillian.logServer.name | string | `"trillian-logserver"` |  |
| trillian.logServer.portHTTP | int | `8090` |  |
| trillian.logServer.portRPC | int | `8091` |  |
| trillian.logSigner.fullnameOverride | string | `"trillian-logsigner"` |  |
| trillian.logSigner.name | string | `"trillian-logsigner"` |  |
| trillian.mysql.fullnameOverride | string | `"trillian-mysql"` |  |
| trillian.namespace.create | bool | `true` |  |
| trillian.namespace.name | string | `"trillian-system"` |  |

----------------------------------------------

## MySQL Credentials

Credentials for running (when deployed) and connecting to MySQL are stored in a secret resource. The _passsword_ and _root password_ are automatically generated when not provided.

_Note:_ If you plan to perform an upgrade of the chart, be sure to specify these values explicitly.

An existing secret containing credentials for MySQL can be provided by passing the `mysql.auth.existingSecret` parameter. This secret must have the following keys:

* `mysql-password` - Password for connecting to MySQL
* `mysql-root-password` - Root Password (required when deploying MySQL)

## Integration with External Components

By Default, the chart deploys all required services. However, configurations can be applied to offload certain services, such as Redis and MySQL externally.

To disable the deployment of Redis or MySQL, pass the `redis.enabled=false` and/or `mysql.enabled=false`. Provide the hostname and port of the external resource using the `<redis|mysql>.hostname` and `<redis|mysql>.port` parameters.

## Ingress

To enabled access from external resources, an Ingress resource is created. The configuration necessary for each Ingress resource is primarily dependent on the specific Ingress Controller being used. In most cases, implementation specific configuration is specified as annotations on the Ingress resources. These can be applied using the `server.ingress.annotations` parameter.
