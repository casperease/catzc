<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Objects/private/Expand-ObjectProperties.ps1
    kind: private-function
    module: Catzc.Base.Objects
    visibility: private
  config:
    synopsis: Recursively flattens a nested object into dot-notation key/value pairs.
    description: |-
      Walks PSCustomObject, IDictionary, and array structures, building
      dot-separated paths for each leaf value and adding them to the
      supplied OrderedDictionary.  Arrays use [index] notation.
      Used internally by ConvertTo-FlatSettingSet.
    parameters:
      Value: The object, or the nested value, to flatten.
      Target: The ordered dictionary that receives the dot-notation key/value pairs.
      Prefix: The key path so far, extended with each property name or [index] on the way down.
      MaxDepth: The depth at which flattening stops. Default 10.
      Depth: The depth reached so far; callers leave it at 0 and the recursion raises it.
---
#>

function Expand-ObjectProperties {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        $Value,

        [Parameter(Mandatory)]
        [System.Collections.Specialized.OrderedDictionary] $Target,

        [string] $Prefix,

        [int] $MaxDepth = 10,

        [int] $Depth = 0
    )

    if ($Depth -ge $MaxDepth) {
        return
    }

    if ($null -eq $Value) {
        if ($Prefix) {
            $Target[$Prefix] = ''
        }
        return
    }

    # IDictionary and array are checked before PSCustomObject: a top-level value arrives here wrapped in a PSObject...
    # [comment:4](/docs/references/automation/catzc-base-objects/private/Expand-ObjectProperties.ps1.md#comment4)
    if ($Value -is [System.Collections.IDictionary]) {
        foreach ($key in $Value.Keys) {
            $path = if ($Prefix) {
                "$Prefix.$key"
            }
            else {
                $key
            }
            Expand-ObjectProperties -Value $Value[$key] -Target $Target -Prefix $path -MaxDepth $MaxDepth -Depth ($Depth + 1)
        }
        return
    }

    if ($Value -is [array]) {
        $index = 0
        foreach ($item in $Value) {
            $path = if ($Prefix) {
                "$Prefix[$index]"
            }
            else {
                "[$index]"
            }
            Expand-ObjectProperties -Value $item -Target $Target -Prefix $path -MaxDepth $MaxDepth -Depth ($Depth + 1)
            $index++
        }
        return
    }

    if ($Value -is [PSCustomObject]) {
        foreach ($property in $Value.PSObject.Properties) {
            $path = if ($Prefix) {
                "$Prefix.$($property.Name)"
            }
            else {
                $property.Name
            }
            Expand-ObjectProperties -Value $property.Value -Target $Target -Prefix $path -MaxDepth $MaxDepth -Depth ($Depth + 1)
        }
        return
    }

    # Complex CLR object (e.g.
    # [comment:5](/docs/references/automation/catzc-base-objects/private/Expand-ObjectProperties.ps1.md#comment5)
    if (-not $Value.GetType().IsValueType -and $Value -isnot [string] -and $Value -isnot [System.Collections.IEnumerable]) {
        $properties = @($Value.PSObject.Properties | Where-Object { $_.MemberType -in @('Property', 'NoteProperty') })
        if ($properties) {
            foreach ($property in $properties) {
                $path = if ($Prefix) {
                    "$Prefix.$($property.Name)"
                }
                else {
                    $property.Name
                }
                Expand-ObjectProperties -Value $property.Value -Target $Target -Prefix $path -MaxDepth $MaxDepth -Depth ($Depth + 1)
            }
            return
        }
    }

    if ($Prefix) {
        $Target[$Prefix] = $Value
    }
}
