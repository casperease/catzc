---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/LinkEngineResult.cs.md
    kind: comment-page
    body_sha: "4241f346d043"
---

# automation/Catzc.Base.QualityGates/types/LinkEngineResult.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System.Collections.Generic;`.

```text
The outcome of one link-engine run (LinkEngine.Run): every finding in file/line order, the aligned text of each
file the aligner would change (repository-relative path -> new text), and how many files were read. The engine
does no writing — Format-Links writes Changed, Test-Links reports Findings.
```
