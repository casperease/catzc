---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
    kind: comment-page
    body_sha: "3446e1beca76"
---

# automation/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-GlobSetChangeRange' -Tag 'L0', 'logic' {`, written with `#`.

```text
The reference-commit resolver ([ADR-FLOW-CD-DETECT](/docs/adr/flow/pipeline-detection.md)): the diff range per
execution context — local working tree,
post-commit first-parent (squash-proof), or the PR merge-base — with a fail-open null.
```
