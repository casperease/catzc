<#
---
catzc:
  immutable:
    with_body_sha: "20653224a26b"
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Test-AspectDeclaration.Tests.ps1
    docs: "[Test-AspectDeclaration.ps1.md](docs/references/pwsh/catzc-base-variants/Test-AspectDeclaration.ps1.md)"
    cites:
      - ADR-REPO-VARIANT
---
#>

function Test-AspectDeclaration {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Track
    )

    $aspects = Get-AspectDeclaration
    $null -ne $aspects -and $aspects.ContainsKey($Track)
}
