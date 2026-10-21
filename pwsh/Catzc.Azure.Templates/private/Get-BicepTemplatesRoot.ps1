<#
---
catzc:
  immutable:
    with_body_sha: e1f21a65f234
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplatesRoot.Tests.ps1
    docs: "[Get-BicepTemplatesRoot.ps1.md](docs/references/pwsh/catzc-azure-templates/private/Get-BicepTemplatesRoot.ps1.md)"
---
#>

function Get-BicepTemplatesRoot {
    [OutputType([string])]
    param()

    Join-Path (Get-RepositoryRoot) (Get-TrackPlace -Track infrastructure -TrackKind templates)
}
