---
catzc:
  immutable:
    with_body_sha: "08458010070e"
    repo_status: locked
    path: docs/references/automation/catzc-azure-templates/tests/Get-BicepTrackTagNameSet.Tests.ps1.md
    folder: docs/references/automation/catzc-azure-templates/tests
    name: get-bicep-track-tag-name-set-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#{4,19}
---

# automation/Catzc.Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
Read-only resolver tests: boundary mocks + config-cache reset run ONCE, not per test — the mocked
config is identical every test and no test mutates it, so the cache stays warm
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)/[ADR-AUTO-TEST#4](/docs/adr/automation/test-automation.md#rule-adr-auto-test4)).
```
