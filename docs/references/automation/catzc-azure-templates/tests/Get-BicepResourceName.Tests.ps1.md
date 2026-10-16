---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Get-BicepResourceName.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "7133dfa979af"
    adrs:
      - ADR-AUTO-TEST#{4,19}
---

# automation/Catzc.Azure.Templates/tests/Get-BicepResourceName.Tests.ps1

<!-- cspell:ignore alweutstsmplst alweutstsmplacst -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
Read-only resolver tests: the boundary mocks and the config-cache reset are set up ONCE, not per test.
The mocked config is the same fixture every test and no test mutates it, so Get-Config keys its cache on
the fixture path and the first call derives it cold (~80ms) while the rest hit the warm cache — a
per-test reset would force that cold re-derive on every test
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)/[ADR-AUTO-TEST#4](/docs/adr/automation/test-automation.md#rule-adr-auto-test4)).
```
