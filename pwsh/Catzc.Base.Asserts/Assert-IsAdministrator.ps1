<#
---
catzc:
  immutable:
    with_body_sha: b4fb0fb80d4f
  edges:
    docs: "[Assert-IsAdministrator.ps1.md](docs/references/pwsh/catzc-base-asserts/Assert-IsAdministrator.ps1.md)"
---
#>

function Assert-IsAdministrator {
    param(
        [string] $ErrorText = 'This operation requires Administrator privileges'
    )

    Assert-True (Test-IsAdministrator) -ErrorText $ErrorText
}
