<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Objects/ConvertTo-YamlSafe.ps1
    kind: function
    module: Catzc.Base.Objects
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Recursively converts an object into a YAML-safe structure of ordered
    dictionaries, arrays, and scalar values.
.DESCRIPTION
    Every level becomes ordered dicts, arrays or scalars, so ConvertTo-Yaml never falls back to ToString.
.PARAMETER Value
    The object to convert; null stays null.
.PARAMETER MaxDepth
    The depth at which a value stops being walked and is rendered as its string form. Default 10.
.PARAMETER Depth
    The depth reached so far; callers leave it at 0 and the recursion raises it.
#>
function ConvertTo-YamlSafe {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowNull()]
        $Value,

        [int] $MaxDepth = 10,

        [int] $Depth = 0
    )

    if ($null -eq $Value) {
        return $null
    }
    if ($Value -is [string] -or $Value -is [ValueType]) {
        return $Value
    }
    if ($Depth -ge $MaxDepth) {
        try {
            return "$Value"
        }
        catch {
            return '[not rendered]'
        }
    }

    if ($Value -is [System.Collections.IDictionary]) {
        $ret = [ordered]@{}
        foreach ($key in $Value.Keys) {
            $ret[$key] = try {
                ConvertTo-YamlSafe -Value $Value[$key] -MaxDepth $MaxDepth -Depth ($Depth + 1)
            }
            catch {
                '[not rendered]'
            }
        }
        return $ret
    }

    if ($Value -is [System.Collections.IEnumerable]) {
        $ret = try {
            foreach ($item in $Value) {
                try {
                    ConvertTo-YamlSafe -Value $item -MaxDepth $MaxDepth -Depth ($Depth + 1)
                }
                catch {
                    '[not rendered]'
                }
            }
        }
        catch {
            return '[not rendered]'
        }
        return @($ret)
    }

    # PSCustomObject or other complex types
    $ret = [ordered]@{}
    $properties = try {
        @($Value.PSObject.Properties)
    }
    catch {
        $null
    }
    if ($null -eq $properties) {
        return '[not rendered]'
    }

    foreach ($p in $properties) {
        $name = try {
            $p.Name
        }
        catch {
            continue
        }
        $v = if ($p -is [System.Management.Automation.PSScriptProperty] -and $null -ne $p.GetterScript) {
            try {
                $p.GetterScript.InvokeReturnAsIs()
            }
            catch {
                '[not rendered]'
            }
        }
        else {
            try {
                $p.Value
            }
            catch {
                '[not rendered]'
            }
        }
        $ret[$name] = try {
            ConvertTo-YamlSafe -Value $v -MaxDepth $MaxDepth -Depth ($Depth + 1)
        }
        catch {
            '[not rendered]'
        }
    }
    return $ret
}
