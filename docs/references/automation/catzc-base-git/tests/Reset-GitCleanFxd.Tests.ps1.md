---
catzc:
  derived:
    path: docs/references/automation/catzc-base-git/tests/Reset-GitCleanFxd.Tests.ps1.md
    kind: test-asset
    body_sha: "0d84c69ab044"
---

# automation/Catzc.Base.Git/tests/Reset-GitCleanFxd.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeEach {`.

```text
git's own dry-run listing is the one external boundary (plus the deleting clean calls); the
whitelist itself is mocked to a fixed set so these tests exercise pure classification logic.
```
