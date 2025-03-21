# Bitcoin Core Chart

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 27.2](https://img.shields.io/badge/AppVersion-27.2-informational?style=flat-square)

A Helm chart for deploying Bitcoin Core nodes

## Prerequisites
Before deploying this chart, ensure your Kubernetes cluster meets the following requirements:

1. Kubernetes 1.19+ – This chart uses features that are supported on Kubernetes 1.19 and above.
2. Helm 3.0+ – Helm 3 is required to manage and deploy this chart.
3. Persistent storage – Bitcoin Core requires significant disk space for blockchain data.

## Installation

### Helm

1. Add the Helm chart repo

```bash
helm repo add k8s-charts https://kriegalex.github.io/k8s-charts/
helm repo update
```

2. Inspect & modify the default values (optional)

```bash
helm show values k8s-charts/bitcoin-core > custom-values.yaml
```

3. Install the chart

```bash
helm upgrade --install bitcoin-core k8s-charts/bitcoin-core --values custom-values.yaml
```

## Using Different Bitcoin Core Images

This chart is designed to work primarily with the `blockstream/bitcoind` image, but it can be adapted to work with other Bitcoin Core images by adjusting the `paths` configuration in your values file:

```yaml
# Example for using a different Bitcoin Core image
image:
  repository: ruimarinho/bitcoin-core
  tag: "27.2"

paths:
  dataDir: "/home/bitcoin/.bitcoin"  # Adjust based on the image's data directory
  configFile: "/home/bitcoin/.bitcoin/bitcoin.conf"  # Adjust based on the image's config path
```

**Note**: While this chart allows for using alternative Bitcoin Core images, compatibility is not guaranteed. Different images may:
- Have different environment variable expectations
- Use different directory structures
- Have different startup parameters

You may need to customize additional settings or even modify the templates for complete compatibility with alternative images.

## Accessing Bitcoin Core

### RPC Access

To access the Bitcoin Core RPC from within the cluster:

```bash
kubectl exec -it sts/bitcoin-core-0 -- bitcoin-cli -rpcuser=YOUR_RPC_USER -rpcpassword=YOUR_RPC_PASSWORD getblockchaininfo
```

To retrieve the auto-generated RPC password (if not manually set):

```bash
kubectl get secret bitcoin-core-auth -o jsonpath="{.data.BTC_RPCPASSWORD}" | base64 --decode
```

### Port Forwarding

For local access to Bitcoin Core:

```bash
# For RPC access (HTTP)
kubectl port-forward sts/bitcoin-core-0 8332:8332

# For P2P network access (TCP)
kubectl port-forward sts/bitcoin-core-0 8333:8333
```

## Storage Considerations

Bitcoin Core requires significant storage for the full blockchain:
- Bitcoin Mainnet: 500+ GB (and growing)
- Bitcoin Testnet: 40+ GB (and growing)

Ensure your persistent volume has adequate capacity. The StatefulSet uses volumeClaimTemplates to provision storage:

```yaml
persistence:
  size: 500Gi  # Adjust according to your needs
```

## Advanced Configuration

### Network Types

This chart supports all three Bitcoin network types:
- Mainnet (default): The main Bitcoin network
- Testnet: Test network for development
- Regtest: Local regression testing

To enable testnet:
```yaml
bitcoind:
  testnet: true
```

To enable regtest:
```yaml
bitcoind:
  regtest: true
```

### Storage Optimization

For nodes with limited storage, you can enable pruning:

```yaml
bitcoind:
  pruning: true
  prunesize: 1000  # Size in MiB to target (minimum 550)
```

### Performance Tuning

For better performance, especially on nodes with more resources:

```yaml
bitcoind:
  dbCache: 4096  # Allocate 4GB for database cache
  sync:
    parallelblocks: 16  # Download more blocks in parallel (1-16)
    maxconnections: 125  # Maximum connections to maintain
```

### Advanced Indexing

Enable additional indexes for specific use cases:

```yaml
bitcoind:
  txIndex: true              # Full transaction index
  blockfilterIndex: true     # Compact block filters (BIP158)
  coinstatsIndex: true       # Coinstats index for faster balance calculations
```

### Initial Sync Optimization

For faster initial synchronization, you can use assumevalid:

```yaml
bitcoind:
  sync:
    assumevalid: "00000000000000000008a89e854d57e5667df88f1cdef6fde2fbca1de5b639ad"  # Recent block hash
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | {} | Affinity for pod assignment |
| bitcoind.blockfilterIndex | bool | `false` | Enable compact block filter index (BIP158) |
| bitcoind.coinstatsIndex | bool | `false` | Enable coinstats index |
| bitcoind.customConfig | string | "" | Custom bitcoin.conf file content @description -- If provided, this will be mounted as a configuration file. Note: This takes precedence over individual settings when both are provided. |
| bitcoind.dbCache | int | `0` | Size of database cache in MB @description -- 0 means use default value |
| bitcoind.disableWallet | bool | `true` | Disable the wallet functionality |
| bitcoind.extraConfig | object | `{}` | Additional custom parameters for bitcoin.conf @example extraConfig:   blockfilterindex: 1   peerblockfilters: 1 |
| bitcoind.prunesize | int | `550` | Prune target size in MiB (only used when pruning is enabled) Must be at least 550 MiB |
| bitcoind.pruning | bool | `false` | Enable blockchain pruning to reduce disk usage |
| bitcoind.regtest | bool | `false` | Enable regtest mode (local testing) |
| bitcoind.rpc.allowip | string | `"10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,127.0.0.1,::1"` | IP addresses allowed to connect to RPC (IPv4, IPv6 or CIDR notation) Default restricts to pod networks and localhost |
| bitcoind.rpc.bind | string | `"0.0.0.0"` | IP address for RPC interface to bind to Use 0.0.0.0 to allow connections from any source within the cluster |
| bitcoind.rpc.clienttimeout | int | `30` | How many seconds to wait for a response from a given call before timing out |
| bitcoind.rpc.password | string | "" | Password for RPC authentication @description -- If not provided, a random password will be generated |
| bitcoind.rpc.port | int | `8332` | Port for RPC interface |
| bitcoind.rpc.user | string | `"btc"` | Username for RPC authentication |
| bitcoind.sync.assumevalid | string | "" | Assume this block hash as valid (reduces initial block download time) |
| bitcoind.sync.maxconnections | int | `125` | Maximum number of connections to other nodes (network dependent) |
| bitcoind.sync.maxinboundconnections | int | `125` | Maximum number of inbound connections (network dependent) |
| bitcoind.sync.parallelblocks | int | `8` | Number of blocks to download in parallel during synchronization (1-16) |
| bitcoind.testnet | bool | `false` | Enable testnet instead of mainnet |
| bitcoind.txIndex | bool | `false` | Maintain a full transaction index |
| bitcoind.zmq.enabled | bool | `false` | Enable ZMQ notifications |
| bitcoind.zmq.hashBlock | string | `"tcp://0.0.0.0:28333"` | ZMQ notification endpoint for block hash notifications |
| bitcoind.zmq.hashTx | string | `"tcp://0.0.0.0:28333"` | ZMQ notification endpoint for transaction hash notifications |
| bitcoind.zmq.rawBlock | string | `"tcp://0.0.0.0:28333"` | ZMQ notification endpoint for raw block notifications |
| bitcoind.zmq.rawTx | string | `"tcp://0.0.0.0:28333"` | ZMQ notification endpoint for raw transaction notifications |
| fullnameOverride | string | `""` | String to fully override bitcoin-core.fullname template |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.repository | string | `"blockstream/bitcoind"` | Docker repository for Bitcoin Core image |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion |
| imagePullSecrets | list | `[]` | Image pull secrets for private Docker registry |
| metrics.enabled | bool | `false` | Enable Prometheus metrics exporter sidecar |
| metrics.image | string | `"prometheuscommunity/bitcoin-exporter:latest"` | Container image for metrics |
| metrics.port | int | `9332` | Metrics container port |
| metrics.pullPolicy | string | `"IfNotPresent"` | Metrics image pull policy |
| metrics.resources | object | `{"limits":{"cpu":"200m","memory":"256Mi"},"requests":{"cpu":"100m","memory":"128Mi"}}` | Resources for metrics container |
| metrics.serviceAnnotations | object | `{"prometheus.io/port":"9332","prometheus.io/scrape":"true"}` | Metrics service annotations |
| metrics.servicePort | int | `9332` | Metrics service port |
| nameOverride | string | `""` | String to partially override bitcoin-core.fullname template |
| networkPolicy.enabled | bool | `false` | Enable network policy for Bitcoin Core |
| networkPolicy.p2pAllowFrom | list | [] | Define which pods can access the Bitcoin P2P interface Leave empty to allow all pods to connect to P2P network |
| networkPolicy.rpcAllowFrom | list | [] | Define which pods can access the Bitcoin RPC interface |
| networkPolicy.zmqAllowFrom | list | [] | Define which pods can access the ZMQ interface |
| nodeSelector | object | {} | Node selector for pod assignment |
| paths.configFile | string | `"/bitcoin.conf"` | Path where bitcoin.conf should be mounted when using custom config |
| paths.dataDir | string | `"/bitcoin/data"` | Directory where Bitcoin Core stores blockchain data |
| persistence.accessModes | list | `["ReadWriteOnce"]` | Access modes for the PVC |
| persistence.annotations | object | {} | Annotations for the PVC |
| persistence.enabled | bool | `true` | Enable persistent storage for blockchain data |
| persistence.existingClaim | string | "" | Use an existing PVC |
| persistence.size | string | `"500Gi"` | Size of the PVC for blockchain data |
| persistence.storageClass | string | "" | Storage class for the blockchain PVC @description -- If defined, storageClass: <storageClass> If set to "-", storageClass: "", which disables dynamic provisioning If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner |
| persistence.waitForBind | bool | `true` | Wait for the PVC to be bound before starting the pod @description -- Setting this to false may help in environments where PVs are created on-demand |
| podAnnotations | object | `{}` | Annotations to add to pods |
| podDisruptionBudget.enabled | bool | `false` | Enable PDB |
| podDisruptionBudget.maxUnavailable | string | `nil` | Maximum unavailable pods |
| podDisruptionBudget.minAvailable | int | `1` | Minimum available pods |
| podSecurityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` | Security context for the pod |
| probes.liveness.command | list | `["/bin/sh","-c","bitcoin-cli -rpcuser=$BTC_RPCUSER -rpcpassword=$BTC_RPCPASSWORD getblockchaininfo"]` | Command for exec probe (only used when type is exec) |
| probes.liveness.enabled | bool | `true` | Enable liveness probe |
| probes.liveness.failureThreshold | int | `3` | Failure threshold |
| probes.liveness.initialDelaySeconds | int | `60` | Initial delay seconds |
| probes.liveness.path | string | `"/v2/info"` | Path for HTTP GET requests (only used when type is httpGet) |
| probes.liveness.periodSeconds | int | `30` | Period seconds |
| probes.liveness.timeoutSeconds | int | `5` | Timeout seconds |
| probes.liveness.type | string | `"tcpSocket"` | Probe type: httpGet, tcpSocket, or exec |
| probes.readiness.command | list | `["/bin/sh","-c","bitcoin-cli -rpcuser=$BTC_RPCUSER -rpcpassword=$BTC_RPCPASSWORD getblockchaininfo"]` | Command for exec probe (only used when type is exec) |
| probes.readiness.enabled | bool | `true` | Enable readiness probe |
| probes.readiness.failureThreshold | int | `3` | Failure threshold |
| probes.readiness.initialDelaySeconds | int | `30` | Initial delay seconds |
| probes.readiness.path | string | `"/v2/info"` | Path for HTTP GET requests (only used when type is httpGet) |
| probes.readiness.periodSeconds | int | `10` | Period seconds |
| probes.readiness.successThreshold | int | `1` | Success threshold |
| probes.readiness.timeoutSeconds | int | `5` | Timeout seconds |
| probes.readiness.type | string | `"tcpSocket"` | Probe type: httpGet, tcpSocket, or exec |
| probes.startup.command | list | `["/bin/sh","-c","bitcoin-cli -rpcuser=$BTC_RPCUSER -rpcpassword=$BTC_RPCPASSWORD getblockchaininfo"]` | Command for exec probe (only used when type is exec) |
| probes.startup.enabled | bool | `true` | Enable startup probe |
| probes.startup.failureThreshold | int | `30` | Failure threshold |
| probes.startup.initialDelaySeconds | int | `30` | Initial delay seconds |
| probes.startup.path | string | `"/v2/info"` | Path for HTTP GET requests (only used when type is httpGet) |
| probes.startup.periodSeconds | int | `10` | Period seconds |
| probes.startup.timeoutSeconds | int | `5` | Timeout seconds |
| probes.startup.type | string | `"tcpSocket"` | Probe type: httpGet, tcpSocket, or exec |
| resources | object | `{"limits":{"cpu":4,"memory":"8Gi"},"requests":{"cpu":1,"memory":"2Gi"}}` | Resource requests and limits |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"readOnlyRootFilesystem":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context for the container |
| service.p2pPort | int | `8333` | Port for P2P connections |
| service.rpcPort | int | `8332` | Port for RPC interface |
| service.type | string | `"ClusterIP"` | Service type |
| service.zmqPort | int | `28333` | Port for ZMQ notifications |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | "" | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | [] | Tolerations for pod assignment |
| topologySpreadConstraints | list | `[]` | Topology spread constraints for pod distribution |
