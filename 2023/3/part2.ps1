<#
Does not work / Unfinished
#>

function Check-Horizontal {
    param (
        $w,
        $wM,
        $h
    )

    process {
        $hValid = $null
        # Establishing Boundaries
        if ($w -eq 0) { $whs = 0 } else { $whs = ($w - 1) } # To the left, adding diagonal option
        if ($wM -eq ($width - 1)) { $whe = $wM } else { $whe = ($wM + 1) } # To the right, adding diagonal option
        
        # Checking the possible positions for a symbol  
        for ($wh = $whs; $wh -le $whe; $wh++) {
            $charToCheck = [string]$content[$h][$wh]
            if ($charToCheck -eq "*") { $hValid = "h$($h)w$($wh)"}
        }
    }

    end {
        return $hValid
    }
}

function Check-Vertical {
    param (
        $h, $w, $wM
    )

    process {
        do {
            $nf += $value
            $wL = ($wL + 1)
            if ($wL -gt $width){ Write-Host "Exceeding the Schemetic Width"; break;  } # If we look beyond the schematic width
            else { $wM = ($wL - 1) } # Width Max the number is found on.
            $value = [string]$content[$h][$wL]
        } while ($numbers.Contains($value))
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

        $vValid = $false
        
        # Find gear on the left, should not happen if we exclud found numbers..
        if ($w -ne 0) {
            $charLeft = [string]$content[$h][$w-1]
            if ($charLeft -eq "*" -and -not $numbers.Contains($charLeft)) { $vValid = $true } # Found a gear on left of number
        }

        # Find gear on the right, we need to check if there's a number on the right, or above/below adjusting..
        if ($vValid -eq $false -and $wM -ne ($width - 1)) {
            $charRight = [string]$content[$h][$wM+1]
            if ($charRight -eq "*" -and -not $numbers.Contains($charRight)) { $vValid = $true } # Found a gear on right of number

            if ($h -ne 0) {
                $hA = ($h - 1)
                $wAl = If ($w -eq 0) { $w } else { ($w - 1) }
                $wAr = If ($wM -eq ($width - 1)) { $wM } else { ($wM + 1) }
                
                $nA = Check-Vertical -h $hA -w $wAl -wM $wAr
            }
            $hB = ($h + 1)

        }

        if ($vValid -eq $false) {
            # Check for row above?
            $hValid = $false
            if ($h -ne 0) {
                $result = Check-Horizontal -w $w -wM $wM -h ($h - 1)
                if ($null -ne $result) { $hValid = $true }
            } 
            
            # Check for row below?
            if ($hValid -eq $false -and $h -ne ($height - 1)) {
                $result = Check-Horizontal -w $w -wM $wM -h ($h + 1)
                if ($null -ne $result) { $hValid = $true }
            }
        }
    }
}

Write-Host "Measurement: $(($vspn | measure-object -sum).sum)"