# Jellyfin Chart
===========

![Version: 0.2.3](https://img.shields.io/badge/Version-0.2.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 10.10.6](https://img.shields.io/badge/AppVersion-10.10.6-informational?style=flat-square)

A Helm chart for Jellyfin

## Support

I cannot provide support for troubleshooting related to the usage of Jellyfin itself. For community assistance, please visit the [support forums](https://forum.jellyfin.org/).

## Installation

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

## Values

The following table lists the configurable parameters of the Jellyfin chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | {} | Affinity settings for the Jellyfin pod assignment |
| commonLabels | object | {} | Common Labels for all resources created by this chart |
| extraEnv | list | [] | Additional environment variables for the Jellyfin container |
| extraHosts | list | [] | Additional hosts to add to the pod's /etc/hosts |
| extraVolumeMounts | list | [] | Additional volume mounts for the Jellyfin container @example extraVolumeMounts:   - name: media     mountPath: /media |
| extraVolumes | list | [] | Additional volumes for the Jellyfin pod @example extraVolumes:   - name: media     persistentVolumeClaim:       claimName: nfs-media |
| fullnameOverride | string | `""` | Override the full name of the chart |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.repository | string | `"jellyfin/jellyfin"` | Docker image repository |
| image.tag | string | "" | Docker image tag If unset, defaults to Chart.appVersion |
| ingress.annotations | object | `{}` | Custom annotations for the ingress |
| ingress.enabled | bool | `false` | Enable the creation of an ingress for the Jellyfin server |
| ingress.ingressClassName | string | `"nginx"` | The ingress class to use |
| ingress.url | string | `""` | The URL for the ingress endpoint to point to the Jellyfin instance |
| nameOverride | string | `""` | Override the name of the chart |
| nodeSelector | object | {} | Node selector for the Jellyfin pod assignment |
| persistence.cache | object | `{"enabled":true,"existingClaim":"","mountPath":"/cache","size":"5Gi","storageClassName":null,"subPath":""}` | Cache directory settings |
| persistence.cache.enabled | bool | `true` | Enable persistent storage for cache |
| persistence.cache.existingClaim | string | `""` | Use an existing PVC for cache |
| persistence.cache.mountPath | string | `"/cache"` | Mount path for cache data |
| persistence.cache.size | string | `"5Gi"` | Size of the PVC for cache |
| persistence.cache.storageClassName | string | null | Storage class for the cache PVC |
| persistence.cache.subPath | string | `""` | Subdirectory to mount |
| persistence.config | object | `{"enabled":true,"existingClaim":"","mountPath":"/config","size":"20Gi","storageClassName":null,"subPath":""}` | Configuration directory settings |
| persistence.config.enabled | bool | `true` | Enable persistent storage for configuration |
| persistence.config.existingClaim | string | `""` | Use an existing PVC for configuration |
| persistence.config.mountPath | string | `"/config"` | Mount path for configuration data |
| persistence.config.size | string | "20Gi (can grow to 100GB+ for big libraries)" | Size of the PVC for configuration |
| persistence.config.storageClassName | string | null | Storage class for the configuration PVC |
| persistence.config.subPath | string | `""` | Subdirectory to mount |
| resources | object | {} | Configure resource requests and limits for the Jellyfin container |
| service.port | int | `8096` | Port the service will use |
| service.type | string | `"ClusterIP"` | Type of Kubernetes service to create |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automountServiceAccountToken | bool | `false` | If the service account token should be auto mounted |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | "" | The name of the service account to use If not set and create is true, a name is generated using the fullname template |
| statefulSet.annotations | object | `{}` | Optional extra annotations to add to the service resource |
| statefulSet.podAnnotations | object | `{}` | Optional extra annotations to add to the pods in the statefulset |
| tolerations | list | [] | Tolerations for the Jellyfin pod assignment |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
