<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/Test-ManagedGuid.ps1
    name: test-managed-guid
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Test-ManagedGuid.Tests.ps1
  config:
    synopsis: Answers whether a GUID is registered in the managed-GUID registry (configs/guids.yml).
    description: |-
      The boolean counterpart of Assert-ManagedGuid; both share one lookup (Resolve-ManagedGuid), so they
      can never disagree. Comparison is case-insensitive by [guid] value.
    parameters:
      Guid: The GUID to check.
    outputs: '[bool] $true when the GUID is registered; $false otherwise.'
    examples:
      - Test-ManagedGuid '499b84ac-1321-427f-aa17-267ca6975798'
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
