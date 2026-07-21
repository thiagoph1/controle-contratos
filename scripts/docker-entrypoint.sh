#!/bin/sh
set -e
python - <<'PY'
import os, socket, time
from config.entrypoint_utils import resolve_database_host_and_port
if os.getenv('DB_ENGINE','').lower() in {'postgres','postgresql'}:
    host, port = resolve_database_host_and_port()
    for _ in range(60):
        try:
            with socket.create_connection((host, port), 2):
                break
        except OSError:
            time.sleep(1)
    else:
        raise SystemExit('PostgreSQL indisponível')
PY
python manage.py migrate --noinput
python manage.py bootstrap_system --no-admin
python manage.py collectstatic --noinput
if [ -n "$INITIAL_ADMIN_USERNAME" ] && [ -n "$INITIAL_ADMIN_PASSWORD" ]; then
  python manage.py bootstrap_system --username "$INITIAL_ADMIN_USERNAME" --password "$INITIAL_ADMIN_PASSWORD" --email "${INITIAL_ADMIN_EMAIL:-}"
fi
PORT="${PORT:-8000}"
exec waitress-serve --listen=0.0.0.0:${PORT} --threads=8 config.wsgi:application
