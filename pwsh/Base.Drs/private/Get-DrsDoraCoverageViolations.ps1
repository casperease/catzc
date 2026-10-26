<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/private/Get-DrsDoraCoverageViolations.ps1.md"
  header: "generated"
---
#>

function Get-DrsDoraCoverageViolations {
    [OutputType([string[]])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.Drs.DrsConfig] $Adrs,

        [Parameter(Mandatory)]
        [pscustomobject] $Index,

        [Parameter(Mandatory)]
        [Catzc.Base.Drs.DrsDoraCheck] $Settings
    )

    $ret = foreach ($domain in $Adrs.Domains) {
        if ($Settings.exempt.ContainsKey($domain.Name)) {
            continue
        }
        $doraRelative = "$($domain.Folder)/$($Settings.file)"
        $doraPath = [System.IO.Path]::Combine($Index.Root, $doraRelative)
        if (-not [System.IO.File]::Exists($doraPath)) {
            foreach ($ruleSet in $domain.RuleSets) {
                "$($Adrs.Root)/${doraRelative}: missing, so no section links $($ruleSet.External)"
            }
            continue
        }

        # The ADR files each `## ` section links, keyed by the section's heading line.
        $sections = [System.Collections.Generic.List[object]]::new()
        $current = $null
        $inFence = $false
        $lines = [System.IO.File]::ReadAllLines($doraPath)
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]
            if ($line -match '^\s*(```|~~~)') {
                $inFence = -not $inFence
                continue
            }
            if ($inFence) {
                continue
            }
            if ($line -match '^#{1,2}\s') {
                $current = $null
                if ($line.StartsWith('## ')) {
                    $current = @{ Line = $i + 1; Targets = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal) }
                    $sections.Add($current)
                }
                continue
            }
            if ($null -eq $current) {
                continue
            }
            foreach ($match in [regex]::Matches($line, '\]\((?<target>[^)\s]+)\)')) {
                $target = Resolve-DrsLinkTarget -DrsRoot $Index.Root -From $doraRelative $match.Groups['target'].Value
                if ($target) {
                    [void]$current.Targets.Add($target)
                }
            }
        }

        foreach ($ruleSet in $domain.RuleSets) {
            if (-not $Index.FileOf.ContainsKey($ruleSet.External)) {
                continue
            }
            $adrRelative = $Index.FileOf[$ruleSet.External]
            if ($Settings.IsExemptPath($adrRelative)) {
                continue
            }
            $linkingLines = [System.Collections.Generic.List[int]]::new()
            foreach ($section in $sections) {
                if ($section.Targets.Contains($adrRelative)) {
                    $linkingLines.Add($section.Line)
                }
            }
            if ($linkingLines.Count -eq 0) {
                "$($Adrs.Root)/${doraRelative}: no section links $($ruleSet.External) ($($Adrs.Root)/$adrRelative)"
            }
            elseif ($linkingLines.Count -gt 1) {
                "$($Adrs.Root)/${doraRelative}:$($linkingLines -join ','): $($linkingLines.Count) sections link $($ruleSet.External) ($($Adrs.Root)/$adrRelative)"
            }
        }
    }

    [string[]] @($ret)
}
