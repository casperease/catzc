---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/types/DocMapping.Tests.ps1.md
    kind: test-asset
    body_sha: "05be751a6ab1"
---

# automation/Catzc.Base.Docs/tests/types/DocMapping.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'DocMapping' -Tag 'L0', 'logic' {`.

```text
Validates the compiled DocMapping type directly — the constructor is the gate that stops a malformed
readme.yml mapping entry from ever producing an instance.
```
