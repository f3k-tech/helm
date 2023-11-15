#!/bin/bash

# Loop through all chart directories
for d in */ ; do
  chart_name=$(basename "$d")
  chart_version=$(yq e '.version' "$d/Chart.yaml")
  app_version=$(yq e '.appVersion' "$d/Chart.yaml")

  # Update the image.tag in values.yaml using yq
  yq e -i '.image.tag = strenv(app_version)' "$d/values.yaml" app_version="$app_version"

  if [ ! -f "../$chart_name-$chart_version.tgz" ]; then
    helm package --sign --key info@f3k.tech --keyring ~/.gnupg/secring.gpg "$d" -d ..
  else
    echo "Chart $chart_name-$chart_version already exists, skipping."
  fi
done

# Cleaning up
cd ..
rm -r charts
