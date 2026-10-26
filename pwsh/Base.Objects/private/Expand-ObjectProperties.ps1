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

    # Dictionaries and arrays before PSCustomObject: a PSObject-wrapped dictionary is a PSCustomObject and would show Count and Keys.
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

    # A complex CLR object, such as a typed config model, flattens by reflecting its public members; strings and value types stay leaves.
    if (-not $Value.GetType().IsValueType -and $Value -isnot [string] -and
        $Value -isnot [System.Collections.IEnumerable]) {
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
