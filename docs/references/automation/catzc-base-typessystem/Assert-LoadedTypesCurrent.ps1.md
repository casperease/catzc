---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/Assert-LoadedTypesCurrent.ps1.md
    kind: comment-page
    body_sha: c6e770400f6f
    adrs:
      - ADR-AUTO-FAILFAST#3
      - ADR-AUTO-TYPES#7
---

# automation/Catzc.Base.TypesSystem/Assert-LoadedTypesCurrent.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The throwing form of Test-LoadedTypesCurrent
([ADR-AUTO-FAILFAST#3](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast3)): a precondition
for work that must run on the types as written, such as a test of a type just edited. A loaded assembly cannot
be swapped in a running process
([ADR-AUTO-TYPES#7](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types7)), so the one remedy is
a new process; the message names it, with every drifted type and both hashes or code roots.
```
