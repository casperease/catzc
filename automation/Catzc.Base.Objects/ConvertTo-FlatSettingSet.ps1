<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Objects/ConvertTo-FlatSettingSet.ps1
    kind: function
    module: Catzc.Base.Objects
    visibility: public
---
#>

<#
.SYNOPSIS
    Flattens a nested object into an ordered dictionary of dot-notation key/value pairs.
.DESCRIPTION
    Only leaves become entries, keyed by their full dot path, and a null leaf is stored as an empty string.
    [comment:1](/docs/references/automation/catzc-base-objects/ConvertTo-FlatSettingSet.ps1.md#comment1)
.PARAMETER InputObject
    One or more objects to flatten.
.PARAMETER MaxDepth
    Maximum recursion depth. Defaults to 10.
.EXAMPLE
    $config = Get-Content config.json | ConvertFrom-Json
    $flat = $config | ConvertTo-FlatSettingSet
    $flat.Keys | ForEach-Object { "$_ = $($flat[$_])" }
    # app.name = myapp
    # app.settings.timeout = 30
.EXAMPLE
    $flat = ConvertTo-FlatSettingSet $config
    foreach ($key in $flat.Keys) {
        Assert-False ($flat[$key] -eq 'UNDEFINED') "Key '$key' is not defined"
    }
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
