---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/tests/Get-ExecutableVersion.Tests.ps1.md
    kind: comment-page
    body_sha: "307cec29c5b2"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Execution/tests/Get-ExecutableVersion.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeEach {`, written with `#`.

```text
The probe's only process start, with Invoke-Executable mocked: the located path is run (quoted), never a
bare name, and the version is the pattern's named group. Fixture tokens are neutral
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
