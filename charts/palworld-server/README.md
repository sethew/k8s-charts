# Palworld Server Helm Chart

This Helm chart deploys an [Palworld](https://www.pocketpair.jp/palworld) dedicated game server on a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure (if persistence is enabled)

## Important Notes

It is recommended to set some minimal resources for your server:

```
resources:
  limits:
    memory: 32Gi
  requests:
    cpu: 4000m
    memory: 8Gi
```