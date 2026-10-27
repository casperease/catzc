function Get-DrsRules {
    [OutputType([object[]])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $DrsPath
    )

    Assert-PathExist $DrsPath

    $ruleHeading = "^###\s+Rule\s+(?<id>$((Get-Config -Config drs).CodeForm.Rule))\s*$"
    $lines = [System.IO.File]::ReadAllLines($DrsPath)
    $ret = for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -cnotmatch $ruleHeading) {
            continue
        }
        $ruleId = $Matches['id']

        # The first paragraph: skip the padding blank lines, then read until the next blank line or heading.
        $paragraph = [System.Collections.Generic.List[string]]::new()
        for ($j = $i + 1; $j -lt $lines.Count; $j++) {
            $candidate = $lines[$j].Trim()
            if ($candidate -eq '') {
                if ($paragraph.Count -gt 0) {
                    break
                }
                continue
            }
            if ($candidate.StartsWith('#')) {
                break
            }
            $paragraph.Add($candidate)
        }

        $summary = ''
        if ($paragraph.Count -gt 0) {
            $summary = $paragraph[0]
        }

        [pscustomobject]@{
            Id        = $ruleId
            Summary   = $summary
            Statement = $paragraph -join ' '
        }
    }

    @($ret)
}
