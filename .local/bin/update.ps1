# Update all Scoop-managed applications
Write-Host "Updating all Scoop apps..."
scoop update *  # Update all apps managed by Scoop

# Cleanup old versions and unused files in Scoop
# Write-Host "Cleaning up Scoop apps..."
# scoop cleanup *  # Cleanup old versions of applications installed via Scoop

# # Remove the Scoop cache (optional, use with caution)
# Write-Host "Removing Scoop cache..."
# scoop cache rm *  # Remove cached files in Scoop

# Export the current Scoop configuration to a JSON file
Write-Host "Exporting Scoop configuration..."
scoop export -c > C:\Users\Howl\.config\scoop\scoopfile.json

# Winget get all upgradeable applications
$apps = winget upgrade

# Filter out the header and empty lines
$parsedApps = $apps | Where-Object { $_ -match "^\S" -and $_ -notmatch "^\s*-{10,}" } | ForEach-Object {
    # Use regex to match the application name, ID, version, available version, and source
    if ($_ -match "^([\w\s]+)\s+([\w\.]+)\s+([\d\.]+)\s+([\d\.]+)\s+(\w+)") {
        # Create a custom object to store the parsed data
        [PSCustomObject]@{
            Name        = $matches[1].Trim()  # Application Name
            Id          = $matches[2].Trim()  # Application ID
            Version     = $matches[3].Trim()  # Installed Version
            Available   = $matches[4].Trim()  # Available Version
            Source      = $matches[5].Trim()  # Source of the package (e.g., winget)
        }
    }
}

# Output the list of all upgradeable apps
if ($parsedApps.Count -eq 0) {
    Write-Host "No upgradeable apps found via Winget."
} else {
    Write-Host "All upgradeable apps:"
    $parsedApps | Format-Table -Property Name, Id, Version, Available, Source
    
    # Exclude specific apps from the list
    $filteredApps = $parsedApps | Where-Object { $_.Id -ne "Mozilla.Firefox" -and $_.Id -ne "Spotify.Spotify" -and $_.Id -ne "Microsoft.Edge" }

    # Output the list of apps after exclusions
    if ($filteredApps.Count -eq 0) {
        Write-Host "No apps to update after exclusions."
    } else {
        Write-Host "Filtered APPS (after exclusions):"
        $filteredApps | Format-Table -Property Name, Id, Version, Available, Source

        # Perform the upgrade for the filtered apps
        Write-Host "Updating filtered apps..."
        foreach ($app in $filteredApps) {
            Write-Host "Updating $($app.Name)..."  # Output the app being updated
            winget upgrade $app.Id  # Upgrade each application in the filtered list
        }
    }
}

# Export the current Winget configuration to a JSON file
Write-Host "Exporting Winget configuration..."
winget export -o C:\Users\Howl\.config\winget\packages.json --ignore-warnings
