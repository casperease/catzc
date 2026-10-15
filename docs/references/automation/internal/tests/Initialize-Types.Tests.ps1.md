---
catzc:
  derived:
    path: docs/references/automation/internal/tests/Initialize-Types.Tests.ps1.md
    kind: test-asset
    body_sha: "83358abbbcb6"
---

# automation/.internal/tests/Initialize-Types.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
L1: each case loads a fixture DLL, so the file is locked for the process lifetime. Fixtures live OUTSIDE TestDrive, in a
self-managed temp dir cleaned best-effort. The pending record and the lookup hook are session state: saved, replaced by
a fresh record per case, and restored after.
```
