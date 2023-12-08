$content = Get-Content $PSScriptRoot\input.txt
$cards = @(1) * ($content.count + 1)
$cards[0] = 0


$totalPoints = 0
foreach ($line in $content) {
    $split1 = ($line -split ":")
    $card = $split1[0]
    [int]$CardNo = $line.split(':')[0] -replace "[^0-9]"

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
    
    for($NoCardsCheck = 0; $NoCardsCheck -lt $cards[$CardNo];$NoCardsCheck++) {
        for($i = ($CardNo + 1); $i -le ($CardNo + $winningSlots); $i++) {
            $Cards[$i] = $Cards[$i] + 1
        }
    }
    
    # Write-Host "$($card): Has $winningSlots of matching numbers, awarded with $points points."
    $totalPoints += $points
}
write-output "$($Cards | Measure-Object -Sum | Select-Object -ExpandProperty Sum )"
