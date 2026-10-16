---
catzc:
  immutable:
    with_body_sha: b21f8884ff49
    path: docs/references/automation/catzc-base-execution/tests/types/ExecutableProbe.Tests.ps1.md
    folder: docs/references/automation/catzc-base-execution/tests/types
    name: executable-probe-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Execution/tests/types/ExecutableProbe.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `It 'reads a found executable as Found with its path' {`, written with `#`.

```text
The existence-check record. Fixture tokens are neutral
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
