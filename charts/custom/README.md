# Custom Helm Charts

This directory contains our custom-built Helm charts designed for specific use cases and infrastructure requirements.

## Structure

```bash
custom/
├── actual-budget/     # https://actualbudget.org
├── jellyfin/          # https://jellyfin.org/
├── paperless-ngx/     # https://docs.paperless-ngx.com/
└── qbittorrent/       # https://github.com/hotio/qbittorrent
```

## Features

- Tailored for homelab environments
- Pre-configured security settings
- Integration with common home automation tools
- Built-in monitoring support

## Installation

Install a chart using Helm:

```bash
helm repo add k8s-charts https://kriegalex.github.io/k8s-charts/
helm install jellyfin k8s-charts/jellyfin
```

## Configuration

Each chart includes detailed configuration options in its respective values.yaml file:

```yaml
# Example configuration structure
global:
  existingClaim: "my-pvc"
  timezone: "Europe/Paris"
```

## Requirements

- Kubernetes 1.29+
- Helm 3.0.0+
- LoadBalancer/Ingress controller

## Testing

Test a chart deployment:

```bash
helm lint charts/custom/my-chart
helm template charts/custom/my-chart
```
