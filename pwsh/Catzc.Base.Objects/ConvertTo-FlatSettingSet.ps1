<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Objects/ConvertTo-FlatSettingSet.ps1
    name: convert-to-flat-setting-set
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Objects
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Objects/tests/ConvertTo-FlatSettingSet.Tests.ps1
    docs: "[ConvertTo-FlatSettingSet.ps1.md](docs/references/pwsh/catzc-base-objects/ConvertTo-FlatSettingSet.ps1.md)"
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
