@echo off
cd /d "%~dp0"
if not exist ".venv\Scripts\python.exe" (
  echo Sistema ainda nao instalado. Execute INSTALAR_WINDOWS.bat.
  pause
  exit /b 1
)
call .venv\Scripts\activate.bat
python manage.py check
python manage.py test
pause
