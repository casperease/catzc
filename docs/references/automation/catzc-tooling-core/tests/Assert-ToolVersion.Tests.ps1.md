---
catzc:
  immutable:
    with_body_sha: d3e87b42d1d4
    path: docs/references/automation/catzc-tooling-core/tests/Assert-ToolVersion.Tests.ps1.md
    folder: docs/references/automation/catzc-tooling-core/tests
    name: assert-tool-version-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Core/tests/Assert-ToolVersion.Tests.ps1

<!-- cspell:ignore lockedtool -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeEach {`, written with `#`.

```text
Hermetic: every collaborator is mocked in the module scope, so the assertion binds to the version-check
LOGIC (pipeline lock vs devbox lever), never to the shipped tools.yml values or the installed toolchain.
Fixture tools ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)): faketool carries a
devbox_version lever, lockedtool has none.
```
