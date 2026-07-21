@echo off
cd /d "%~dp0"
call .venv\Scripts\activate.bat
python -m pip install -r requirements.txt
python manage.py migrate --noinput
python manage.py bootstrap_system --no-admin
python manage.py collectstatic --noinput
python manage.py check
pause
