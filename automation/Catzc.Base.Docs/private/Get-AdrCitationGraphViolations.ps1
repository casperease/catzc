<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/private/Get-AdrCitationGraphViolations.ps1
    folder: private
    name: get-adr-citation-graph-violations
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.Docs/tests/Get-AdrCitationGraphViolations.Tests.ps1
---
#>

function Get-AdrCitationGraphViolations {
    [OutputType([string[]])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.Docs.AdrsConfig] $Adrs,

        [Parameter(Mandatory)]
        [pscustomobject] $Index
    )

    $domainOfCode = @{}
    foreach ($ruleSet in $Adrs.RuleSets) {
        $domainOfCode[$ruleSet.External] = $ruleSet.Domain
    }
    foreach ($ruleSet in $Adrs.RuleSets) {
        if (-not $domainOfCode.ContainsKey("ADR-$($ruleSet.Code)")) {
            $domainOfCode["ADR-$($ruleSet.Code)"] = $ruleSet.Domain
        }
    }
    $domainNames = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Adrs.Domains.Name), [System.StringComparer]::Ordinal)

    $ret = foreach ($domain in $Adrs.Domains) {
        $allowed = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        [void]$allowed.Add($domain.Name)
        foreach ($dependency in $domain.DependsOn) {
            [void]$allowed.Add($dependency)
        }
        $dependsOn = if ($domain.DependsOn.Count -gt 0) {
            $domain.DependsOn -join ', '
        }
        else {
            'none'
        }

        foreach ($ruleSet in $domain.RuleSets) {
            if (-not $Index.FileOf.ContainsKey($ruleSet.External)) {
                continue
            }
            $relative = $Index.FileOf[$ruleSet.External]
            foreach ($summaryLine in (Get-AdrRuleSummaryLines ([System.IO.Path]::Combine($Index.Root, $relative)))) {
                $references = [System.Collections.Generic.List[object]]::new()
                foreach ($match in [regex]::Matches($summaryLine.Text, '(?<![A-Za-z0-9-])(?<code>ADR-[A-Z]+(?:-[A-Z]+)*)(?<rule>#\d+)?')) {
                    $code = $match.Groups['code'].Value
                    if ($domainOfCode.ContainsKey($code)) {
                        $references.Add(@{ Text = $match.Value; Domain = $domainOfCode[$code] })
                    }
                }
                foreach ($match in [regex]::Matches($summaryLine.Text, '\]\((?<target>[^)\s]+)\)')) {
                    $target = Resolve-AdrLinkTarget -AdrRoot $Index.Root -From $relative $match.Groups['target'].Value
                    if (-not $target -or $target.IndexOf('/') -lt 0) {
                        continue
                    }
                    $targetDomain = $target.Split('/')[0]
                    if ($domainNames.Contains($targetDomain)) {
                        $references.Add(@{ Text = $match.Groups['target'].Value; Domain = $targetDomain })
                    }
                }

                $reported = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
                foreach ($reference in $references) {
                    if ($allowed.Contains($reference.Domain) -or -not $reported.Add($reference.Domain)) {
                        continue
                    }
                    "docs/adr/${relative}:$($summaryLine.Line): $($summaryLine.Rule) ($($domain.Name)) cites $($reference.Text) ($($reference.Domain)); $($domain.Name) depends on: $dependsOn"
                }
            }
        }
    }

    [string[]] @($ret)
}
