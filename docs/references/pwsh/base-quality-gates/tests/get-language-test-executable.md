# pwsh/Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1

The tests of `Get-LanguageTestExecutable`, with the test folder discovery and the tool probe mocked. The source session hands down a
language's tool only when it is found at the pin, and the command probes nothing for a language without test folders. Fixture paths are
neutral ([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).
