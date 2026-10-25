<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-maps/Get-LayerStackMinimapData.ps1.md"
  header: "generated"
---
#>

function Get-LayerStackMinimapData {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.MinimapData], [string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Adr,

        [Catzc.Base.Maps.WorldMap] $WorldMap,

        [System.Collections.IDictionary] $Facts,

        [switch] $AsJson
    )

    # The layers in stack order; each subject file lights the layer of the ADR its requested code belongs to.
    $layers = [string[]] @([Catzc.Base.Drs.DrsConfig]::Layers)
    $ruleSets = @(Get-DrsRuleSet | Sort-Object { $_.External.Length } -Descending)
    $count = @{}
    $reasons = @{}
    foreach ($item in @(Get-MinimapSubject -Adr $Adr -WorldMap $WorldMap -Facts $Facts)) {
        $ruleSet = $ruleSets | Where-Object { $item.Requested -ceq $_.External -or $item.Requested.StartsWith("$($_.External)-", [System.StringComparison]::Ordinal) } |
            Select-Object -First 1
        if (-not $ruleSet) {
            continue
        }
        $reason = [Catzc.Base.Maps.MinimapReason]::new($item.Path, 'cites', $item.Requested, $ruleSet.External)
        Add-MinimapHit -Count $count -Reasons $reasons -At @($ruleSet.Layer) -Reason $reason
    }
    $cells = [string[][]] @(foreach ($layer in $layers) {
            , [string[]] @($layer)
        })
    $data = New-MinimapData -Id ([Catzc.Base.Maps.MinimapData]::LayerStack) -Axes ([ordered]@{ layer = $layers }) -Cells $cells -Count $count -Reasons $reasons
    if ($AsJson) {
        return $data.ToJson()
    }
    $data
}
