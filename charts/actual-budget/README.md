# Actual Budget Helm Chart

This is a Helm chart for deploying [Actual Budget](https://actualbudget.org/), a self-hosted budgeting application. This chart provides a convenient and customizable way to deploy Actual Budget on a Kubernetes cluster.

## Prerequisites
- Kubernetes 1.19+
- Helm 3.0+

## Installation
1. Add the repository containing this Helm chart:

```bash
helm repo add k8s-charts https://kriegalex.github.io/k8s-charts/
```

2. Install the chart using Helm:

```bash
helm upgrade --install actual-budget k8s-charts/actual-budget
```

### Installing with Custom Values
To customize your deployment, you can override the default values in the `values.yaml` file. Here's an example of how to use custom values:

```bash
helm show values k8s-charts/actual-budget > custom-values.yaml
helm upgrade --install actual-budget k8s-charts/actual-budget -f custom-values.yaml
```

## Uninstallation
To uninstall the chart and delete all resources:

```bash
helm uninstall actual-budget
```

## Chart Structure
The chart has the following structure:

```
actual-budget/
├── Chart.yaml          # Metadata for the Helm chart
├── values.yaml         # Default configuration values
├── templates/          # Directory for Kubernetes manifest templates
│   ├── _helpers.tpl    # Helper template for generating names and labels
│   ├── deployment.yaml # Deployment resource for Actual Budget
│   ├── service.yaml    # Service resource for exposing Actual Budget
│   ├── pvc.yaml        # Persistent Volume Claim for data storage
│   └── ingress.yaml    # Ingress management
```

## Values

| Parameter                    | Description                                                                 | Default                   |
|------------------------------|-----------------------------------------------------------------------------|---------------------------|
| `image.repository`           | Image repository for Actual Budget                                          | `actualbudget/actual-server` |
| `image.tag`                  | Image tag for the Actual Budget                                             | `24.10.1`                 |
| `image.pullPolicy`           | Image pull policy                                                           | `IfNotPresent`            |
| `replicaCount`               | Number of Actual Budget replicas                                            | `1`                       |
| `service.type`               | Kubernetes Service type (`ClusterIP`, `NodePort`, `LoadBalancer`)           | `ClusterIP`               |
| `service.port`               | Service port for the Actual Budget application                              | `5006`                    |
| `ingress.enabled`            | Enable Ingress for external access                                          | `false`                   |
| `ingress.ingressClassName`   | Specify the ingress class name for the Ingress resource                      | `""`                     |
| `ingress.annotations`        | Additional annotations for the Ingress resource                             | `{}`                      |
| `ingress.hosts`              | List of hosts for the Ingress                                               | `[{ host: "actual.local", paths: [{ path: "/", pathType: "Prefix" }] }]` |
| `ingress.tls`                | TLS configuration for the Ingress                                           | `[]`                      |
| `persistence.enabled`        | Enable Persistent Volume Claim for `/data`                                  | `true`                    |
| `persistence.size`           | Size of Persistent Volume                                                   | `5Gi`                     |
| `persistence.storageClass`   | StorageClass to use for the PVC (if not specified, use default)              | `""`                     |
| `persistence.existingClaim`  | Use an existing PVC claim name (if specified, new PVC will not be created)   | `""`                     |
| `resources.requests.memory`  | Minimum amount of memory requested (optional)                               | `256Mi`                   |
| `resources.requests.cpu`     | Minimum amount of CPU requested (optional)                                  | `100m`                    |
| `resources.limits.memory`    | Maximum amount of memory allowed (optional)                                 | `512Mi`                   |
| `resources.limits.cpu`       | Maximum amount of CPU allowed (optional)                                    | `500m`                    |
| `securityContext.runAsUser`  | User ID to run the container (optional)                                     | `1000`                    |
| `securityContext.runAsGroup` | Group ID to run the container (optional)                                    | `1000`                    |
| `securityContext.fsGroup`    | File system group for mounted volumes (optional)                            | `2000`                    |

## Customization
You can customize various aspects of this chart by modifying the `values.yaml` file. Below are some key options:

### Image Configuration
Set the image repository and tag for deploying different versions:

```yaml
image:
  repository: actualbudget/actual-server
  tag: latest
  pullPolicy: Always
