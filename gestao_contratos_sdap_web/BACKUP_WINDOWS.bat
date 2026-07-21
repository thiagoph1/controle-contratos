@echo off
cd /d "%~dp0"
if not exist ".venv\Scripts\python.exe" (
  echo Sistema ainda nao instalado.
  pause
  exit /b 1
)
call .venv\Scripts\activate.bat
python manage.py backup_system
pause
