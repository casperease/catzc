---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-ClaudeMdAgentNames.ps1.md
    kind: reference
    body_sha: ec01aecfe80f
    adrs:
      - ADR-REPO-AGENTS#3
---

# automation/Catzc.Base.Docs/private/Get-ClaudeMdAgentNames.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the `## Sub-agents` section of .claude/CLAUDE.md (from its heading to the next `## ` heading) and returns
the name of every bullet that opens with a name in bold code, `` - **`<name>`** ``
([ADR-REPO-AGENTS#3](/docs/adr/repository/agent-definitions.md#rule-adr-repo-agents3)). Lines that are not such
a bullet (prose, continuation lines) are skipped. It returns nothing when the file has no such section.

Private helper for Test-AgentDefinitions; not exported.
```
