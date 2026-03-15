# Meteoblue image to Pushover pipeline

This repo uses `redo` to fetch a Meteoblue forecast image and send it to Pushover.

## Usage

Run the default pipeline:

```sh
redo
```

This builds `all`, which sends `forecast-image-pushover.sent.json`.

Or run the individual stages:

```sh
redo forecast-image.png
redo forecast-image-pushover.sent.json
```

## Environment

The targets expect environment variables to already be loaded, for example by `direnv`.

Required:

- `METEOBLUE_API_KEY`
- `LAT`
- `LNG`
- `PUSHOVER_TOKEN`
- `PUSHOVER_USER`

Optional:

- `FORECAST_DAYS` default `2`
- `METEOBLUE_TEMPERATURE_UNIT` default `C`
- `METEOBLUE_WINDSPEED_UNIT` default `ms-1`
- `METEOBLUE_PRECIPITATION_UNIT` default `mm`
- `METEOBLUE_IMAGE_TYPE` default `meteogram_extended`
- `PUSHOVER_TITLE` default `Meteoblue forecast`
- `PUSHOVER_IMAGE_TITLE` default `Meteoblue image`
- `PUSHOVER_IMAGE_MESSAGE` default `Meteoblue forecast image`
- `PUSHOVER_DEVICE`
- `PUSHOVER_PRIORITY` default `0`
- `PUSHOVER_TTL` default `43200` seconds (12 hours)
