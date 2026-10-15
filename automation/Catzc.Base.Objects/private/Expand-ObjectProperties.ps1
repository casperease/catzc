<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Objects/private/Expand-ObjectProperties.ps1
    kind: function
    module: Catzc.Base.Objects
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Recursively flattens a nested object into dot-notation key/value pairs.
.DESCRIPTION
    Array items are keyed with an [index] suffix, not a dot, so a path tells a list item from a property.
.PARAMETER Value
    The object, or the nested value, to flatten.
.PARAMETER Target
    The ordered dictionary that receives the dot-notation key/value pairs.
.PARAMETER Prefix
    The key path so far, extended with each property name or [index] on the way down.
.PARAMETER MaxDepth
    The depth at which flattening stops. Default 10.
.PARAMETER Depth
    The depth reached so far; callers leave it at 0 and the recursion raises it.
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

    # Dictionary and array come first: a PSObject-wrapped dictionary also matches PSCustomObject.
    # [comment:2](/docs/references/automation/catzc-base-objects/private/Expand-ObjectProperties.ps1.md#comment2)
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

    # A typed model flattens like a dictionary here; strings and value types fall through to leaf.
    # [comment:3](/docs/references/automation/catzc-base-objects/private/Expand-ObjectProperties.ps1.md#comment3)
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
