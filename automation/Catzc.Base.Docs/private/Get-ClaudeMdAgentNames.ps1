<#
.SYNOPSIS
    Lists the sub-agent names the `## Sub-agents` section of a CLAUDE.md file lists.
.DESCRIPTION
    Only bullets that open with a bold-code name count; prose and continuation lines in the section are skipped.
    [ADR-REPO-AGENTS#3](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents3)
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-ClaudeMdAgentNames.ps1.md#comment1)
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
