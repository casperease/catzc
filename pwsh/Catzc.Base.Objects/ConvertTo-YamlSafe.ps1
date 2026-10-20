<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Objects/ConvertTo-YamlSafe.ps1
    name: convert-to-yaml-safe
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Objects
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Objects/tests/ConvertTo-YamlSafe.Tests.ps1
    docs: "[ConvertTo-YamlSafe.ps1.md](docs/references/pwsh/catzc-base-objects/ConvertTo-YamlSafe.ps1.md)"
---
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
