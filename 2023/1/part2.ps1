function Get-Number {
    param (
        $value
    )

    switch ($value) {
        "one" { return "1" }
        "two" { return "2" }
        "three" { return "3" }
        "four" { return "4" }
        "five" { return "5" }
        "six" { return "6" }
        "seven" { return "7" }
        "eight" { return "8" }
        "nine" { return "9" }       
        default { return $value}
    }
}



$string = Get-Content input.txt

$total = 0
foreach ($line in $string) {

    $linematches = [System.Collections.ArrayList]::new()
    $pattern = "one|two|three|four|five|six|seven|eight|nine|\d"
    for ($x = 0; $x -lt $line.Length ; $x++){
        if ($line.Substring($x) -match $pattern) {
            $number = Get-Number -value $matches.Values
            if ($number -ne "") { $linematches.Add($number) | Out-Null }
        }
    }
    $first = $linematches[0]
    $last = $linematches[($linematches.Count - 1)]
    $total += [int]($first + $last)
}
Write-Host $total