<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Assert-ManagedGuid.ps1
    kind: function
    subkind: assert
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Assert-ManagedGuid.Tests.ps1
  config:
    synopsis: Asserts a GUID is registered in the managed-GUID registry (configs/guids.yml); throws when it is not.
    description: |-
      The throwing counterpart of Test-ManagedGuid; both share one lookup (Resolve-ManagedGuid), so they can
      never disagree. Comparison is case-insensitive by [guid] value. Succeeds silently — the absence of an
      error is the output.
    parameters:
      Guid: The GUID to assert.
    examples:
      - Assert-ManagedGuid '499b84ac-1321-427f-aa17-267ca6975798'
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
