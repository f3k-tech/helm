#!/bin/bash

# Fetching necessary branches and checking out charts
git fetch origin gh-pages
git checkout gh-pages
git checkout main -- charts
cd charts

# Loop through all chart directories
for d in */ ; do
  chart_name=$(basename "$d")
  chart_version=$(grep 'version:' "$d/Chart.yaml" | cut -d " " -f 2)
  app_version=$(grep 'appVersion:' "$d/Chart.yaml" | cut -d " " -f 2)

  # Update the image.tag in values.yaml
  sed -i "s/^image\.tag:.*$/image\.tag: $app_version/" "$d/values.yaml"

  if [ ! -f "../$chart_name-$chart_version.tgz" ]; then
    helm package --sign --key info@f3k.tech --keyring ~/.gnupg/secring.gpg "$d" -d ..
  else
    echo "Chart $chart_name-$chart_version already exists, skipping."
  fi
done

# Cleaning up
cd ..
rm -r charts

