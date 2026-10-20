<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/Test-AspectDeclaration.ps1
    name: test-aspect-declaration
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
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
