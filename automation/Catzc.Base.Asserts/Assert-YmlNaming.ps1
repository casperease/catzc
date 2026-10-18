<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Asserts/Assert-YmlNaming.ps1
    name: assert-yml-naming
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
    visibility: public
  edges:
    test: automation/Catzc.Base.Asserts/tests/Assert-YmlNaming.Tests.ps1
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
