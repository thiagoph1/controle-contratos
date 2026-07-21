$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $ProjectRoot

Write-Host "=== Instalação - Gestão de Contratos SDAP ===" -ForegroundColor Cyan

if (Get-Command py -ErrorAction SilentlyContinue) {
    $Launcher = "py"
    $LauncherArgs = @("-3")
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
    $Launcher = "python"
    $LauncherArgs = @()
} else {
    throw "Python 3.10 ou superior não encontrado. Instale o Python e marque 'Add Python to PATH'."
}

& $Launcher @LauncherArgs -c "import sys; assert sys.version_info >= (3,10), 'Python 3.10+ obrigatório'; print(sys.version)"
if (-not (Test-Path ".venv")) {
    & $Launcher @LauncherArgs -m venv .venv
}
$Python = Join-Path $ProjectRoot ".venv\Scripts\python.exe"
$Pip = Join-Path $ProjectRoot ".venv\Scripts\pip.exe"

& $Python -m pip install --upgrade pip
& $Pip install -r requirements.txt

if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    $Secret = & $Python -c "import secrets; print(secrets.token_urlsafe(60))"
    $IPv4 = (Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254*" } | Select-Object -First 1 -ExpandProperty IPAddress)
    if (-not $IPv4) { $IPv4 = "SEU_IP_DO_SERVIDOR" }
    $EnvText = Get-Content ".env" -Raw
    $EnvText = $EnvText.Replace("SUBSTITUA-POR-UMA-CHAVE-ALEATORIA-LONGA", $Secret)
    $EnvText = $EnvText.Replace("SEU_IP_DO_SERVIDOR", $IPv4)
    Set-Content ".env" $EnvText -Encoding UTF8
    Write-Host "Arquivo .env criado. IP sugerido para rede: $IPv4" -ForegroundColor Green
}

& $Python manage.py migrate --noinput
& $Python manage.py bootstrap_system --no-admin
& $Python manage.py collectstatic --noinput

Write-Host "" 
$CreateAdmin = Read-Host "Deseja criar agora o usuário administrador? (S/N)"
if ($CreateAdmin -match "^[Ss]") {
    & $Python manage.py createsuperuser
}

Write-Host "" 
Write-Host "Instalação concluída." -ForegroundColor Green
Write-Host "Para iniciar, execute INICIAR_SERVIDOR_WINDOWS.bat na raiz do projeto."
Write-Host "Para acesso em rede, valide o firewall e a autorização da TI conforme o manual."
Read-Host "Pressione ENTER para encerrar"
