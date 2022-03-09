# Cosigned Admission Webhook

## Requirements

* Kubernetes cluster with rights to install admission webhooks
* Helm

## Parameters

The following table lists the configurable parameters of the cosigned chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| commonNodeSelector | object | `{}` |  |
| commonTolerations | list | `[]` |  |
| cosign.cosignPub | string | `""` |  |
| cosign.secretKeyRef.name | string | `""` |  |
| serviceMonitor.enabled | bool | `false` |  |
| webhook.env | object | `{}` |  |
| webhook.extraArgs | object | `{}` |  |
| webhook.image.pullPolicy | string | `"IfNotPresent"` |  |
| webhook.image.repository | string | `"gcr.io/projectsigstore/cosigned"` |  |
| webhook.image.version | string | `"sha256:18c7db5051c0d5ac147b1785567ef647f23f7949ae5858776561cfc9cd8cc4b2"` |  |
| webhook.name | string | `"webhook"` |  |
| webhook.podSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| webhook.podSecurityContext.capabilities.drop[0] | string | `"all"` |  |
| webhook.podSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| webhook.podSecurityContext.runAsUser | int | `1000` |  |
| webhook.resources.limits.cpu | string | `"100m"` |  |
| webhook.resources.limits.memory | string | `"256Mi"` |  |
| webhook.resources.requests.cpu | string | `"100m"` |  |
| webhook.resources.requests.memory | string | `"128Mi"` |  |
| webhook.securityContext.enabled | bool | `false` |  |
| webhook.securityContext.runAsUser | int | `65532` |  |
| webhook.service.annotations | object | `{}` |  |
| webhook.service.port | int | `443` |  |
| webhook.service.type | string | `"ClusterIP"` |  |
| webhook.serviceAccount.annotations | object | `{}` |  |

----------------------------------------------

### Deploy `cosigned` Helm Chart

```shell
export COSIGN_PASSWORD=<my_cosign_password>
cosign generate-key-pair
```

The previous command generates two key files `cosign.key` and `cosign.pub`. Next, create a secret to validate the signatures:

```shell
kubectl create namespace cosign-system

kubectl create secret generic mysecret -n \
cosign-system --from-file=cosign.pub=./cosign.pub
```

Install `cosigned` using Helm and setting the value of the secret key reference to `mysecret` that you created above:

```shell
helm repo add sigstore https://sigstore.github.io/helm-charts

helm repo update

helm install cosigned -n cosign-system sigstore/cosigned --devel --set cosign.secretKeyRef.name=mysecret
```

### Enabling Admission control

To enable the `cosigned admission webhook` to check for signed images, you will need to add the following label in each namespace that you would want the webhook triggered:

Label: `cosigned.sigstore.dev/include: "true"`

```yaml
apiVersion: v1
kind: Namespace
metadata:
  labels:
    cosigned.sigstore.dev/include: "true"
    kubernetes.io/metadata.name: my-namespace
  name: my-namespace
spec:
  finalizers:
  - kubernetes
```

### Testing the webhook

1. Using Unsigned Images:
Creating a deployment referencing images that are not signed will yield the following error and no resources will be created:

    ```shell
    kubectl apply -f my-deployment.yaml
    Error from server (BadRequest): error when creating "my-deployment.yaml": admission webhook "cosigned.sigstore.dev" denied the request: validation failed: invalid image signature: spec.template.spec.containers[0].image
    ```

2. Using Signed Images: Assuming a signed `nginx` image with a tag `signed` exists on a registry, the resource will be successfully created.

   ```shell
   kubectl run pod1-signed  --image=< REGISTRY_USER >/nginx:signed -n testns
   pod/pod1-signed created
   ```
