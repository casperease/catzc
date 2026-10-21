<#
---
catzc:
  immutable:
    with_body_sha: c3d0b8d27585
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Assert-YmlNaming.Tests.ps1
    docs: "[Assert-YmlNaming.ps1.md](docs/references/pwsh/catzc-base-asserts/Assert-YmlNaming.ps1.md)"
---
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

    function Test-NodeNaming {
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
                Test-NodeNaming $Node[$key] $keyPath
            }
        }
        elseif ($Node -is [System.Collections.IList]) {
            for ($i = 0; $i -lt $Node.Count; $i++) {
                Test-NodeNaming $Node[$i] "$CurrentPath[$i]"
            }
        }
    }

    Test-NodeNaming $Yaml $PropertyPath

    if ($errors.Count -gt 0) {
        throw "YAML naming validation failed:`n$($errors -join "`n")"
    }
}
