# automation/Catzc.Base.Docs/tests/Get-Glossary.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-Glossary' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-Glossary merges the glossary sources into GlossaryEntry records. Discovery is mocked at Get-GlossarySources
(its own tests cover the config seam and git), and the sources are built from the real GlossaryConfig type.
Get-Glossary caches per repository root, so every test resets the cache entry
([ADR-PWSH-PESTER#3](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester3)). Fixture terms
are
neutral (widget/gadget, [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `InModuleScope Catzc.Base.Docs { $script:glossaryCache = $null }` (occurrence 2), written with `#`.

```text
The cache is keyed by the REAL repository root, so a fixture glossary left in it would be served to any later
caller in this worker — e.g. the real-tree glossary check.
```
