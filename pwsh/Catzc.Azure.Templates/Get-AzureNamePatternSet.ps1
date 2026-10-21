<#
---
catzc:
  immutable:
    with_body_sha: "4e96b8d331d5"
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-AzureNamePatternSet.Tests.ps1
    docs: "[Get-AzureNamePatternSet.ps1.md](docs/references/pwsh/catzc-azure-templates/Get-AzureNamePatternSet.ps1.md)"
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
