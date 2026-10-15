---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Test-GlobSetProtection.Tests.ps1.md
    kind: test-asset
    body_sha: cb8e26b68678
---

# automation/Catzc.Base.Globs/tests/Test-GlobSetProtection.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-GlobSetProtection / Protect-GlobSet' -Tag 'L0', 'logic' {`.

```text
The protected-glob skip ([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)): session-memory skip of a
repeated green scan over an unchanged
globset; hash-before-scan via the pending-promote handshake; completely ignored in pipelines.
```
