<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/private/Get-ClaudeMdAgentNames.ps1
    folder: private
    name: get-claude-md-agent-names
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
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
