<#
---
catzc:
  immutable:
    with_body_sha: "98b82abe7bd0"
  edges:
    docs: "[Get-ManagedGuids.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-ManagedGuids.ps1.md)"
---
#>

function Get-ManagedGuids {
    [CmdletBinding()]
    param()

    (Get-Config -Config guids).guids
}
