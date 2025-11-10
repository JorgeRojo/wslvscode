# Launch-WslVscode.ps1
param([string]$url)

# --- Configuración de Logs (simplificado para mantenerlo limpio) ---
$logPath = Join-Path -Path $PSScriptRoot -ChildPath "wsl_vscode_log.txt"
function Write-Log($message) { Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $message" }
# Write-Log("--- Script Started (No Wait) ---")

# --- Procesamiento de Ruta ---
$linuxPath = $url.Replace("wslvscode://", "")
$linuxPath = $linuxPath.Replace("\", "/")
$linuxPath = $linuxPath.Replace("""", "") # Limpieza de comillas
$distro = "kali-linux"

# Write-Log("Processed Linux Path (Cleaned): $linuxPath")

# --- Ejecución del Comando ---
$command = "wsl.exe"
# Eliminamos el argumento --wait
$arguments = "-d", $distro, "code", $linuxPath

# Write-Log("Executing Command: $command $arguments")

try {
    # Usamos Start-Process sin -NoNewWindow para asegurar que el proceso principal se cierre inmediatamente
    # y el shell de PowerShell termine con él.
    Start-Process -FilePath $command -ArgumentList $arguments
    # Write-Log("Command executed successfully via Start-Process. Terminal should close now.")
}
catch {
    Write-Log("ERROR during command execution: $_")  
    Write-Log("Executed Command: $command $arguments")
}

# El script termina aquí, permitiendo que la ventana de PowerShell se cierre.
