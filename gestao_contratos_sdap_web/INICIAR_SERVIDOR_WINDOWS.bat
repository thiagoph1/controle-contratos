@echo off
cd /d "%~dp0"
if not exist ".venv\Scripts\python.exe" (
  echo Sistema ainda nao instalado. Execute INSTALAR_WINDOWS.bat.
  pause
  exit /b 1
)
call .venv\Scripts\activate.bat
python manage.py migrate --noinput
python manage.py bootstrap_system --no-admin
python manage.py collectstatic --noinput
start "" http://127.0.0.1:8000/login/
echo.
echo Servidor ativo na porta 8000.
echo Neste computador: http://127.0.0.1:8000
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do echo Rede interna: http://%%a:8000
waitress-serve --listen=0.0.0.0:8000 --threads=8 config.wsgi:application
pause
