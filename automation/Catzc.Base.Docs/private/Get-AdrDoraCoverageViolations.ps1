<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-AdrDoraCoverageViolations.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Lists every rule set whose domain's DORA file has no section, or more than one, linking its ADR.
.DESCRIPTION
    Rule sets in exempt_folders are skipped, as a vendor-checklist ADR is grounded in the vendor's reference, not DORA.
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-AdrDoraCoverageViolations.ps1.md#comment1)
.PARAMETER Adrs
    The ADR registry (Get-Config -Config adrs).
.PARAMETER Index
    The docs/adr/ file index (Get-AdrFileIndex).
.PARAMETER Settings
    The check's settings (AdrChecksConfig.dora_coverage).
.OUTPUTS
    [string[]] One finding per missing or duplicated section, naming the DORA file, the linking sections' heading lines, and the rule
    set.
#>
function Get-AdrDoraCoverageViolations {
    [OutputType([string[]])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.Docs.AdrsConfig] $Adrs,

        [Parameter(Mandatory)]
        [pscustomobject] $Index,

        [Parameter(Mandatory)]
        [Catzc.Base.Docs.AdrDoraCheck] $Settings
    )

    $ret = foreach ($domain in $Adrs.Domains) {
        if ($Settings.exempt.ContainsKey($domain.Name)) {
            continue
        }
        $doraRelative = "$($domain.Name)/$($Settings.file)"
        $doraPath = [System.IO.Path]::Combine($Index.Root, $doraRelative)
        if (-not [System.IO.File]::Exists($doraPath)) {
            foreach ($ruleSet in $domain.RuleSets) {
                "docs/adr/${doraRelative}: missing, so no section links $($ruleSet.External)"
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
                $target = Resolve-AdrLinkTarget -AdrRoot $Index.Root -From $doraRelative $match.Groups['target'].Value
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
                "docs/adr/${doraRelative}: no section links $($ruleSet.External) (docs/adr/$adrRelative)"
            }
            elseif ($linkingLines.Count -gt 1) {
                "docs/adr/${doraRelative}:$($linkingLines -join ','): $($linkingLines.Count) sections link $($ruleSet.External) (docs/adr/$adrRelative)"
            }
        }
    }

    [string[]] @($ret)
}
