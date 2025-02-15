# Patched Helm Charts

This directory contains third-party Helm charts that have been modified to meet specific requirements or fix issues not yet addressed upstream.

## Structure

```bash
patched/
├── jellyfin/        # Jellyfin with hardware transcoding fixes
└── nextcloud/       # Nextcloud with privacy adaptations
```

## Modification Types

1. Security Enhancements
   - Updated security contexts
   - Hardened network policies
   - Privacy law compliance

2. Performance Optimizations
   - Resource limit adjustments
   - Cache configurations
   - Hardware acceleration support

3. Bug Fixes
   - Upstream issues pending merge
   - Custom patches for specific use cases

## Version Tracking

Original vs Patched versions:

```yaml
# Example version tracking
jellyfin:
  upstream: "10.8.4"
  patched: "10.8.4-p1"  # p1 indicates patch version
```

## Patch Management

Track patches using patch files:

```bash
patches/
├── jellyfin/
│   └── hardware-transcoding.patch
└── nextcloud/
    └── privacy.patch
```

## Contributing

1. Document all changes
2. Create patch files
3. Update CHANGELOG.md
4. Submit upstream when applicable

## Maintenance

Patches are reviewed when:
- Upstream releases new versions
- Security vulnerabilities are found
- New requirements emerge
