<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Maps/Get-LifecyclePositionMinimapData.ps1
    name: get-lifecycle-position-minimap-data
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Get-LifecyclePositionMinimapData.Tests.ps1
    docs: "[Get-LifecyclePositionMinimapData.ps1.md](docs/references/pwsh/catzc-base-maps/Get-LifecyclePositionMinimapData.ps1.md)"
    cites:
      - ADR-FLOW-CD
---
#>

function Get-LifecyclePositionMinimapData {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.MinimapData], [string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Adr,

        [switch] $AsJson
    )

    # The rungs in climbing order; a subject file lights a rung when it cites one of the rung's rules, or the ADR that holds the rule.
    $rungs = @(Get-Rung)
    $count = @{}
    $reasons = @{}
    foreach ($item in @(Get-MinimapSubject -Adr $Adr)) {
        foreach ($rung in $rungs) {
            $hit = foreach ($rule in $rung.rules) {
                foreach ($citation in $item.Citations) {
                    if ($citation -ceq $rule -or $rule.StartsWith("$citation-", [System.StringComparison]::Ordinal)) {
                        $rule
                    }
                }
            }
            $rule = @($hit) | Select-Object -First 1
            if ($rule) {
                Add-MinimapHit -Count $count -Reasons $reasons -At @($rung.name) -Reason ([Catzc.Base.Maps.MinimapReason]::new($item.Path, 'cites', $item.Requested, $rule))
            }
        }
    }
    $names = [string[]] @($rungs | ForEach-Object name)
    $cells = [string[][]] @(foreach ($name in $names) {
            , [string[]] @($name)
        })
    $data = New-MinimapData -Id ([Catzc.Base.Maps.MinimapData]::LifecyclePosition) -Axes ([ordered]@{ rung = $names }) -Cells $cells -Count $count -Reasons $reasons
    if ($AsJson) {
        return $data.ToJson()
    }
    $data
}
