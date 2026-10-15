---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-AgentFrontMatter.ps1.md
    kind: comment-page
    body_sha: fb62a2bd8583
    adrs:
      - ADR-REPO-AGENTS#1
    links: []
---

# automation/Catzc.Base.Docs/private/Get-AgentFrontMatter.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the block between the opening `---` line (the file's first line) and the next `---` line of a
.claude/agents/<name>.md file and parses it as YAML
([ADR-REPO-AGENTS#1](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents1)). It throws when the file
has no front-matter block, when the block is not valid YAML, or when the block is not a mapping, so the caller
(Test-AgentDefinitions) records one issue per unreadable file.

Private helper for Test-AgentDefinitions; not exported.
```
