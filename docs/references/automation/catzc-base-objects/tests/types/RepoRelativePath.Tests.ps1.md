---
catzc:
  derived:
    path: docs/references/automation/catzc-base-objects/tests/types/RepoRelativePath.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "03f95758400c"
---

# automation/Catzc.Base.Objects/tests/types/RepoRelativePath.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'RepoRelativePath' -Tag 'L0', 'logic' {`, written with `#`.

```text
Neutral, non-reserved path segments only. 'out' is deliberately avoided here: it is the reserved output
anchor (Get-OutputRoot — {root}/out locally, the external staging dir in a pipeline), a different anchor
from repo-root-relative, so it does not belong in a test of generic repo-relative normalization.
```
