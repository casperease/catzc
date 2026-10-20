<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/Test-ManagedGuid.ps1
    name: test-managed-guid
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
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
