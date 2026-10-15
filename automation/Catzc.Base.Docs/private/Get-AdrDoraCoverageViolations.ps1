<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-AdrDoraCoverageViolations.ps1
    kind: automation-function
    module: Catzc.Base.Docs
    visibility: private
    relatives:
      test: automation/Catzc.Base.Docs/tests/Get-AdrDoraCoverageViolations.Tests.ps1
  config:
    synopsis: Lists every rule set whose domain's DORA file has no section, or more than one, linking its ADR.
    description: |-
      Every domain outside the exempt list keeps one DORA file (dora_coverage.file, default dora-explains.md) with one `## ` section per
      ADR of the domain, the authoring conventions of the ADR index. A section links an ADR when any markdown link in it resolves to the
      ADR's file (Resolve-AdrLinkTarget). This collects a finding when a rule set's ADR is linked from no section, or from more than one,
      and when the DORA file itself is missing. A rule set with no file, or several, is a finding of Test-AdrRegistry and is skipped here,
      and so is one whose ADR lies in a folder the settings exempt (exempt_folders): a vendor-checklist ADR is grounded in the vendor's
      reference, not in DORA.

      Private helper for Test-AdrRegistry; not exported.
    parameters:
      Adrs: The ADR registry (Get-Config -Config adrs).
      Index: The docs/adr/ file index (Get-AdrFileIndex).
      Settings: The check's settings (AdrChecksConfig.dora_coverage).
    outputs: |-
      [string[]] One finding per missing or duplicated section, naming the DORA file, the linking sections' heading lines, and the rule
      set.
---
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
