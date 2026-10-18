<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/private/Get-ClaudeMdAgentNames.ps1
    folder: private
    name: get-claude-md-agent-names
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1
    cites:
      - ADR-REPO-AGENTS#3
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
