function Select-BicepOptionsYamlText {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Text,

        [Parameter(Mandatory)]
        [string[]] $ExcludeKey
    )

    $lines = @($Text -replace "`r", '' -split "`n")
    $kept = [System.Collections.Generic.List[string]]::new()
    $dropping = $false
    foreach ($line in $lines) {
        $topLevel = $line.Length -gt 0 -and -not [char]::IsWhiteSpace($line[0]) -and -not $line.StartsWith('#')
        if ($topLevel) {
            $key = ($line -split ':', 2)[0]
            $dropping = $key -cin $ExcludeKey
            if ($dropping) {
                # The comment lines right above a dropped key describe it, so they go with it.
                while ($kept.Count -gt 0 -and $kept[$kept.Count - 1].StartsWith('#')) {
                    $kept.RemoveAt($kept.Count - 1)
                }
                continue
            }
        }
        elseif ($dropping -and ($line.Length -eq 0 -or [char]::IsWhiteSpace($line[0]))) {
            continue
        }
        else {
            $dropping = $false
        }
        $kept.Add($line)
    }
    ((@($kept) -join "`n").TrimEnd("`n")) + "`n"
}
