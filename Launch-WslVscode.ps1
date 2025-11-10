# Launch-WslVscode.ps1
param([string]$url)

# --- Log Configuration (simplified to keep it clean) ---
$logPath = Join-Path -Path $PSScriptRoot -ChildPath "wsl_vscode_log.txt"
function Write-Log($message) { Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $message" }
# Write-Log("--- Script Started (No Wait) ---")

# --- Path Processing ---
$linuxPath = $url.Replace("wslvscode://", "")
$linuxPath = $linuxPath.Replace("\", "/")
$linuxPath = $linuxPath.Replace("""", "") # Clean up quotes

# Write-Log("Processed Linux Path (Cleaned): $linuxPath")

# --- Command Execution ---
$command = "wsl.exe"
# Removing the --wait argument
$arguments = "code", "--goto", $linuxPath, "--wait"

# Write-Log("Executing Command: $command $arguments")

try {
    # We use Start-Process without -NoNewWindow to ensure the main process closes immediately
    # and the PowerShell shell terminates with it.
    Start-Process -FilePath $command -ArgumentList $arguments -WindowStyle Hidden -ErrorAction Stop
    # Write-Log("Command executed successfully via Start-Process. Terminal should close now.")
}
catch {
    Write-Log("ERROR during command execution: $_")  
    Write-Log("Executed Command: $command $arguments")
}

# The script ends here, allowing the PowerShell window to close.

