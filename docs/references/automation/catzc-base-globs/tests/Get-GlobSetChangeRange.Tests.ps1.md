---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Get-GlobSetChangeRange.Tests.ps1.md
    kind: test-asset
    body_sha: "6685beac1a20"
---

# automation/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-GlobSetChangeRange' -Tag 'L0', 'logic' {`.

```text
The reference-commit resolver ([ADR-FLOW-CD-DETECT](/docs/adr/flow/pipeline-detection.md)): the diff range per
execution context — local working tree,
post-commit first-parent (squash-proof), or the PR merge-base — with a fail-open null.
```
