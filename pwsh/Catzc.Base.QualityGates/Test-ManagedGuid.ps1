<#
---
catzc:
  immutable:
    with_body_sha: "8a0d503318f0"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-ManagedGuid.Tests.ps1
    docs: "[Test-ManagedGuid.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Test-ManagedGuid.ps1.md)"
---
#>

function Test-ManagedGuid {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [guid] $Guid
    )

    $found = Resolve-ManagedGuid $Guid
    $null -ne $found
}
