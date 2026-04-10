<#
.SYNOPSIS
    Validates that all property keys in a parsed YAML object use snake_case.
.DESCRIPTION
    Recursively walks a parsed YAML structure and asserts that every property key
    matches snake_case (lowercase letters, digits, underscores, starting with a letter).
    List items and values are not checked.
.PARAMETER Yaml
    The parsed YAML object (from ConvertFrom-Yaml -Ordered).
.PARAMETER PropertyPath
    Optional root prefix for error messages. Useful when validating a subtree,
    e.g. Assert-YmlNaming $config.customers 'customers' will report paths as
    'customers.blue.details' instead of 'blue.details'.
.EXAMPLE
    $config = Get-Content config.yml -Raw | ConvertFrom-Yaml -Ordered
    Assert-YmlNaming $config
.EXAMPLE
    Assert-YmlNaming $config.customers 'customers'
#>
function Assert-YmlNaming {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
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
