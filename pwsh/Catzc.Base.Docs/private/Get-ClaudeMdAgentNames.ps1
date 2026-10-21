<#
---
catzc:
  immutable:
    with_body_sha: "7da5c3b47da8"
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1
    docs: "[Get-ClaudeMdAgentNames.ps1.md](docs/references/pwsh/catzc-base-docs/private/Get-ClaudeMdAgentNames.ps1.md)"
    cites:
      - ADR-REPO-AGENTS-LISTEDINCLAUDEFILE
---
#>

function Get-ClaudeMdAgentNames {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    Assert-PathExist $Path

    $inSection = $false
    foreach ($line in [System.IO.File]::ReadAllLines($Path)) {
        if ($line -match '^##\s') {
            $inSection = $line -match '^##\s+Sub-agents\s*$'
            continue
        }
        if ($inSection -and $line -match '^-\s+\*\*`(?<name>[^`]+)`\*\*') {
            $Matches['name']
        }
    }
}
