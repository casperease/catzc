<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-ClaudeMdAgentNames.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: private
    adrs:
      - ADR-REPO-AGENTS#3
---
#>

<#
.SYNOPSIS
    Lists the sub-agent names the `## Sub-agents` section of a CLAUDE.md file lists.
.DESCRIPTION
    Only bullets that open with a bold-code name count; prose and continuation lines in the section are skipped.
.PARAMETER Path
    Absolute path to the CLAUDE.md file.
.OUTPUTS
    [string[]] The listed names, in file order.
.EXAMPLE
    Get-ClaudeMdAgentNames -Path (Resolve-RepoPath '.claude/CLAUDE.md')
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
