---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-Glossary.Tests.ps1.md
    kind: test-asset
    body_sha: d0b66565f819
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-PWSH-PESTER#3
---

# automation/Catzc.Base.Docs/tests/Get-Glossary.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-Glossary' -Tag 'L0', 'logic' {`.

```text
Get-Glossary merges the glossary sources into GlossaryEntry records. Discovery is mocked at Get-GlossarySources
(its own tests cover the config seam and git), and the sources are built from the real GlossaryConfig type.
Get-Glossary caches per repository root, so every test resets the cache entry
([ADR-PWSH-PESTER#3](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester3)). Fixture terms
are
neutral (widget/gadget, [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `InModuleScope Catzc.Base.Docs { $script:glossaryCache = $null }`.

```text
The cache is keyed by the REAL repository root, so a fixture glossary left in it would be served to any later
caller in this worker — e.g. the real-tree glossary check.
```
