---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-inspiration/tests/types/InspirationRoot.Tests.ps1.md
    kind: test-asset
    body_sha: ff181f1d5e87
    adrs:
      - ADR-AUTO-PATH#11
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Catzc.Tooling.Inspiration.InspirationRoot' -Tag 'L0', 'logic' {`.

```text
InspirationRoot over neutral fixture paths (widget/gadget,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)): the {workspace} anchor resolves to
the parent of the repository root ([ADR-AUTO-PATH#11](/docs/adr/automation/path-representation.md#rule-adr-auto-path11)),
identically from pwsh's and Git Bash's view of that root. The platform is a parameter, so every branch runs on
every OS.
```
