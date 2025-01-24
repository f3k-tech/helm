# Akaunting Helm Chart

Please note that this chart is currently under development. While it seems to work reliably, it has yet to prove itself in practice. Below are the details on how the deployment works, including key environment variables, image tags, and special configurations required for setup and upgrades.

## Repository

| Name       | Url                                                              |
|------------|------------------------------------------------------------------|
| Contribute | https://github.com/f3k-tech/helm/tree/main/charts/akaunting |
| Issues     | https://github.com/f3k-tech/helm/issues                          |

## Deployment

The chart downloads the required Akaunting application zip file during the initialization process. This ensures the app files are extracted into the `/var/www/html` directory of your container.

### Key Environment Variables

#### `AKAUNTING_SETUP`

- **Purpose**: Triggers initial application setup.
- **Behavior**:
  - When set to `true`, downloads the Akaunting application zip file and extracts it to `/var/www/html`. This should only be enabled on the first run to initialize the application.
  - It is important to set this to `false` after the first successful deployment to avoid repeated initialization or accidental overwrites.

```yaml
# values.yml
env:
  - name: AKAUNTING_SETUP
    value: "false"
```

#### `AKAUNTING_UPGRADE`

- **Purpose**: Facilitates application upgrades by downloading and overwriting the application files.
- **Behavior**:
  - When set to `true`, downloads the latest Akaunting application zip (corresponding to the app version) and overwrites the current files in `/var/www/html`.
  - It can remain `true` if frequent updates are required, but this will re-download the files every time the pod starts. Therefore, it is recommended to set it to `true` only during upgrades.

```yaml
# values.yml
env:
  - name: AKAUNTING_UPGRADE
    value: "true"
```

### Image Details

The container image is constructed using the following:

- **`flavour`**: Specifies the application variant.
- **`appVersion`**: Identifies the Akaunting version corresponding to the image.
- **Image Tag Construction**: `appVersion-flavour` (e.g., `3.0.5-fpm-alpine`).

This setup ensures that the app version matches the corresponding version of the zip file downloaded during initialization or upgrades.

#### Why Version Matching Matters

The app version (`appVersion`) is used to determine the specific version of the Akaunting zip file to download. This ensures compatibility between the container image and application files.
