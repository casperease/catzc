---
catzc:
  immutable:
    with_body_sha: "70d8d04228d6"
    repo_status: locked
    path: docs/references/automation/catzc-azure/tests/Get-AzureBicepMinVersion.Tests.ps1.md
    folder: docs/references/automation/catzc-azure/tests
    name: get-azure-bicep-min-version-tests-ps1
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

# automation/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
Read-only resolver tests: the config mock + cache reset run ONCE, not per test — the mocked config is
identical every test and no test mutates it, so the cache stays warm
([ADR-AUTO-TEST#19](/docs/adr/automation/test-automation.md#rule-adr-auto-test19)/[ADR-AUTO-TEST#4](/docs/adr/automation/test-automation.md#rule-adr-auto-test4)).
```
