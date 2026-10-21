<#
---
catzc:
  immutable:
    with_body_sha: fcd448ca524f
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Assert-TypeIs.Tests.ps1
    docs: "[Assert-TypeIs.ps1.md](../../docs/references/pwsh/catzc-base-asserts/Assert-TypeIs.ps1.md)"
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
