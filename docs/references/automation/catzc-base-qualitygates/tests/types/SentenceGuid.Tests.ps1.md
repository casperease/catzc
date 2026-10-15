---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/types/SentenceGuid.Tests.ps1.md
    kind: test-asset
    body_sha: "67e0730dc619"
---

# automation/Catzc.Base.QualityGates/tests/types/SentenceGuid.Tests.ps1

<!-- cspell:ignore oilzstgq -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$result = [Catzc.Base.QualityGates.SentenceGuid]::Convert('!!! ??? ,,,')`.

```text
Compared as [guid]::Empty, not a literal — the all-zeros GUID is on the registry's denied list
and never appears in tracked text.
```
