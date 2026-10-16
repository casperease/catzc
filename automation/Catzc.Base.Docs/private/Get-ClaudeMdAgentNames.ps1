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
  config:
    synopsis: Lists the sub-agent names the `## Sub-agents` section of a CLAUDE.md file lists.
    description: |-
      Reads the `## Sub-agents` section of .claude/CLAUDE.md (from its heading to the next `## ` heading) and returns
      the name of every bullet that opens with a name in bold code, `` - **`<name>`** ``
      ([ADR-REPO-AGENTS#3](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents3)). Lines that are not such
      a bullet (prose, continuation lines) are skipped. It returns nothing when the file has no such section.

      Private helper for Test-AgentDefinitions; not exported.
    parameters:
      Path: Absolute path to the CLAUDE.md file.
    outputs: '[string[]] The listed names, in file order.'
    examples:
      - Get-ClaudeMdAgentNames -Path (Resolve-RepoPath '.claude/CLAUDE.md')
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
