# Manage-WslVscodeProtocol.ps1
# Manages the installation/uninstallation of the wslvscode:// custom URI protocol

# --- CONFIGURATION (Static parts) ---
$protocolName = "wslvscode"
$protocolDescription = "URL: Open WSL file/folder in VS Code dynamically"
$launcherFileName = "Launch-WslVscode.ps1"
$registryPath = "HKCU:\Software\Classes\$protocolName"
$launcherScriptPath = $null


# --- Helper Function to Get Path Automatically ---
function Get-LauncherPath {
    $currentDir = $PSScriptRoot
    $scriptPath = Join-Path -Path $currentDir -ChildPath $launcherFileName
    
    if (-not (Test-Path $scriptPath -PathType Leaf)) {
        Write-Host "Error: The file '$launcherFileName' was not found in the current directory." -ForegroundColor Red
        Write-Host "Expected Path: $scriptPath" -ForegroundColor Red
        return $false
    }
    
    $scriptPath
}

# --- INSTALL FUNCTION ---
function Install-Protocol {
    Write-Host "Starting installation..." -ForegroundColor Cyan

    $launcherScriptPath = Get-LauncherPath
    if ($launcherScriptPath -eq $false) {
        Write-Host "Automatic path failed. Cannot proceed." -ForegroundColor Red
        exit 1
    }
    Write-Host "Automatic path determined: $launcherScriptPath" -ForegroundColor Green

    # --- FINAL SOLUTION: Use CMD /c start "" to hide the CMD window ---
    # The final command in the registry will be: cmd /c start "" powershell.exe -WindowStyle Hidden [...]
    
    # Construct the internal PowerShell command with WindowStyle Hidden
    $powerShellCommand = 'powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File ""{0}"" ""%1"""' -f $launcherScriptPath

    # The command line saved to the Registry, using CMD to launch invisibly
    # start "" is crucial for handling quotes correctly with the window title
    $commandToRun = 'cmd /c start "" {0}' -f $powerShellCommand
    
    # Register the protocol
    New-Item -Path $registryPath -Force | Out-Null
    Set-ItemProperty -Path $registryPath -Name "(Default)" -Value $protocolDescription
    Set-ItemProperty -Path $registryPath -Name "URL Protocol" -Value ""
    $commandPath = "$registryPath\shell\open\command"
    New-Item -Path $commandPath -Force | Out-Null
    Set-ItemProperty -Path $commandPath -Name "(Default)" -Value $commandToRun

    Write-Host "Installation complete! Using CMD /c start for minimal visibility." -ForegroundColor Green
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
        Write-Host "Registry keys found for $protocolName." -ForegroundColor Green
        $regCommand = Get-ItemProperty -Path "HKCU:\Software\Classes\$protocolName\shell\open\command" | Select-Object -ExpandProperty '(Default)'
        Write-Host "Registry command points to: $regCommand" -ForegroundColor Gray
        
        Write-Host "Verification requires manual testing in a web browser." -ForegroundColor Yellow
        Write-Host "Please open your browser and navigate to:" -ForegroundColor Cyan
        Write-Host "wslvscode:///home/test/verification.log" -ForegroundColor Cyan
        Write-Host "Ensure the window is hidden and check the log file (or VS Code) for success." -ForegroundColor Yellow
    } else { 
        Write-Host "Verification failed: Registry keys for $protocolName not found." -ForegroundColor Red 
    }
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
