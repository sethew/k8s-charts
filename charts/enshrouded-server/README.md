# Enshrouded Server Helm Chart

This Helm chart deploys an [Enshrouded](https://enshrouded.net/) dedicated game server on a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)

## Important Notes

This Helm chart is configured to run the Enshrouded server as user `steam` with UID/GID 10000:10000, as required by the container image. The persistent volume for save data is mounted at `/home/steam/enshrouded/savegame` and must be accessible by this user.

It is also recommended to set some minimal resources for your server:

```
resources:
  # -- We usually recommend not to specify default resources and to leave this as a conscious
  # choice for the user. This also increases chances charts run on environments with little
  # resources, such as Minikube.
  limits:
    memory: 12Gi
  requests:
    cpu: 4000m
    memory: 4Gi
```

## Installation

### Add the repository

```bash
helm repo add k8s-charts https://kriegalex.github.io/k8s-charts/
helm repo update
```

### Install the chart

```bash
helm install enshrouded-server k8s-charts/enshrouded-server
```
Alternatively, clone the repository and install from local files:

```bash
git clone https://github.com/kriegalex/k8s-charts.git
cd charts/enshrouded-server
helm install enshrouded-server .
```

## Uninstallation

To uninstall/delete the my-enshrouded-server deployment:

```bash
helm delete enshrouded-server
```

## Managing Savegame Data

This section explains how to safely copy savegames between your local computer and the Kubernetes cluster.

### Copying Savegames to the Kubernetes PVC

To upload your existing Enshrouded savegames to the server, follow these steps:

#### 1. Scale Down the Enshrouded Server

First, scale down the Enshrouded server to prevent data corruption while copying files:

```bash
# Replace 'enshrouded-server' with your Helm release name
kubectl scale deployment enshrouded-server --replicas=0
```

#### 2. Scale Down the Enshrouded Server

Create a file named enshrouded-server-savegame.yaml with the following content:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: enshrouded-server-savegame
  labels:
    app: enshrouded-server-savegame
spec:
  securityContext:
    runAsUser: 10000
    fsGroup: 10000
  containers:
  - name: copy-container
    image: ubuntu:24.04
    command: ['sleep', 'infinity']
    volumeMounts:
    - name: savegame-data
      mountPath: /home/steam/enshrouded/savegame
  volumes:
  - name: savegame-data
    persistentVolumeClaim:
      # Replace with your PVC name
      claimName: enshrouded-server
```

Apply this manifest to create the pod:

```bash
kubectl apply -f enshrouded-server-savegame.yaml
```

#### 3. Copy Files from Local to PVC

Wait for the pod to be ready:
```bash
kubectl wait --for=condition=Ready pod/enshrouded-server-savegame
```
Copy your local savegame files to the PVC:
```bash
# For Windows (PowerShell)
# Replace C:\path\to\local\savegame with your local savegame directory
kubectl cp 'C:\path\to\local\savegame\' enshrouded-server-savegame:/home/steam/enshrouded/savegame/

# For macOS/Linux
# Replace /path/to/local/savegame with your local savegame directory
kubectl cp /path/to/local/savegame/ enshrouded-server-savegame:/home/steam/enshrouded/savegame/
```
#### 4. Verify File Permissions
Ensure files have correct permissions:
```bash
kubectl exec enshrouded-server-savegame -- ls -la /home/steam/enshrouded/savegame/
```
#### 5. Clean Up and Restart the Server
Delete the temporary pod:
```bash
kubectl delete pod enshrouded-server-savegame
```
Scale the Enshrouded server back up:
```bash
kubectl scale deployment enshrouded-server --replicas=1
```
### Retrieving Savegames from the Server
To download your savegames from the server to your local machine:

```bash
# Scale down the server first (optional but recommended)
kubectl scale deployment enshrouded-server --replicas=0

# Create the temporary pod as described above
kubectl apply -f copy-pod.yaml
kubectl wait --for=condition=Ready pod/enshrouded-server-savegame

# Copy from PVC to local (Windows PowerShell)
kubectl cp enshrouded-server-savegame:/home/steam/enshrouded/savegame/ 'C:\path\to\destination\'

# Copy from PVC to local (macOS/Linux)
kubectl cp enshrouded-server-savegame:/home/steam/enshrouded/savegame/ /path/to/destination/

# Clean up
kubectl delete pod enshrouded-server-savegame
kubectl scale deployment enshrouded-server --replicas=1
```

### Finding Your Local Savegame Files
Enshrouded savegame files are typically located at:

- Windows: C:\Program Files (x86)\Steam\userdata\STEAM_ID\1203620\remote\
- Linux (Steam/Proton): ~/.local/share/Steam/steamapps/compatdata/1203620/pfx/drive_c/users/steamuser/AppData/Local/Enshrouded/Saves

### Notes on Savegame Management
- Always scale down the server before copying files to prevent data corruption
- Savegame files use the .sav extension
- The container runs as UID/GID 10000:10000, which is why the copy pod uses the same values
- Making regular backups of your savegames is recommended

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
The Enshrouded dedicated server stores game saves at /home/steam/enshrouded/savegame. The chart by default sets up a volume to persist this data. If you're running on a local K3s or other single-node cluster, you might want to use local-path as your storage class.

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