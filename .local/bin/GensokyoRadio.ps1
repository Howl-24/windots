$global:pipeName = "\\.\pipe\mpvsocket"  # Pipe name for MPV communication
$global:volume = 50  # Initial volume level
$global:pauseState = $true  # Global pause state for MPV

# Function to start the MPV player
function Start-MPV {
    # Start the MPV process with the required arguments (no video, volume, IPC server, stream URL)
    Start-Process -WindowStyle Hidden -FilePath "mpv.com" -ArgumentList "--no-video --volume=$global:volume --input-ipc-server=$pipeName https://stream.gensokyoradio.net/3/"  
    $global:pipeStream = New-Object System.IO.Pipes.NamedPipeClientStream(".", "mpvsocket", [System.IO.Pipes.PipeDirection]::Out)  # Named pipe stream for communication
    $global:pipeStream.Connect()  # Connect to the pipe stream
}

# Function to toggle between play and pause
function Toggle {
    # Toggle the play/pause state by sending a JSON command to MPV
    $jsonCommand = '{"command": ["set_property", "pause", ' + $global:pauseState.ToString().ToLower() + ']}'
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($jsonCommand + "`r`n")
    $pipeStream.Write($bytes, 0, $bytes.Length)
    $pipeStream.Flush()

    if($global:pauseState) { Write-Host "Paused" }
    else { Write-Host "Playing" }

    $global:pauseState = -not $global:pauseState  # Toggle the pause state
}

# Function to set the volume of MPV
function Set-Volume ($volume) {
    # Send a JSON command to adjust the volume of MPV
    $jsonCommand = '{"command": ["set", "volume", "' + $volume + '"]}'
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($jsonCommand + "`r`n")
    $pipeStream.Write($bytes, 0, $bytes.Length)
    Write-Host "Volume: $volume%"  # Output the current volume
}

# Function to convert seconds to minutes and seconds format (mm:ss)
function ConvertTo-MinSec($seconds) {
    $min = [int]([math]::Floor($seconds / 60))  # Calculate minutes and ensure it's an integer
    $sec = [int]($seconds % 60)                  # Calculate seconds and ensure it's an integer
    return "{0:D2}:{1:D2}" -f $min, $sec  # Return formatted time as "mm:ss"
}

Start-MPV  # Start the MPV player

while ($true) {
    # Fetch the current song data from the station API
    $infoUrl = "https://gensokyoradio.net/api/station/playing/"
    $info = Invoke-RestMethod -Uri $infoUrl -Method Get
    $startTime = Get-Date
    $title = $info.SONGINFO.TITLE
    $artist = $info.SONGINFO.ARTIST
    $album = $info.SONGINFO.ALBUM
    $year = $info.SONGINFO.YEAR
    $duration = $info.SONGTIMES.DURATION
    $played = $info.SONGTIMES.PLAYED
    $rating = $info.SONGDATA.RATING
    $albumArt = $info.MISC.ALBUMART
    $albumArtUrl = "https://gensokyoradio.net/images/albums/500/$albumArt"
    
    # Wait for the song to finish
    while ($played -ge $duration) {
        Start-Sleep -Seconds 1
        $info = Invoke-RestMethod -Uri $infoUrl -Method Get  # Fetch updated song data
        $startTime = Get-Date
        $title = $info.SONGINFO.TITLE
        $artist = $info.SONGINFO.ARTIST
        $album = $info.SONGINFO.ALBUM
        $year = $info.SONGINFO.YEAR
        $duration = $info.SONGTIMES.DURATION
        $played = $info.SONGTIMES.PLAYED
        $rating = $info.SONGDATA.RATING
        $albumArt = $info.MISC.ALBUMART
        $albumArtUrl = "https://gensokyoradio.net/images/albums/500/$albumArt"
    }

    # Display album art if available
    if ($albumArt) {
        Invoke-WebRequest -Uri $albumArtUrl -Method Get | Select-Object -ExpandProperty Content | wezterm imgcat
        Write-Host "`r"  # Clear the output line after displaying the album art
    }

    # Display song information
    meow "Title:  $title"
    meow "Artist: $artist"
    meow "Album:  $album"
    meow "Year:   $year"
    if ($rating -ne "N/A") {
        meow "Rating: $rating"
    }
    
    while ($totalPlayed -le $duration) {
        # Calculate the total played time
        $elapsedTime = (Get-Date) - $startTime
        $totalPlayed = $played + [math]::Floor($elapsedTime.TotalSeconds)

        # Calculate the progress as a percentage and ensure that progress does not exceed 100
        $progress = [math]::Min(100, ($totalPlayed / $duration) * 100)

        # Format the time display
        $playedFormatted = ConvertTo-MinSec $totalPlayed
        $durationFormatted = ConvertTo-MinSec $duration

        # Show the progress bar
        Write-Progress -PercentComplete $progress -Status "Playing: $playedFormatted / $durationFormatted" -Activity "Song Progress"
        
        # Check for key presses for user interaction
        if ([console]::KeyAvailable) {
            $key = [console]::ReadKey($true).Key

            # Stop the script and MPV when "Q" is pressed
            if ($key -eq "Q") {
                Write-Host "Stopping the script execution, MPV will also stop playing..."
                Stop-Process -Name "mpv" -Force
                $global:pipeStream.Close()
                $global:pipeStream.Dispose()
                Exit  # Exit the entire script
            }
            
            # Restart MPV when "R" is pressed
            if ($key -eq "R") {
                Write-Host "Restarting MPV..."
                Stop-Process -Name "mpv" -Force
                if ($global:pipeStream -and $global:pipeStream.IsConnected) {
                    $global:pipeStream.Close()
                    $global:pipeStream.Dispose()
                }
                Start-Sleep -Seconds 1
                Start-MPV  # Restart MPV
                break
            }
            
            # Toggle pause/play when Spacebar is pressed
            if ($key -eq "Spacebar") {
                Toggle  # Call pause/resume function
            } 
            
            # Increase volume when "OemPlus" (Equals key) is pressed
            if ($key -eq "OemPlus") {
                $global:volume = [math]::Min(100, $global:volume + 5)  # Ensure the volume doesn't exceed 100
                Set-Volume -volume $global:volume
            }
            
            # Decrease volume when "OemMinus" (Minus key) is pressed
            if ($key -eq "OemMinus") {
                $global:volume = [math]::Max(0, $global:volume - 5)  # Ensure the volume doesn't go below 0
                Set-Volume -volume $global:volume
            }

            # Print image url
            if ($key -eq "P") {
                Write-Host "Image: $albumArtUrl"
            }
                     
        }
        Start-Sleep -Milliseconds 100  # Small delay to avoid excessive CPU usage
    }

    $totalPlayed = 0  # Reset total played time
    $progress = 0     # Reset progress
    Write-Progress -Activity "Done" -Completed  # Mark the progress as completed
    Write-Output "`r"  # Clear the progress bar
}
