---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/types/GlobPattern.Tests.ps1.md
    kind: test-asset
    body_sha: "9fc09e336ac5"
    adrs:
      - ADR-FLOW-CD-GLOBS#2
      - ADR-FLOW-CD-GLOBS#3
---

# automation/Catzc.Base.Globs/tests/types/GlobPattern.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'GlobPattern' -Tag 'L0', 'logic' {`.

```text
The dialect's truth table ([ADR-FLOW-CD-GLOBS#2](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs2)) and the
constructor guard
([ADR-FLOW-CD-GLOBS#3](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs3)): per-segment PowerShell
wildcards, '**' as the only cross-segment operator (zero or more whole segments), case-sensitive; a
malformed pattern never produces an instance.
```
