# Prompt the user to select a terminal to launch
Write-Host "Select a terminal to launch:"
Write-Host "1. WezTerm (wezterm-gui) [Default]"
Write-Host "2. Windows Terminal (wt)"
Write-Host "3. Command Prompt (cmd)"
$choice = Read-Host "Enter your choice (1/2/3, default is 1)"

# Launch the selected terminal with administrative privileges
switch ($choice) {
    "2" { Start-Process "wt" -Verb RunAs }
    "3" { Start-Process "cmd" -Verb RunAs }
    default { Start-Process "wezterm-gui" -Verb RunAs }
}
