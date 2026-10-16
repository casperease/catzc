---
catzc:
  immutable:
    with_body_sha: "23ae3abed73c"
    path: docs/references/automation/catzc-tooling-provisioning/tests/Install-Postman.Tests.ps1.md
    folder: docs/references/automation/catzc-tooling-provisioning/tests
    name: install-postman-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Provisioning/tests/Install-Postman.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeEach {`, written with `#`.

```text
Like Install-Git, the actual install is a live download (dl.pstmn.io) best proven by an L2/manual run.
These L0 tests cover the hermetic idempotent-skip decision on every platform, with all download/CLI
boundaries mocked so nothing is fetched, extracted, or launched.
```
