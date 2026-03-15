#!/bin/sh -eu

redo-always
redo-ifchange forecast-message.txt

target="$3"

: "${PUSHOVER_TOKEN:?PUSHOVER_TOKEN is required}"
: "${PUSHOVER_USER:?PUSHOVER_USER is required}"

title="${PUSHOVER_TITLE:-Meteoblue forecast}"
device="${PUSHOVER_DEVICE:-}"
priority="${PUSHOVER_PRIORITY:-0}"
ttl="${PUSHOVER_TTL:-43200}"

response_file="$(mktemp)"
set -- \
  --data-urlencode "token=${PUSHOVER_TOKEN}" \
  --data-urlencode "user=${PUSHOVER_USER}" \
  --data-urlencode "title=${title}" \
  --data-urlencode "message@forecast-message.txt" \
  --data-urlencode "priority=${priority}" \
  --data-urlencode "ttl=${ttl}"

if [ -n "${device}" ]; then
  set -- "$@" --data-urlencode "device=${device}"
fi

http_code="$(
  curl -sS \
    -o "${response_file}" \
    -w '%{http_code}' \
    -X POST https://api.pushover.net/1/messages.json \
    "$@"
)"

python3 - "$response_file" "$http_code" <<'PY'
import json
import sys
from pathlib import Path

response_path = Path(sys.argv[1])
http_code = int(sys.argv[2])
body = response_path.read_text()

try:
    payload = json.loads(body)
except json.JSONDecodeError as exc:
    raise SystemExit(f"Pushover returned non-JSON output (HTTP {http_code}): {exc}: {body}")

if http_code != 200 or payload.get("status") != 1:
    errors = payload.get("errors") or [body]
    raise SystemExit(f"Pushover request failed (HTTP {http_code}): {'; '.join(errors)}")
PY

cp "${response_file}" "${target}"
rm -f "${response_file}"
