<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Objects/ConvertTo-Dictionary.ps1
    kind: function
    module: Catzc.Base.Objects
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Converts a typed object, PSCustomObject, or dictionary into a nested, mutable structure of ordered
    dictionaries (default) or PSCustomObjects (-AsPSObject).
.DESCRIPTION
    The result is a fresh mutable copy, so a frozen typed object can be changed without touching its source.
.PARAMETER InputObject
    The object to convert.
.PARAMETER AsPSObject
    Emit nested [PSCustomObject] instead of [ordered] dictionaries.
.PARAMETER MaxDepth
    Maximum recursion depth (default 10).
.EXAMPLE
    $env = Get-AzureEnvironment dev -Subscription shared_nonprod | ConvertTo-Dictionary
    $env.subscription.customer = 'override'   # the dict is mutable; the typed object was not
.EXAMPLE
    Get-BicepTemplate sample | ConvertTo-Dictionary -AsPSObject
#>
function ConvertTo-Dictionary {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [AllowNull()]
        $InputObject,

        [switch] $AsPSObject,

        [int] $MaxDepth = 10
    )

    begin {
        function ConvertTo-PSObjectTree {
            param($Node)
            if ($Node -is [System.Collections.IDictionary]) {
                $shaped = [ordered]@{}
                foreach ($key in $Node.Keys) {
                    $shaped[$key] = ConvertTo-PSObjectTree $Node[$key]
                }
                return [PSCustomObject]$shaped
            }
            if ($Node -is [System.Collections.IList]) {
                return @($Node | ForEach-Object { ConvertTo-PSObjectTree $_ })
            }
            $Node
        }
    }

    process {
        # The dictionary is ConvertTo-YamlSafe's own output; only the PSCustomObject shape is added here.
        # [comment:2](/docs/references/automation/catzc-base-objects/ConvertTo-Dictionary.ps1.md#comment2)
        $dict = ConvertTo-YamlSafe -Value $InputObject -MaxDepth $MaxDepth
        if ($AsPSObject) {
            ConvertTo-PSObjectTree $dict
        }
        else {
            $dict
        }
    }
}
