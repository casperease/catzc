# pwsh/Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1

The tests of `Get-GlossaryPhrasingViolations`. The function is private, so it is exercised through the module (`InModuleScope`, per
[ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)). Each
test writes its own fixture file under `$TestDrive` and passes it as the only tracked file (`-TrackedFile`, `-Root`), so no git process
runs; the glossary is built in memory from the real types. Fixture terms and rule codes are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)): the
avoided phrase is 'widget bundle', and the fixture entry is the widget's source avoiding it (say 'widget suite'), with the source's options,
if any.
