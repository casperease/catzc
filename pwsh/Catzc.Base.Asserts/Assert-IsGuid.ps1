<#
---
catzc:
  immutable:
    with_body_sha: "8e2574ce3a98"
  edges:
    test: pwsh/Catzc.Base.Asserts/tests/Assert-IsGuid.Tests.ps1
    docs: "[Assert-IsGuid.ps1.md](docs/references/pwsh/catzc-base-asserts/Assert-IsGuid.ps1.md)"
---
#>

function Assert-IsGuid {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $ObjectGuid
    )

    if (-not (Test-IsGuid $ObjectGuid)) {
        throw "'$ObjectGuid' is not a valid GUID"
    }
}
