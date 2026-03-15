#!/bin/sh -eu

redo-ifchange forecast-image-pushover.sent.json
cp forecast-image-pushover.sent.json "$3"
