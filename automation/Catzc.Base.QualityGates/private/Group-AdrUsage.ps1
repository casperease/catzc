<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Group-AdrUsage.ps1
    folder: private
    name: group-adr-usage
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Group-AdrUsage.Tests.ps1
---
#>

function Group-AdrUsage {
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
        $groups = $Row | Group-Object -Property { "$($_.Code)#$($_.Rule)" }
        $result = foreach ($group in $groups) {
            $first = $group.Group[0]
            $documents = [string[]] @($group.Group.Path | Sort-Object -Unique -CaseSensitive)
            [pscustomobject]@{ Code = $first.Code; Rule = $first.Rule; Count = $documents.Count; Documents = $documents }
        }
        $result | Sort-Object -Property Code, @{ Expression = { if ($null -eq $_.Rule) {
                    -1
                }
                else {
                    $_.Rule
                } }
        }
        return
    }

    $groups = $Row | Group-Object -Property Path
    $result = foreach ($group in $groups) {
        $citations = [string[]] @($group.Group | ForEach-Object { if ($null -eq $_.Rule) {
                    $_.Code
                }
                else {
                    "$($_.Code)#$($_.Rule)"
                } } | Sort-Object -Unique -CaseSensitive)
        [pscustomobject]@{ Path = $group.Name; Count = $citations.Count; Citations = $citations }
    }
    $result | Sort-Object -Property Path
}
