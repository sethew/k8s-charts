# nostr-relay

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.9.0](https://img.shields.io/badge/AppVersion-0.9.0-informational?style=flat-square)

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
| config.database.data_directory | string | `"/usr/src/app/db"` | Directory where the database files will be stored |
| config.info.contact | string | `""` | Administrative contact for the relay |
| config.info.description | string | `"A nostr-rs-relay instance"` | Description of your relay |
| config.info.name | string | `"Nostr Relay"` | Name of your relay |
| config.info.pubkey | string | `""` | Public key of the relay administrator (hexadecimal string) |
| config.info.relay_url | string | `"wss://your-relay.example.com"` | The public-facing URL of your relay with the websocket schema (wss:// or ws://) |
| config.info.software | string | `"https://github.com/scsibug/nostr-rs-relay"` | URL of the relay software repository |
| config.info.supported_nips | list | `[1,2,4,9,11,12,15,16,20,22,28,33,40]` | List of NIPs (Nostr Implementation Possibilities) supported by this relay |
| config.info.version | string | `"0.8.7"` | Version of the relay software |
| config.network.address | string | `"0.0.0.0:8080"` | Network binding address and port |
| config.network.proxy_protocol | string | `"http"` | Proxy protocol to use (http or https) |
| config.network.real_ip_header | string | `"X-Real-IP"` | Alternative header for client's real IP |
| config.network.remote_ip_header | string | `"X-Forwarded-For"` | Header for finding the client's IP when behind a reverse proxy |
| config.nip05.domain | string | `"your-domain.com"` | Domain name for NIP-05 verification |
| config.nip05.enabled | bool | `false` | Enable NIP-05 identity verification service |
| config.nip05.users | object | `{}` | Map of usernames to public keys @example users:   alice: "pubkey1"   bob: "pubkey2" |
| config.options.blacklist_address | list | [] | IPv4 network addresses that are disallowed from connecting |
| config.options.blacklist_content | list | [] | Content patterns to be blocked in notes |
| config.options.blacklist_pubkey | list | [] | List of public keys that are not allowed to post to the relay |
| config.options.event_retention_time | int | `90` | Event retention time in days |
| config.options.max_filter_count | int | `10` | Maximum number of filters per subscription |
| config.options.max_limit | int | `300` | Maximum limit on events returned per subscription |
| config.options.max_message_length | int | `128000` | Maximum message size in bytes |
| config.options.max_subscriptions | int | `20` | Maximum number of subscriptions that a client can create |
| config.options.message_rate_per_min | int | `300` | Maximum number of events per minute clients can send |
| config.options.min_pow_difficulty | int | `0` | Minimum Proof of Work difficulty to accept (0 for no minimum) |
| config.options.min_prefix_length | int | `4` | Minimum prefix length for subscriptions |
| config.options.reject_future_seconds | int | `7200` | Reject events that claim to be created too far in the future (seconds) |
| config.options.reject_invalid_signatures | bool | `true` | Whether to reject events that don't have a valid signature |
| fullnameOverride | string | `""` | String to fully override nostr-relay.fullname template |
| image.pullPolicy | string | `"IfNotPresent"` | Nostr relay Docker image pull policy |
| image.repository | string | `"scsibug/nostr-rs-relay"` | Nostr relay Docker image repository |
| image.tag | string | `"latest"` | Overrides the image tag. Default is the chart appVersion |
| imagePullSecrets | list | [] | Specify imagePullSecrets if your Docker repository requires authentication |
| ingress.annotations | object | {} | Additional ingress annotations |
| ingress.className | string | `""` | Ingress class name |
| ingress.enabled | bool | `false` | Enable ingress resource |
| ingress.hosts | list | See below | List of ingress hosts |
| ingress.tls | list | [] | Ingress TLS configuration |
| nameOverride | string | `""` | String to partially override nostr-relay.fullname template |
| persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the persistent volume |
| persistence.enabled | bool | `true` | Enable persistent storage for the database |
| persistence.size | string | `"10Gi"` | Size of the persistent volume |
| persistence.storageClass | string | `""` | StorageClass name. If empty, uses the default provisioner. |
| podAnnotations | object | {} | Annotations to be added to the pod |
| podSecurityContext | object | {} | Security context for the pod |
| replicaCount | int | `1` | Number of nostr-relay replicas |
| resources | object | `{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Define resource limits and requests for the relay |
| securityContext | object | {} | Security context for the container |
| service.port | int | `8080` | Kubernetes Service port |
| service.type | string | `"ClusterIP"` | Kubernetes Service type |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use If not set and create is true, a name is generated using the fullname template |

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
