$string = Get-Content input.txt

$total = 0
foreach ($line in $string) {
    $numbers = $line -replace "[^0-9]" , ''
    $array = $numbers.ToCharArray()

    $res = 0
    if ($array.Count -eq 1) {
        $res += [int]"$($array[0])$($array[0])"
    } else {
        $res += [int]"$($array[0])$($array[($array.Count - 1)])"
    }
    $total += $res
}
Write-Host $total