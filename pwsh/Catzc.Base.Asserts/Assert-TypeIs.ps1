<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Asserts/Assert-TypeIs.ps1
    name: assert-type-is
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Asserts
    moduletype: pwsh-folder
    catzc_bundle: minimal
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Assert-TypeIs.Tests.ps1
    docs: "[Assert-TypeIs.ps1.md](docs/references/pwsh/catzc-base-asserts/Assert-TypeIs.ps1.md)"
---
#>

function Assert-TypeIs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Object,

        [Parameter(Mandatory, Position = 1)]
        [string] $TypeFullName
    )

    if ($Object.GetType().FullName -ne $TypeFullName) {
        throw "Object is not a $TypeFullName (actual: $($Object.GetType().FullName))"
    }
}
