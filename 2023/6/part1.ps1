$content = Get-Content $PSScriptRoot\input.txt

$time = (($content[0] -split ":")[1].Trim() -split "\s+")
$distance = (($content[1] -split ":")[1].Trim() -split "\s+")

$calc = New-Object System.Collections.Generic.List[System.Object]
for ($i = 0; $i -lt $time.Count; $i++) {

    $t = $time[$i]
    $d = $distance[$i]

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
    $calc.Add($pb) | Out-Null
}

$total = $calc[0]
for ($c = 1; $c -lt $calc.Count; $c++) {
    $total = ($total * $calc[$c])
}

Write-Host $total