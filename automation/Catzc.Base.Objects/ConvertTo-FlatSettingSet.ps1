<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Objects/ConvertTo-FlatSettingSet.ps1
    name: convert-to-flat-setting-set
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Objects
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.Objects/tests/ConvertTo-FlatSettingSet.Tests.ps1
  config:
    synopsis: Flattens a nested object into an ordered dictionary of dot-notation key/value pairs.
    description: |-
      Recursively walks a PSCustomObject (e.g. parsed JSON/YAML configuration)
      and returns an OrderedDictionary where each key is the full dot-separated
      path to a leaf property and each value is the leaf value.

      Non-leaf nodes (objects, dictionaries, arrays) are expanded, not included.
      Null values are stored as empty strings.

      Supports pipeline input for batch processing.
    parameters:
      InputObject: One or more objects to flatten.
      MaxDepth: Maximum recursion depth. Defaults to 10.
    examples:
      - |-
        $config = Get-Content config.json | ConvertFrom-Json
        $flat = $config | ConvertTo-FlatSettingSet
        $flat.Keys | ForEach-Object { "$_ = $($flat[$_])" }
        # app.name = myapp
        # app.settings.timeout = 30
      - |-
        $flat = ConvertTo-FlatSettingSet $config
        foreach ($key in $flat.Keys) {
            Assert-False ($flat[$key] -eq 'UNDEFINED') "Key '$key' is not defined"
        }
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
