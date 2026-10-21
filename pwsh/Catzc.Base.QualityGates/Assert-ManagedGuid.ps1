<#
---
catzc:
  immutable:
    with_body_sha: fd278965b44b
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Assert-ManagedGuid.Tests.ps1
    docs: "[Assert-ManagedGuid.ps1.md](../../docs/references/pwsh/catzc-base-quality-gates/Assert-ManagedGuid.ps1.md)"
---
#>

function Assert-ManagedGuid {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [guid] $Guid
    )

    $found = Resolve-ManagedGuid $Guid
    if ($null -eq $found) {
        throw "Guid '$Guid' is not registered in the managed-GUID registry (Catzc.Base.QualityGates configs/guids.yml). Register it — mint a readable placeholder with ConvertTo-Guid — or remove it."
    }
}
