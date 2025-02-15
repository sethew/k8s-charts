# Jellyfin Chart
===========

A Helm chart for deploying the Jellyfin server.

I cannot provide support for troubleshooting related to the usage of Jellyfin itself. For community assistance, please visit the [support forums](https://forum.jellyfin.org/).

### Installation via Helm

1. Add the Helm chart repo

```bash
helm repo add k8s-charts https://kriegalex.github.io/k8s-charts/
```

2. Inspect & modify the default values (optional)

```bash
helm show values k8s-charts/jellyfin > custom-values.yaml
```

3. Install the chart

```bash
helm upgrade --install jellyfin k8s-charts/jellyfin -f custom-values.yaml
```

## License

[MIT](../../LICENSE)

## Configuration

The following table lists the configurable parameters of the Jellyfin chart and their default values.

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `image.repository` | The docker repo that will be used for the Jellyfin image | `"jellyfin/jellyfin"` |
| `image.tag` | The tag to use | `"latest"` |
| `image.pullPolicy` |  | `"IfNotPresent"` |
| `ingress.enabled` | If an ingress for the Jellyfin port should be created. | `false` |
| `ingress.ingressClassName` |  | `"nginx"` |
| `ingress.url` | The url that will be used for the ingress, this should be manually configured as the app URL in Jellyfin. | `""` |
| `ingress.annotations` | Extra annotations to add to the ingress.  | `{}` |
| `persistence.config.storageClassName` | The storage class that will be used for the Jellyfin configuration directory, if not specified the default will be used | `null` |
| `persistence.config.size` | The amount of storage space that is allocated to the config volume.  | `"2Gi"` |
| `persistence.config.existingClaim` | Use an existing PersistentVolumeClaim for the config storage.  | `""` |
| `persistence.config.mountPath` | The mount path of the config storage. Useful is the Helm chart is not up-to-date with the docker image.  | `"/config"` |
| `persistence.cache.storageClassName` | The storage class that will be used for the Jellyfin cache directory, if not specified the default will be used | `null` |
| `persistence.cache.size` | The amount of storage space that is allocated to the cache volume, this will probably need to be much higher if thumbnails are enabled.  | `"10Gi"` |
| `persistence.cache.existingClaim` | Use an existing PersistentVolumeClaim for the cache storage.  | `""` |
| `persistence.cache.mountPath` | The mount path of the cache storage. Useful is the Helm chart is not up-to-date with the docker image.  | `"/cache"` |
| `nameOverride` | Override the default name used in this chart | `""` |
| `fullnameOverride` | Override the default fullname used in this chart | `""` |
| `serviceAccount.create` |  | `true` |
| `serviceAccount.automountServiceAccountToken` |  | `false` |
| `serviceAccount.annotations` |  | `{}` |
| `serviceAccount.name` |  | `""` |
| `statefulSet.annotations` |  | `{}` |
| `service.type` |  | `"ClusterIP"` |
| `service.port` | The port number that will be used for exposing the Jellyfin port from the service | `8096` |
| `nodeSelector` |  | `{}` |
| `tolerations` |  | `[]` |
| `affinity` |  | `{}` |
| `priorityClassName` |  | `""` |
| `commonLabels` | Labels that will be added to all resources created by the chart  | `{}` |
| `extraEnv` | Environment variables that will be added to the Jellyfin container | `{}` |
| `extraVolumeMounts` | Additional volume mount configuration blocks for the Jellyfin container | `[]` |
| `extraVolumes` | Extra volume configurations | `[]` |

