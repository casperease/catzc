---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/types/SentenceGuid.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "0a096ffd23ff"
---

# automation/Catzc.Base.QualityGates/tests/types/SentenceGuid.Tests.ps1

<!-- cspell:ignore oilzstgq -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$result = [Catzc.Base.QualityGates.SentenceGuid]::Convert('!!! ??? ,,,')`, written with `#`.

```text
Compared as [guid]::Empty, not a literal — the all-zeros GUID is on the registry's denied list
and never appears in tracked text.
```
