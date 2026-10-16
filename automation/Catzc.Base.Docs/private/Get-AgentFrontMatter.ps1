<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/private/Get-AgentFrontMatter.ps1
    folder: private
    name: get-agent-front-matter
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
    test: automation/Catzc.Base.Docs/tests/Get-AgentFrontMatter.Tests.ps1
    cites:
      - ADR-REPO-AGENTS#1
  config:
    synopsis: Parses the YAML front matter of one sub-agent definition file.
    description: |-
      Reads the block between the opening `---` line (the file's first line) and the next `---` line of a
      .claude/agents/<name>.md file and parses it as YAML
      ([ADR-REPO-AGENTS#1](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents1)). It throws when the file
      has no front-matter block, when the block is not valid YAML, or when the block is not a mapping, so the caller
      (Test-AgentDefinitions) records one issue per unreadable file.

      Private helper for Test-AgentDefinitions; not exported.
    parameters:
      Path: Absolute path to the agent definition file.
    outputs: '[System.Collections.IDictionary] The front-matter keys and values, in file order.'
    examples:
      - Get-AgentFrontMatter -Path (Resolve-RepoPath '.claude/agents/catzc-worker.md')
---
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
