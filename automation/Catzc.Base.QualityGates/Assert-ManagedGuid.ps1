<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/Assert-ManagedGuid.ps1
    name: assert-managed-guid
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Assert-ManagedGuid.Tests.ps1
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
        throw "Guid '$Guid' is not registered in the managed-GUID registry (automation/Catzc.Base.QualityGates/configs/guids.yml). Register it — mint a readable placeholder with ConvertTo-Guid — or remove it."
    }
}
