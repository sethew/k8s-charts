# Enshrouded Server Helm Chart

This Helm chart deploys an [Enshrouded](https://enshrouded.net/) dedicated game server on a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)

## Important Note

This Helm chart is configured to run the Enshrouded server as user `steam` with UID/GID 10000:10000, as required by the container image. The persistent volume for save data is mounted at `/home/steam/enshrouded/savegame` and must be accessible by this user.

## Installation

### Add the repository

```bash
helm repo add my-repo https://your-helm-repo.example
helm repo update
```

### Install the chart

```bash
helm install my-enshrouded-server my-repo/enshrouded-server
```
Alternatively, clone the repository and install from local files:

```bash
git clone https://github.com/your-repo/enshrouded-server-chart.git
cd enshrouded-server-chart
helm install my-enshrouded-server .
```

## Uninstallation

To uninstall/delete the my-enshrouded-server deployment:

```bash
helm delete my-enshrouded-server
```

## Parameters

### Enshrouded Server Configuration

| Name                     | Description                                  | Value                   |
|--------------------------|----------------------------------------------|-------------------------|
| `enshrouded.serverName`  | Server name displayed in the server browser  | `"My Enshrouded Server"` |
| `enshrouded.serverPassword` | Server password (leave blank for no password) | `""` |
| `enshrouded.maxPlayers`  | Maximum number of players                   | `16`                    |
| `enshrouded.saveInterval` | Game save interval in seconds               | `300`                   |
| `enshrouded.serverIP`    | Server IP address to bind to                 | `"0.0.0.0"`             |
| `enshrouded.gamePort`    | Game server port (UDP)                      | `15636`                 |
| `enshrouded.queryPort`   | Query server port (UDP)                     | `15637`                 |
| `enshrouded.timeZone`    | TZ environment variable for server time zone | `"UTC"`                 |

### ConfigMap (server extra configuration)

| Name                     | Description                                   | Value    |
|--------------------------|-----------------------------------------------|----------|
| `configMap.enabled`      | Enable additional configuration through ConfigMap | `true`  |
| `configMap.data`         | Additional environment variables for the ConfigMap | `{}`   |

### Image Configuration

| Name               | Description                                  | Value                          |
|--------------------|----------------------------------------------|--------------------------------|
| `image.repository` | Repository for the Enshrouded Server image   | `sknnr/enshrouded-dedicated-server` |
| `image.tag`        | Specify a tag, defaults to latest            | `"latest"`                     |
| `image.pullPolicy` | Image pull policy                            | `Always`                       |

### Common Kubernetes Configuration

| Name                        | Description                                | Value          |
|-----------------------------|--------------------------------------------|----------------|
| `imagePullSecrets`          | ImagePullSecrets for private docker registry | `[]`         |
| `nameOverride`              | Override the app name                      | `""`           |
| `fullnameOverride`          | Override the full app name                 | `""`           |
| `serviceAccount.create`     | Specifies whether a service account should be created | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account   | `{}`        |
| `serviceAccount.name`       | The name of the service account to use      | `""`          |
| `podAnnotations`            | Pod annotations                             | `{}`          |
| `podSecurityContext`        | Pod security context                        | `fsGroup: 1000, runAsUser: 1000` |
| `securityContext`           | Container security context                  | Security hardening settings |

### Service Configuration

| Name                              | Description                                    | Value            |
|-----------------------------------|------------------------------------------------|------------------|
| `service.type`                    | Service type                                   | `LoadBalancer`   |
| `service.annotations`             | Annotations for the service                    | `{}`             |
| `service.gamePort.port`           | Port exposed by the service                    | `15636`          |
| `service.gamePort.targetPort`     | Port targetted on the pods                     | `15636`          |
| `service.gamePort.protocol`       | Protocol used by the port                      | `UDP`            |
| `service.queryPort.port`          | Port exposed by the service                    | `15637`          |
| `service.queryPort.targetPort`    | Port targetted on the pods                     | `15637`          |
| `service.queryPort.protocol`      | Protocol used by the port                      | `UDP`            |
| `service.loadBalancerIP`          | LoadBalancer IP (optional, cloud specific)     | `""`             |
| `service.loadBalancerSourceRanges` | Specify the allowed IPs for LoadBalancer      | `[]`             |

### Persistence Configuration

| Name                          | Description                                        | Value          |
|-------------------------------|----------------------------------------------------|----------------|
| `persistence.enabled`         | Enable persistence using Persistent Volume Claims  | `true`         |
| `persistence.storageClassName`| StorageClass to use for persistence                | `""`           |
| `persistence.accessModes`     | Access mode for the volume                         | `["ReadWriteOnce"]` |
| `persistence.size`            | Size of persistent volume claim                    | `10Gi`         |
| `persistence.annotations`     | Annotations for PVC                                | `{}`           |
| `persistence.existingClaim`   | Use existing PVC                                   | `""`           |

### Resource Management

| Name                      | Description           | Value                  |
|---------------------------|-----------------------|------------------------|
| `resources.limits.cpu`    | CPU limit             | `2000m`                |
| `resources.limits.memory` | Memory limit          | `4Gi`                  |
| `resources.requests.cpu`  | CPU request           | `1000m`                |
| `resources.requests.memory` | Memory request      | `2Gi`                  |

### Scheduling Configuration

| Name             | Description      | Value |
|------------------|------------------|-------|
| `nodeSelector`   | Node selector    | `{}`  |
| `tolerations`    | Tolerations      | `[]`  |
| `affinity`       | Affinity rules   | `{}`  |

### Advanced Configuration

| Name                          | Description                                     | Value             |
|-------------------------------|-------------------------------------------------|-------------------|
| `updateStrategy.type`         | Update strategy                                 | `RollingUpdate`   |
| `updateStrategy.rollingUpdate.maxUnavailable` | Maximum unavailable pods during update | `1`        |
| `updateStrategy.rollingUpdate.maxSurge`       | Maximum surge pods during update       | `0`         |
| `podDisruptionBudget.enabled` | Enable PodDisruptionBudget                      | `false`           |
| `podDisruptionBudget.minAvailable` | Minimum available pods                     | `1`               |

## Notes on Persistence
The Enshrouded dedicated server stores game saves at /opt/enshrouded/savegame. The chart by default sets up a volume to persist this data. If you're running on a local K3s or other single-node cluster, you might want to use local-path as your storage class.

## Troubleshooting

### Server Not Visible in Game

1. Ensure UDP ports are properly exposed (both game and query ports)
2. Check that the LoadBalancer or NodePort has the correct external IP
3. Verify the server is running: kubectl logs -f pod/my-enshrouded-server-xxx
4. Make sure no firewall is blocking the server ports

### Game Save Issues

1. Verify that persistence is enabled and working
2. Check if the PVC is bound: kubectl get pvc
3. If necessary, adjust the save interval with enshrouded.saveInterval