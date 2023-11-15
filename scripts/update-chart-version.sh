#!/bin/bash

# Takes two arguments: chart directory and app version
chart_dir=$1

chart_version=$(yq e '.version' "$chart_dir/Chart.yaml")
app_version=$(yq e '.appVersion' "$chart_dir/Chart.yaml")

  # Update the image.tag in values.yaml using yq
  yq e -i '.image.tag = strenv(app_version)' "$chart_dir/values.yaml" app_version="$app_version"
