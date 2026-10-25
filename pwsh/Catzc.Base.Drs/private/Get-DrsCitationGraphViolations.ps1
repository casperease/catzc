<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/private/Get-DrsCitationGraphViolations.ps1.md"
  warning: "Generated Header"
---
#>

function Get-DrsCitationGraphViolations {
    [OutputType([string[]])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.Drs.DrsConfig] $Adrs,

        [Parameter(Mandatory)]
        [pscustomobject] $Index
    )

    $domainOfCode = @{}
    foreach ($ruleSet in $Adrs.RuleSets) {
        $domainOfCode[$ruleSet.External] = $ruleSet.Domain
    }
    foreach ($ruleSet in $Adrs.RuleSets) {
        if (-not $domainOfCode.ContainsKey($ruleSet.Prefix)) {
            $domainOfCode[$ruleSet.Prefix] = $ruleSet.Domain
        }
    }
    $ruleHeading = "^###\s+Rule\s+(?<code>$($Adrs.CodeForm.Rule))\s*$"
    $citation = "(?<![A-Za-z0-9-])$($Adrs.CodeForm.Cited)"
    # A link's domain is the one with the longest folder that holds its target, so a domain folder nested in another keeps its own links.
    $folders = @($Adrs.Domains | Sort-Object -Property { $_.Folder.Length } -Descending)

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
            $lines = [System.IO.File]::ReadAllLines([System.IO.Path]::Combine($Index.Root, $relative))
            $rule = $null
            $inFence = $false
            for ($i = 0; $i -lt $lines.Count; $i++) {
                $text = $lines[$i]
                if ($text -match '^\s*(```|~~~)') {
                    $inFence = -not $inFence
                    continue
                }
                if ($inFence) {
                    continue
                }
                if ($text -match '^#{1,6}\s') {
                    $rule = if ($text -cmatch $ruleHeading) {
                        $Matches['code']
                    }
                    else {
                        $null
                    }
                }
                $citer = if ($rule) {
                    $rule
                }
                else {
                    $ruleSet.External
                }
                $references = [System.Collections.Generic.List[object]]::new()
                foreach ($match in [regex]::Matches($text, $citation)) {
                    # A rule's code extends its ADR's code, so the longest registered prefix names the domain.
                    $code = $match.Value
                    while ($code.Contains('-') -and -not $domainOfCode.ContainsKey($code)) {
                        $code = $code.Substring(0, $code.LastIndexOf('-'))
                    }
                    if ($domainOfCode.ContainsKey($code)) {
                        $references.Add(@{ Text = $match.Value; Domain = $domainOfCode[$code] })
                    }
                }
                foreach ($match in [regex]::Matches($text, '\]\((?<target>[^)\s]+)\)')) {
                    $target = Resolve-DrsLinkTarget -DrsRoot $Index.Root -From $relative $match.Groups['target'].Value
                    if (-not $target -or $target.IndexOf('/') -lt 0) {
                        continue
                    }
                    $owner = $folders | Where-Object { $target.StartsWith("$($_.Folder)/", [System.StringComparison]::Ordinal) } | Select-Object -First 1
                    if ($owner) {
                        $references.Add(@{ Text = $match.Groups['target'].Value; Domain = $owner.Name })
                    }
                }

                $reported = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
                foreach ($reference in $references) {
                    if ($allowed.Contains($reference.Domain) -or -not $reported.Add($reference.Domain)) {
                        continue
                    }
                    "$($Adrs.Root)/${relative}:$($i + 1): $citer ($($domain.Name)) cites $($reference.Text) ($($reference.Domain)); $($domain.Name) depends on: $dependsOn"
                }
            }
        }
    }

    [string[]] @($ret)
}
