# Vendored Helm Charts

This directory contains Helm charts that are directly imported from upstream sources with minimal modifications. These charts serve as dependencies for our custom implementations.

## Structure

```bash
vendored/
├── radarr/          # Radarr from alekc-charts
└── plex/            # Plex from official plex chart
```

## Usage

These charts are referenced as dependencies in our custom charts. Example:

```yaml
# In custom/my-media-stack/Chart.yaml
dependencies:
  - name: radarr
    version: 1.12.0
    repository: file://../vendored/radarr
```

## Version Management

- Charts are updated periodically from upstream sources
- Version changes are documented in each chart's CHANGELOG.md
- Security patches are applied promptly

## Current Versions

| Chart Name | Version | Upstream Source | Last Updated |
|------------|---------|-----------------|--------------|
| radarr | 1.12.0 | alekc-charts | 2025-02-15 |
| sonarr | 1.7.0 | alekc-charts | 2025-02-15 |
| prowlarr | 1.12.0 | alekc-charts | 2025-02-15 |
| plex | 0.8.0 | plex | 2025-02-15 |
| nextcloud | 6.6.3 | nextcloud | 2025-02-15 |
| gitea | 10.6.0 | gitea-charts | 2025-02-15 |
