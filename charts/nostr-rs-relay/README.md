# nostr-rs-relay

![Version: 1.0.1](https://img.shields.io/badge/Version-1.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.9.0](https://img.shields.io/badge/AppVersion-0.9.0-informational?style=flat-square)

A Helm chart for deploying a Nostr RS Relay

## Introduction

This Helm chart deploys a [nostr-rs-relay](https://github.com/scsibug/nostr-rs-relay) instance on a Kubernetes cluster. The Nostr relay provides a server for the Nostr (Notes and Other Stuff Transmitted by Relays) protocol, a decentralized social network with no central authority.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)

## Installing the Chart

To install the chart with the release name `my-relay`:

```bash
helm install my-relay ./nostr-relay
```

## Uninstalling the Chart

To uninstall/delete the `my-relay` deployment:

```bash
helm delete my-relay
```

## Configuration

The following table lists the configurable parameters for the nostr-relay chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| config.info.description | string | `"A nostr-rs-relay on kubernetes."` | Description of your relay (required) |
| config.info.name | string | `"nostr-rs-relay"` | Name of your relay (required) |
| config.info.relay_url | string | `"wss://nostr.k3s.home/"` | The public-facing URL of your relay with the websocket schema (required) |
| config.limits.limit_scrapers | bool | `false` | Rejects imprecise requests (kind only and author only etc) |
| config.network | object | `{"address":"0.0.0.0","port":8080}` | Whether the event admission server denies writes restricts_write: false Network settings |
| config.network.address | string | `"0.0.0.0"` | Network binding address |
| config.network.port | int | `8080` | Network port |
| config.options.reject_future_seconds | int | `1800` | Reject events that claim to be created too far in the future (seconds) |
| fullnameOverride | string | `""` | String to fully override nostr-relay.fullname template |
| image.pullPolicy | string | `"IfNotPresent"` | Nostr relay Docker image pull policy |
| image.repository | string | `"scsibug/nostr-rs-relay"` | Nostr relay Docker image repository |
| image.tag | string | `""` | Overrides the image tag. Default is the chart appVersion |
| imagePullSecrets | list | `[]` | Specify imagePullSecrets if your Docker repository requires authentication |
| ingress.annotations | object | `{}` | Additional ingress annotations |
| ingress.className | string | `""` | Ingress class name |
| ingress.enabled | bool | `false` | Enable ingress resource |
| ingress.hosts | list | [{ host: nostr.k3s.home }] | List of ingress hosts |
| ingress.tls | list | `[]` | Ingress TLS configuration |
| nameOverride | string | `""` | String to partially override nostr-relay.fullname template |
| persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the persistent volume |
| persistence.enabled | bool | `true` | Enable persistent storage for the database |
| persistence.size | string | `"10Gi"` | Size of the persistent volume |
| persistence.storageClass | string | `""` | StorageClass name. If empty, uses the default provisioner. |
| podAnnotations | object | `{}` | Annotations to be added to the pod |
| podSecurityContext.fsGroup | int | `1000` | Group ID for filesystem access |
| podSecurityContext.runAsGroup | int | `1000` | Group ID for the pod |
| podSecurityContext.runAsUser | int | `1000` | User ID for the pod |
| replicaCount | int | `1` | Number of nostr-relay replicas |
| resources | object | `{}` | Resource limits and requests for the relay |
| securityContext.runAsGroup | int | `1000` | Group ID to run the container |
| securityContext.runAsNonRoot | bool | `true` | Run container as non-root user |
| securityContext.runAsUser | int | `1000` | User ID to run the container |
| service.port | int | `8080` | Kubernetes Service port |
| service.type | string | `"ClusterIP"` | Kubernetes Service type |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |

## Persistence

This chart mounts a Persistent Volume for the database. The volume is created using dynamic volume provisioning. If you want to disable this (and instead use an emptyDir volume), set `persistence.enabled` to `false`.

## Ingress and Reverse Proxy

This chart includes support for Ingress resources. If you have an Ingress controller installed on your cluster, such as [nginx-ingress](https://kubernetes.github.io/ingress-nginx/) or [traefik](https://traefik.io/), you can utilize the ingress controller to serve your Nostr relay.

For proper WebSocket support in an ingress configuration, you may need to add specific annotations. For example, with NGINX:

```yaml
ingress:
  enabled: true
  annotations:
    nginx.ingress.kubernetes.io/proxy-read-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-body-size: "64m"
  hosts:
    - host: relay.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: relay-tls
      hosts:
        - relay.example.com
```

## NIP-05 Verification

To enable NIP-05 verification, set `config.nip05.enabled` to `true` and configure your domain and users:

```yaml
config:
  nip05:
    enabled: true
    domain: "example.com"
    users:
      alice: "pubkey1"
      bob: "pubkey2"
```

This will allow users to verify their identities using the format `alice@example.com` or `bob@example.com`.

## Using with Kubernetes

Once your relay is deployed, you can access it using the service endpoint. The default configuration creates a ClusterIP service, which means it's only accessible within the cluster.

### Accessing the Relay

1. For internal cluster access:
   ```
   ws://RELEASE-NAME-nostr-relay.NAMESPACE.svc.cluster.local:8080
   ```

2. To access from your local machine:
   ```bash
   kubectl port-forward --namespace NAMESPACE svc/RELEASE-NAME-nostr-relay 8080:8080
   ```
   Then connect to `ws://localhost:8080`

3. If you enabled Ingress, use the domain you specified.

### Checking Logs

To view the logs of your relay:
```bash
kubectl logs -f deployment/RELEASE-NAME-nostr-relay -n NAMESPACE
```

## Notes on Production Use

For production deployments, consider:

1. Using a specific image tag rather than `latest`
2. Setting appropriate resource limits and requests
3. Enabling TLS via Ingress or another method
4. Setting up proper monitoring and backup strategies for the database
5. Configuring blacklists and rate limits to protect against abuse

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
