---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/tests/Install-Postman.Tests.ps1.md
    kind: test-asset
    body_sha: "7e721a12795e"
---

# automation/Catzc.Tooling.Provisioning/tests/Install-Postman.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeEach {`.

```text
Like Install-Git, the actual install is a live download (dl.pstmn.io) best proven by an L2/manual run.
These L0 tests cover the hermetic idempotent-skip decision on every platform, with all download/CLI
boundaries mocked so nothing is fetched, extracted, or launched.
```
