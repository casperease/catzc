# pwsh/Base.Docs/tests/Get-Glossary.Tests.ps1

The tests of `Get-Glossary`, which merges the glossary sources into `GlossaryEntry` records. Discovery is mocked at `Get-GlossarySources`,
whose own tests cover the config seam and git, and the sources are built from the real `GlossaryConfig` type. Fixture terms are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## The cache

`Get-Glossary` caches per repository root, so every test resets the cache entry
([ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-mockmoduleboundaries)). The
cache is keyed by the real repository root, so a fixture glossary left in it would be served to any later caller in the same worker, for
example the real-tree glossary check.
