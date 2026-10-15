---
catzc:
  derived:
    path: docs/references/automation/catzc-base-objects/tests/types/RepoRelativePath.Tests.ps1.md
    kind: test-asset
    body_sha: b51309b4e796
---

# automation/Catzc.Base.Objects/tests/types/RepoRelativePath.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'RepoRelativePath' -Tag 'L0', 'logic' {`.

```text
Neutral, non-reserved path segments only. 'out' is deliberately avoided here: it is the reserved output
anchor (Get-OutputRoot — {root}/out locally, the external staging dir in a pipeline), a different anchor
from repo-root-relative, so it does not belong in a test of generic repo-relative normalization.
```
