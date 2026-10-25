<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Test-ManagedGuid.ps1.md"
  header: "generated"
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
