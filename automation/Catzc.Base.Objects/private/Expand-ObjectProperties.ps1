<#
.SYNOPSIS
    Recursively flattens a nested object into dot-notation key/value pairs.
.DESCRIPTION
    Walks PSCustomObject, IDictionary, and array structures, building
    dot-separated paths for each leaf value and adding them to the
    supplied OrderedDictionary.  Arrays use [index] notation.
    Used internally by ConvertTo-FlatSettingSet.
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

    # IDictionary and array are checked before PSCustomObject: a top-level value arrives here wrapped in a
    # PSObject (ConvertTo-FlatSettingSet binds [PSObject[]]), and a PSObject-wrapped dictionary matches
    # -is [PSCustomObject]. Routing it there would reflect the dictionary's own CLR members (Count, Keys,
    # SyncRoot, ...) instead of its entries. Matching the more specific shapes first keeps a dictionary a
    # dictionary and an array an array, wrapped or not.
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

    # Complex CLR object (e.g. a typed/validated config model): reflect over its public
    # members so a typed config subtree flattens the same way a dictionary or PSCustomObject
    # does. Strings and value types (numbers, bool, DateTime, Guid, enums) fall through to leaf.
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
