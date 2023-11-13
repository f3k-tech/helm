# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2023-11-15

### Added
- Persistent Volume Claim (PVC) template to support dynamic storage provisioning. This enables the chart to attach persistent storage to the container.
- Volume mount configuration within the container specification, allowing containers to access persistent storage mounted at `/app/db`.
- Configuration options in `values.yaml` for PVC size and access modes (`ReadWriteOnce` by default), providing customization for storage needs.
- `persistence.enabled` flag in `values.yaml` to allow users to enable or disable the creation of PVCs according to their requirements.
- `volumes` section in the pod specification of the deployment template, ensuring proper linkage of PVCs to the pods.

### Changed
- Updated `values.yaml` and deployment templates to integrate persistent storage features.

### Fixed
- No specific fixes in this release.

### Deprecated
- No deprecations in this release.

### Removed
- No features removed in this release.

### Security
- No security updates in this release.

[0.2.0]: https://artifacthub.io/packages/helm/f3k-tech/libretranslate/0.2.0
