$content = Get-Content $PSScriptRoot\input.txt

$totalPoints = 0
foreach ($line in $content) {
    $split1 = ($line -split ":")
    $card = $split1[0]

    $split2 = ($split1[1] -split "\|")
    $winningArray = ($split2[0].Trim() -split " ")
    $scratchNumbers = ($split2[1].Trim() -split " ")

    $winningSlots = 0
    foreach ($sn in $scratchNumbers) {
        $number = [int]$sn
        if ($number -eq 0) {continue}
        foreach ($win in $winningArray) {
            $number2 = [int]$win
            if ($number2 -eq 0) {continue}
            if ($number -eq $number2) {
                # Write-Host "Winning Slot: $number -eq $number2"
                $winningSlots++ 
            }
        }
    }
    
    
    
    $points = 0
    for ($p = 0; $p -lt $winningSlots; $p++) {
        if ($points -eq 0) { $points++ }
        else { $points += $points }
    }
    
    Write-Host "$($card): Has $winningSlots of matching numbers, awarded with $points points."
    $totalPoints += $points
}
Write-Host "Total Points: $totalPoints"