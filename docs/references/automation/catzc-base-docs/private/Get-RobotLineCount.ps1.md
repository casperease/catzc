# automation/Catzc.Base.Docs/private/Get-RobotLineCount.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Counts the lines of a robot or capability file the roofs apply to.

### description

Reads one `.claude/agents/<name>.md` or `.claude/skills/<name>/SKILL.md` and returns two counts
([ADR-REPO-AGENTS#6](../../../../adr/repository/agent-definitions.md#rule-adr-repo-agents6),
[ADR-REPO-AGENTS#8](../../../../adr/repository/agent-definitions.md#rule-adr-repo-agents8)): Body, the lines after the front matter's
closing `---`; and Capability, the front-matter lines outside the catzc head (the two `---` delimiters excluded) plus the body lines. A line
counts when it starts something of its own (a key, a heading, a step, a paragraph); a line that starts with whitespace continues the line
before it, the formatter's wrap at the repository width or a folded YAML value, and counts with it; a blank line and a comment line count as
nothing. The catzc head is left out of both because Format-FileMeta writes it, so it is never the author's text; -Key says where the file's
carrier puts it, at the top level or nested under another tool's key, whose own line still counts. A file with no front matter counts its
whole text as body.

Private helper for Test-AgentDefinitions; not exported.

### parameter `Path`

Absolute path to the agent or capability file.

### parameter `Key`

The front-matter key path of the catzc head, from the file's carrier: catzc (the default) or a path such as metadata.catzc.

### outputs

`[pscustomobject]` { Body; Capability }.

### example 1

```powershell
Get-RobotLineCount -Path (Resolve-RepoPath '.claude/agents/plan-clear.md')
```

### example 2

```powershell
Get-RobotLineCount -Path (Resolve-RepoPath '.claude/skills/catzc-run/SKILL.md') -Key metadata.catzc
```

## comment:1

Above `$front = @($document.OtherFrontMatter | Where-Object { $_ -cmatch '^\S' }).Count`, written with `#`.

```text
A line counts when it starts something of its own: a key, a heading, a step, a paragraph. A line that starts with
whitespace continues the line before it (the formatter's wrap at the repository width, or a folded YAML value) and
counts with it; a blank line and a comment line (`<!-- -->`) count as nothing.
```
