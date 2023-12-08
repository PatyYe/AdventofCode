function Check-Horizontal {
    param (
        $w,
        $wM,
        $h
    )

    process {
        $hValid = $false
        # Establishing Boundaries
        if ($w -eq 0) { $whs = 0 } else { $whs = ($w - 1) } # To the left, adding diagonal option
        if ($wM -eq ($width - 1)) { $whe = $wM } else { $whe = ($wM + 1) } # To the right, adding diagonal option
        
        # Checking the possible positions for a symbol  
        for ($wh = $whs; $wh -le $whe; $wh++) {
            $charToCheck = [string]$content[$h][$wh]
            if ($charToCheck -ne ".") { $hValid = $true }
        }
    }

    end {
        return $hValid
    }
}


$content = Get-Content input.txt
$numbers = @('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')

$width = $content[0].Length
$height = $content.Count

$vspn = [System.Collections.ArrayList]::new()


for ($h = 0; $h -lt $height; $h++) {
    $wF = 0
    for ($w = 0; $w -lt $width; $w++) {
        if ($w -le $wF -and $w -ne 0) { continue } # Foundt his number already
        
        ### Look Vertical for additional numbers.
        $value = [string]$content[$h][$w]
        $wM = $w
        $wL = $w
        $nF = ""

        if (-not $numbers.Contains($value)) { continue } # Don't have to check any corresponding numbers
        do {
            $nf += $value
            $wL = ($wL + 1)
            if ($wL -gt $width){ Write-Host "Exceeding the Schemetic Width"; break;  } # If we look beyond the schematic width
            else { $wM = ($wL - 1) } # Width Max the number is found on.
            $value = [string]$content[$h][$wL]
        } while ($numbers.Contains($value))
        $wF = $wM  # Set the number to not be searched again from this position
        
        if ($nF -eq "126") { Write-Host "Found number ($nF) in Row: $h, Position $w - $wM" }

        $vValid = $false
        if ($w -ne 0) {
            $charLeft = [string]$content[$h][$w-1]
            if ($charLeft -ne "." -and -not $numbers.Contains($charLeft)) { $vValid = $true }
        }
        if ($vValid -eq $false -and $wM -ne ($width - 1)) {
            $charRight = [string]$content[$h][$wM+1]
            if ($charRight -ne "." -and -not $numbers.Contains($charRight)) { $vValid = $true }
        }

        if ($vValid -eq $false) {
            # Check for row above?
            $hValid = $false
            if ($h -ne 0) {
                $hValid = Check-Horizontal -w $w -wM $wM -h ($h - 1)
            } 
            
            # Check for row below?
            if ($hValid -eq $false -and $h -ne ($height - 1)) {
                $hValid = Check-Horizontal -w $w -wM $wM -h ($h + 1)
            }

            if ($hValid -eq $true) {
                $vspn.Add($nF) | Out-Null
            }
        } else {
            $vspn.Add($nF) | Out-Null
        }
    }
}

Write-Host "Measurement: $(($vspn | measure-object -sum).sum)"