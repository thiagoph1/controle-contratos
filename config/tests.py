import os
from importlib import reload
from unittest.mock import patch

from django.test import SimpleTestCase
from django.urls import resolve

import config.settings as settings_module


class RailwaySettingsTests(SimpleTestCase):
    def _reload_settings(self):
        return reload(settings_module)

    def test_database_url_is_used_for_postgresql(self):
        with patch.dict(os.environ, {
            'DATABASE_URL': 'postgresql://usuario:senha@db.example.com:5432/contratos',
            'DB_ENGINE': 'sqlite',
            'POSTGRES_DB': '',
            'POSTGRES_USER': '',
            'POSTGRES_PASSWORD': '',
            'POSTGRES_HOST': '',
            'POSTGRES_PORT': '',
        }, clear=False):
            settings = self._reload_settings()
            self.assertEqual(settings.DATABASES['default']['ENGINE'], 'django.db.backends.postgresql')
            self.assertEqual(settings.DATABASES['default']['NAME'], 'contratos')
            self.assertEqual(settings.DATABASES['default']['HOST'], 'db.example.com')
            self.assertEqual(settings.DATABASES['default']['PORT'], '5432')

    def test_railway_public_domain_is_added_to_allowed_hosts(self):
        with patch.dict(os.environ, {
            'DJANGO_ALLOWED_HOSTS': 'localhost',
            'RAILWAY_PUBLIC_DOMAIN': 'app.railway.app',
        }, clear=False):
            settings = self._reload_settings()
            self.assertIn('localhost', settings.ALLOWED_HOSTS)
            self.assertIn('app.railway.app', settings.ALLOWED_HOSTS)
            self.assertIn('https://app.railway.app', settings.CSRF_TRUSTED_ORIGINS)

    def test_render_external_hostname_is_added_to_allowed_hosts(self):
        with patch.dict(os.environ, {
            'DJANGO_ALLOWED_HOSTS': 'localhost',
            'RENDER_EXTERNAL_HOSTNAME': 'app.onrender.com',
        }, clear=False):
            settings = self._reload_settings()
            self.assertIn('localhost', settings.ALLOWED_HOSTS)
            self.assertIn('app.onrender.com', settings.ALLOWED_HOSTS)
            self.assertIn('https://app.onrender.com', settings.CSRF_TRUSTED_ORIGINS)

    def test_login_and_logout_routes_resolve_with_and_without_trailing_slash(self):
        self.assertEqual(resolve('/login').view_name, 'login')
        self.assertEqual(resolve('/login/').view_name, 'login')
        self.assertEqual(resolve('/logout').view_name, 'logout')
        self.assertEqual(resolve('/logout/').view_name, 'logout')
