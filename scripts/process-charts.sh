#!/bin/bash

# Loop through all chart directories
for d in */ ; do
  chart_name=$(basename "$d")
  chart_version=$(yq e '.version' "$d/Chart.yaml")
  image_tag=$(yq e '.image.tag' "$d/values.yaml")

  # Update the image.tag in values.yaml using yq
  yq e -i '.appVersion = strenv(image_tag)' "$d/Chart.yaml" image_tag="$image_tag"

  if [ ! -f "../$chart_name-$chart_version.tgz" ]; then
    helm package --sign --key info@f3k.tech --keyring ~/.gnupg/secring.gpg "$d" -d ..
  else
    echo "Chart $chart_name-$chart_version already exists, skipping."
  fi
done

# Cleaning up
cd ..
rm -r charts
