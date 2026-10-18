<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Objects/ConvertTo-FlatSettingSet.ps1
    name: convert-to-flat-setting-set
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Objects
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Objects/tests/ConvertTo-FlatSettingSet.Tests.ps1
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
