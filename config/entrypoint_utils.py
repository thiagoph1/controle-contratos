import os
from urllib.parse import urlparse


def resolve_database_host_and_port():
    database_url = os.getenv('DATABASE_URL', '').strip()
    parsed = urlparse(database_url) if database_url else None
    if parsed is not None and parsed.scheme in {'postgres', 'postgresql', 'postgresql+psycopg', 'postgresql+psycopg2'}:
        host = parsed.hostname or os.getenv('POSTGRES_HOST', 'db')
        port = parsed.port or int(os.getenv('POSTGRES_PORT', '5432'))
        return host, port
    host = os.getenv('POSTGRES_HOST', 'db')
    port = int(os.getenv('POSTGRES_PORT', '5432'))
    return host, port
