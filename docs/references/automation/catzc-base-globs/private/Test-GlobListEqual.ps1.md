# docs/references/automation/catzc-base-globs/private/Test-GlobListEqual.ps1.md

`automation/Catzc.Base.Globs/private/Test-GlobListEqual.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The comparison behind the trigger-drift quality gates (Test-AdoPipelineTriggerGlob / Test-GitHubWorkflowTriggerGlob).
ADO path filters are order-independent (union include minus union exclude), so a set comparison is
correct and an ordinal sort makes it deterministic
([ADR-AUTO-XPLAT](/docs/adr/automation/cross-platform.md) — Sort-Object is culture-aware). GitHub
paths are ordered last-match-wins ('!' negation), so -Ordered compares element by element. Matching is
case-sensitive (tracked paths are case-sensitive identities,
[ADR-FLOW-CD-GLOBS#2](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs2)).
```
