#!/bin/sh -eu

redo-always

target="$3"

: "${METEOBLUE_API_KEY:?METEOBLUE_API_KEY is required}"
: "${LAT:?LAT is required}"
: "${LNG:?LNG is required}"

image_type="${METEOBLUE_IMAGE_TYPE:-meteogram_extended}"
curl -fsS \
  -o "${target}" \
  "https://my.meteoblue.com/images/${image_type}?lat=${LAT}&lon=${LNG}&apikey=${METEOBLUE_API_KEY}"
