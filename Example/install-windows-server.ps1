# Instala los requisitos previos y dependencias para el servidor Baileys en Windows
# Ejecutar en una PowerShell con privilegios de administrador

# Comprobar privilegios de administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Ejecute esta consola como Administrador"
    exit 1
}

# Instalar Chocolatey si no está disponible
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Instalar Node.js LTS si falta
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Node.js LTS..."
    choco install nodejs-lts -y
}

# Instalar Git si falta (necesario para dependencias que usan git)
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Git..."
    choco install git -y
}

# Instalar dependencias npm
Write-Host "Instalando dependencias npm..."
npm install

Write-Host "Instalación completada"
