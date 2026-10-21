<#
---
catzc:
  immutable:
    with_body_sha: "74c097155f58"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Group-DrsUsage.Tests.ps1
    docs: "[Group-DrsUsage.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Group-DrsUsage.ps1.md)"
---
#>

function Group-DrsUsage {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [pscustomobject[]] $Row,

        [Parameter(Mandatory)]
        [ValidateSet('Rule', 'Document')]
        [string] $By
    )

    if ($By -eq 'Rule') {
        $groups = $Row | Group-Object -Property { "$($_.Code)|$($_.Rule)" }
        $result = foreach ($group in $groups) {
            $first = $group.Group[0]
            $documents = [string[]] @($group.Group.Path | Sort-Object -Unique -CaseSensitive)
            [pscustomobject]@{ Code = $first.Code; Rule = $first.Rule; Count = $documents.Count; Documents = $documents }
        }
        # The whole ADR sorts before its rules: an empty rule key is the smallest.
        $result | Sort-Object -CaseSensitive -Property Code, @{ Expression = { "$($_.Rule)" } }
        return
    }

    $groups = $Row | Group-Object -Property Path
    $result = foreach ($group in $groups) {
        $citations = [string[]] @($group.Group | ForEach-Object { if ($null -eq $_.Rule) {
                    $_.Code
                }
                else {
                    $_.Rule
                } } | Sort-Object -Unique -CaseSensitive)
        [pscustomobject]@{ Path = $group.Name; Count = $citations.Count; Citations = $citations }
    }
    $result | Sort-Object -Property Path
}
