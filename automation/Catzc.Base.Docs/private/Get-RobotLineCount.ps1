<#
---
catzc:
  immutable:
    repo_status: clean
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
    page: docs/references/automation/catzc-base-docs/private/Get-RobotLineCount.ps1.md
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
        [string] $Path,

        [ValidateNotNullOrEmpty()]
        [string] $Key = [Catzc.Base.MarkdownMeta.MarkdownDocument]::MetaKey
    )

    Assert-PathExist $Path

    $document = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse([System.IO.File]::ReadAllText($Path), $Key)
    $front = @($document.OtherFrontMatter | Where-Object { $_ -cmatch '^\S' }).Count
    $body = @(($document.Body -split "`r?`n") | Where-Object { $_ -cmatch '^\S' -and $_ -cnotmatch '^<!--' }).Count
    [pscustomobject]@{ Body = $body; Capability = $front + $body }
}
