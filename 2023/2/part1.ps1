<#
The Elf would first like to know which games would have been possible if the bag contained only 12 red cubes, 13 green cubes, and 14 blue cubes?

Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
#>

$content = Get-Content input.txt

$maxRed = 12
$maxGreen = 13
$maxBlue = 14

$sum = 0
foreach ($game in $content) {
    $gameSplit = ($game -split ":")
    $gameNum = [int]($gameSplit[0] -split "Game ")[1]

    $rounds = $gameSplit[1] -split ";"

    $gameValid = $true
    foreach ($round in $rounds) {
        $cubes = $round -split ","
        foreach ($cubeColor in $cubes) {
            if ($cubeColor -match "green") {
                if ([int]($cubeColor -split "green")[0].Trim() -gt $maxGreen) { $gameValid = $false }
            }
            if ($cubeColor -match "blue") {
                if ([int]($cubeColor -split "blue")[0].Trim() -gt $maxBlue) { $gameValid = $false }
            }
            if ($cubeColor -match "red") {
                if ([int]($cubeColor -split "red")[0].Trim() -gt $maxRed) { $gameValid = $false }
            }
        }
    }
    
    if ($gameValid) {
        Write-Host "Game $($gameNum) is valid."
        $sum += $gameNum
    } else {
        Write-Host "Game $($gameNum) is invalid."
        Write-Host $gameSplit[1] -ForegroundColor Green
    }
}

Write-Host "Sum Total: $($sum)"