# Prompt the user for input
$choice = Read-Host "Enable proxy? (y/N)"

# Process user input
if ($choice -eq "y") {
    $proxy = "http://127.0.0.1:10808"
    $env:HTTP_PROXY = $proxy
    $env:HTTPS_PROXY = $proxy
    Write-Host "Proxy has been set to: $proxy"
} else {
    $env:HTTP_PROXY = ""
    $env:HTTPS_PROXY = ""
    Write-Host "Proxy has been cleared"
}
