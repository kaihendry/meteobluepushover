#!/bin/sh -eu

redo-ifchange forecast-pushover.sent.json
cp forecast-pushover.sent.json "$3"
