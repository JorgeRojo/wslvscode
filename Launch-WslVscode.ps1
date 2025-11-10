param([string]$url)

$linuxPath = $url.Replace("wslvscode://", "")
$linuxPath = $linuxPath.Replace("\", "/")
$linuxPath = $linuxPath.Replace("""", "")

$command = "wsl.exe"
$arguments = "code", "--goto", $linuxPath, "--wait"

try {
  Start-Process -FilePath $command -ArgumentList $arguments -WindowStyle Hidden -ErrorAction Stop
}
catch {
  Write-Error "ERROR during command execution: $_"
}


