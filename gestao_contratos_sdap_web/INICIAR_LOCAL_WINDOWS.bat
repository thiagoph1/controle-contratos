@echo off
cd /d "%~dp0"
if not exist ".venv\Scripts\python.exe" (
  echo Sistema ainda nao instalado. Execute INSTALAR_WINDOWS.bat.
  pause
  exit /b 1
)
call .venv\Scripts\activate.bat
start "" http://127.0.0.1:8000/login/
waitress-serve --listen=127.0.0.1:8000 --threads=4 config.wsgi:application
pause
