#!/usr/bin/env python3

import json
import sys
from pathlib import Path


MAX_MESSAGE_LEN = 1024
UNIT_LABELS = {
    "ms-1": "m/s",
}


def compass(degrees: float) -> str:
    points = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
    index = int((degrees % 360) / 45.0 + 0.5) % len(points)
    return points[index]


def value(seq, index, digits=1):
    raw = seq[index]
    if isinstance(raw, (int, float)):
        rounded = round(raw, digits)
        if digits == 0:
            return str(int(rounded))
        return f"{rounded:.{digits}f}"
    return str(raw)


def main() -> int:
    if len(sys.argv) != 2:
        raise SystemExit("usage: render_forecast_message.py <forecast.json>")

    payload = json.loads(Path(sys.argv[1]).read_text())
    metadata = payload["metadata"]
    units = payload["units"]
    data_day = payload["data_day"]

    dates = data_day["time"]
    lines = []
    for i, day in enumerate(dates):
        temp_min = value(data_day["temperature_min"], i)
        temp_max = value(data_day["temperature_max"], i)
        rain = value(data_day["precipitation"], i)
        rain_probability = value(data_day["precipitation_probability"], i, 0)
        wind = value(data_day["windspeed_mean"], i)
        wind_dir = compass(float(data_day["winddirection"][i]))
        predictability = value(data_day["predictability"], i, 0)

        lines.append(
            f"{day}: {temp_min}-{temp_max}{units['temperature']}, "
            f"rain {rain}{units['precipitation']} ({rain_probability}%), "
            f"wind {wind}{UNIT_LABELS.get(units['windspeed'], units['windspeed'])} {wind_dir}, "
            f"predictability {predictability}%."
        )

    updated = metadata.get("modelrun_updatetime_utc") or metadata.get("modelrun_utc")
    if updated:
        lines.append(f"Updated {updated} UTC.")

    message = "\n".join(lines)
    if len(message) > MAX_MESSAGE_LEN:
        cutoff = MAX_MESSAGE_LEN - len("\n...")
        message = message[:cutoff].rstrip() + "\n..."

    sys.stdout.write(message)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
