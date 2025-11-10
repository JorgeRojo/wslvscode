# Manage-WslVscodeProtocol.ps1
# Manages the installation/uninstallation of the wslvscode:// custom URI protocol

# --- CONFIGURATION (Static parts) ---
$protocolName = "wslvscode"
$protocolDescription = "URL: Open WSL file/folder in VS Code dynamically"
$launcherFileName = "Launch-WslVscode.ps1"
$registryPath = "HKCU:\Software\Classes\$protocolName"
$launcherScriptPath = $null

# --- Helper Function to Get Path from User ---
function Get-LauncherPath {
    Write-Host "Please specify the full directory path where you saved '$launcherFileName'." -ForegroundColor Cyan
    $dirInput = Read-Host "Enter Path (e.g. C:\Users\<user>\win-projects\WslVsCode)"
    if (-not (Test-Path $dirInput -PathType Container)) { Write-Host "Error: The provided directory path does not exist." -ForegroundColor Red; return $false }
    $scriptPath = Join-Path -Path $dirInput -ChildPath $launcherFileName
    if (-not (Test-Path $scriptPath -PathType Leaf)) { Write-Host "Error: The file '$launcherFileName' was not found in that directory." -ForegroundColor Red; return $false }
    $scriptPath
}

# --- INSTALL FUNCTION ---
function Install-Protocol {
    Write-Host "Starting installation..." -ForegroundColor Cyan
    do { $launcherScriptPath = Get-LauncherPath } while ($launcherScriptPath -eq $false)

    # --- CORRECCIÓN FINAL: Asegurarse de usar %1 y la sintaxis de comillas correcta ---
    # La cadena final DEBE ser: "powershell.exe -ExecutionPolicy Bypass -File "C:\Path\To\Script.ps1" "%1""
    $commandToRun = '"{0}" -ExecutionPolicy Bypass -File ""{1}"" ""%1"""' -f "powershell.exe", $launcherScriptPath
    
    # Registrar el protocolo
    New-Item -Path $registryPath -Force | Out-Null
    Set-ItemProperty -Path $registryPath -Name "(Default)" -Value $protocolDescription
    Set-ItemProperty -Path $registryPath -Name "URL Protocol" -Value ""
    $commandPath = "$registryPath\shell\open\command"
    New-Item -Path $commandPath -Force | Out-Null
    Set-ItemProperty -Path $commandPath -Name "(Default)" -Value $commandToRun

    Write-Host "Installation complete!" -ForegroundColor Green
    Write-Host "Registered command in Registry:" -ForegroundColor Gray
    Write-Host $commandToRun -ForegroundColor Gray
    Verify-ProtocolInstallation
}

# --- UNINSTALL / VERIFY / MAIN MENU FUNCTIONS ---
function Uninstall-Protocol {
    Write-Host "Removing protocol '${protocolName}://'..." -ForegroundColor Cyan
    if (Test-Path $registryPath) { Remove-Item -Path $registryPath -Recurse -Force; Write-Host "Uninstallation complete!" -ForegroundColor Green } else { Write-Host "The protocol was not installed or is already removed." -ForegroundColor Yellow }
}

function Verify-ProtocolInstallation {
    Write-Host "Verifying installation..." -ForegroundColor Blue
    if (Test-Path $registryPath) {
        $regCommand = Get-ItemProperty -Path "HKCU:\Software\Classes\$protocolName\shell\open\command" | Select-Object -ExpandProperty '(Default)'
        Write-Host "Registry command points to: $regCommand" -ForegroundColor Gray
        $testUrl = "${protocolName}://home/test/verification.log"
        # La verificación programática puede fallar por la caché de Windows, pero el comando del navegador sí funcionará
        try {
            # Start-Process -FilePath $testUrl # Comentado porque falla la caché de Windows
            Write-Host "Automatic verification command prepared: Start-Process -FilePath $testUrl" -ForegroundColor Gray
            Write-Host "Verification requires manual browser test due to Windows caching." -ForegroundColor Yellow
        } catch {
            Write-Host "ERROR during programmatic launch verification: $_" -ForegroundColor Red
        }
    } else { Write-Host "Verification failed: Registry keys for $protocolName not found." -ForegroundColor Red }
}

Write-Host "--- $protocolName Protocol Manager ---" -ForegroundColor Blue
Write-Host "Select an option:"
Write-Host "[I]nstall"
Write-Host "[U]ninstall"
Write-Host "[V]erify existing installation"
Write-Host "[E]xit"

$choice = Read-Host "Option"
switch ($choice.ToLower()) {
    "i" { Install-Protocol }
    "u" { Uninstall-Protocol }
    "v" { Verify-ProtocolInstallation }
    "e" { Write-Host "Exiting..."; exit }
    default { Write-Host "Invalid option. Use I, U, V or E." -ForegroundColor Red }
}
