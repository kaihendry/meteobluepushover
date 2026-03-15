#!/bin/sh -eu

redo-ifchange forecast.json scripts/render_forecast_message.py
python3 scripts/render_forecast_message.py forecast.json > "$3"
