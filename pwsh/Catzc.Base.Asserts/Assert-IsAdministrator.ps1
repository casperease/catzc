<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-asserts/Assert-IsAdministrator.ps1.md"
  header: "generated"
---
#>

function Assert-IsAdministrator {
    param(
        [string] $ErrorText = 'This operation requires Administrator privileges'
    )

    Assert-True (Test-IsAdministrator) -ErrorText $ErrorText
}
