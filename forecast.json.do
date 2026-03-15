#!/bin/sh -eu

redo-always

: "${METEOBLUE_API_KEY:?METEOBLUE_API_KEY is required}"
: "${LAT:?LAT is required}"
: "${LNG:?LNG is required}"

forecast_days="${FORECAST_DAYS:-2}"
temperature_unit="${METEOBLUE_TEMPERATURE_UNIT:-C}"
windspeed_unit="${METEOBLUE_WINDSPEED_UNIT:-ms-1}"
precipitation_unit="${METEOBLUE_PRECIPITATION_UNIT:-mm}"

curl -fsS \
  "https://my.meteoblue.com/packages/basic-day?lat=${LAT}&lon=${LNG}&forecast_days=${forecast_days}&temperature=${temperature_unit}&windspeed=${windspeed_unit}&precipitationamount=${precipitation_unit}&apikey=${METEOBLUE_API_KEY}" \
  > "$3"
