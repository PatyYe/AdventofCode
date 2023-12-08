<#
Code works but execution time is to long when doing LOTS of seeds.
#>
$content = Get-Content $PSScriptRoot\input.txt

function MapPart {
    param (
        $ctx
    )
    process {
        $array = New-Object System.Collections.Generic.List[System.Object]
        foreach ($item in $ctx) {
            $split = ($item.Trim() -split " ")
            $dest = [bigint]$split[0]
            $source = [bigint]$split[1]
            $range = [bigint]$split[2]

            $hashMap = @{
                source = $source
                dest = $dest
                range = $range
            }
            $array.Add($hashMap) | Out-Null
        }
    }
    end {
        return $array
    }
}

function breakContent {
    param(
        $ctx, $toreturn
    )

    process {
        $outItems = New-Object System.Collections.Generic.List[System.Object]
        $foundPart = $false
        foreach ($line in $ctx) {
            if ($line -match $toreturn) { $foundPart = $true; continue}
            if ($foundPart) {
                if ($line -eq "") { break; }
                else {
                    $outItems.Add($line)
                }
            }
        }
    }

    end {
        return $outItems
    }
}

function sourceToDest {
    param (
        $compare, $list
    )

    process {
        $res = $compare
        foreach ($option in $list) {
            # Write-Host "Checking $($option.source) -> $($option.source + $option.range)"
            # if ($compare -ge $option.source -and $compare -le ($option.source + $option.range)) {
            if (($option.source -le $compare) -and (($option.source + $option.range) -ge $compare)) {
                # Write-Host "$compare found in between $($option.source) and $(($option.source + $option.range))"
                [bigint]$diff = ($compare - $option.source) # Difference between source
                if ($diff -lt 0) { $diff = ($diff * -1) }
                $res = ($option.dest + $diff) # Add difference to dest to get correct dest
            }
        }
    }

    end {
        # Write-Host "Returning $res"
        return $res
    }
}

$seeds = (($content[0] -split "seeds: ")[1].Trim() -split " ")
$sts = MapPart -ctx (breakContent -ctx $content -toreturn "seed-to-soil")
$stf = MapPart -ctx (breakContent -ctx $content -toreturn "soil-to-fertilizer")
$ftw = MapPart -ctx (breakContent -ctx $content -toreturn "fertilizer-to-water")
$wtl = MapPart -ctx (breakContent -ctx $content -toreturn "water-to-light")
$ltt = MapPart -ctx (breakContent -ctx $content -toreturn "light-to-temperature")
$tth = MapPart -ctx (breakContent -ctx $content -toreturn "temperature-to-humidity")
$htl = MapPart -ctx (breakContent -ctx $content -toreturn "humidity-to-location")

$lowestLoca = $null
$i = 0
foreach ($ita in $seeds) {
    $Result = $i % 2
    if ($Result -eq 0) {
        $start = [bigint]$seeds[$i]
        $end = [bigint]([bigint]$seeds[$i] + [bigint]$seeds[$i+1] - 1)
        Write-Host "Checking Seeds $start -> $end"
        for ($j = [bigint]$start; $j -le $end; $j = $j + 1) {
            $seed = [bigint]$j
            Write-Progress -Activity "Checking $seed" -PercentComplete ((100 / $end) * $j)
            $soil = sourceToDest -compare $seed -list $sts
            $fert = sourceToDest -compare $soil -list $stf
            $water = sourceToDest -compare $fert -list $ftw
            $light = sourceToDest -compare $water -list $wtl
            $temp = sourceToDest -compare $light -list $ltt
            $humi = sourceToDest -compare $temp -list $tth
            $loca = sourceToDest -compare $humi -list $htl
        
            if ($null -eq $lowestLoca) { $lowestLoca = $loca }
            else { 
                if ($loca -lt $lowestLoca) {
                    $lowestLoca = $loca
                }
            }
            # Write-Host "Seed $seed, soil $soil, fertilizer $fert, water $water, light $light, temperature $temp, humidity $humi, location $loca."
        }
    }
    $i++

}

Write-Host "Lowest Location: $lowestLoca"