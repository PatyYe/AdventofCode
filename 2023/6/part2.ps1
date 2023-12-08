<#
Execution time is long, but not so long you need to wait over 10 minutes.
#>
$content = Get-Content $PSScriptRoot\input.txt

$time = ((($content[0] -split ":")[1].Trim() -split "\s+") -join '')
$distance = ((($content[1] -split ":")[1].Trim() -split "\s+") -join '')

$t = $time
$d = $distance

Write-Host "Time: $t - Distance: $d"

# $h for holding
$pb = 0
for ($h = 0; $h -lt $t; $h++) {

    $timeRemaining  = ($t - $h) # time remaining after holding
    $speed          = ($h * 1) # acceleration
    $distancePassed = ($timeRemaining * $speed) # Distance for remaining time at speed

    if ($distancePassed -gt $d) {
        $pb++
        # Write-Host "Holding for $h ms, will cover $distancePassed millimeters over $timeRemaining ms at $speed /ms"
    }
}

Write-Host $pb