# catzc:
#   path: automation/Catzc.Base.Docs/private/Get-AgentFrontMatter.ps1
#   module: Catzc.Base.Docs
#   visibility: private

<#
.SYNOPSIS
    Parses the YAML front matter of one sub-agent definition file.
.DESCRIPTION
    Every unreadable shape throws, so the caller records exactly one issue per broken agent file.
    [ADR-REPO-AGENTS#1](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents1)
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-AgentFrontMatter.ps1.md#comment1)
.PARAMETER Path
    Absolute path to the agent definition file.
.OUTPUTS
    [System.Collections.IDictionary] The front-matter keys and values, in file order.
.EXAMPLE
    Get-AgentFrontMatter -Path (Resolve-RepoPath '.claude/agents/catzc-worker.md')
#>
function Get-AgentFrontMatter {
    [CmdletBinding()]
    [OutputType([System.Collections.IDictionary])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    Assert-PathExist $Path

    $lines = [System.IO.File]::ReadAllLines($Path)
    if ($lines.Count -eq 0 -or $lines[0].TrimEnd() -ne '---') {
        throw [System.ArgumentException]::new('has no front matter: the first line must be ---')
    }
    $end = -1
    for ($index = 1; $index -lt $lines.Count; $index++) {
        if ($lines[$index].TrimEnd() -eq '---') {
            $end = $index
            break
        }
    }
    if ($end -lt 0) {
        throw [System.ArgumentException]::new('has no closing --- for its front matter')
    }

    $block = $lines[1..($end - 1)] -join "`n"
    if ($end -eq 1) {
        $block = ''
    }
    try {
        $parsed = ConvertFrom-Yaml -Yaml $block -Ordered
    }
    catch {
        throw [System.ArgumentException]::new("has front matter that is not valid YAML: $($_.Exception.Message)")
    }
    if ($parsed -isnot [System.Collections.IDictionary]) {
        throw [System.ArgumentException]::new('has front matter that is not a mapping')
    }
    $parsed
}
