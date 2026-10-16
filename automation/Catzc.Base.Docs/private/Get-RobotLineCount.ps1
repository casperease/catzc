<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Docs/private/Get-RobotLineCount.ps1
    folder: private
    name: get-robot-line-count
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
    cites:
      - ADR-REPO-AGENTS#{6,8}
  config:
    synopsis: Counts the lines of a robot or capability file the roofs apply to.
    description: |-
      Reads one .claude/agents/<name>.md or .claude/skills/<name>/SKILL.md and returns two counts
      ([ADR-REPO-AGENTS#6](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents6),
      [ADR-REPO-AGENTS#8](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents8)): Body, the lines after the
      front matter's closing `---`; and Capability, the front-matter lines outside the catzc head (the two `---`
      delimiters excluded) plus the body lines. A line counts when it starts something of its own (a key, a heading, a
      step, a paragraph); a line that starts with whitespace continues the line before it, the formatter's wrap at the
      repository width or a folded YAML value, and counts with it; a blank line and a comment line count as nothing. The
      catzc head is left out of both because Format-FileMeta writes it, so it is never the author's text; -Key says where
      the file's carrier puts it, at the top level or nested under another tool's key, whose own line still counts. A
      file with no front matter counts its whole text as body.

      Private helper for Test-AgentDefinitions; not exported.
    parameters:
      Path: Absolute path to the agent or capability file.
      Key: 'The front-matter key path of the catzc head, from the file''s carrier: catzc (the default) or a path such as metadata.catzc.'
    outputs: '[pscustomobject] { Body; Capability }.'
    examples:
      - Get-RobotLineCount -Path (Resolve-RepoPath '.claude/agents/plan-clear.md')
      - Get-RobotLineCount -Path (Resolve-RepoPath '.claude/skills/catzc-run/SKILL.md') -Key metadata.catzc
---
#>

function Get-RobotLineCount {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    Assert-PathExist $Path

    $lines = [System.IO.File]::ReadAllLines($Path)
    $end = -1
    if ($lines.Count -gt 0 -and $lines[0].TrimEnd() -eq '---') {
        for ($index = 1; $index -lt $lines.Count; $index++) {
            if ($lines[$index].TrimEnd() -eq '---') {
                $end = $index
                break
            }
        }
    }
    # A line counts when it starts something of its own: a key, a heading, a step, a paragraph. A line that starts with
    # whitespace continues the line before it (the formatter's wrap at the repository width, or a folded YAML value) and
    # counts with it; a blank line and a comment line (`<!-- -->`) count as nothing.
    $front = 0
    if ($end -gt 0) {
        for ($index = 1; $index -lt $end; $index++) {
            if ($lines[$index] -cmatch '^catzc:\s*$') {
                break
            }
            if ($lines[$index] -cmatch '^\S') {
                $front++
            }
        }
    }
    $body = 0
    for ($index = $end + 1; $index -lt $lines.Count; $index++) {
        if ($lines[$index] -cmatch '^\S' -and $lines[$index] -cnotmatch '^<!--') {
            $body++
        }
    }
    [pscustomobject]@{ Body = $body; Capability = $front + $body }
}
