<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Templates/Get-AzureNamePatternSet.ps1
    name: get-azure-name-pattern-set
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.Templates/tests/Get-AzureNamePatternSet.Tests.ps1
---
#>

function Get-AzureNamePatternSet {
    param()

    [ordered]@{
        long    = @{ separator = '-' }              # hyphenated, generous — length doesn't bind; type carries its own limit
        kv      = @{ separator = '-'; limit = 24 }  # hyphenated but length-restricted (key-vault class: 24, binds)
        storage = @{ separator = ''; limit = 24 }   # tight (concatenated, no hyphens), 24
        vm      = @{ separator = ''; limit = 15 }   # same tight render as storage, capped at the Windows computer-name 15
    }
}
