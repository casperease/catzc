<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Assert-YmlNaming.ps1
    kind: assert-function
    module: Catzc.Base.Asserts
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Validates that all property keys in a parsed YAML object use snake_case.
.DESCRIPTION
    Only keys are checked: list items and values may be any case, so a value never fails the naming rule.
.PARAMETER Yaml
    The parsed YAML object (from ConvertFrom-Yaml -Ordered).
.PARAMETER PropertyPath
    For a subtree it makes errors report the full path, as customers.blue.details rather than blue.details.
.EXAMPLE
    $config = Get-Content config.yml -Raw | ConvertFrom-Yaml -Ordered
    Assert-YmlNaming $config
.EXAMPLE
    Assert-YmlNaming $config.customers 'customers'
#>
function Assert-YmlNaming {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Yaml,

        [string] $PropertyPath = ''
    )

    $pattern = '^[a-z][a-z0-9_]*$'
    $errors = [System.Collections.Generic.List[string]]::new()

    function Walk {
        param($Node, $CurrentPath)
        if ($Node -is [System.Collections.IDictionary]) {
            foreach ($key in $Node.Keys) {
                $keyPath = if ($CurrentPath) {
                    "$CurrentPath.$key"
                }
                else {
                    $key
                }
                if ($key -cnotmatch $pattern) {
                    $errors.Add("Property '$keyPath' is not snake_case (must match $pattern)")
                }
                Walk $Node[$key] $keyPath
            }
        }
        elseif ($Node -is [System.Collections.IList]) {
            for ($i = 0; $i -lt $Node.Count; $i++) {
                Walk $Node[$i] "$CurrentPath[$i]"
            }
        }
    }

    Walk $Yaml $PropertyPath

    if ($errors.Count -gt 0) {
        throw "YAML naming validation failed:`n$($errors -join "`n")"
    }
}
