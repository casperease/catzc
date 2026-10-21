<#
---
catzc:
  immutable:
    with_body_sha: e897de6ed136
  edges:
    test: pwsh/Catzc.Base.Objects/tests/ConvertTo-FlatSettingSet.Tests.ps1
    docs: "[ConvertTo-FlatSettingSet.ps1.md](../../docs/references/pwsh/catzc-base-objects/ConvertTo-FlatSettingSet.ps1.md)"
---
#>

function ConvertTo-FlatSettingSet {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [PSObject[]] $InputObject,

        [int] $MaxDepth = 10
    )

    process {
        foreach ($object in $InputObject) {
            $settings = [ordered]@{}
            Expand-ObjectProperties -Value $object -Target $settings -MaxDepth $MaxDepth
            $settings
        }
    }
}
