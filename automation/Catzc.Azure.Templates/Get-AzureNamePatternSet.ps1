<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-AzureNamePatternSet.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
---
#>

<#
.SYNOPSIS
    The three Azure resource-name patterns the generator (Get-AzureResourceName) renders.
.DESCRIPTION
    A pattern fixes both the separator and the length budget, since a restriction is length as much as format.
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-AzureNamePatternSet.ps1.md#comment1)
.EXAMPLE
    (Get-AzureNamePatternSet).storage   # -> @{ separator = ''; limit = 24 }
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
