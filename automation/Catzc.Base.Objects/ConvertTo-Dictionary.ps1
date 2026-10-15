<#
.SYNOPSIS
    Converts a typed object, PSCustomObject, or dictionary into a nested, mutable structure of ordered
    dictionaries (default) or PSCustomObjects (-AsPSObject).
.DESCRIPTION
    The escape hatch from the native data-model classes back to a dictionary surface.
    [comment:1](/docs/references/automation/catzc-base-objects/ConvertTo-Dictionary.ps1.md#comment1)
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
        # ConvertTo-YamlSafe is the shared recursive reflector — it already turns any object (typed class,...
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
